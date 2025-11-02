import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _loginTimeKey = 'loginTime';
  static const String _userTypeKey = 'userType';

  // Save login data to SharedPreferences
  static Future<void> saveLoginData(String email, {String userType = 'vehicle_owner'}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_loginTimeKey, DateTime.now().toString());
      await prefs.setString(_userTypeKey, userType);
      print('✅ Login data saved for: $email');
    } catch (e) {
      print('❌ Error saving login data: $e');
      throw Exception('Failed to save login data');
    }
  }

  // Clear login data from SharedPreferences (for logout)
  static Future<void> clearLoginData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_loginTimeKey);
      await prefs.remove(_userTypeKey);
      print('✅ Login data cleared successfully');
    } catch (e) {
      print('❌ Error clearing login data: $e');
      throw Exception('Failed to clear login data');
    }
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Get user email from SharedPreferences
  static Future<String?> getUserEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      print('❌ Error getting user email: $e');
      return null;
    }
  }

  // Get user type from SharedPreferences
  static Future<String?> getUserType() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTypeKey);
    } catch (e) {
      print('❌ Error getting user type: $e');
      return null;
    }
  }

  // Get login time from SharedPreferences
  static Future<DateTime?> getLoginTime() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? loginTimeString = prefs.getString(_loginTimeKey);
      if (loginTimeString != null) {
        return DateTime.parse(loginTimeString);
      }
      return null;
    } catch (e) {
      print('❌ Error getting login time: $e');
      return null;
    }
  }

  // Check if session is expired (optional: 30 days expiry)
  static Future<bool> isSessionExpired() async {
    try {
      final DateTime? loginTime = await getLoginTime();
      if (loginTime == null) return true;
      
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(loginTime);
      
      // Session expires after 30 days
      return difference.inDays > 30;
    } catch (e) {
      print('❌ Error checking session expiry: $e');
      return true;
    }
  }

  // Comprehensive login status check
  static Future<bool> checkValidLogin() async {
    try {
      final bool isLoggedIn = await isUserLoggedIn();
      if (!isLoggedIn) return false;
      
      final bool isExpired = await isSessionExpired();
      if (isExpired) {
        await clearLoginData();
        return false;
      }
      
      return true;
    } catch (e) {
      print('❌ Error checking valid login: $e');
      return false;
    }
  }
}