import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/services/vehicle_owner_sync_service.dart';
import 'package:smart_road_app/services/database_service.dart';

class EnhancedHistoryScreen extends StatefulWidget {

  const EnhancedHistoryScreen({super.key, required this.userEmail, required List<Map<String, dynamic>> serviceHistory, required garageName});
  final String userEmail;

  @override
  State<EnhancedHistoryScreen> createState() => _EnhancedHistoryScreenState();
}

class _EnhancedHistoryScreenState extends State<EnhancedHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final VehicleOwnerSyncService _syncService = VehicleOwnerSyncService();
  List<ServiceHistory> _serviceHistory = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  StreamSubscription<QuerySnapshot>? _garageSubscription;
  StreamSubscription<QuerySnapshot>? _towSubscription;
  final Map<String, ServiceHistory> _historyMap = {}; // Track history items by requestId
  
  // Statistics
  Map<String, int> _statistics = {
    'total': 0,
    'completed': 0,
    'notCompleted': 0,
  };
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _initializeSync();
    _loadServiceHistory();
    _loadStatistics();
    _setupRealtimeListeners();
  }

  @override
  void dispose() {
    _garageSubscription?.cancel();
    _towSubscription?.cancel();
    _syncService.dispose();
    super.dispose();
  }

  Future<void> _initializeSync() async {
    await _syncService.initialize();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final stats = await _syncService.getServiceStatistics(
        userEmail: widget.userEmail,
        useCache: true,
      );

      if (mounted) {
        setState(() {
          _statistics = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      print('❌ Error loading statistics: $e');
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
    }
  }

  void _setupRealtimeListeners() {
    if (widget.userEmail.isEmpty) {
      return;
    }

    final userEmail = widget.userEmail;

    // Listen to garage requests in real-time
    _garageSubscription = _firestore
        .collection('owner')
        .doc(userEmail)
        .collection('garagerequest')
        .snapshots()
        .listen((snapshot) {
      _handleRealtimeUpdate(snapshot, 'Garage Service');
    }, onError: (error) {
      print('❌ Error in garage listener: $error');
    });

    // Listen to tow requests in real-time
    _towSubscription = _firestore
        .collection('owner')
        .doc(userEmail)
        .collection('towrequest')
        .snapshots()
        .listen((snapshot) {
      _handleRealtimeUpdate(snapshot, 'Tow Service');
    }, onError: (error) {
      print('❌ Error in tow listener: $error');
    });
  }

  void _handleRealtimeUpdate(QuerySnapshot snapshot, String serviceType) {
    if (!mounted) return;

    try {
      bool hasUpdates = false;

      // Process each document in the snapshot
      for (var doc in snapshot.docs) {
        try {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          
          // Get status and determine if it's a past service
          String status = _getField(data, 'status', 'pending').toLowerCase().trim();
          String normalizedStatus = _normalizeStatus(status);
          
          // Check if this is an ongoing service (should be excluded from history)
          // Only exclude services that are actively pending/processing
          bool isOngoing = (normalizedStatus == 'pending' || 
                          normalizedStatus == 'in process' ||
                          status.contains('pending')) &&
                          !status.contains('complete') &&
                          !status.contains('reject');
          
          String requestId = _getField(data, 'requestId', doc.id);
          
          // If service is ongoing, remove it from history if it exists
          if (isOngoing) {
            if (_historyMap.containsKey(requestId)) {
              _historyMap.remove(requestId);
              hasUpdates = true;
              print('🔄 Removed ongoing service from history: $requestId');
            }
            continue;
          }
          
          // Include all past services (completed, rejected, cancelled, and any other non-ongoing statuses)
          // Skip if already in history and unchanged
          if (_historyMap.containsKey(requestId)) {
            final existingService = _historyMap[requestId]!;
            // Check if status changed
            if (existingService.status != normalizedStatus) {
              // Status changed, update it
              hasUpdates = true;
            } else {
              // No change, skip
              continue;
            }
          }
          
          print('✅ Adding/updating service in history: $requestId - status: $normalizedStatus');
          
          // Parse dates safely
          DateTime createdAt = _parseTimestamp(data['createdAt']);
          DateTime updatedAt = _parseTimestamp(data['updatedAt']);
          DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;
          
          // Extract all possible fields with proper fallbacks
          String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
          String garageName = serviceType == 'Garage Service'
              ? _getField(data, 'assignedGarage', 
                  _getField(data, 'garageName', 'AutoCare Garage'))
              : _getField(data, 'providerName', 
                  _getField(data, 'towProviderName', 'Tow Provider'));
          
          // Get cost information
          String cost = _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00')));
          
          String rating = _getField(data, 'rating', 'N/A');
          
          // Get date and time
          String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
          String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));
          
          // Handle problem description
          String problemDescription = serviceType == 'Garage Service'
              ? _getField(data, 'problemDescription', 
                  _getField(data, 'description', 
                  _getField(data, 'additionalDetails', 
                  _getField(data, 'issueDescription', 'No description provided'))))
              : _getField(data, 'description', 
                  _getField(data, 'issue', 
                  _getField(data, 'problemDescription', 'No description provided')));

          ServiceHistory service = ServiceHistory(
            id: doc.id,
            requestId: requestId,
            vehicleNumber: vehicleNumber,
            serviceType: serviceType,
            preferredDate: preferredDate,
            preferredTime: preferredTime,
            name: _getField(data, 'name', 'Customer'),
            phone: _getField(data, 'phone', 'Not Provided'),
            location: _getField(data, 'location', 'Not Provided'),
            problemDescription: problemDescription,
            userEmail: widget.userEmail,
            status: normalizedStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            cost: cost,
            garageName: garageName,
            rating: rating,
            vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
            fuelType: _getField(data, 'fuelType', 'Not Specified'),
            vehicleType: _getField(data, 'vehicleType', 'Car'),
            additionalData: {
              'completedAt': completedAt,
            },
          );
          
          _historyMap[requestId] = service;
          hasUpdates = true;
          
        } catch (e) {
          print('⚠️ Error processing document ${doc.id}: $e');
        }
      }

      // Update UI if there were changes
      if (hasUpdates) {
        _updateHistoryList();
        
        // Cache updated history to SQLite
        _cacheHistoryToSQLite();
      }
    } catch (e) {
      print('❌ Error handling real-time update: $e');
    }
  }

  void _updateHistoryList() {
    if (!mounted) return;

    // Convert map to list and sort by creation date (newest first)
    final historyList = _historyMap.values.toList();
    historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      _serviceHistory = historyList;
      _isLoading = false;
      _hasError = false;
    });

    print('✅ History updated: ${historyList.length} services in history');
  }

  Future<void> _cacheHistoryToSQLite() async {
    try {
      if (_historyMap.isEmpty) return;

      final historyData = _historyMap.values.map((service) => {
        'id': service.id,
        'requestId': service.requestId,
        'serviceType': service.serviceType,
        'status': service.status,
        'createdAt': service.createdAt,
        'updatedAt': service.updatedAt,
        'completedAt': service.additionalData['completedAt'],
        'cost': service.cost,
        'rating': service.rating,
        'vehicleNumber': service.vehicleNumber,
        'garageName': service.garageName,
        'name': service.name,
        'phone': service.phone,
        'location': service.location,
        'problemDescription': service.problemDescription,
        'preferredDate': service.preferredDate,
        'preferredTime': service.preferredTime,
        'vehicleModel': service.vehicleModel,
        'fuelType': service.fuelType,
        'vehicleType': service.vehicleType,
      }).toList();

      final dbService = DatabaseService();
      await dbService.cacheServiceHistoryList(historyData, widget.userEmail);
      
      // Update statistics
      await _loadStatistics();
    } catch (e) {
      print('⚠️ Error caching history to SQLite: $e');
    }
  }

  Future<void> _loadServiceHistory() async {
    try {
      if (widget.userEmail.isEmpty) {
        throw Exception('User email is empty');
      }

      print('🔄 Loading service history for: ${widget.userEmail}');

      // Load from SQLite first (offline-first)
      final cachedHistory = await _syncService.getServiceHistory(
        userEmail: widget.userEmail,
        useCache: true,
        syncInBackground: true,
      );

      // Convert cached data to ServiceHistory objects
      List<ServiceHistory> history = [];
      for (var data in cachedHistory) {
        try {
          final requestId = data['requestId'] ?? data['id'] ?? '';
          final status = (data['status'] ?? '').toString().toLowerCase().trim();
          final normalizedStatus = _normalizeStatus(status);

          // Skip ongoing services
          bool isOngoing = (normalizedStatus == 'pending' ||
                          normalizedStatus == 'in process' ||
                          status.contains('pending')) &&
                          !status.contains('complete') &&
                          !status.contains('reject');

          if (isOngoing) continue;

          // Parse dates
          DateTime createdAt = _parseTimestamp(data['createdAt']);
          DateTime updatedAt = _parseTimestamp(data['updatedAt']);
          DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;

          // Extract fields
          String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
          String serviceType = _getField(data, 'serviceType', 'Garage Service');
          String garageName = serviceType == 'Garage Service'
              ? _getField(data, 'assignedGarage', _getField(data, 'garageName', 'AutoCare Garage'))
              : _getField(data, 'providerName', _getField(data, 'towProviderName', 'Tow Provider'));

          String cost = _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00')));
          String rating = _getField(data, 'rating', 'N/A');
          String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
          String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));

          String problemDescription = serviceType == 'Garage Service'
              ? _getField(data, 'problemDescription', _getField(data, 'description', _getField(data, 'additionalDetails', _getField(data, 'issueDescription', 'No description provided'))))
              : _getField(data, 'description', _getField(data, 'issue', _getField(data, 'problemDescription', 'No description provided')));

          ServiceHistory service = ServiceHistory(
            id: data['id'] ?? requestId,
            requestId: requestId,
            vehicleNumber: vehicleNumber,
            serviceType: serviceType,
            preferredDate: preferredDate,
            preferredTime: preferredTime,
            name: _getField(data, 'name', 'Customer'),
            phone: _getField(data, 'phone', 'Not Provided'),
            location: _getField(data, 'location', 'Not Provided'),
            problemDescription: problemDescription,
            userEmail: widget.userEmail,
            status: normalizedStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            cost: cost,
            garageName: garageName,
            rating: rating,
            vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
            fuelType: _getField(data, 'fuelType', 'Not Specified'),
            vehicleType: _getField(data, 'vehicleType', 'Car'),
            additionalData: {
              'completedAt': completedAt,
            },
          );

          history.add(service);
        } catch (e) {
          print('⚠️ Error processing cached history item: $e');
        }
      }

      // Update history map and UI
      _historyMap.clear();
      for (var service in history) {
        _historyMap[service.requestId] = service;
      }
      _updateHistoryList();

      // Reload statistics after loading history
      await _loadStatistics();

      // If no cached data and online, try loading from Firestore directly
      if (history.isEmpty && _syncService.isOnline) {
        print('📡 No cached data, loading from Firestore...');
        await _loadFromFirestore();
      }
    } catch (e) {
      print('❌ Error loading service history: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadFromFirestore() async {
    try {
      // First, check if the user document exists
      final userDoc = await _firestore
          .collection('owner')
          .doc(widget.userEmail)
          .get();

      if (!userDoc.exists) {
        print('❌ User document does not exist');
        if (mounted) {
          setState(() {
            _serviceHistory = [];
            _isLoading = false;
            _hasError = false;
          });
        }
        return;
      }

      List<ServiceHistory> history = [];
      
      // Load Garage Requests
      try {
        QuerySnapshot garageRequestsSnapshot;
        try {
          garageRequestsSnapshot = await _firestore
              .collection('owner')
              .doc(widget.userEmail)
              .collection('garagerequest')
              .orderBy('createdAt', descending: true)
              .get();
        } catch (e) {
          // If orderBy fails (missing index), load without ordering
          print('⚠️ OrderBy failed, loading without ordering: $e');
          garageRequestsSnapshot = await _firestore
              .collection('owner')
              .doc(widget.userEmail)
              .collection('garagerequest')
              .get();
        }

        print('📥 Found ${garageRequestsSnapshot.docs.length} garage requests');

        for (var doc in garageRequestsSnapshot.docs) {
          try {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            
            // Get status and determine if it's a past service
            String status = _getField(data, 'status', 'pending').toLowerCase().trim();
            String normalizedStatus = _normalizeStatus(status);
            
            // Check if this is an ongoing service (should be excluded from history)
            // Only exclude services that are actively pending/processing
            bool isOngoing = (normalizedStatus == 'pending' || 
                            normalizedStatus == 'in process' ||
                            status.contains('pending')) &&
                            !status.contains('complete') &&
                            !status.contains('reject');
            
            // Include all past services (completed, rejected, cancelled, and any other non-ongoing statuses)
            // Exclude only actively pending/processing services
            if (isOngoing) {
              print('⏭️ Skipping ongoing service: ${doc.id} - status: $status');
              continue;
            }
            
            print('✅ Including past service: ${doc.id} - status: $normalizedStatus');
            
            // Parse dates safely
            DateTime createdAt = _parseTimestamp(data['createdAt']);
            DateTime updatedAt = _parseTimestamp(data['updatedAt']);
            DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;
            
            // Extract all possible fields with proper fallbacks
            String requestId = _getField(data, 'requestId', 'GRG-${DateTime.now().millisecondsSinceEpoch}');
            String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
            String serviceType = 'Garage Service';
            String garageName = _getField(data, 'assignedGarage', 
                              _getField(data, 'garageName', 'AutoCare Garage'));
            
            // Get cost information
            String cost = _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00')));
            
            String rating = _getField(data, 'rating', 'N/A');
            
            // Get date and time - prefer preferredDate/preferredTime, fallback to createdAt
            String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
            String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));
            
            // Handle problem description from multiple possible fields
            String problemDescription = _getField(data, 'problemDescription', 
                                    _getField(data, 'description', 
                                    _getField(data, 'additionalDetails', 
                                    _getField(data, 'issueDescription', 'No description provided'))));

            ServiceHistory service = ServiceHistory(
              id: doc.id,
              requestId: requestId,
              vehicleNumber: vehicleNumber,
              serviceType: serviceType,
              preferredDate: preferredDate,
              preferredTime: preferredTime,
              name: _getField(data, 'name', 'Customer'),
              phone: _getField(data, 'phone', 'Not Provided'),
              location: _getField(data, 'location', 'Not Provided'),
              problemDescription: problemDescription,
              userEmail: widget.userEmail,
              status: normalizedStatus,
              createdAt: createdAt,
              updatedAt: updatedAt,
              cost: cost,
              garageName: garageName,
              rating: rating,
              vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
              fuelType: _getField(data, 'fuelType', 'Not Specified'),
              vehicleType: _getField(data, 'vehicleType', 'Car'),
              additionalData: {
                'completedAt': completedAt,
              },
            );
            
            history.add(service);
            print('✅ Added to history: ${service.requestId} - ${service.serviceType} - ${service.status}');
            
          } catch (e) {
            print('⚠️ Skipping garage document ${doc.id} due to error: $e');
          }
        }
      } catch (e) {
        print('❌ Error loading garage requests: $e');
      }

      // Load Tow Requests
      try {
        QuerySnapshot towRequestsSnapshot;
        try {
          towRequestsSnapshot = await _firestore
              .collection('owner')
              .doc(widget.userEmail)
              .collection('towrequest')
              .orderBy('createdAt', descending: true)
              .get();
        } catch (e) {
          // If orderBy fails (missing index), load without ordering
          print('⚠️ OrderBy failed, loading without ordering: $e');
          towRequestsSnapshot = await _firestore
              .collection('owner')
              .doc(widget.userEmail)
              .collection('towrequest')
              .get();
        }

        print('📥 Found ${towRequestsSnapshot.docs.length} tow requests');

        for (var doc in towRequestsSnapshot.docs) {
          try {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            
            // Get status and determine if it's a past service
            String status = _getField(data, 'status', 'pending').toLowerCase().trim();
            String normalizedStatus = _normalizeStatus(status);
            
            // Check if this is an ongoing service (should be excluded from history)
            // Only exclude services that are actively pending/processing
            bool isOngoing = (normalizedStatus == 'pending' || 
                            normalizedStatus == 'in process' ||
                            status.contains('pending')) &&
                            !status.contains('complete') &&
                            !status.contains('reject');
            
            // Include all past services (completed, rejected, cancelled, and any other non-ongoing statuses)
            // Exclude only actively pending/processing services
            if (isOngoing) {
              print('⏭️ Skipping ongoing service: ${doc.id} - status: $status');
              continue;
            }
            
            print('✅ Including past service: ${doc.id} - status: $normalizedStatus');
            
            // Parse dates safely
            DateTime createdAt = _parseTimestamp(data['createdAt']);
            DateTime updatedAt = _parseTimestamp(data['updatedAt']);
            DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;
            
            // Extract all possible fields with proper fallbacks
            String requestId = _getField(data, 'requestId', 'TOW-${DateTime.now().millisecondsSinceEpoch}');
            String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
            String serviceType = 'Tow Service';
            String providerName = _getField(data, 'providerName', 
                            _getField(data, 'towProviderName', 'Tow Provider'));
            
            // Get cost information
            String cost = _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00')));
            
            String rating = _getField(data, 'rating', 'N/A');
            
            // Get date and time
            String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
            String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));
            
            // Handle description
            String problemDescription = _getField(data, 'description', 
                                    _getField(data, 'issue', 
                                    _getField(data, 'problemDescription', 'No description provided')));

            ServiceHistory service = ServiceHistory(
              id: doc.id,
              requestId: requestId,
              vehicleNumber: vehicleNumber,
              serviceType: serviceType,
              preferredDate: preferredDate,
              preferredTime: preferredTime,
              name: _getField(data, 'name', 'Customer'),
              phone: _getField(data, 'phone', 'Not Provided'),
              location: _getField(data, 'location', 'Not Provided'),
              problemDescription: problemDescription,
              userEmail: widget.userEmail,
              status: normalizedStatus,
              createdAt: createdAt,
              updatedAt: updatedAt,
              cost: cost,
              garageName: providerName, // Reusing garageName field for provider name
              rating: rating,
              vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
              fuelType: _getField(data, 'fuelType', 'Not Specified'),
              vehicleType: _getField(data, 'vehicleType', 'Car'),
              additionalData: {
                'completedAt': completedAt,
              },
            );
            
            history.add(service);
            print('✅ Added to history: ${service.requestId} - ${service.serviceType} - ${service.status}');
            
          } catch (e) {
            print('⚠️ Skipping tow document ${doc.id} due to error: $e');
          }
        }
      } catch (e) {
        print('❌ Error loading tow requests: $e');
      }

      // Cache to SQLite - convert ServiceHistory to Map format
      if (history.isNotEmpty) {
        final historyData = history.map((service) => {
          'id': service.id,
          'requestId': service.requestId,
          'serviceType': service.serviceType,
          'status': service.status,
          'createdAt': service.createdAt,
          'updatedAt': service.updatedAt,
          'completedAt': service.additionalData['completedAt'],
          'cost': service.cost,
          'rating': service.rating,
          'vehicleNumber': service.vehicleNumber,
          'garageName': service.garageName,
          'name': service.name,
          'phone': service.phone,
          'location': service.location,
          'problemDescription': service.problemDescription,
          'preferredDate': service.preferredDate,
          'preferredTime': service.preferredTime,
          'vehicleModel': service.vehicleModel,
          'fuelType': service.fuelType,
          'vehicleType': service.vehicleType,
        }).toList();
        
        // Use DatabaseService to cache directly
        final dbService = DatabaseService();
        await dbService.cacheServiceHistoryList(historyData, widget.userEmail);
      }

      // Populate history map for real-time updates
      _historyMap.clear();
      for (var service in history) {
        _historyMap[service.requestId] = service;
      }

      // Sort by creation date (newest first)
      history.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (mounted) {
        setState(() {
          _serviceHistory = history;
          _isLoading = false;
          _hasError = false;
        });
      }

      // Reload statistics
      await _loadStatistics();

      print('🎉 Service History loaded successfully: ${_serviceHistory.length} completed/rejected requests');

    } catch (e, stackTrace) {
      print('❌ Error loading service history: $e');
      print('📝 Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load service history: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  String _getField(Map<String, dynamic> data, String field, String defaultValue) {
    try {
      if (!data.containsKey(field)) {
        return defaultValue;
      }
      
      final value = data[field];
      if (value == null) {
        return defaultValue;
      }
      
      // Handle different data types
      if (value is String) {
        return value.trim().isEmpty ? defaultValue : value.trim();
      } else if (value is num) {
        return value.toString();
      } else if (value is bool) {
        return value.toString();
      } else if (value is Timestamp) {
        return _formatDate(value.toDate());
      } else {
        final stringValue = value.toString().trim();
        return stringValue.isEmpty ? defaultValue : stringValue;
      }
    } catch (e) {
      print('⚠️ Error getting field "$field": $e');
      return defaultValue;
    }
  }

  String _normalizeStatus(String status) {
    final normalized = status.toLowerCase().trim();
    if (normalized.contains('pending') || normalized == 'pending') {
      return 'pending';
    } else if (normalized.contains('process') || normalized == 'in process' || normalized == 'accepted' || normalized == 'confirmed') {
      return 'in process';
    } else if (normalized.contains('complete') || normalized == 'completed') {
      return 'completed';
    } else if (normalized.contains('reject') || normalized == 'rejected' || normalized == 'cancelled') {
      return 'rejected';
    }
    return normalized;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) {
        return DateTime.now();
      }
      
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }
      
      if (timestamp is DateTime) {
        return timestamp;
      }
      
      if (timestamp is int) {
        // Handle milliseconds timestamp
        if (timestamp > 1000000000000) {
          return DateTime.fromMillisecondsSinceEpoch(timestamp);
        } else {
          // Might be seconds
          return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        }
      }
      
      if (timestamp is String) {
        // Try to parse as milliseconds first
        final intValue = int.tryParse(timestamp);
        if (intValue != null && intValue > 1000000000000) {
          return DateTime.fromMillisecondsSinceEpoch(intValue);
        }
        
        // Try to parse various date formats
        try {
          return DateTime.parse(timestamp);
        } catch (e) {
          // If parsing fails, try common formats
          try {
            return DateFormat('yyyy-MM-dd').parse(timestamp);
          } catch (e) {
            return DateTime.now();
          }
        }
      }
      
      return DateTime.now();
    } catch (e) {
      print('⚠️ Error parsing timestamp: $e');
      return DateTime.now();
    }
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatTime(DateTime date) {
    try {
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return 'Invalid Time';
    }
  }

  IconData _getServiceIcon(String serviceType) {
    final type = serviceType.toLowerCase();
    
    if (type.contains('engine')) {
      return Icons.engineering;
    } else if (type.contains('brake')) {
      return Icons.fact_check;
    } else if (type.contains('ac') || type.contains('air conditioning')) {
      return Icons.ac_unit;
    } else if (type.contains('electrical')) {
      return Icons.electrical_services;
    } else if (type.contains('dent') || type.contains('paint')) {
      return Icons.format_paint;
    } else if (type.contains('maintenance') || type.contains('periodic')) {
      return Icons.build_circle;
    } else if (type.contains('oil')) {
      return Icons.opacity;
    } else if (type.contains('tire') || type.contains('tyre')) {
      return Icons.donut_large;
    } else if (type.contains('battery')) {
      return Icons.battery_charging_full;
    } else {
      return Icons.handyman;
    }
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed') {
      return Colors.green;
    } else if (statusLower == 'cancelled') {
      return Colors.red;
    } else if (statusLower.contains('progress')) {
      return Colors.orange;
    } else if (statusLower.contains('confirm')) {
      return Colors.blue;
    } else if (statusLower == 'pending') {
      return Colors.amber;
    } else {
      return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed' || statusLower.contains('complete')) {
      return 'Complete';
    } else if (statusLower == 'cancelled' || statusLower.contains('cancel')) {
      return 'Cancelled';
    } else if (statusLower.contains('reject')) {
      return 'Rejected';
    } else if (statusLower.contains('progress')) {
      return 'In Progress';
    } else if (statusLower.contains('confirm')) {
      return 'Confirmed';
    } else if (statusLower == 'pending') {
      return 'Pending';
    } else {
      // For any other status, show as "Not Complete"
      return 'Not Complete';
    }
  }
  
  bool _isComplete(String status) {
    final statusLower = status.toLowerCase();
    return statusLower == 'completed' || statusLower.contains('complete');
  }

  void _handleRetry() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    _loadServiceHistory();
  }

  void _showServiceDetails(ServiceHistory service, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsBottomSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_serviceHistory.isEmpty) {
      return _buildNoDataState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadServiceHistory();
        await _loadStatistics();
        if (_syncService.isOnline) {
          await _syncService.syncNow(widget.userEmail);
        }
      },
      backgroundColor: const Color(0xFF6D28D9),
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          // Statistics Section
          SliverToBoxAdapter(
            child: _buildStatisticsSection(),
          ),
          // History List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = _serviceHistory[index];
                  return _buildHistoryCard(service, context);
                },
                childCount: _serviceHistory.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading Service History...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fetching data for: ${widget.userEmail}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Load History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            const Text(
              'No Service History Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You don\'t have any completed or cancelled service requests yet.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Completed and cancelled requests will appear here automatically.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    if (_isLoadingStats) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Service Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (!_syncService.isOnline)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Services',
                  _statistics['total'] ?? 0,
                  Icons.request_quote,
                  Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  _statistics['completed'] ?? 0,
                  Icons.check_circle,
                  Colors.green.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Not Completed',
                  _statistics['notCompleted'] ?? 0,
                  Icons.pending,
                  Colors.orange.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color iconBg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ServiceHistory service, BuildContext context) {
    final statusColor = _getStatusColor(service.status);
    final statusText = _getStatusText(service.status);
    final isComplete = _isComplete(service.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showServiceDetails(service, context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getServiceIcon(service.serviceType),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serviceType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.vehicleNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Enhanced Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isComplete 
                            ? Colors.green.withOpacity(0.15)
                            : statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isComplete 
                              ? Colors.green
                              : statusColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isComplete ? Icons.check_circle : Icons.info_outline,
                            size: 14,
                            color: isComplete ? Colors.green : statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: isComplete ? Colors.green : statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Details Row
                Row(
                  children: [
                    _buildDetailItem(Icons.calendar_today, service.preferredDate),
                    _buildDetailItem(Icons.access_time, service.preferredTime),
                    _buildDetailItem(Icons.business, service.garageName),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          service.rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      service.cost,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDetailsBottomSheet extends StatelessWidget {

  const ServiceDetailsBottomSheet({super.key, required this.service});
  final ServiceHistory service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Service Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Service Information', [
                      _buildDetailRow('Request ID', service.requestId),
                      _buildDetailRow('Service Type', service.serviceType),
                      _buildDetailRow('Status', _getStatusText(service.status)),
                      _buildDetailRow('Provider', service.garageName),
                      _buildDetailRow('Rating', service.rating != 'N/A' ? '${service.rating} ⭐' : 'Not Rated'),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Timeline', [
                      _buildDetailRow('Requested On', DateFormat('MMM dd, yyyy • hh:mm a').format(service.createdAt)),
                      if (service.additionalData['completedAt'] != null)
                        _buildDetailRow('Completed On', DateFormat('MMM dd, yyyy • hh:mm a').format(service.additionalData['completedAt'] as DateTime)),
                    ]),
                    
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Schedule & Location', [
                      _buildDetailRow('Preferred Date', service.preferredDate),
                      _buildDetailRow('Preferred Time', service.preferredTime),
                      _buildDetailRow('Location', service.location),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Vehicle Information', [
                      _buildDetailRow('Vehicle Number', service.vehicleNumber),
                      _buildDetailRow('Vehicle Model', service.vehicleModel),
                      _buildDetailRow('Vehicle Type', service.vehicleType),
                      _buildDetailRow('Fuel Type', service.fuelType),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Customer Details', [
                      _buildDetailRow('Customer Name', service.name),
                      _buildDetailRow('Phone', service.phone),
                      _buildDetailRow('Email', service.userEmail),
                    ]),
                    
                    if (service.problemDescription.isNotEmpty && 
                        service.problemDescription != 'No description provided') ...[
                      const SizedBox(height: 20),
                      _buildDetailSection('Problem Description', [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            service.problemDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ]),
                    ],
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invoice download started...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Download Invoice',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D28D9),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed' || statusLower.contains('complete')) {
      return 'Complete';
    } else if (statusLower == 'cancelled' || statusLower.contains('cancel')) {
      return 'Cancelled';
    } else if (statusLower.contains('reject')) {
      return 'Rejected';
    } else if (statusLower.contains('progress') || statusLower == 'in process') {
      return 'In Progress';
    } else if (statusLower.contains('confirm')) {
      return 'Confirmed';
    } else if (statusLower == 'pending') {
      return 'Pending';
    } else {
      // For any other status, show as "Not Complete"
      return 'Not Complete';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class ServiceHistory {

  ServiceHistory({
    required this.id,
    required this.requestId,
    required this.vehicleNumber,
    required this.serviceType,
    required this.preferredDate,
    required this.preferredTime,
    required this.name,
    required this.phone,
    required this.location,
    required this.problemDescription,
    required this.userEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.cost,
    required this.garageName,
    required this.rating,
    required this.vehicleModel,
    required this.fuelType,
    required this.vehicleType,
    Map<String, dynamic>? additionalData,
  }) : additionalData = additionalData ?? {};
  final String id;
  final String requestId;
  final String vehicleNumber;
  final String serviceType;
  final String preferredDate;
  final String preferredTime;
  final String name;
  final String phone;
  final String location;
  final String problemDescription;
  final String userEmail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String cost;
  final String garageName;
  final String rating;
  final String vehicleModel;
  final String fuelType;
  final String vehicleType;
  Map<String, dynamic> additionalData;
}