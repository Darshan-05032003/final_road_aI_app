import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_road_app/services/database_service.dart';

/// Vehicle Owner Sync Service
/// Handles offline-first data access with automatic Firestore synchronization
class VehicleOwnerSyncService {
  factory VehicleOwnerSyncService() => _instance;
  VehicleOwnerSyncService._internal();
  static final VehicleOwnerSyncService _instance = VehicleOwnerSyncService._internal();

  final DatabaseService _dbService = DatabaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;

  /// Initialize the sync service
  Future<void> initialize() async {
    // Check initial connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    _isOnline = _hasInternetConnection(connectivityResult);

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOnline = _isOnline;
        _isOnline = _hasInternetConnection(results);
        
        if (!wasOnline && _isOnline) {
          // Just came online, trigger sync
          print('🌐 Internet connection restored, triggering sync...');
        }
      },
    );
  }

  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.any((result) => 
      result == ConnectivityResult.mobile || 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet
    );
  }

  /// Check if online
  bool get isOnline => _isOnline;

  /// Get service history with offline-first strategy
  Future<List<Map<String, dynamic>>> getServiceHistory({
    required String userEmail,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    List<Map<String, dynamic>> cachedData = [];

    // 1. Load from cache first (fast)
    if (useCache) {
      cachedData = await _dbService.getCachedServiceHistory(userEmail: userEmail);
      
      // Return cached data immediately if available
      if (cachedData.isNotEmpty) {
        print('✅ Loaded ${cachedData.length} service history items from cache');
        
        // Sync with Firestore in background if online
        if (syncInBackground && _isOnline) {
          _syncServiceHistory(userEmail);
        }
        
        return cachedData;
      }
    }

    // 2. Load from Firestore (if cache empty or cache disabled)
    if (_isOnline) {
      print('📡 Loading service history from Firestore...');
      final firestoreData = await _loadServiceHistoryFromFirestore(userEmail: userEmail);

      // 3. Cache the Firestore data
      if (firestoreData.isNotEmpty) {
        await _dbService.cacheServiceHistoryList(firestoreData, userEmail);
        print('✅ Cached ${firestoreData.length} service history items');
      }

      return firestoreData;
    } else {
      print('⚠️ Offline: Returning cached data only');
      return cachedData;
    }
  }

  /// Sync service history from Firestore (background)
  Future<void> _syncServiceHistory(String userEmail) async {
    if (!_isOnline) {
      print('⚠️ Cannot sync: No internet connection');
      return;
    }

    try {
      print('🔄 Syncing service history for: $userEmail');
      final firestoreData = await _loadServiceHistoryFromFirestore(userEmail: userEmail);
      
      if (firestoreData.isNotEmpty) {
        await _dbService.cacheServiceHistoryList(firestoreData, userEmail);
        print('✅ Synced ${firestoreData.length} service history items');
      }
    } catch (e) {
      print('❌ Error syncing service history: $e');
    }
  }

  /// Load service history from Firestore
  Future<List<Map<String, dynamic>>> _loadServiceHistoryFromFirestore({
    required String userEmail,
  }) async {
    try {
      List<Map<String, dynamic>> history = [];

      // Load Garage Requests
      try {
        final garageRequestsSnapshot = await _firestore
            .collection('owner')
            .doc(userEmail)
            .collection('garagerequest')
            .orderBy('createdAt', descending: true)
            .get();

        for (var doc in garageRequestsSnapshot.docs) {
          final data = doc.data();
          final status = (data['status'] ?? '').toString().toLowerCase();
          
          // Include only completed, rejected, cancelled, or other non-ongoing statuses
          final isOngoing = (status == 'pending' || 
                           status == 'in process' || 
                           status.contains('pending')) &&
                           !status.contains('complete') &&
                           !status.contains('reject');
          
          if (!isOngoing) {
            history.add({
              'id': doc.id,
              'requestId': data['requestId'] ?? doc.id,
              'serviceType': 'Garage Service',
              'status': data['status'] ?? '',
              'createdAt': data['createdAt'],
              'completedAt': data['completedAt'],
              ...data,
            });
          }
        }
      } catch (e) {
        print('⚠️ Error loading garage requests: $e');
      }

      // Load Tow Requests
      try {
        final towRequestsSnapshot = await _firestore
            .collection('owner')
            .doc(userEmail)
            .collection('tow_requests')
            .orderBy('createdAt', descending: true)
            .get();

        for (var doc in towRequestsSnapshot.docs) {
          final data = doc.data();
          final status = (data['status'] ?? '').toString().toLowerCase();
          
          // Include only completed, rejected, cancelled, or other non-ongoing statuses
          final isOngoing = (status == 'pending' || 
                           status == 'in process' || 
                           status.contains('pending')) &&
                           !status.contains('complete') &&
                           !status.contains('reject');
          
          if (!isOngoing) {
            history.add({
              'id': doc.id,
              'requestId': data['requestId'] ?? doc.id,
              'serviceType': 'Tow Service',
              'status': data['status'] ?? '',
              'createdAt': data['createdAt'],
              'completedAt': data['completedAt'],
              ...data,
            });
          }
        }
      } catch (e) {
        print('⚠️ Error loading tow requests: $e');
      }

      return history;
    } catch (e) {
      print('❌ Error loading service history from Firestore: $e');
      return [];
    }
  }

  /// Get service statistics (from cache or Firestore)
  Future<Map<String, int>> getServiceStatistics({
    required String userEmail,
    bool useCache = true,
  }) async {
    // Try cache first
    if (useCache) {
      final cachedStats = await _dbService.getServiceStatistics(userEmail);
      if (cachedStats['total']! > 0) {
        // If online, sync in background to update stats
        if (_isOnline) {
          _syncServiceHistory(userEmail);
        }
        return cachedStats;
      }
    }

    // If cache empty and online, fetch from Firestore
    if (_isOnline) {
      final history = await _loadServiceHistoryFromFirestore(userEmail: userEmail);
      
      // Cache the history
      if (history.isNotEmpty) {
        await _dbService.cacheServiceHistoryList(history, userEmail);
      }
      
      // Calculate statistics
      final total = history.length;
      final completed = history.where((item) {
        final status = (item['status'] ?? '').toString().toLowerCase();
        return status.contains('completed') || status.contains('complete');
      }).length;
      final notCompleted = total - completed;

      return {
        'total': total,
        'completed': completed,
        'notCompleted': notCompleted,
      };
    }

    // Offline and no cache, return empty stats
    return {'total': 0, 'completed': 0, 'notCompleted': 0};
  }

  /// Force sync now
  Future<void> syncNow(String userEmail) async {
    if (!_isOnline) {
      print('⚠️ Cannot sync: No internet connection');
      return;
    }
    await _syncServiceHistory(userEmail);
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

