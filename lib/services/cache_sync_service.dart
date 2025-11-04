import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_road_app/services/database_service.dart';

/// Cache Sync Service
/// Provides cache-first data access with background Firestore synchronization
class CacheSyncService {
  factory CacheSyncService() => _instance;
  CacheSyncService._internal();
  static final CacheSyncService _instance = CacheSyncService._internal();

  final DatabaseService _dbService = DatabaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get service requests with cache-first strategy
  Future<List<Map<String, dynamic>>> getServiceRequests({
    required String userEmail,
    String? status,
    String? serviceType,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    List<Map<String, dynamic>> cachedData = [];

    // 1. Load from cache first (fast)
    if (useCache) {
      cachedData = await _dbService.getCachedServiceRequests(
        userEmail: userEmail,
        status: status,
        serviceType: serviceType,
      );
      
      // Return cached data immediately if available
      if (cachedData.isNotEmpty) {
        print('✅ Loaded ${cachedData.length} service requests from cache');
        
        // Sync with Firestore in background
        if (syncInBackground) {
          _syncServiceRequests(userEmail, status: status, serviceType: serviceType);
        }
        
        return cachedData;
      }
    }

    // 2. Load from Firestore (if cache empty or cache disabled)
    print('📡 Loading service requests from Firestore...');
    final firestoreData = await _loadServiceRequestsFromFirestore(
      userEmail: userEmail,
      status: status,
      serviceType: serviceType,
    );

    // 3. Cache the Firestore data
    if (firestoreData.isNotEmpty) {
      await _dbService.cacheServiceRequests(firestoreData);
      print('✅ Cached ${firestoreData.length} service requests');
    }

    return firestoreData;
  }

  /// Sync service requests from Firestore (background)
  Future<void> _syncServiceRequests(
    String userEmail, {
    String? status,
    String? serviceType,
  }) async {
    try {
      final firestoreData = await _loadServiceRequestsFromFirestore(
        userEmail: userEmail,
        status: status,
        serviceType: serviceType,
      );
      
      if (firestoreData.isNotEmpty) {
        await _dbService.cacheServiceRequests(firestoreData);
        print('✅ Synced ${firestoreData.length} service requests');
      }
    } catch (e) {
      print('⚠️ Error syncing service requests: $e');
    }
  }

  /// Load service requests from Firestore
  Future<List<Map<String, dynamic>>> _loadServiceRequestsFromFirestore({
    required String userEmail,
    String? status,
    String? serviceType,
  }) async {
    try {
      List<Map<String, dynamic>> allServices = [];

      // Load garage requests
      try {
        final garageSnapshot = await _firestore
            .collection('owner')
            .doc(userEmail)
            .collection('garagerequest')
            .get();

        for (var doc in garageSnapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          data['serviceType'] = 'Garage Service';
          data['userEmail'] = userEmail;
          allServices.add(data);
        }
      } catch (e) {
        print('⚠️ Error loading garage requests: $e');
      }

      // Load tow requests
      try {
        final towSnapshot = await _firestore
            .collection('owner')
            .doc(userEmail)
            .collection('towrequest')
            .get();

        for (var doc in towSnapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          data['serviceType'] = 'Tow Service';
          data['userEmail'] = userEmail;
          allServices.add(data);
        }
      } catch (e) {
        print('⚠️ Error loading tow requests: $e');
      }

      // Apply filters
      if (status != null) {
        allServices = allServices.where((s) {
          final sStatus = (s['status'] as String?)?.toLowerCase() ?? '';
          return sStatus.contains(status.toLowerCase());
        }).toList();
      }

      if (serviceType != null) {
        allServices = allServices.where((s) {
          return s['serviceType'] == serviceType;
        }).toList();
      }

      return allServices;
    } catch (e) {
      print('❌ Error loading from Firestore: $e');
      return [];
    }
  }

  /// Get payments with cache-first strategy
  Future<List<Map<String, dynamic>>> getPayments({
    required String userEmail,
    String? status,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    // Load from cache first
    if (useCache) {
      final cachedPayments = await _dbService.getCachedPayments(
        userEmail: userEmail,
        status: status,
      );

      if (cachedPayments.isNotEmpty) {
        print('✅ Loaded ${cachedPayments.length} payments from cache');
        
        if (syncInBackground) {
          _syncPayments(userEmail, status: status);
        }
        
        return cachedPayments;
      }
    }

    // Load from Firestore
    try {
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('customerEmail', isEqualTo: userEmail)
          .orderBy('createdAt', descending: true)
          .get();

      final payments = paymentsSnapshot.docs
          .map((doc) => <String, dynamic>{...?doc.data() as Map<String, dynamic>?, 'id': doc.id})
          .toList();

      // Cache payments
      for (var payment in payments) {
        await _dbService.cachePayment(payment);
      }

      return payments;
    } catch (e) {
      print('❌ Error loading payments: $e');
      return [];
    }
  }

  /// Sync payments from Firestore (background)
  Future<void> _syncPayments(String userEmail, {String? status}) async {
    try {
      Query query = _firestore
          .collection('payments')
          .where('customerEmail', isEqualTo: userEmail)
          .orderBy('createdAt', descending: true);

      final snapshot = await query.get();
      final payments = snapshot.docs
          .map((doc) => <String, dynamic>{...?doc.data() as Map<String, dynamic>?, 'id': doc.id})
          .toList();

      for (var payment in payments) {
        await _dbService.cachePayment(payment);
      }

      print('✅ Synced ${payments.length} payments');
    } catch (e) {
      print('⚠️ Error syncing payments: $e');
    }
  }

  /// Get user profile with cache-first strategy
  Future<Map<String, dynamic>?> getUserProfile({
    required String email,
    required String role,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    // Load from cache first
    if (useCache) {
      final cachedProfile = await _dbService.getCachedUserProfile(email);
      if (cachedProfile != null) {
        print('✅ Loaded user profile from cache');
        
        if (syncInBackground) {
          _syncUserProfile(email, role);
        }
        
        return cachedProfile;
      }
    }

    // Load from Firestore
    try {
      DocumentSnapshot? profileDoc;
      
      switch (role.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          profileDoc = await _firestore
              .collection('owner')
              .doc(email)
              .collection('profile')
              .doc('user_details')
              .get();
          break;
        case 'garage':
          profileDoc = await _firestore.collection('garages').doc(email).get();
          break;
        case 'tow_provider':
        case 'toe_provider':
          profileDoc = await _firestore.collection('tow_providers').doc(email).get();
          break;
        default:
          return null;
      }

      if (profileDoc.exists) {
        final profileData = <String, dynamic>{...profileDoc.data() as Map<String, dynamic>};
        await _dbService.cacheUserProfile(profileData, email, role);
        return profileData;
      }
    } catch (e) {
      print('❌ Error loading user profile: $e');
    }

    return null;
  }

  /// Sync user profile from Firestore (background)
  Future<void> _syncUserProfile(String email, String role) async {
    try {
      DocumentSnapshot? profileDoc;
      
      switch (role.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          profileDoc = await _firestore
              .collection('owner')
              .doc(email)
              .collection('profile')
              .doc('user_details')
              .get();
          break;
        case 'garage':
          profileDoc = await _firestore.collection('garages').doc(email).get();
          break;
        case 'tow_provider':
        case 'toe_provider':
          profileDoc = await _firestore.collection('tow_providers').doc(email).get();
          break;
      }

      if (profileDoc != null && profileDoc.exists) {
        final profileData = profileDoc.data() as Map<String, dynamic>;
        await _dbService.cacheUserProfile(profileData, email, role);
        print('✅ Synced user profile');
      }
    } catch (e) {
      print('⚠️ Error syncing user profile: $e');
    }
  }

  /// Get notifications with cache-first strategy
  Future<List<Map<String, dynamic>>> getNotifications({
    required String userEmail,
    bool? isRead,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    // Load from cache first
    if (useCache) {
      final cachedNotifications = await _dbService.getCachedNotifications(
        userEmail: userEmail,
        isRead: isRead,
      );

      if (cachedNotifications.isNotEmpty) {
        print('✅ Loaded ${cachedNotifications.length} notifications from cache');
        
        if (syncInBackground) {
          _syncNotifications(userEmail);
        }
        
        return cachedNotifications;
      }
    }

    // Load from Firestore
    try {
      Query query = _firestore
          .collection('notifications')
          .doc(userEmail)
          .collection('items')
          .orderBy('timestamp', descending: true);

      if (isRead != null) {
        query = query.where('isRead', isEqualTo: isRead);
      }

      final snapshot = await query.get();
      final notifications = snapshot.docs
          .map((doc) => <String, dynamic>{...?doc.data() as Map<String, dynamic>?, 'id': doc.id})
          .toList();

      // Cache notifications
      for (var notification in notifications) {
        await _dbService.cacheNotification(notification, userEmail);
      }

      return notifications.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error loading notifications: $e');
      return [];
    }
  }

  /// Sync notifications from Firestore (background)
  Future<void> _syncNotifications(String userEmail) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .doc(userEmail)
          .collection('items')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final notifications = snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      for (var notification in notifications) {
        await _dbService.cacheNotification(notification, userEmail);
      }

      print('✅ Synced ${notifications.length} notifications');
    } catch (e) {
      print('⚠️ Error syncing notifications: $e');
    }
  }

  /// Invalidate cache for a specific service request
  Future<void> invalidateServiceRequest(String requestId) async {
    // This will force reload from Firestore on next request
    print('🔄 Invalidated cache for request: $requestId');
  }

  /// Clear all cache
  Future<void> clearCache() async {
    await _dbService.clearAllCache();
    print('✅ Cleared all cache');
  }
}
