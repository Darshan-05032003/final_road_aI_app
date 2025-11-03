import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// SQLite Database Service for local caching
/// This service provides fast local storage for frequently accessed data
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'smart_road_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Service Requests Table (Garage & Tow)
    await db.execute('''
      CREATE TABLE service_requests (
        id TEXT PRIMARY KEY,
        request_id TEXT NOT NULL,
        user_email TEXT NOT NULL,
        service_type TEXT NOT NULL,
        status TEXT NOT NULL,
        payment_status TEXT,
        vehicle_number TEXT,
        vehicle_model TEXT,
        vehicle_type TEXT,
        fuel_type TEXT,
        provider_name TEXT,
        provider_email TEXT,
        provider_upi_id TEXT,
        problem_description TEXT,
        service_amount REAL,
        tax_amount REAL,
        total_amount REAL,
        estimated_price REAL,
        location TEXT,
        latitude REAL,
        longitude REAL,
        preferred_date TEXT,
        preferred_time TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        completed_at INTEGER,
        paid_at INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_user_email (user_email),
        INDEX idx_status (status),
        INDEX idx_service_type (service_type),
        INDEX idx_request_id (request_id),
        INDEX idx_last_synced (last_synced)
      )
    ''');

    // Payment History Table
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        transaction_id TEXT,
        request_id TEXT NOT NULL,
        user_email TEXT NOT NULL,
        provider_email TEXT NOT NULL,
        service_type TEXT NOT NULL,
        amount REAL NOT NULL,
        tax_amount REAL,
        total_amount REAL NOT NULL,
        payment_method TEXT,
        payment_status TEXT NOT NULL,
        upi_transaction_id TEXT,
        provider_upi_id TEXT,
        created_at INTEGER NOT NULL,
        paid_at INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_user_email (user_email),
        INDEX idx_request_id (request_id),
        INDEX idx_payment_status (payment_status),
        INDEX idx_created_at (created_at)
      )
    ''');

    // User Profiles Table
    await db.execute('''
      CREATE TABLE user_profiles (
        email TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        role TEXT NOT NULL,
        profile_picture_url TEXT,
        upi_id TEXT,
        address TEXT,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_role (role)
      )
    ''');

    // Notifications Table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_email TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        type TEXT,
        is_read INTEGER NOT NULL DEFAULT 0,
        data_json TEXT,
        created_at INTEGER NOT NULL,
        last_synced INTEGER NOT NULL,
        INDEX idx_user_email (user_email),
        INDEX idx_is_read (is_read),
        INDEX idx_created_at (created_at)
      )
    ''');

    // Inventory Parts Table (for Garage)
    await db.execute('''
      CREATE TABLE inventory_parts (
        id TEXT PRIMARY KEY,
        garage_email TEXT NOT NULL,
        name TEXT NOT NULL,
        category TEXT,
        compatible_models TEXT,
        upi_id TEXT,
        description TEXT,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        image_url TEXT,
        is_available INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_garage_email (garage_email),
        INDEX idx_category (category),
        INDEX idx_is_available (is_available)
      )
    ''');

    // Service History Table (for quick access)
    await db.execute('''
      CREATE TABLE service_history (
        id TEXT PRIMARY KEY,
        request_id TEXT NOT NULL,
        user_email TEXT NOT NULL,
        service_type TEXT NOT NULL,
        status TEXT NOT NULL,
        cost REAL,
        rating TEXT,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_user_email (user_email),
        INDEX idx_status (status),
        INDEX idx_created_at (created_at)
      )
    ''');

    // Admin Users Table (for admin dashboard)
    await db.execute('''
      CREATE TABLE admin_users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT,
        phone TEXT,
        user_type TEXT NOT NULL,
        status TEXT,
        registration_date INTEGER,
        avatar_color INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_user_type (user_type),
        INDEX idx_status (status),
        INDEX idx_email (email)
      )
    ''');

    // Admin Services Table (all active services)
    await db.execute('''
      CREATE TABLE admin_services (
        id TEXT PRIMARY KEY,
        service_type TEXT NOT NULL,
        customer_email TEXT NOT NULL,
        status TEXT NOT NULL,
        location TEXT,
        vehicle_number TEXT,
        problem_description TEXT,
        provider_name TEXT,
        provider_email TEXT,
        created_at INTEGER NOT NULL,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_service_type (service_type),
        INDEX idx_status (status),
        INDEX idx_created_at (created_at)
      )
    ''');

    // Admin Revenue Table
    await db.execute('''
      CREATE TABLE admin_revenue (
        id TEXT PRIMARY KEY,
        transaction_id TEXT,
        customer_email TEXT NOT NULL,
        provider_email TEXT NOT NULL,
        service_type TEXT,
        amount REAL NOT NULL,
        tax_amount REAL,
        total_amount REAL NOT NULL,
        payment_method TEXT,
        payment_status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        paid_at INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_customer_email (customer_email),
        INDEX idx_payment_status (payment_status),
        INDEX idx_created_at (created_at)
      )
    ''');

    // Admin Providers Table
    await db.execute('''
      CREATE TABLE admin_providers (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        provider_type TEXT NOT NULL,
        phone TEXT,
        services_count INTEGER DEFAULT 0,
        rating REAL DEFAULT 0.0,
        data_json TEXT,
        last_synced INTEGER NOT NULL,
        INDEX idx_provider_type (provider_type),
        INDEX idx_email (email)
      )
    ''');

    // Admin Stats Cache Table (for quick stats)
    await db.execute('''
      CREATE TABLE admin_stats (
        key TEXT PRIMARY KEY,
        value INTEGER,
        data_json TEXT,
        last_synced INTEGER NOT NULL
      )
    ''');

    print('✅ Database tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here if needed
  }

  // ==================== Service Requests ====================

  /// Cache service request
  Future<void> cacheServiceRequest(Map<String, dynamic> serviceData) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await db.insert(
        'service_requests',
        {
          'id': serviceData['id'] ?? serviceData['requestId'],
          'request_id': serviceData['requestId'] ?? serviceData['id'],
          'user_email': serviceData['userEmail'] ?? '',
          'service_type': serviceData['serviceType'] ?? '',
          'status': serviceData['status'] ?? 'pending',
          'payment_status': serviceData['paymentStatus'] ?? 'pending',
          'vehicle_number': serviceData['vehicleNumber'],
          'vehicle_model': serviceData['vehicleModel'],
          'vehicle_type': serviceData['vehicleType'],
          'fuel_type': serviceData['fuelType'],
          'provider_name': serviceData['garageName'] ?? serviceData['providerName'] ?? serviceData['assignedGarage'],
          'provider_email': serviceData['garageEmail'] ?? serviceData['providerEmail'],
          'provider_upi_id': serviceData['providerUpiId'],
          'problem_description': serviceData['problemDescription'] ?? serviceData['description'] ?? serviceData['issue'],
          'service_amount': serviceData['serviceAmount'],
          'tax_amount': serviceData['taxAmount'],
          'total_amount': serviceData['totalAmount'],
          'estimated_price': serviceData['estimatedPrice'],
          'location': serviceData['location'],
          'latitude': serviceData['userLatitude'] ?? serviceData['latitude'],
          'longitude': serviceData['userLongitude'] ?? serviceData['longitude'],
          'preferred_date': serviceData['preferredDate'],
          'preferred_time': serviceData['preferredTime'],
          'created_at': _parseTimestamp(serviceData['createdAt']),
          'updated_at': _parseTimestamp(serviceData['updatedAt'] ?? serviceData['createdAt']),
          'completed_at': _parseTimestamp(serviceData['completedAt']),
          'paid_at': _parseTimestamp(serviceData['paidAt']),
          'data_json': jsonEncode(serviceData),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching service request: $e');
    }
  }

  /// Cache multiple service requests
  Future<void> cacheServiceRequests(List<Map<String, dynamic>> services) async {
    for (var service in services) {
      await cacheServiceRequest(service);
    }
    print('✅ Cached ${services.length} service requests');
  }

  /// Get cached service requests
  Future<List<Map<String, dynamic>>> getCachedServiceRequests({
    required String userEmail,
    String? status,
    String? serviceType,
    int? limit,
  }) async {
    final db = await database;
    try {
      String whereClause = 'user_email = ?';
      List<dynamic> whereArgs = [userEmail];

      if (status != null) {
        whereClause += ' AND status = ?';
        whereArgs.add(status);
      }

      if (serviceType != null) {
        whereClause += ' AND service_type = ?';
        whereArgs.add(serviceType);
      }

      String query = 'SELECT * FROM service_requests WHERE $whereClause ORDER BY created_at DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);

      return maps.map((map) {
        // Try to parse JSON data first, fallback to map fields
        if (map['data_json'] != null) {
          try {
            final jsonData = jsonDecode(map['data_json'] as String);
            return jsonData as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing cached JSON: $e');
          }
        }
        
        // Convert SQLite map to service format
        return {
          'id': map['id'],
          'requestId': map['request_id'],
          'userEmail': map['user_email'],
          'serviceType': map['service_type'],
          'status': map['status'],
          'paymentStatus': map['payment_status'],
          'vehicleNumber': map['vehicle_number'],
          'vehicleModel': map['vehicle_model'],
          'vehicleType': map['vehicle_type'],
          'fuelType': map['fuel_type'],
          'garageName': map['provider_name'],
          'providerName': map['provider_name'],
          'garageEmail': map['provider_email'],
          'providerEmail': map['provider_email'],
          'providerUpiId': map['provider_upi_id'],
          'problemDescription': map['problem_description'],
          'description': map['problem_description'],
          'issue': map['problem_description'],
          'serviceAmount': map['service_amount'],
          'taxAmount': map['tax_amount'],
          'totalAmount': map['total_amount'],
          'estimatedPrice': map['estimated_price'],
          'location': map['location'],
          'userLatitude': map['latitude'],
          'userLongitude': map['longitude'],
          'preferredDate': map['preferred_date'],
          'preferredTime': map['preferred_time'],
          'createdAt': Timestamp.fromMillisecondsSinceEpoch(map['created_at'] as int),
          'updatedAt': Timestamp.fromMillisecondsSinceEpoch(map['updated_at'] as int),
          'completedAt': map['completed_at'] != null 
              ? Timestamp.fromMillisecondsSinceEpoch(map['completed_at'] as int)
              : null,
          'paidAt': map['paid_at'] != null
              ? Timestamp.fromMillisecondsSinceEpoch(map['paid_at'] as int)
              : null,
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting cached service requests: $e');
      return [];
    }
  }

  /// Clear old cached service requests (older than 30 days)
  Future<void> clearOldServiceRequests({int daysOld = 30}) async {
    final db = await database;
    final cutoffTime = DateTime.now().subtract(Duration(days: daysOld)).millisecondsSinceEpoch;
    await db.delete(
      'service_requests',
      where: 'last_synced < ?',
      whereArgs: [cutoffTime],
    );
    print('✅ Cleared old service requests');
  }

  // ==================== Payments ====================

  /// Cache payment
  Future<void> cachePayment(Map<String, dynamic> paymentData) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await db.insert(
        'payments',
        {
          'id': paymentData['id'] ?? paymentData['transactionId'],
          'transaction_id': paymentData['transactionId'],
          'request_id': paymentData['requestId'],
          'user_email': paymentData['customerEmail'] ?? paymentData['userEmail'],
          'provider_email': paymentData['providerEmail'],
          'service_type': paymentData['serviceType'],
          'amount': paymentData['amount'] ?? paymentData['serviceAmount'],
          'tax_amount': paymentData['taxAmount'],
          'total_amount': paymentData['totalAmount'],
          'payment_method': paymentData['paymentMethod'],
          'payment_status': paymentData['paymentStatus'] ?? 'pending',
          'upi_transaction_id': paymentData['upiTransactionId'],
          'provider_upi_id': paymentData['providerUpiId'],
          'created_at': _parseTimestamp(paymentData['createdAt']),
          'paid_at': _parseTimestamp(paymentData['paidAt']),
          'data_json': jsonEncode(paymentData),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching payment: $e');
    }
  }

  /// Get cached payments
  Future<List<Map<String, dynamic>>> getCachedPayments({
    required String userEmail,
    String? status,
    int? limit,
  }) async {
    final db = await database;
    try {
      String whereClause = 'user_email = ?';
      List<dynamic> whereArgs = [userEmail];

      if (status != null) {
        whereClause += ' AND payment_status = ?';
        whereArgs.add(status);
      }

      String query = 'SELECT * FROM payments WHERE $whereClause ORDER BY created_at DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing payment JSON: $e');
          }
        }
        return map;
      }).toList();
    } catch (e) {
      print('❌ Error getting cached payments: $e');
      return [];
    }
  }

  // ==================== User Profiles ====================

  /// Cache user profile
  Future<void> cacheUserProfile(Map<String, dynamic> profileData, String email, String role) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await db.insert(
        'user_profiles',
        {
          'email': email,
          'name': profileData['name'],
          'phone': profileData['phone'],
          'role': role,
          'profile_picture_url': profileData['profilePictureUrl'],
          'upi_id': profileData['upiId'],
          'address': profileData['address'],
          'data_json': jsonEncode(profileData),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching user profile: $e');
    }
  }

  /// Get cached user profile
  Future<Map<String, dynamic>?> getCachedUserProfile(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'user_profiles',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      if (map['data_json'] != null) {
        try {
          return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
        } catch (e) {
          print('⚠️ Error parsing profile JSON: $e');
        }
      }

      return {
        'email': map['email'],
        'name': map['name'],
        'phone': map['phone'],
        'role': map['role'],
        'profilePictureUrl': map['profile_picture_url'],
        'upiId': map['upi_id'],
        'address': map['address'],
      };
    } catch (e) {
      print('❌ Error getting cached user profile: $e');
      return null;
    }
  }

  // ==================== Notifications ====================

  /// Cache notification
  Future<void> cacheNotification(Map<String, dynamic> notificationData, String userEmail) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await db.insert(
        'notifications',
        {
          'id': notificationData['id'],
          'user_email': userEmail,
          'title': notificationData['title'],
          'body': notificationData['body'],
          'type': notificationData['type'],
          'is_read': notificationData['isRead'] == true ? 1 : 0,
          'data_json': jsonEncode(notificationData),
          'created_at': _parseTimestamp(notificationData['timestamp'] ?? notificationData['createdAt']),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching notification: $e');
    }
  }

  /// Get cached notifications
  Future<List<Map<String, dynamic>>> getCachedNotifications({
    required String userEmail,
    bool? isRead,
    int? limit,
  }) async {
    final db = await database;
    try {
      String whereClause = 'user_email = ?';
      List<dynamic> whereArgs = [userEmail];

      if (isRead != null) {
        whereClause += ' AND is_read = ?';
        whereArgs.add(isRead ? 1 : 0);
      }

      String query = 'SELECT * FROM notifications WHERE $whereClause ORDER BY created_at DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing notification JSON: $e');
          }
        }
        return map;
      }).toList();
    } catch (e) {
      print('❌ Error getting cached notifications: $e');
      return [];
    }
  }

  // ==================== Inventory Parts ====================

  /// Cache inventory part
  Future<void> cacheInventoryPart(Map<String, dynamic> partData, String garageEmail) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await db.insert(
        'inventory_parts',
        {
          'id': partData['id'],
          'garage_email': garageEmail,
          'name': partData['name'],
          'category': partData['category'],
          'compatible_models': partData['compatibleModels'],
          'upi_id': partData['upiId'],
          'description': partData['description'],
          'price': partData['price'],
          'stock': partData['stock'],
          'image_url': partData['imageUrl'],
          'is_available': partData['isAvailable'] == true ? 1 : 0,
          'created_at': _parseTimestamp(partData['createdAt']),
          'updated_at': _parseTimestamp(partData['updatedAt'] ?? partData['createdAt']),
          'data_json': jsonEncode(partData),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching inventory part: $e');
    }
  }

  /// Get cached inventory parts
  Future<List<Map<String, dynamic>>> getCachedInventoryParts(String garageEmail) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'inventory_parts',
        where: 'garage_email = ?',
        whereArgs: [garageEmail],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing inventory JSON: $e');
          }
        }
        return map;
      }).toList();
    } catch (e) {
      print('❌ Error getting cached inventory parts: $e');
      return [];
    }
  }

  // ==================== Utility Methods ====================

  int _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now().millisecondsSinceEpoch;
    if (timestamp is Timestamp) return timestamp.millisecondsSinceEpoch;
    if (timestamp is DateTime) return timestamp.millisecondsSinceEpoch;
    if (timestamp is int) return timestamp;
    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp).millisecondsSinceEpoch;
      } catch (e) {
        return DateTime.now().millisecondsSinceEpoch;
      }
    }
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Clear all cached data for a user
  Future<void> clearUserCache(String userEmail) async {
    final db = await database;
    await db.delete('service_requests', where: 'user_email = ?', whereArgs: [userEmail]);
    await db.delete('payments', where: 'user_email = ?', whereArgs: [userEmail]);
    await db.delete('notifications', where: 'user_email = ?', whereArgs: [userEmail]);
    await db.delete('user_profiles', where: 'email = ?', whereArgs: [userEmail]);
    print('✅ Cleared cache for user: $userEmail');
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('service_requests');
    await db.delete('payments');
    await db.delete('notifications');
    await db.delete('user_profiles');
    await db.delete('inventory_parts');
    await db.delete('service_history');
    print('✅ Cleared all cached data');
  }

  /// Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    final db = await database;
    final serviceCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM service_requests'),
    ) ?? 0;
    final paymentCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM payments'),
    ) ?? 0;
    final notificationCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM notifications'),
    ) ?? 0;
    final profileCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_profiles'),
    ) ?? 0;
    final adminUserCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM admin_users'),
    ) ?? 0;
    final adminServiceCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM admin_services'),
    ) ?? 0;

    return {
      'services': serviceCount,
      'payments': paymentCount,
      'notifications': notificationCount,
      'profiles': profileCount,
      'admin_users': adminUserCount,
      'admin_services': adminServiceCount,
    };
  }

  // ==================== ADMIN DATA CACHING ====================

  /// Cache admin user
  Future<void> cacheAdminUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        'admin_users',
        {
          'id': user['id'] ?? user['email'],
          'email': user['email'] ?? '',
          'name': user['name'],
          'phone': user['phone'],
          'user_type': user['type'] ?? '',
          'status': user['status'] ?? 'Active',
          'registration_date': _parseTimestamp(user['registrationDate']),
          'avatar_color': (user['avatarColor'] as Color?)?.value ?? 0xFF6366F1,
          'data_json': jsonEncode(user),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching admin user: $e');
    }
  }

  /// Cache multiple admin users
  Future<void> cacheAdminUsers(List<Map<String, dynamic>> users) async {
    for (var user in users) {
      await cacheAdminUser(user);
    }
    print('✅ Cached ${users.length} admin users');
  }

  /// Get cached admin users
  Future<List<Map<String, dynamic>>> getCachedAdminUsers({
    String? userType,
    String? status,
  }) async {
    final db = await database;
    try {
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];

      if (userType != null) {
        whereClause += ' AND user_type = ?';
        whereArgs.add(userType);
      }

      if (status != null) {
        whereClause += ' AND status = ?';
        whereArgs.add(status);
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'admin_users',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'registration_date DESC',
      );

      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing cached admin user JSON: $e');
          }
        }
        return {
          'id': map['id'],
          'email': map['email'],
          'name': map['name'],
          'phone': map['phone'],
          'type': map['user_type'],
          'status': map['status'],
          'registrationDate': map['registration_date'] != null
              ? Timestamp.fromMillisecondsSinceEpoch(map['registration_date'] as int)
              : null,
          'avatarColor': Color(map['avatar_color'] as int? ?? 0xFF6366F1),
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting cached admin users: $e');
      return [];
    }
  }

  /// Get cached admin users count
  Future<Map<String, int>> getCachedAdminUsersCount() async {
    final db = await database;
    try {
      final total = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_users'),
      ) ?? 0;
      final owners = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_users WHERE user_type = ?', ['Vehicle Owner']),
      ) ?? 0;
      final garages = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_users WHERE user_type = ?', ['Garage']),
      ) ?? 0;
      final tow = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_users WHERE user_type = ?', ['Tow Provider']),
      ) ?? 0;
      final insurance = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_users WHERE user_type = ?', ['Insurance']),
      ) ?? 0;

      return {
        'total': total,
        'vehicleOwners': owners,
        'garages': garages,
        'towProviders': tow,
        'insurance': insurance,
      };
    } catch (e) {
      print('❌ Error getting cached admin users count: $e');
      return {'total': 0, 'vehicleOwners': 0, 'garages': 0, 'towProviders': 0, 'insurance': 0};
    }
  }

  /// Cache admin service
  Future<void> cacheAdminService(Map<String, dynamic> service) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        'admin_services',
        {
          'id': service['id'],
          'service_type': service['type'] ?? service['serviceType'] ?? '',
          'customer_email': service['customer'] ?? service['userEmail'] ?? '',
          'status': service['status'] ?? 'pending',
          'location': service['location'],
          'vehicle_number': service['vehicle'] ?? service['vehicleNumber'],
          'problem_description': service['problem'] ?? service['problemDescription'] ?? service['description'],
          'provider_name': service['provider'] ?? service['providerName'] ?? service['garageName'],
          'provider_email': service['providerEmail'] ?? service['garageEmail'],
          'created_at': _parseTimestamp(service['createdAt']),
          'data_json': jsonEncode(service),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching admin service: $e');
    }
  }

  /// Cache multiple admin services
  Future<void> cacheAdminServices(List<Map<String, dynamic>> services) async {
    for (var service in services) {
      await cacheAdminService(service);
    }
    print('✅ Cached ${services.length} admin services');
  }

  /// Get cached admin services
  Future<List<Map<String, dynamic>>> getCachedAdminServices({
    String? serviceType,
    String? status,
    int? limit,
  }) async {
    final db = await database;
    try {
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];

      if (serviceType != null) {
        whereClause += ' AND service_type = ?';
        whereArgs.add(serviceType);
      }

      if (status != null) {
        whereClause += ' AND status = ?';
        whereArgs.add(status);
      }

      String query = 'SELECT * FROM admin_services WHERE $whereClause ORDER BY created_at DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);

      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing cached admin service JSON: $e');
          }
        }
        return {
          'id': map['id'],
          'type': map['service_type'],
          'customer': map['customer_email'],
          'status': map['status'],
          'location': map['location'],
          'vehicle': map['vehicle_number'],
          'problem': map['problem_description'],
          'provider': map['provider_name'],
          'createdAt': Timestamp.fromMillisecondsSinceEpoch(map['created_at'] as int),
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting cached admin services: $e');
      return [];
    }
  }

  /// Get cached admin active services count
  Future<int> getCachedAdminActiveServicesCount() async {
    final db = await database;
    try {
      return Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM admin_services WHERE status IN (?, ?, ?, ?)',
          ['pending', 'in process', 'accepted', 'confirmed'],
        ),
      ) ?? 0;
    } catch (e) {
      print('❌ Error getting cached admin active services count: $e');
      return 0;
    }
  }

  /// Cache admin revenue transaction
  Future<void> cacheAdminRevenue(Map<String, dynamic> transaction) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        'admin_revenue',
        {
          'id': transaction['id'] ?? transaction['transactionId'],
          'transaction_id': transaction['transactionId'] ?? transaction['id'],
          'customer_email': transaction['customer'] ?? transaction['customerEmail'] ?? '',
          'provider_email': transaction['provider'] ?? transaction['providerEmail'] ?? '',
          'service_type': transaction['serviceType'],
          'amount': transaction['amount'] ?? 0.0,
          'tax_amount': transaction['taxAmount'],
          'total_amount': transaction['totalAmount'] ?? transaction['amount'] ?? 0.0,
          'payment_method': transaction['method'] ?? transaction['paymentMethod'] ?? 'UPI',
          'payment_status': transaction['status'] ?? transaction['paymentStatus'] ?? 'pending',
          'created_at': _parseTimestamp(transaction['date'] ?? transaction['createdAt'] ?? transaction['paidAt']),
          'paid_at': _parseTimestamp(transaction['paidAt']),
          'data_json': jsonEncode(transaction),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching admin revenue: $e');
    }
  }

  /// Cache multiple admin revenue transactions
  Future<void> cacheAdminRevenueList(List<Map<String, dynamic>> transactions) async {
    for (var transaction in transactions) {
      await cacheAdminRevenue(transaction);
    }
    print('✅ Cached ${transactions.length} admin revenue transactions');
  }

  /// Get cached admin revenue transactions
  Future<List<Map<String, dynamic>>> getCachedAdminRevenue({int? limit}) async {
    final db = await database;
    try {
      String query = 'SELECT * FROM admin_revenue ORDER BY created_at DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query);

      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing cached revenue JSON: $e');
          }
        }
        return {
          'id': map['id'],
          'transactionId': map['transaction_id'],
          'customer': map['customer_email'],
          'provider': map['provider_email'],
          'serviceType': map['service_type'],
          'amount': map['amount'],
          'totalAmount': map['total_amount'],
          'status': map['payment_status'],
          'date': Timestamp.fromMillisecondsSinceEpoch(map['created_at'] as int),
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting cached admin revenue: $e');
      return [];
    }
  }

  /// Get cached admin revenue stats
  Future<Map<String, dynamic>> getCachedAdminRevenueStats() async {
    final db = await database;
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final monthStart = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;

      // Total revenue
      final totalResult = await db.rawQuery(
        'SELECT SUM(total_amount) as total FROM admin_revenue WHERE payment_status = ?',
        ['completed'],
      );
      final totalRevenue = (totalResult.first['total'] as num?)?.toDouble() ?? 0.0;

      // Today revenue
      final todayResult = await db.rawQuery(
        'SELECT SUM(total_amount) as total FROM admin_revenue WHERE payment_status = ? AND created_at >= ?',
        ['completed', todayStart],
      );
      final todayRevenue = (todayResult.first['total'] as num?)?.toDouble() ?? 0.0;

      // Monthly revenue
      final monthResult = await db.rawQuery(
        'SELECT SUM(total_amount) as total FROM admin_revenue WHERE payment_status = ? AND created_at >= ?',
        ['completed', monthStart],
      );
      final monthlyRevenue = (monthResult.first['total'] as num?)?.toDouble() ?? 0.0;

      // Total transactions
      final transactionCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM admin_revenue'),
      ) ?? 0;

      return {
        'totalRevenue': totalRevenue,
        'todayRevenue': todayRevenue,
        'monthlyRevenue': monthlyRevenue,
        'totalTransactions': transactionCount,
        'averageTransaction': transactionCount > 0 ? totalRevenue / transactionCount : 0.0,
      };
    } catch (e) {
      print('❌ Error getting cached admin revenue stats: $e');
      return {
        'totalRevenue': 0.0,
        'todayRevenue': 0.0,
        'monthlyRevenue': 0.0,
        'totalTransactions': 0,
        'averageTransaction': 0.0,
      };
    }
  }

  /// Cache admin provider
  Future<void> cacheAdminProvider(Map<String, dynamic> provider) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        'admin_providers',
        {
          'id': provider['id'] ?? provider['email'],
          'email': provider['email'] ?? '',
          'name': provider['name'] ?? '',
          'provider_type': provider['type'] ?? '',
          'phone': provider['phone'],
          'services_count': provider['services'] ?? 0,
          'rating': provider['rating'] ?? 0.0,
          'data_json': jsonEncode(provider),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching admin provider: $e');
    }
  }

  /// Cache multiple admin providers
  Future<void> cacheAdminProviders(List<Map<String, dynamic>> providers) async {
    for (var provider in providers) {
      await cacheAdminProvider(provider);
    }
    print('✅ Cached ${providers.length} admin providers');
  }

  /// Get cached admin providers
  Future<List<Map<String, dynamic>>> getCachedAdminProviders({
    String? providerType,
    int? limit,
  }) async {
    final db = await database;
    try {
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];

      if (providerType != null) {
        whereClause += ' AND provider_type = ?';
        whereArgs.add(providerType);
      }

      String query = 'SELECT * FROM admin_providers WHERE $whereClause ORDER BY services_count DESC';
      if (limit != null) {
        query += ' LIMIT $limit';
      }

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);

      return maps.map((map) {
        if (map['data_json'] != null) {
          try {
            return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
          } catch (e) {
            print('⚠️ Error parsing cached provider JSON: $e');
          }
        }
        return {
          'id': map['id'],
          'email': map['email'],
          'name': map['name'],
          'type': map['provider_type'],
          'phone': map['phone'],
          'services': map['services_count'],
          'rating': map['rating'],
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting cached admin providers: $e');
      return [];
    }
  }

  /// Cache admin stats
  Future<void> cacheAdminStats(String key, Map<String, dynamic> stats) async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        'admin_stats',
        {
          'key': key,
          'value': stats['total'] ?? 0,
          'data_json': jsonEncode(stats),
          'last_synced': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error caching admin stats: $e');
    }
  }

  /// Get cached admin stats
  Future<Map<String, dynamic>?> getCachedAdminStats(String key) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'admin_stats',
        where: 'key = ?',
        whereArgs: [key],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      if (map['data_json'] != null) {
        try {
          return jsonDecode(map['data_json'] as String) as Map<String, dynamic>;
        } catch (e) {
          print('⚠️ Error parsing cached stats JSON: $e');
        }
      }

      return {'total': map['value'] ?? 0};
    } catch (e) {
      print('❌ Error getting cached admin stats: $e');
      return null;
    }
  }

  /// Clear admin cache
  Future<void> clearAdminCache() async {
    final db = await database;
    await db.delete('admin_users');
    await db.delete('admin_services');
    await db.delete('admin_revenue');
    await db.delete('admin_providers');
    await db.delete('admin_stats');
    print('✅ Cleared admin cache');
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
