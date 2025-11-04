import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_road_app/services/database_service.dart';

/// Admin Cache Sync Service - Cache-first data loading for admin section
class AdminCacheSyncService {
  factory AdminCacheSyncService() => _instance;
  AdminCacheSyncService._internal();
  static final AdminCacheSyncService _instance = AdminCacheSyncService._internal();

  final DatabaseService _dbService = DatabaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USERS ====================

  /// Get users count with cache-first strategy
  Future<Map<String, int>> getUsersCount({
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedCount = await _dbService.getCachedAdminUsersCount();
      if (cachedCount['total']! > 0) {
        print('✅ Loaded users count from cache: $cachedCount');
        if (syncInBackground) {
          _syncUsersCount();
        }
        return cachedCount;
      }
    }

    // Fetch from Firestore
    final counts = await _fetchUsersCountFromFirestore();
    await _dbService.cacheAdminStats('users_count', counts);
    return counts;
  }

  Future<Map<String, int>> _fetchUsersCountFromFirestore() async {
    try {
      final ownerCount = await _firestore.collection('owner').count().get();
      final garageCount = await _firestore.collection('garages').count().get();
      final towCount = await _firestore.collection('tow_providers').count().get();
      final insuranceCount = await _firestore.collection('insurance_companies').count().get();

      final owner = ownerCount.count ?? 0;
      final garage = garageCount.count ?? 0;
      final tow = towCount.count ?? 0;
      final insurance = insuranceCount.count ?? 0;

      return {
        'total': owner + garage + tow + insurance,
        'vehicleOwners': owner,
        'garages': garage,
        'towProviders': tow,
        'insurance': insurance,
      };
    } catch (e) {
      print('Error fetching users count from Firestore: $e');
      return {'total': 0, 'vehicleOwners': 0, 'garages': 0, 'towProviders': 0, 'insurance': 0};
    }
  }

  Future<void> _syncUsersCount() async {
    try {
      final counts = await _fetchUsersCountFromFirestore();
      await _dbService.cacheAdminStats('users_count', counts);
      print('✅ Synced users count in background');
    } catch (e) {
      print('⚠️ Error syncing users count: $e');
    }
  }

  /// Get all users with cache-first strategy
  Future<List<Map<String, dynamic>>> getAllUsers({
    String? userType,
    String? status,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedUsers = await _dbService.getCachedAdminUsers(
        userType: userType,
        status: status,
      );
      if (cachedUsers.isNotEmpty) {
        print('✅ Loaded ${cachedUsers.length} users from cache');
        if (syncInBackground) {
          _syncAllUsers();
        }
        return cachedUsers;
      }
    }

    // Fetch from Firestore
    final users = await _fetchAllUsersFromFirestore();
    if (users.isNotEmpty) {
      await _dbService.cacheAdminUsers(users);
    }
    return users;
  }

  Future<List<Map<String, dynamic>>> _fetchAllUsersFromFirestore() async {
    try {
      List<Map<String, dynamic>> allUsers = [];

      // Get Vehicle Owners
      final ownersSnapshot = await _firestore.collection('owner').get();
      for (var doc in ownersSnapshot.docs) {
        final data = doc.data();
        final profileDoc = await _firestore
            .collection('owner')
            .doc(doc.id)
            .collection('profile')
            .doc('user_details')
            .get();
        final profileData = profileDoc.data() ?? {};

        allUsers.add({
          'id': doc.id,
          'type': 'Vehicle Owner',
          'name': profileData['name'] ?? data['name'] ?? 'Unknown',
          'email': doc.id,
          'phone': profileData['phone'] ?? data['phone'] ?? 'N/A',
          'status': 'Active',
          'registrationDate': profileData['createdAt'] ?? data['createdAt'] ?? Timestamp.now(),
          'avatarColor': _getColorForType('Vehicle Owner'),
        });
      }

      // Get Garages
      final garagesSnapshot = await _firestore.collection('garages').get();
      for (var doc in garagesSnapshot.docs) {
        final data = doc.data();
        allUsers.add({
          'id': doc.id,
          'type': 'Garage',
          'name': data['garageName'] ?? data['name'] ?? 'Unknown Garage',
          'email': doc.id,
          'phone': data['phone'] ?? data['contactNumber'] ?? 'N/A',
          'status': data['status'] ?? 'Active',
          'registrationDate': data['createdAt'] ?? Timestamp.now(),
          'avatarColor': _getColorForType('Garage'),
        });
      }

      // Get Tow Providers
      final towSnapshot = await _firestore.collection('tow_providers').get();
      for (var doc in towSnapshot.docs) {
        final data = doc.data();
        allUsers.add({
          'id': doc.id,
          'type': 'Tow Provider',
          'name': data['providerName'] ?? data['name'] ?? 'Unknown Provider',
          'email': doc.id,
          'phone': data['phone'] ?? data['contactNumber'] ?? 'N/A',
          'status': data['status'] ?? 'Active',
          'registrationDate': data['createdAt'] ?? Timestamp.now(),
          'avatarColor': _getColorForType('Tow Provider'),
        });
      }

      // Get Insurance Companies
      final insuranceSnapshot = await _firestore.collection('insurance_companies').get();
      for (var doc in insuranceSnapshot.docs) {
        final data = doc.data();
        allUsers.add({
          'id': doc.id,
          'type': 'Insurance',
          'name': data['companyName'] ?? data['name'] ?? 'Unknown Insurance',
          'email': doc.id,
          'phone': data['phone'] ?? data['contactNumber'] ?? 'N/A',
          'status': data['status'] ?? 'Active',
          'registrationDate': data['createdAt'] ?? Timestamp.now(),
          'avatarColor': _getColorForType('Insurance'),
        });
      }

      return allUsers;
    } catch (e) {
      print('Error fetching all users from Firestore: $e');
      return [];
    }
  }

  Future<void> _syncAllUsers() async {
    try {
      final users = await _fetchAllUsersFromFirestore();
      await _dbService.cacheAdminUsers(users);
      print('✅ Synced ${users.length} users in background');
    } catch (e) {
      print('⚠️ Error syncing users: $e');
    }
  }

  // ==================== SERVICES ====================

  /// Get active services count with cache-first strategy
  Future<int> getActiveServicesCount({
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedCount = await _dbService.getCachedAdminActiveServicesCount();
      if (cachedCount > 0) {
        print('✅ Loaded active services count from cache: $cachedCount');
        if (syncInBackground) {
          _syncActiveServices();
        }
        return cachedCount;
      }
    }

    // Fetch from Firestore
    final count = await _fetchActiveServicesCountFromFirestore();
    return count;
  }

  Future<int> _fetchActiveServicesCountFromFirestore() async {
    try {
      int count = 0;

      final garageRequests = await _firestore
          .collectionGroup('garagerequest')
          .where('status', whereIn: ['pending', 'in process', 'accepted', 'confirmed'])
          .count()
          .get();
      count += garageRequests.count ?? 0;

      final towRequests = await _firestore
          .collectionGroup('towrequest')
          .where('status', whereIn: ['pending', 'in process', 'accepted', 'confirmed'])
          .count()
          .get();
      count += towRequests.count ?? 0;

      return count;
    } catch (e) {
      print('Error fetching active services count from Firestore: $e');
      return 0;
    }
  }

  /// Get active services with cache-first strategy
  Future<List<Map<String, dynamic>>> getActiveServices({
    String? serviceType,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedServices = await _dbService.getCachedAdminServices(
        serviceType: serviceType,
        status: null, // Get all active statuses
        limit: 50,
      );
      if (cachedServices.isNotEmpty) {
        print('✅ Loaded ${cachedServices.length} active services from cache');
        if (syncInBackground) {
          _syncActiveServices();
        }
        return cachedServices;
      }
    }

    // Fetch from Firestore
    final services = await _fetchActiveServicesFromFirestore();
    if (services.isNotEmpty) {
      await _dbService.cacheAdminServices(services);
    }
    return services;
  }

  Future<List<Map<String, dynamic>>> _fetchActiveServicesFromFirestore() async {
    try {
      List<Map<String, dynamic>> allServices = [];

      // Get garage requests
      final garageRequests = await _firestore
          .collectionGroup('garagerequest')
          .where('status', whereIn: ['pending', 'in process', 'accepted', 'confirmed'])
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      for (var doc in garageRequests.docs) {
        final data = doc.data();
        allServices.add({
          'id': doc.id,
          'type': 'Garage Service',
          'serviceType': 'Mechanic',
          'customer': data['userEmail'] ?? 'Unknown',
          'status': data['status'] ?? 'Pending',
          'createdAt': data['createdAt'] ?? Timestamp.now(),
          'location': data['location'] ?? 'Unknown',
          'vehicle': data['vehicleNumber'] ?? 'N/A',
          'problem': data['problemDescription'] ?? data['description'] ?? 'N/A',
          'provider': data['garageName'] ?? data['assignedGarage'] ?? 'Not Assigned',
        });
      }

      // Get tow requests
      final towRequests = await _firestore
          .collectionGroup('towrequest')
          .where('status', whereIn: ['pending', 'in process', 'accepted', 'confirmed'])
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      for (var doc in towRequests.docs) {
        final data = doc.data();
        allServices.add({
          'id': doc.id,
          'type': 'Tow Service',
          'serviceType': 'Tow',
          'customer': data['userEmail'] ?? 'Unknown',
          'status': data['status'] ?? 'Pending',
          'createdAt': data['createdAt'] ?? Timestamp.now(),
          'location': data['location'] ?? 'Unknown',
          'vehicle': data['vehicleNumber'] ?? 'N/A',
          'problem': data['description'] ?? data['issue'] ?? 'N/A',
          'provider': data['providerName'] ?? data['towProviderName'] ?? 'Not Assigned',
        });
      }

      // Sort by creation date
      allServices.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp;
        final bTime = b['createdAt'] as Timestamp;
        return bTime.compareTo(aTime);
      });

      return allServices.take(50).toList();
    } catch (e) {
      print('Error fetching active services from Firestore: $e');
      return [];
    }
  }

  Future<void> _syncActiveServices() async {
    try {
      final services = await _fetchActiveServicesFromFirestore();
      await _dbService.cacheAdminServices(services);
      print('✅ Synced ${services.length} active services in background');
    } catch (e) {
      print('⚠️ Error syncing active services: $e');
    }
  }

  // ==================== REVENUE ====================

  /// Get revenue stats with cache-first strategy
  Future<Map<String, dynamic>> getRevenueStats({
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedStats = await _dbService.getCachedAdminRevenueStats();
      if (cachedStats['totalTransactions']! > 0) {
        print('✅ Loaded revenue stats from cache');
        if (syncInBackground) {
          _syncRevenue();
        }
        return cachedStats;
      }
    }

    // Fetch from Firestore
    final stats = await _fetchRevenueStatsFromFirestore();
    return stats;
  }

  Future<Map<String, dynamic>> _fetchRevenueStatsFromFirestore() async {
    try {
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('paymentStatus', isEqualTo: 'completed')
          .get();

      double totalRevenue = 0;
      double todayRevenue = 0;
      double monthlyRevenue = 0;
      int totalTransactions = 0;

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final monthStart = DateTime(now.year, now.month, 1);

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data();
        final amount = (data['totalAmount'] ?? data['amount'] ?? 0).toDouble();
        final createdAt = (data['createdAt'] ?? data['paidAt'] ?? Timestamp.now()) as Timestamp;
        final createdDate = createdAt.toDate();

        totalRevenue += amount;
        totalTransactions++;

        if (createdDate.isAfter(todayStart)) {
          todayRevenue += amount;
        }

        if (createdDate.isAfter(monthStart)) {
          monthlyRevenue += amount;
        }
      }

      final stats = {
        'totalRevenue': totalRevenue,
        'todayRevenue': todayRevenue,
        'monthlyRevenue': monthlyRevenue,
        'totalTransactions': totalTransactions,
        'averageTransaction': totalTransactions > 0 ? totalRevenue / totalTransactions : 0,
      };

      // Cache the stats
      await _dbService.cacheAdminStats('revenue_stats', stats);

      return stats;
    } catch (e) {
      print('Error fetching revenue stats from Firestore: $e');
      return {
        'totalRevenue': 0.0,
        'todayRevenue': 0.0,
        'monthlyRevenue': 0.0,
        'totalTransactions': 0,
        'averageTransaction': 0.0,
      };
    }
  }

  /// Get recent transactions with cache-first strategy
  Future<List<Map<String, dynamic>>> getRecentTransactions({
    int limit = 20,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedTransactions = await _dbService.getCachedAdminRevenue(limit: limit);
      if (cachedTransactions.isNotEmpty) {
        print('✅ Loaded ${cachedTransactions.length} transactions from cache');
        if (syncInBackground) {
          _syncRevenue();
        }
        return cachedTransactions;
      }
    }

    // Fetch from Firestore
    final transactions = await _fetchRecentTransactionsFromFirestore(limit: limit);
    if (transactions.isNotEmpty) {
      await _dbService.cacheAdminRevenueList(transactions);
    }
    return transactions;
  }

  Future<List<Map<String, dynamic>>> _fetchRecentTransactionsFromFirestore({int limit = 20}) async {
    try {
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return paymentsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'transactionId': data['transactionId'] ?? doc.id,
          'customer': data['customerEmail'] ?? 'Unknown',
          'provider': data['providerEmail'] ?? 'Unknown',
          'serviceType': data['serviceType'] ?? 'Unknown',
          'amount': data['totalAmount'] ?? data['amount'] ?? 0.0,
          'status': data['paymentStatus'] ?? 'pending',
          'date': data['createdAt'] ?? data['paidAt'] ?? Timestamp.now(),
          'method': data['paymentMethod'] ?? 'UPI',
        };
      }).toList();
    } catch (e) {
      print('Error fetching recent transactions from Firestore: $e');
      return [];
    }
  }

  Future<void> _syncRevenue() async {
    try {
      final transactions = await _fetchRecentTransactionsFromFirestore(limit: 100);
      await _dbService.cacheAdminRevenueList(transactions);
      
      // Also sync stats
      await _fetchRevenueStatsFromFirestore();
      
      print('✅ Synced revenue data in background');
    } catch (e) {
      print('⚠️ Error syncing revenue: $e');
    }
  }

  // ==================== PROVIDERS ====================

  /// Get top providers with cache-first strategy
  Future<List<Map<String, dynamic>>> getTopProviders({
    int limit = 10,
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    if (useCache) {
      final cachedProviders = await _dbService.getCachedAdminProviders(limit: limit);
      if (cachedProviders.isNotEmpty) {
        print('✅ Loaded ${cachedProviders.length} providers from cache');
        if (syncInBackground) {
          _syncProviders();
        }
        return cachedProviders;
      }
    }

    // Fetch from Firestore
    final providers = await _fetchTopProvidersFromFirestore(limit: limit);
    if (providers.isNotEmpty) {
      await _dbService.cacheAdminProviders(providers);
    }
    return providers;
  }

  Future<List<Map<String, dynamic>>> _fetchTopProvidersFromFirestore({int limit = 10}) async {
    try {
      List<Map<String, dynamic>> providers = [];

      // Get garages with service counts
      final garagesSnapshot = await _firestore.collection('garages').get();
      for (var doc in garagesSnapshot.docs) {
        final data = doc.data();
        final serviceRequestsSnapshot = await _firestore
            .collection('garages')
            .doc(doc.id)
            .collection('service_requests')
            .count()
            .get();

        providers.add({
          'id': doc.id,
          'name': data['garageName'] ?? 'Unknown Garage',
          'type': 'Garage',
          'services': serviceRequestsSnapshot.count ?? 0,
          'rating': (data['rating'] ?? 4.5).toDouble(),
          'email': doc.id,
          'phone': data['phone'] ?? 'N/A',
        });
      }

      // Get tow providers with service counts
      final towSnapshot = await _firestore.collection('tow_providers').get();
      for (var doc in towSnapshot.docs) {
        final data = doc.data();
        final serviceRequestsSnapshot = await _firestore
            .collection('tow_providers')
            .doc(doc.id)
            .collection('service_requests')
            .count()
            .get();

        providers.add({
          'id': doc.id,
          'name': data['providerName'] ?? 'Unknown Provider',
          'type': 'Tow Provider',
          'services': serviceRequestsSnapshot.count ?? 0,
          'rating': (data['rating'] ?? 4.5).toDouble(),
          'email': doc.id,
          'phone': data['phone'] ?? 'N/A',
        });
      }

      // Sort by service count
      providers.sort((a, b) => (b['services'] as int).compareTo(a['services'] as int));

      return providers.take(limit).toList();
    } catch (e) {
      print('Error fetching top providers from Firestore: $e');
      return [];
    }
  }

  Future<void> _syncProviders() async {
    try {
      final providers = await _fetchTopProvidersFromFirestore(limit: 50);
      await _dbService.cacheAdminProviders(providers);
      print('✅ Synced ${providers.length} providers in background');
    } catch (e) {
      print('⚠️ Error syncing providers: $e');
    }
  }

  // ==================== ANALYTICS ====================

  /// Get analytics data with cache-first strategy
  Future<Map<String, dynamic>> getAnalyticsData({
    bool useCache = true,
    bool syncInBackground = true,
  }) async {
    // Analytics is calculated from other data, so we'll use cache for the underlying data
    final servicesCount = await getServicesCount(useCache: useCache);
    final usersCount = await getUsersCount(useCache: useCache);
    final revenueStats = await getRevenueStats(useCache: useCache);

    // Get service distribution
    final garageCount = servicesCount['garage'] ?? 0;
    final towCount = servicesCount['tow'] ?? 0;
    final total = servicesCount['total'] ?? 1;

    final serviceDistribution = {
      'Garage Service': total > 0 ? (garageCount / total * 100).round() : 0,
      'Tow Service': total > 0 ? (towCount / total * 100).round() : 0,
    };

    // Get completion rate
    final completedGarage = await _firestore
        .collectionGroup('garagerequest')
        .where('status', isEqualTo: 'completed')
        .count()
        .get();
    final completedTow = await _firestore
        .collectionGroup('towrequest')
        .where('status', isEqualTo: 'completed')
        .count()
        .get();

    final completedCount = (completedGarage.count ?? 0) + (completedTow.count ?? 0);
    final completionRate = total > 0 ? (completedCount / total * 100) : 0.0;

    return {
      'kpis': {
        'totalServices': total,
        'activeUsers': usersCount['total'] ?? 0,
        'revenue': revenueStats['totalRevenue'] ?? 0.0,
        'completionRate': completionRate,
        'averageResponseTime': 12.5,
      },
      'serviceDistribution': serviceDistribution,
      'usersCount': usersCount,
    };
  }

  /// Get services count
  Future<Map<String, int>> getServicesCount({bool useCache = true}) async {
    try {
      final garageTotal = await _firestore.collectionGroup('garagerequest').count().get();
      final towTotal = await _firestore.collectionGroup('towrequest').count().get();

      final garage = garageTotal.count ?? 0;
      final tow = towTotal.count ?? 0;

      return {
        'total': garage + tow,
        'garage': garage,
        'tow': tow,
      };
    } catch (e) {
      print('Error getting services count: $e');
      return {'total': 0, 'garage': 0, 'tow': 0};
    }
  }

  // ==================== RECENT ACTIVITY ====================

  /// Get recent activity (uses cached services and users)
  Future<List<Map<String, dynamic>>> getRecentActivity({
    int limit = 20,
    bool useCache = true,
  }) async {
    try {
      List<Map<String, dynamic>> activities = [];

      // Get recent services from cache or Firestore
      final recentServices = await getActiveServices(
        useCache: useCache,
        syncInBackground: false,
      );

      for (var service in recentServices.take(limit ~/ 2)) {
        activities.add({
          'type': 'service_request',
          'title': 'New ${service['type']} request',
          'description': '${service['customer'] ?? 'User'} requested service',
          'timestamp': service['createdAt'] ?? Timestamp.now(),
          'icon': 'build',
        });
      }

      // Get recent users from cache
      final recentUsers = await getAllUsers(
        useCache: useCache,
        syncInBackground: false,
      );

      for (var user in recentUsers.take(limit ~/ 4)) {
        activities.add({
          'type': 'user_registration',
          'title': 'New ${user['type']} registered',
          'description': '${user['email']} joined the platform',
          'timestamp': user['registrationDate'] ?? Timestamp.now(),
          'icon': 'person_add',
        });
      }

      // Sort by timestamp
      activities.sort((a, b) {
        final aTime = a['timestamp'] as Timestamp;
        final bTime = b['timestamp'] as Timestamp;
        return bTime.compareTo(aTime);
      });

      return activities.take(limit).toList();
    } catch (e) {
      print('Error getting recent activity: $e');
      return [];
    }
  }

  // ==================== HELPER METHODS ====================

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'vehicle owner':
        return const Color(0xFF6366F1);
      case 'garage':
        return const Color(0xFFF59E0B);
      case 'tow provider':
        return const Color(0xFF3B82F6);
      case 'insurance':
        return const Color(0xFF8B5CF6);
      default:
        return Colors.grey;
    }
  }
}
