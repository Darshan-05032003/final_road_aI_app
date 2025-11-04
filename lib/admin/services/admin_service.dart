import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_road_app/admin/services/admin_data_service.dart';
import 'package:smart_road_app/services/database_service.dart';

/// Comprehensive Admin Service - Aggregates data from all collections
class AdminService {
  factory AdminService() => _instance;
  AdminService._internal();
  static final AdminService _instance = AdminService._internal();

  final AdminDataService _dataService = AdminDataService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _dbService = DatabaseService();

  // ==================== DASHBOARD OVERVIEW ====================

  /// Get cached dashboard overview (fast - from SQLite)
  Future<Map<String, dynamic>> getCachedDashboardOverview() async {
    try {
      final cached = await _dbService.getCachedAdminStats('dashboard_overview');
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    } catch (e) {
      print('⚠️ Error getting cached dashboard overview: $e');
    }
    return {};
  }

  /// Get dashboard overview with all KPIs (with caching)
  Future<Map<String, dynamic>> getDashboardOverview() async {
    try {
      final usersCount = await _dataService.getUsersCount();
      final activeServices = await _dataService.getActiveServices();

      // Calculate metrics
      int totalRequests = 0;
      int completedRequests = 0;
      double totalRevenue = 0.0;
      double avgResponseTime = 0.0;

      // Get all service requests from all collections
      final allRequests = await _getAllServiceRequests();
      totalRequests = allRequests.length;
      completedRequests = allRequests.where((r) => r['status'] == 'completed').length;
      
      // Calculate revenue
      final completedWithCost = allRequests.where((r) => 
        r['status'] == 'completed' && r['totalAmount'] != null
      ).toList();
      totalRevenue = completedWithCost.fold(0.0, (sum, r) => sum + (r['totalAmount'] ?? 0.0));

      // Calculate average response time
      final responseTimes = <int>[];
      for (var req in allRequests) {
        if (req['assignedAt'] != null && req['createdAt'] != null) {
          final createdAt = req['createdAt'] is Timestamp 
              ? req['createdAt'].toDate() 
              : DateTime.parse(req['createdAt'].toString());
          final assignedAt = req['assignedAt'] is Timestamp 
              ? req['assignedAt'].toDate() 
              : DateTime.parse(req['assignedAt'].toString());
          final diff = assignedAt.difference(createdAt).inMinutes;
          if (diff > 0) responseTimes.add(diff);
        }
      }
      avgResponseTime = responseTimes.isEmpty 
          ? 0.0 
          : responseTimes.reduce((a, b) => a + b) / responseTimes.length;

      // Calculate completion rate
      final completionRate = totalRequests > 0 
          ? (completedRequests / totalRequests * 100) 
          : 0.0;

      final overview = {
        'totalUsers': usersCount['total'] ?? 0,
        'totalRequests': totalRequests,
        'activeRequests': activeServices.length,
        'completedRequests': completedRequests,
        'totalRevenue': totalRevenue,
        'avgResponseTime': avgResponseTime.round(),
        'completionRate': completionRate.round(),
        'vehicleOwners': usersCount['vehicleOwners'] ?? 0,
        'garages': usersCount['garages'] ?? 0,
        'towProviders': usersCount['towProviders'] ?? 0,
      };

      // Cache the overview for fast loading next time
      await _dbService.cacheAdminStats('dashboard_overview', overview);
      
      return overview;
    } catch (e) {
      print('❌ Error getting dashboard overview: $e');
      return {
        'totalUsers': 0,
        'totalRequests': 0,
        'activeRequests': 0,
        'completedRequests': 0,
        'totalRevenue': 0.0,
        'avgResponseTime': 0,
        'completionRate': 0,
      };
    }
  }

  /// Get cached recent activity (fast - from SQLite)
  Future<List<Map<String, dynamic>>> getCachedRecentActivity({int limit = 10}) async {
    try {
      final cached = await _dbService.getCachedAdminStats('recent_activity');
      if (cached != null && cached['activities'] != null) {
        final activities = cached['activities'] as List;
        return activities.take(limit).map((a) => a as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print('⚠️ Error getting cached recent activity: $e');
    }
    return [];
  }

  /// Get recent activity
  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 10}) async {
    try {
      final activities = <Map<String, dynamic>>[];
      
      // Get recent service requests
      final allRequests = await _getAllServiceRequests();
      allRequests.sort((a, b) {
        try {
          DateTime aTime;
          DateTime bTime;
          
          if (a['createdAt'] is Timestamp) {
            aTime = (a['createdAt'] as Timestamp).toDate();
          } else if (a['createdAt'] is DateTime) {
            aTime = a['createdAt'] as DateTime;
          } else if (a['createdAt'] is int) {
            aTime = DateTime.fromMillisecondsSinceEpoch(a['createdAt'] as int);
          } else {
            aTime = DateTime.parse(a['createdAt'].toString());
          }
          
          if (b['createdAt'] is Timestamp) {
            bTime = (b['createdAt'] as Timestamp).toDate();
          } else if (b['createdAt'] is DateTime) {
            bTime = b['createdAt'] as DateTime;
          } else if (b['createdAt'] is int) {
            bTime = DateTime.fromMillisecondsSinceEpoch(b['createdAt'] as int);
          } else {
            bTime = DateTime.parse(b['createdAt'].toString());
          }
          
          return bTime.compareTo(aTime);
        } catch (e) {
          print('⚠️ Error parsing timestamp in sort: $e');
          return 0;
        }
      });

      for (var req in allRequests.take(limit)) {
        activities.add({
          'type': 'Service Request',
          'icon': Icons.assignment,
          'description': 'New ${req['serviceType'] ?? 'service'} request',
          'timestamp': req['createdAt'],
          'color': Colors.blue,
        });
      }

      // Get recent user registrations
      final recentUsers = await _getRecentUsers(limit: 5);
      for (var user in recentUsers) {
        activities.add({
          'type': 'User Registration',
          'icon': Icons.person_add,
          'description': '${user['name']} registered as ${user['type']}',
          'timestamp': user['registrationDate'],
          'color': Colors.green,
        });
      }

      activities.sort((a, b) {
        try {
          DateTime aTime;
          DateTime bTime;
          
          if (a['timestamp'] is Timestamp) {
            aTime = (a['timestamp'] as Timestamp).toDate();
          } else if (a['timestamp'] is DateTime) {
            aTime = a['timestamp'] as DateTime;
          } else if (a['timestamp'] is int) {
            aTime = DateTime.fromMillisecondsSinceEpoch(a['timestamp'] as int);
          } else {
            aTime = DateTime.parse(a['timestamp'].toString());
          }
          
          if (b['timestamp'] is Timestamp) {
            bTime = (b['timestamp'] as Timestamp).toDate();
          } else if (b['timestamp'] is DateTime) {
            bTime = b['timestamp'] as DateTime;
          } else if (b['timestamp'] is int) {
            bTime = DateTime.fromMillisecondsSinceEpoch(b['timestamp'] as int);
          } else {
            bTime = DateTime.parse(b['timestamp'].toString());
          }
          
          return bTime.compareTo(aTime);
        } catch (e) {
          print('⚠️ Error parsing timestamp in activity sort: $e');
          return 0;
        }
      });

      final result = activities.take(limit).toList();
      
      // Cache the activity for fast loading next time
      await _dbService.cacheAdminStats('recent_activity', {
        'activities': result,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });
      
      return result;
    } catch (e) {
      print('❌ Error getting recent activity: $e');
      return [];
    }
  }

  /// Get cached emergency requests (fast - from SQLite)
  Future<List<Map<String, dynamic>>> getCachedEmergencyRequests() async {
    try {
      final cached = await _dbService.getCachedAdminStats('emergency_requests');
      if (cached != null && cached['emergencies'] != null) {
        final emergencies = cached['emergencies'] as List;
        return emergencies.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print('⚠️ Error getting cached emergency requests: $e');
    }
    return [];
  }

  /// Get emergency requests
  Future<List<Map<String, dynamic>>> getEmergencyRequests() async {
    try {
      final allRequests = await _getAllServiceRequests();
      final emergencies = allRequests.where((r) => 
        r['urgencyLevel'] == 'emergency' || 
        r['isEmergency'] == true ||
        (r['serviceType']?.toString().toLowerCase().contains('emergency') ?? false)
      ).toList();
      
      // Cache the emergency requests for fast loading next time
      await _dbService.cacheAdminStats('emergency_requests', {
        'emergencies': emergencies,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });
      
      return emergencies;
    } catch (e) {
      print('❌ Error getting emergency requests: $e');
      return [];
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Get all users with filters
  Future<List<Map<String, dynamic>>> getAllUsers({
    String? searchQuery,
    String? status,
    String? userType,
  }) async {
    try {
      var users = await _dataService.getAllUsers();
      
      // Apply filters
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        users = users.where((user) {
          final name = (user['name'] ?? '').toString().toLowerCase();
          final email = (user['email'] ?? '').toString().toLowerCase();
          final phone = (user['phone'] ?? '').toString().toLowerCase();
          return name.contains(query) || email.contains(query) || phone.contains(query);
        }).toList();
      }

      if (status != null && status.isNotEmpty && status != 'All Status') {
        users = users.where((user) => user['status'] == status).toList();
      }

      if (userType != null && userType.isNotEmpty && userType != 'All Users') {
        users = users.where((user) {
          final type = user['type']?.toString() ?? '';
          if (userType == 'Vehicle Owners') return type == 'Vehicle Owner';
          if (userType == 'Tow Providers') return type == 'Tow Provider';
          if (userType == 'Mechanics') return type == 'Garage';
          return true;
        }).toList();
      }

      return users;
    } catch (e) {
      print('❌ Error getting users: $e');
      return [];
    }
  }

  /// Update user status
  Future<bool> updateUserStatus(String userId, String userType, String newStatus) async {
    try {
      String collection = _getCollectionForUserType(userType);
      
      await _firestore.collection(collection).doc(userId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('❌ Error updating user status: $e');
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String userId, String userType) async {
    try {
      String collection = _getCollectionForUserType(userType);
      await _firestore.collection(collection).doc(userId).delete();
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  // ==================== ANALYTICS ====================

  /// Get analytics data
  Future<Map<String, dynamic>> getAnalyticsData({
    String timeRange = 'Monthly',
    String serviceFilter = 'All Services',
  }) async {
    try {
      final allRequests = await _getAllServiceRequests();
      
      // Filter by time range
      final now = DateTime.now();
      DateTime startDate;
      switch (timeRange) {
        case 'Daily':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'Weekly':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Quarterly':
          startDate = now.subtract(const Duration(days: 90));
          break;
        default: // Monthly
          startDate = DateTime(now.year, now.month, 1);
      }

      final filteredRequests = allRequests.where((req) {
        DateTime createdAt;
        if (req['createdAt'] is Timestamp) {
          createdAt = req['createdAt'].toDate();
        } else if (req['createdAt'] is DateTime) {
          createdAt = req['createdAt'] as DateTime;
        } else if (req['createdAt'] is int) {
          createdAt = DateTime.fromMillisecondsSinceEpoch(req['createdAt'] as int);
        } else {
          final str = req['createdAt'].toString();
          final intValue = int.tryParse(str);
          if (intValue != null && intValue > 1000000000000) {
            createdAt = DateTime.fromMillisecondsSinceEpoch(intValue);
          } else {
            createdAt = DateTime.parse(str);
          }
        }
        return createdAt.isAfter(startDate);
      }).toList();

      // Filter by service type
      final serviceFiltered = serviceFilter != 'All Services'
          ? filteredRequests.where((r) => 
              r['serviceType']?.toString().toLowerCase() == serviceFilter.toLowerCase()
            ).toList()
          : filteredRequests;

      // Calculate metrics
      final totalServices = serviceFiltered.length;
      final completed = serviceFiltered.where((r) => r['status'] == 'completed').length;
      final completionRate = totalServices > 0 ? (completed / totalServices * 100) : 0.0;

      // Calculate response time
      final responseTimes = <int>[];
      for (var req in serviceFiltered) {
        if (req['assignedAt'] != null && req['createdAt'] != null) {
          final createdAt = req['createdAt'] is Timestamp 
              ? req['createdAt'].toDate() 
              : DateTime.parse(req['createdAt'].toString());
          final assignedAt = req['assignedAt'] is Timestamp 
              ? req['assignedAt'].toDate() 
              : DateTime.parse(req['assignedAt'].toString());
          final diff = assignedAt.difference(createdAt).inMinutes;
          if (diff > 0) responseTimes.add(diff);
        }
      }
      final avgResponseTime = responseTimes.isEmpty 
          ? 0.0 
          : responseTimes.reduce((a, b) => a + b) / responseTimes.length;

      // Service distribution
      final serviceDistribution = <String, int>{};
      for (var req in serviceFiltered) {
        final type = req['serviceType']?.toString() ?? 'Unknown';
        serviceDistribution[type] = (serviceDistribution[type] ?? 0) + 1;
      }

      // Revenue
      final revenue = serviceFiltered.where((r) => 
        r['status'] == 'completed' && r['totalAmount'] != null
      ).fold(0.0, (sum, r) => sum + (r['totalAmount'] ?? 0.0));

      return {
        'totalServices': totalServices,
        'avgResponseTime': avgResponseTime.round(),
        'completionRate': completionRate.round(),
        'satisfactionRate': 85.0, // Placeholder - would need rating data
        'revenue': revenue,
        'activeUsers': await _getActiveUsersCount(),
        'serviceDistribution': serviceDistribution,
        'monthlyTrends': await _getMonthlyTrends(),
      };
    } catch (e) {
      print('❌ Error getting analytics data: $e');
      return {};
    }
  }

  // ==================== LIVE MONITORING ====================

  /// Get live monitoring data
  Future<Map<String, dynamic>> getLiveMonitoringData() async {
    try {
      final allRequests = await _getAllServiceRequests();
      
      final activeRequests = allRequests.where((r) => 
        ['pending', 'assigned', 'in_progress'].contains(r['status'])
      ).toList();

      final emergencyRequests = allRequests.where((r) => 
        r['urgencyLevel'] == 'emergency' || r['isEmergency'] == true
      ).toList();

      // Get online providers count (simplified - would need actual online status)
      final allProviders = await _dataService.getTopProviders();
      final onlineProviders = allProviders.length; // Placeholder

      return {
        'activeRequests': activeRequests.length,
        'onlineProviders': onlineProviders,
        'emergencyRequests': emergencyRequests.length,
        'requests': activeRequests,
        'emergencyRequestsList': emergencyRequests,
      };
    } catch (e) {
      print('❌ Error getting live monitoring data: $e');
      return {
        'activeRequests': 0,
        'onlineProviders': 0,
        'emergencyRequests': 0,
        'requests': [],
        'emergencyRequestsList': [],
      };
    }
  }

  // ==================== REVENUE ====================

  /// Get revenue data
  Future<Map<String, dynamic>> getRevenueData({String timeRange = 'Monthly'}) async {
    try {
      final allRequests = await _getAllServiceRequests();
      
      // Filter by time range
      final now = DateTime.now();
      DateTime startDate;
      switch (timeRange) {
        case 'Daily':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'Weekly':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Quarterly':
          startDate = now.subtract(const Duration(days: 90));
          break;
        default: // Monthly
          startDate = DateTime(now.year, now.month, 1);
      }

      final filteredRequests = allRequests.where((req) {
        DateTime createdAt;
        if (req['createdAt'] is Timestamp) {
          createdAt = req['createdAt'].toDate();
        } else if (req['createdAt'] is DateTime) {
          createdAt = req['createdAt'] as DateTime;
        } else if (req['createdAt'] is int) {
          createdAt = DateTime.fromMillisecondsSinceEpoch(req['createdAt'] as int);
        } else {
          final str = req['createdAt'].toString();
          final intValue = int.tryParse(str);
          if (intValue != null && intValue > 1000000000000) {
            createdAt = DateTime.fromMillisecondsSinceEpoch(intValue);
          } else {
            createdAt = DateTime.parse(str);
          }
        }
        return createdAt.isAfter(startDate) && req['status'] == 'completed';
      }).toList();

      // Calculate revenue
      final totalRevenue = filteredRequests.fold(0.0, (sum, r) => 
        sum + (r['totalAmount'] ?? 0.0)
      );
      final adminCommission = totalRevenue * 0.10; // 10%
      final providerEarnings = totalRevenue * 0.90; // 90%
      final transactionCount = filteredRequests.length;
      final avgTransaction = transactionCount > 0 
          ? totalRevenue / transactionCount 
          : 0.0;

      // Calculate growth (simplified - would need previous period data)
      final previousPeriodRevenue = totalRevenue * 0.88; // Placeholder
      final growthRate = previousPeriodRevenue > 0 
          ? ((totalRevenue - previousPeriodRevenue) / previousPeriodRevenue * 100) 
          : 0.0;

      return {
        'totalRevenue': totalRevenue,
        'adminCommission': adminCommission,
        'providerEarnings': providerEarnings,
        'transactions': transactionCount,
        'avgTransaction': avgTransaction,
        'growthRate': growthRate,
        'monthlyTrends': await _getMonthlyRevenueTrends(),
      };
    } catch (e) {
      print('❌ Error getting revenue data: $e');
      return {
        'totalRevenue': 0.0,
        'adminCommission': 0.0,
        'providerEarnings': 0.0,
        'transactions': 0,
        'avgTransaction': 0.0,
        'growthRate': 0.0,
        'monthlyTrends': [],
      };
    }
  }

  // ==================== HELPER METHODS ====================

  /// Get all service requests from all collections
  Future<List<Map<String, dynamic>>> _getAllServiceRequests() async {
    try {
      final allRequests = <Map<String, dynamic>>[];

      // Get from vehicle owners' garage requests
      final ownersSnapshot = await _firestore.collection('owner').get();
      for (var ownerDoc in ownersSnapshot.docs) {
        final garageRequests = await _firestore
            .collection('owner')
            .doc(ownerDoc.id)
            .collection('garagerequest')
            .get();
        
        for (var reqDoc in garageRequests.docs) {
          final data = reqDoc.data();
          allRequests.add({
            'id': reqDoc.id,
            'userId': ownerDoc.id,
            'serviceType': data['serviceType'] ?? 'Garage Service',
            'status': data['status'] ?? 'pending',
            'urgencyLevel': data['urgencyLevel'] ?? 'medium',
            'location': data['location'] ?? '',
            'latitude': data['userLatitude'],
            'longitude': data['userLongitude'],
            'totalAmount': data['totalAmount'] ?? data['serviceAmount'] ?? 0.0,
            'createdAt': data['createdAt'],
            'assignedAt': data['assignedAt'],
            ...data,
          });
        }

        // Get tow requests if they exist
        try {
          final towRequests = await _firestore
              .collection('owner')
              .doc(ownerDoc.id)
              .collection('towrequest')
              .get();
          
          for (var reqDoc in towRequests.docs) {
            final data = reqDoc.data();
            allRequests.add({
              'id': reqDoc.id,
              'userId': ownerDoc.id,
              'serviceType': data['serviceType'] ?? 'Tow Service',
              'status': data['status'] ?? 'pending',
              'urgencyLevel': data['urgencyLevel'] ?? 'medium',
              'location': data['location'] ?? '',
              'latitude': data['latitude'],
              'longitude': data['longitude'],
              'totalAmount': data['totalAmount'] ?? data['cost'] ?? 0.0,
              'createdAt': data['createdAt'] ?? data['timestamp'],
              'assignedAt': data['assignedAt'],
              ...data,
            });
          }
        } catch (e) {
          // Collection might not exist
        }
      }

      // Get from garages' service requests
      final garagesSnapshot = await _firestore.collection('garages').get();
      for (var garageDoc in garagesSnapshot.docs) {
        try {
          final serviceRequests = await _firestore
              .collection('garages')
              .doc(garageDoc.id)
              .collection('service_requests')
              .get();
          
          for (var reqDoc in serviceRequests.docs) {
            final data = reqDoc.data();
            allRequests.add({
              'id': reqDoc.id,
              'providerId': garageDoc.id,
              'serviceType': data['serviceType'] ?? 'Garage Service',
              'status': data['status'] ?? 'pending',
              'urgencyLevel': data['urgencyLevel'] ?? 'medium',
              'location': data['location'] ?? '',
              'latitude': data['userLatitude'],
              'longitude': data['userLongitude'],
              'totalAmount': data['totalAmount'] ?? data['serviceAmount'] ?? 0.0,
              'createdAt': data['createdAt'],
              'assignedAt': data['assignedAt'],
              ...data,
            });
          }
        } catch (e) {
          // Collection might not exist
        }
      }

      // Get from tow providers' service requests
      final towProvidersSnapshot = await _firestore.collection('tow_providers').get();
      for (var providerDoc in towProvidersSnapshot.docs) {
        try {
          final serviceRequests = await _firestore
              .collection('tow_providers')
              .doc(providerDoc.id)
              .collection('service_requests')
              .get();
          
          for (var reqDoc in serviceRequests.docs) {
            final data = reqDoc.data();
            allRequests.add({
              'id': reqDoc.id,
              'providerId': providerDoc.id,
              'serviceType': data['serviceType'] ?? 'Tow Service',
              'status': data['status'] ?? 'pending',
              'urgencyLevel': data['urgencyLevel'] ?? 'emergency',
              'location': data['location'] ?? '',
              'latitude': data['latitude'],
              'longitude': data['longitude'],
              'totalAmount': data['totalAmount'] ?? data['cost'] ?? 0.0,
              'createdAt': data['createdAt'] ?? data['timestamp'],
              'assignedAt': data['assignedAt'],
              ...data,
            });
          }
        } catch (e) {
          // Collection might not exist
        }
      }

      return allRequests;
    } catch (e) {
      print('❌ Error getting all service requests: $e');
      return [];
    }
  }

  /// Get recent users
  Future<List<Map<String, dynamic>>> _getRecentUsers({int limit = 10}) async {
    try {
      final users = await _dataService.getAllUsers();
      users.sort((a, b) {
        final aTime = a['registrationDate'] is Timestamp 
            ? a['registrationDate'].toDate() 
            : DateTime.parse(a['registrationDate'].toString());
        final bTime = b['registrationDate'] is Timestamp 
            ? b['registrationDate'].toDate() 
            : DateTime.parse(b['registrationDate'].toString());
        return bTime.compareTo(aTime);
      });
      return users.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get active users count
  Future<int> _getActiveUsersCount() async {
    try {
      final users = await _dataService.getAllUsers();
      return users.where((u) => u['status'] == 'Active').length;
    } catch (e) {
      return 0;
    }
  }

  /// Get monthly trends
  Future<List<Map<String, dynamic>>> _getMonthlyTrends() async {
    try {
      final allRequests = await _getAllServiceRequests();
      final now = DateTime.now();
      final trends = <Map<String, dynamic>>[];

      for (int i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 0);
        
        final monthRequests = allRequests.where((req) {
          final createdAt = req['createdAt'] is Timestamp 
              ? req['createdAt'].toDate() 
              : DateTime.parse(req['createdAt'].toString());
          return createdAt.isAfter(month.subtract(const Duration(days: 1))) &&
                 createdAt.isBefore(monthEnd.add(const Duration(days: 1)));
        }).toList();

        trends.add({
          'month': _getMonthName(month.month),
          'services': monthRequests.length,
          'revenue': monthRequests.where((r) => 
            r['status'] == 'completed' && r['totalAmount'] != null
          ).fold(0.0, (sum, r) => sum + (r['totalAmount'] ?? 0.0)),
          'satisfaction': 85.0, // Placeholder
        });
      }

      return trends;
    } catch (e) {
      return [];
    }
  }

  /// Get monthly revenue trends
  Future<List<Map<String, dynamic>>> _getMonthlyRevenueTrends() async {
    try {
      final allRequests = await _getAllServiceRequests();
      final now = DateTime.now();
      final trends = <Map<String, dynamic>>[];

      for (int i = 5; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 0);
        
        final monthRequests = allRequests.where((req) {
          final createdAt = req['createdAt'] is Timestamp 
              ? req['createdAt'].toDate() 
              : DateTime.parse(req['createdAt'].toString());
          return createdAt.isAfter(month.subtract(const Duration(days: 1))) &&
                 createdAt.isBefore(monthEnd.add(const Duration(days: 1))) &&
                 req['status'] == 'completed';
        }).toList();

        final revenue = monthRequests.fold(0.0, (sum, r) => 
          sum + (r['totalAmount'] ?? 0.0)
        );

        trends.add({
          'month': _getMonthName(month.month),
          'revenue': revenue,
        });
      }

      return trends;
    } catch (e) {
      return [];
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getCollectionForUserType(String userType) {
    switch (userType) {
      case 'Vehicle Owner':
        return 'owner';
      case 'Garage':
        return 'garages';
      case 'Tow Provider':
        return 'tow_providers';
      case 'Insurance':
        return 'insurance_companies';
      default:
        return 'owner';
    }
  }
}

