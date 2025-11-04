import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_road_app/admin/services/admin_cache_sync_service.dart';

/// Admin Data Service - Uses Cache-First Strategy for Fast Data Loading
class AdminDataService {
  factory AdminDataService() => _instance;
  AdminDataService._internal();
  static final AdminDataService _instance = AdminDataService._internal();

  final AdminCacheSyncService _cacheSync = AdminCacheSyncService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER STATISTICS ====================

  /// Get total users count by type (cache-first)
  Future<Map<String, int>> getUsersCount() async {
    return await _cacheSync.getUsersCount(
      useCache: true,
      syncInBackground: true,
    );
  }

  /// Get all users with details (cache-first)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await _cacheSync.getAllUsers(
      useCache: true,
      syncInBackground: true,
    );
  }

  // ==================== SERVICE STATISTICS ====================

  /// Get active services count (cache-first)
  Future<int> getActiveServicesCount() async {
    return await _cacheSync.getActiveServicesCount(
      useCache: true,
      syncInBackground: true,
    );
  }

  /// Get all active services (cache-first)
  Future<List<Map<String, dynamic>>> getActiveServices() async {
    return await _cacheSync.getActiveServices(
      useCache: true,
      syncInBackground: true,
    );
  }


  // ==================== REVENUE STATISTICS ====================

  /// Get revenue statistics (cache-first)
  Future<Map<String, dynamic>> getRevenueStats() async {
    return await _cacheSync.getRevenueStats(
      useCache: true,
      syncInBackground: true,
    );
  }

  /// Get recent transactions (cache-first)
  Future<List<Map<String, dynamic>>> getRecentTransactions({int limit = 20}) async {
    return await _cacheSync.getRecentTransactions(
      limit: limit,
      useCache: true,
      syncInBackground: true,
    );
  }

  // ==================== ANALYTICS ====================

  /// Get analytics data (cache-first)
  Future<Map<String, dynamic>> getAnalyticsData() async {
    return await _cacheSync.getAnalyticsData(
      useCache: true,
      syncInBackground: true,
    );
  }

  // ==================== PROVIDERS STATISTICS ====================

  /// Get top providers (cache-first)
  Future<List<Map<String, dynamic>>> getTopProviders({int limit = 10}) async {
    return await _cacheSync.getTopProviders(
      limit: limit,
      useCache: true,
      syncInBackground: true,
    );
  }

  // ==================== RECENT ACTIVITY ====================

  /// Get recent activity (cache-first)
  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 20}) async {
    return await _cacheSync.getRecentActivity(
      limit: limit,
      useCache: true,
    );
  }

  /// Get services count (for analytics)
  Future<Map<String, int>> getServicesCount() async {
    return await _cacheSync.getServicesCount(useCache: true);
  }
}
