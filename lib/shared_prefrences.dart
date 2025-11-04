// // // // // // import 'package:shared_preferences/shared_preferences.dart';

// // // // // // class AuthService {
// // // // // //   // Keys for SharedPreferences
// // // // // //   static const String _isLoggedInKey = 'isLoggedIn';
// // // // // //   static const String _userEmailKey = 'userEmail';
// // // // // //   static const String _userRoleKey = 'userRole';
// // // // // //   static const String _loginTimeKey = 'loginTime';
// // // // // //   static const String _userIdKey = 'userId';
// // // // // //   static const String _userNameKey = 'userName';

// // // // // //   // Save login data
// // // // // //   static Future<void> saveLoginData({
// // // // // //     required String email,
// // // // // //     String? role,
// // // // // //     String? userId,
// // // // // //     String? userName,
// // // // // //   }) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_isLoggedInKey, true);
// // // // // //       await prefs.setString(_userEmailKey, email);
// // // // // //       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
// // // // // //       if (role != null) {
// // // // // //         await prefs.setString(_userRoleKey, role);
// // // // // //       }
      
// // // // // //       if (userId != null) {
// // // // // //         await prefs.setString(_userIdKey, userId);
// // // // // //       }
      
// // // // // //       if (userName != null) {
// // // // // //         await prefs.setString(_userNameKey, userName);
// // // // // //       }
      
// // // // // //       print('✅ Login data saved successfully for: $email');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving login data: $e');
// // // // // //       throw Exception('Failed to save login data');
// // // // // //     }
// // // // // //   }

// // // // // //   // Check if user is logged in
// // // // // //   static Future<bool> checkValidLogin() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
// // // // // //       if (isLoggedIn) {
// // // // // //         // Optional: Check if login session is still valid (e.g., within 30 days)
// // // // // //         final loginTime = prefs.getString(_loginTimeKey);
// // // // // //         if (loginTime != null) {
// // // // // //           final loginDateTime = DateTime.parse(loginTime);
// // // // // //           final now = DateTime.now();
// // // // // //           final difference = now.difference(loginDateTime);
          
// // // // // //           // Session expires after 30 days (optional)
// // // // // //           if (difference.inDays > 30) {
// // // // // //             await logout();
// // // // // //             return false;
// // // // // //           }
// // // // // //         }
// // // // // //       }
      
// // // // // //       return isLoggedIn;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking login status: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get user email
// // // // // //   static Future<String?> getUserEmail() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_userEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting user email: $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get user role
// // // // // //   static Future<String?> getUserRole() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_userRoleKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting user role: $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get user ID
// // // // // //   static Future<String?> getUserId() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_userIdKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting user ID: $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get user name
// // // // // //   static Future<String?> getUserName() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_userNameKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting user name: $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get login time
// // // // // //   static Future<DateTime?> getLoginTime() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       final loginTimeString = prefs.getString(_loginTimeKey);
// // // // // //       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting login time: $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // Logout user
// // // // // //   static Future<void> logout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_isLoggedInKey, false);
// // // // // //       await prefs.remove(_userEmailKey);
// // // // // //       await prefs.remove(_userRoleKey);
// // // // // //       await prefs.remove(_userIdKey);
// // // // // //       await prefs.remove(_userNameKey);
// // // // // //       await prefs.remove(_loginTimeKey);
      
// // // // // //       print('✅ User logged out successfully');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during logout: $e');
// // // // // //       throw Exception('Failed to logout');
// // // // // //     }
// // // // // //   }

// // // // // //   // Clear all data (for debugging or app reset)
// // // // // //   static Future<void> clearAllData() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.clear();
// // // // // //       print('✅ All SharedPreferences data cleared');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error clearing all data: $e');
// // // // // //       throw Exception('Failed to clear data');
// // // // // //     }
// // // // // //   }

// // // // // //   // Check if first time app launch
// // // // // //   static Future<bool> isFirstTime() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       final isFirstTime = prefs.getBool('first_time') ?? true;
// // // // // //       if (isFirstTime) {
// // // // // //         await prefs.setBool('first_time', false);
// // // // // //       }
// // // // // //       return isFirstTime;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking first time: $e');
// // // // // //       return true;
// // // // // //     }
// // // // // //   }

// // // // // //   // Get all stored data (for debugging)
// // // // // //   static Future<Map<String, dynamic>> getAllStoredData() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return {
// // // // // //         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
// // // // // //         'userEmail': prefs.getString(_userEmailKey),
// // // // // //         'userRole': prefs.getString(_userRoleKey),
// // // // // //         'userId': prefs.getString(_userIdKey),
// // // // // //         'userName': prefs.getString(_userNameKey),
// // // // // //         'loginTime': prefs.getString(_loginTimeKey),
// // // // // //       };
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting all stored data: $e');
// // // // // //       return {};
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // // Role-specific SharedPreferences services
// // // // // // class VehicleOwnerAuth {
// // // // // //   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
// // // // // //   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

// // // // // //   static Future<void> saveVehicleOwnerLogin(String email) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
// // // // // //       await prefs.setString(_vehicleOwnerEmailKey, email);
// // // // // //       // Also save in main auth service
// // // // // //       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving vehicle owner login: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> isVehicleOwnerLoggedIn() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking vehicle owner login: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<void> vehicleOwnerLogout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
// // // // // //       await prefs.remove(_vehicleOwnerEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during vehicle owner logout: $e');
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // class GarageAuth {
// // // // // //   static const String _garageLoggedInKey = 'garageIsLoggedIn';
// // // // // //   static const String _garageEmailKey = 'garageEmail';

// // // // // //   static Future<void> saveGarageLogin(String email) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_garageLoggedInKey, true);
// // // // // //       await prefs.setString(_garageEmailKey, email);
// // // // // //       await AuthService.saveLoginData(email: email, role: 'garage');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving garage login: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> isGarageLoggedIn() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_garageLoggedInKey) ?? false;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking garage login: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<void> garageLogout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_garageLoggedInKey, false);
// // // // // //       await prefs.remove(_garageEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during garage logout: $e');
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // class TowProviderAuth {
// // // // // //   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
// // // // // //   static const String _towProviderEmailKey = 'towProviderEmail';

// // // // // //   static Future<void> saveTowProviderLogin(String email) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_towProviderLoggedInKey, true);
// // // // // //       await prefs.setString(_towProviderEmailKey, email);
// // // // // //       await AuthService.saveLoginData(email: email, role: 'tow_provider');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving tow provider login: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> isTowProviderLoggedIn() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_towProviderLoggedInKey) ?? false;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking tow provider login: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<void> towProviderLogout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_towProviderLoggedInKey, false);
// // // // // //       await prefs.remove(_towProviderEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during tow provider logout: $e');
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // class InsuranceAuth {
// // // // // //   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
// // // // // //   static const String _insuranceEmailKey = 'insuranceEmail';

// // // // // //   static Future<void> saveInsuranceLogin(String email) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_insuranceLoggedInKey, true);
// // // // // //       await prefs.setString(_insuranceEmailKey, email);
// // // // // //       await AuthService.saveLoginData(email: email, role: 'insurance');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving insurance login: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> isInsuranceLoggedIn() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_insuranceLoggedInKey) ?? false;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking insurance login: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<void> insuranceLogout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_insuranceLoggedInKey, false);
// // // // // //       await prefs.remove(_insuranceEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during insurance logout: $e');
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // class AdminAuth {
// // // // // //   static const String _adminLoggedInKey = 'adminIsLoggedIn';
// // // // // //   static const String _adminEmailKey = 'adminEmail';

// // // // // //   static Future<void> saveAdminLogin(String email) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_adminLoggedInKey, true);
// // // // // //       await prefs.setString(_adminEmailKey, email);
// // // // // //       await AuthService.saveLoginData(email: email, role: 'admin');
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving admin login: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> isAdminLoggedIn() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_adminLoggedInKey) ?? false;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error checking admin login: $e');
// // // // // //       return false;
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<void> adminLogout() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_adminLoggedInKey, false);
// // // // // //       await prefs.remove(_adminEmailKey);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error during admin logout: $e');
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // // Utility class for app settings
// // // // // // class AppSettings {
// // // // // //   static const String _themeModeKey = 'themeMode';
// // // // // //   static const String _languageKey = 'language';
// // // // // //   static const String _notificationKey = 'notificationsEnabled';

// // // // // //   // Theme mode
// // // // // //   static Future<void> setThemeMode(String themeMode) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setString(_themeModeKey, themeMode);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving theme mode: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<String> getThemeMode() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_themeModeKey) ?? 'light';
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting theme mode: $e');
// // // // // //       return 'light';
// // // // // //     }
// // // // // //   }

// // // // // //   // Language
// // // // // //   static Future<void> setLanguage(String language) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setString(_languageKey, language);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving language: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<String> getLanguage() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getString(_languageKey) ?? 'en';
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting language: $e');
// // // // // //       return 'en';
// // // // // //     }
// // // // // //   }

// // // // // //   // Notifications
// // // // // //   static Future<void> setNotificationsEnabled(bool enabled) async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       await prefs.setBool(_notificationKey, enabled);
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error saving notification settings: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   static Future<bool> getNotificationsEnabled() async {
// // // // // //     try {
// // // // // //       final prefs = await SharedPreferences.getInstance();
// // // // // //       return prefs.getBool(_notificationKey) ?? true;
// // // // // //     } catch (e) {
// // // // // //       print('❌ Error getting notification settings: $e');
// // // // // //       return true;
// // // // // //     }
// // // // // //   }
// // // // // // } 

// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:firebase_auth/firebase_auth.dart';

// // // // // class AuthService {
// // // // //   // Keys for SharedPreferences
// // // // //   static const String _isLoggedInKey = 'isLoggedIn';
// // // // //   static const String _userEmailKey = 'userEmail';
// // // // //   static const String _userRoleKey = 'userRole';
// // // // //   static const String _loginTimeKey = 'loginTime';
// // // // //   static const String _userIdKey = 'userId';
// // // // //   static const String _userNameKey = 'userName';

// // // // //   // Save login data
// // // // //   static Future<void> saveLoginData({
// // // // //     required String email,
// // // // //     String? role,
// // // // //     String? userId,
// // // // //     String? userName,
// // // // //   }) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_isLoggedInKey, true);
// // // // //       await prefs.setString(_userEmailKey, email);
// // // // //       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
// // // // //       if (role != null) {
// // // // //         await prefs.setString(_userRoleKey, role);
// // // // //       }
      
// // // // //       if (userId != null) {
// // // // //         await prefs.setString(_userIdKey, userId);
// // // // //       }
      
// // // // //       if (userName != null) {
// // // // //         await prefs.setString(_userNameKey, userName);
// // // // //       }
      
// // // // //       print('✅ Login data saved successfully for: $email');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving login data: $e');
// // // // //       throw Exception('Failed to save login data');
// // // // //     }
// // // // //   }

// // // // //   // Check if user is logged in
// // // // //   static Future<bool> checkValidLogin() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
// // // // //       if (isLoggedIn) {
// // // // //         // Optional: Check if login session is still valid (e.g., within 30 days)
// // // // //         final loginTime = prefs.getString(_loginTimeKey);
// // // // //         if (loginTime != null) {
// // // // //           final loginDateTime = DateTime.parse(loginTime);
// // // // //           final now = DateTime.now();
// // // // //           final difference = now.difference(loginDateTime);
          
// // // // //           // Session expires after 30 days (optional)
// // // // //           if (difference.inDays > 30) {
// // // // //             await logout();
// // // // //             return false;
// // // // //           }
// // // // //         }
// // // // //       }
      
// // // // //       return isLoggedIn;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking login status: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   // Get user email
// // // // //   static Future<String?> getUserEmail() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_userEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting user email: $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // Get user role
// // // // //   static Future<String?> getUserRole() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_userRoleKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting user role: $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // Get user ID
// // // // //   static Future<String?> getUserId() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_userIdKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting user ID: $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // Get user name
// // // // //   static Future<String?> getUserName() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_userNameKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting user name: $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // Get login time
// // // // //   static Future<DateTime?> getLoginTime() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final loginTimeString = prefs.getString(_loginTimeKey);
// // // // //       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting login time: $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // Logout user - WITHOUT BuildContext parameter
// // // // //   static Future<void> logout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_isLoggedInKey, false);
// // // // //       await prefs.remove(_userEmailKey);
// // // // //       await prefs.remove(_userRoleKey);
// // // // //       await prefs.remove(_userIdKey);
// // // // //       await prefs.remove(_userNameKey);
// // // // //       await prefs.remove(_loginTimeKey);
      
// // // // //       // Also sign out from Firebase
// // // // //       try {
// // // // //         await FirebaseAuth.instance.signOut();
// // // // //       } catch (e) {
// // // // //         print('❌ Error signing out from Firebase: $e');
// // // // //       }
      
// // // // //       print('✅ User logged out successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error during logout: $e');
// // // // //       throw Exception('Failed to logout');
// // // // //     }
// // // // //   }

// // // // //   // Clear all data (for debugging or app reset)
// // // // //   static Future<void> clearAllData() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.clear();
// // // // //       print('✅ All SharedPreferences data cleared');
// // // // //     } catch (e) {
// // // // //       print('❌ Error clearing all data: $e');
// // // // //       throw Exception('Failed to clear data');
// // // // //     }
// // // // //   }

// // // // //   // Check if first time app launch
// // // // //   static Future<bool> isFirstTime() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       final isFirstTime = prefs.getBool('first_time') ?? true;
// // // // //       if (isFirstTime) {
// // // // //         await prefs.setBool('first_time', false);
// // // // //       }
// // // // //       return isFirstTime;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking first time: $e');
// // // // //       return true;
// // // // //     }
// // // // //   }

// // // // //   // Get all stored data (for debugging)
// // // // //   static Future<Map<String, dynamic>> getAllStoredData() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return {
// // // // //         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
// // // // //         'userEmail': prefs.getString(_userEmailKey),
// // // // //         'userRole': prefs.getString(_userRoleKey),
// // // // //         'userId': prefs.getString(_userIdKey),
// // // // //         'userName': prefs.getString(_userNameKey),
// // // // //         'loginTime': prefs.getString(_loginTimeKey),
// // // // //       };
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting all stored data: $e');
// // // // //       return {};
// // // // //     }
// // // // //   }
// // // // // }

// // // // // // Role-specific SharedPreferences services
// // // // // class VehicleOwnerAuth {
// // // // //   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
// // // // //   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

// // // // //   static Future<void> saveVehicleOwnerLogin(String email) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
// // // // //       await prefs.setString(_vehicleOwnerEmailKey, email);
// // // // //       // Also save in main auth service
// // // // //       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving vehicle owner login: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> isVehicleOwnerLoggedIn() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking vehicle owner login: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> vehicleOwnerLogout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
// // // // //       await prefs.remove(_vehicleOwnerEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error during vehicle owner logout: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // class GarageAuth {
// // // // //   static const String _garageLoggedInKey = 'garageIsLoggedIn';
// // // // //   static const String _garageEmailKey = 'garageEmail';

// // // // //   static Future<void> saveGarageLogin(String email) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_garageLoggedInKey, true);
// // // // //       await prefs.setString(_garageEmailKey, email);
// // // // //       await AuthService.saveLoginData(email: email, role: 'garage');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving garage login: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> isGarageLoggedIn() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_garageLoggedInKey) ?? false;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking garage login: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> garageLogout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_garageLoggedInKey, false);
// // // // //       await prefs.remove(_garageEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error during garage logout: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // class TowProviderAuth {
// // // // //   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
// // // // //   static const String _towProviderEmailKey = 'towProviderEmail';

// // // // //   static Future<void> saveTowProviderLogin(String email) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_towProviderLoggedInKey, true);
// // // // //       await prefs.setString(_towProviderEmailKey, email);
// // // // //       await AuthService.saveLoginData(email: email, role: 'tow_provider');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving tow provider login: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> isTowProviderLoggedIn() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_towProviderLoggedInKey) ?? false;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking tow provider login: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> towProviderLogout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_towProviderLoggedInKey, false);
// // // // //       await prefs.remove(_towProviderEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error during tow provider logout: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // class InsuranceAuth {
// // // // //   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
// // // // //   static const String _insuranceEmailKey = 'insuranceEmail';

// // // // //   static Future<void> saveInsuranceLogin(String email) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_insuranceLoggedInKey, true);
// // // // //       await prefs.setString(_insuranceEmailKey, email);
// // // // //       await AuthService.saveLoginData(email: email, role: 'insurance');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving insurance login: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> isInsuranceLoggedIn() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_insuranceLoggedInKey) ?? false;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking insurance login: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> insuranceLogout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_insuranceLoggedInKey, false);
// // // // //       await prefs.remove(_insuranceEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error during insurance logout: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // class AdminAuth {
// // // // //   static const String _adminLoggedInKey = 'adminIsLoggedIn';
// // // // //   static const String _adminEmailKey = 'adminEmail';

// // // // //   static Future<void> saveAdminLogin(String email) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_adminLoggedInKey, true);
// // // // //       await prefs.setString(_adminEmailKey, email);
// // // // //       await AuthService.saveLoginData(email: email, role: 'admin');
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving admin login: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> isAdminLoggedIn() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_adminLoggedInKey) ?? false;
// // // // //     } catch (e) {
// // // // //       print('❌ Error checking admin login: $e');
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> adminLogout() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_adminLoggedInKey, false);
// // // // //       await prefs.remove(_adminEmailKey);
// // // // //     } catch (e) {
// // // // //       print('❌ Error during admin logout: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // // Utility class for app settings
// // // // // class AppSettings {
// // // // //   static const String _themeModeKey = 'themeMode';
// // // // //   static const String _languageKey = 'language';
// // // // //   static const String _notificationKey = 'notificationsEnabled';

// // // // //   // Theme mode
// // // // //   static Future<void> setThemeMode(String themeMode) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setString(_themeModeKey, themeMode);
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving theme mode: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<String> getThemeMode() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_themeModeKey) ?? 'light';
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting theme mode: $e');
// // // // //       return 'light';
// // // // //     }
// // // // //   }

// // // // //   // Language
// // // // //   static Future<void> setLanguage(String language) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setString(_languageKey, language);
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving language: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<String> getLanguage() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getString(_languageKey) ?? 'en';
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting language: $e');
// // // // //       return 'en';
// // // // //     }
// // // // //   }

// // // // //   // Notifications
// // // // //   static Future<void> setNotificationsEnabled(bool enabled) async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       await prefs.setBool(_notificationKey, enabled);
// // // // //     } catch (e) {
// // // // //       print('❌ Error saving notification settings: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<bool> getNotificationsEnabled() async {
// // // // //     try {
// // // // //       final prefs = await SharedPreferences.getInstance();
// // // // //       return prefs.getBool(_notificationKey) ?? true;
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting notification settings: $e');
// // // // //       return true;
// // // // //     }
// // // // //   }
// // // // // }  

// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';

// // // // class AuthService {
// // // //   // Keys for SharedPreferences
// // // //   static const String _isLoggedInKey = 'isLoggedIn';
// // // //   static const String _userEmailKey = 'userEmail';
// // // //   static const String _userRoleKey = 'userRole';
// // // //   static const String _loginTimeKey = 'loginTime';
// // // //   static const String _userIdKey = 'userId';
// // // //   static const String _userNameKey = 'userName';

// // // //   // Save login data
// // // //   static Future<void> saveLoginData({
// // // //     required String email,
// // // //     String? role,
// // // //     String? userId,
// // // //     String? userName,
// // // //   }) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_isLoggedInKey, true);
// // // //       await prefs.setString(_userEmailKey, email);
// // // //       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
// // // //       if (role != null) {
// // // //         await prefs.setString(_userRoleKey, role);
// // // //       }
      
// // // //       if (userId != null) {
// // // //         await prefs.setString(_userIdKey, userId);
// // // //       }
      
// // // //       if (userName != null) {
// // // //         await prefs.setString(_userNameKey, userName);
// // // //       }
      
// // // //       print('✅ Login data saved successfully for: $email');
// // // //     } catch (e) {
// // // //       print('❌ Error saving login data: $e');
// // // //       throw Exception('Failed to save login data');
// // // //     }
// // // //   }

// // // //   // Check if user is logged in
// // // //   static Future<bool> checkValidLogin() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
// // // //       if (isLoggedIn) {
// // // //         // Optional: Check if login session is still valid (e.g., within 30 days)
// // // //         final loginTime = prefs.getString(_loginTimeKey);
// // // //         if (loginTime != null) {
// // // //           final loginDateTime = DateTime.parse(loginTime);
// // // //           final now = DateTime.now();
// // // //           final difference = now.difference(loginDateTime);
          
// // // //           // Session expires after 30 days (optional)
// // // //           if (difference.inDays > 30) {
// // // //             await logout();
// // // //             return false;
// // // //           }
// // // //         }
// // // //       }
      
// // // //       return isLoggedIn;
// // // //     } catch (e) {
// // // //       print('❌ Error checking login status: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   // Get user email
// // // //   static Future<String?> getUserEmail() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_userEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error getting user email: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // Get user role
// // // //   static Future<String?> getUserRole() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_userRoleKey);
// // // //     } catch (e) {
// // // //       print('❌ Error getting user role: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // Get user ID
// // // //   static Future<String?> getUserId() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_userIdKey);
// // // //     } catch (e) {
// // // //       print('❌ Error getting user ID: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // Get user name
// // // //   static Future<String?> getUserName() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_userNameKey);
// // // //     } catch (e) {
// // // //       print('❌ Error getting user name: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // Get login time
// // // //   static Future<DateTime?> getLoginTime() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final loginTimeString = prefs.getString(_loginTimeKey);
// // // //       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
// // // //     } catch (e) {
// // // //       print('❌ Error getting login time: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // Main logout method - SIMPLE AND RELIABLE
// // // //   static Future<void> logout() async {
// // // //     try {
// // // //       print('🔄 Starting logout process...');
      
// // // //       // 1. Clear SharedPreferences
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_isLoggedInKey, false);
// // // //       await prefs.remove(_userEmailKey);
// // // //       await prefs.remove(_userRoleKey);
// // // //       await prefs.remove(_userIdKey);
// // // //       await prefs.remove(_userNameKey);
// // // //       await prefs.remove(_loginTimeKey);
      
// // // //       // 2. Clear role-specific data
// // // //       await _clearRoleSpecificData();
      
// // // //       // 3. Sign out from Firebase (if available)
// // // //       await _signOutFromFirebase();
      
// // // //       print('✅ Logout completed successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error during logout: $e');
// // // //       // Don't throw exception - we want logout to complete
// // // //     }
// // // //   }

// // // //   // Clear role-specific data
// // // //   static Future<void> _clearRoleSpecificData() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
      
// // // //       // Clear all role-specific data
// // // //       await prefs.remove('towProviderIsLoggedIn');
// // // //       await prefs.remove('towProviderEmail');
// // // //       await prefs.remove('vehicleOwnerIsLoggedIn');
// // // //       await prefs.remove('vehicleOwnerEmail');
// // // //       await prefs.remove('garageIsLoggedIn');
// // // //       await prefs.remove('garageEmail');
// // // //       await prefs.remove('insuranceIsLoggedIn');
// // // //       await prefs.remove('insuranceEmail');
// // // //       await prefs.remove('adminIsLoggedIn');
// // // //       await prefs.remove('adminEmail');
      
// // // //       print('✅ Role-specific data cleared');
// // // //     } catch (e) {
// // // //       print('⚠️ Error clearing role data: $e');
// // // //     }
// // // //   }

// // // //   // Sign out from Firebase
// // // //   static Future<void> _signOutFromFirebase() async {
// // // //     try {
// // // //       final FirebaseAuth auth = FirebaseAuth.instance;
// // // //       if (auth.currentUser != null) {
// // // //         await auth.signOut();
// // // //         print('✅ Firebase signOut successful');
// // // //       } else {
// // // //         print('ℹ️ No user logged in Firebase');
// // // //       }
// // // //     } catch (e) {
// // // //       print('⚠️ Firebase signOut error (non-critical): $e');
// // // //       // Continue even if Firebase logout fails
// // // //     }
// // // //   }

// // // //   // Clear all data (for debugging or app reset)
// // // //   static Future<void> clearAllData() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.clear();
// // // //       print('✅ All SharedPreferences data cleared');
// // // //     } catch (e) {
// // // //       print('❌ Error clearing all data: $e');
// // // //     }
// // // //   }

// // // //   // Check if first time app launch
// // // //   static Future<bool> isFirstTime() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final isFirstTime = prefs.getBool('first_time') ?? true;
// // // //       if (isFirstTime) {
// // // //         await prefs.setBool('first_time', false);
// // // //       }
// // // //       return isFirstTime;
// // // //     } catch (e) {
// // // //       print('❌ Error checking first time: $e');
// // // //       return true;
// // // //     }
// // // //   }

// // // //   // Get all stored data (for debugging)
// // // //   static Future<Map<String, dynamic>> getAllStoredData() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return {
// // // //         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
// // // //         'userEmail': prefs.getString(_userEmailKey),
// // // //         'userRole': prefs.getString(_userRoleKey),
// // // //         'userId': prefs.getString(_userIdKey),
// // // //         'userName': prefs.getString(_userNameKey),
// // // //         'loginTime': prefs.getString(_loginTimeKey),
// // // //       };
// // // //     } catch (e) {
// // // //       print('❌ Error getting all stored data: $e');
// // // //       return {};
// // // //     }
// // // //   }
// // // // }

// // // // // Role-specific SharedPreferences services
// // // // class VehicleOwnerAuth {
// // // //   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
// // // //   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

// // // //   static Future<void> saveVehicleOwnerLogin(String email) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
// // // //       await prefs.setString(_vehicleOwnerEmailKey, email);
// // // //       // Also save in main auth service
// // // //       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
// // // //     } catch (e) {
// // // //       print('❌ Error saving vehicle owner login: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> isVehicleOwnerLoggedIn() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
// // // //     } catch (e) {
// // // //       print('❌ Error checking vehicle owner login: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> vehicleOwnerLogout() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
// // // //       await prefs.remove(_vehicleOwnerEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error during vehicle owner logout: $e');
// // // //     }
// // // //   }
// // // // }

// // // // class GarageAuth {
// // // //   static const String _garageLoggedInKey = 'garageIsLoggedIn';
// // // //   static const String _garageEmailKey = 'garageEmail';

// // // //   static Future<void> saveGarageLogin(String email) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_garageLoggedInKey, true);
// // // //       await prefs.setString(_garageEmailKey, email);
// // // //       await AuthService.saveLoginData(email: email, role: 'garage');
// // // //     } catch (e) {
// // // //       print('❌ Error saving garage login: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> isGarageLoggedIn() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_garageLoggedInKey) ?? false;
// // // //     } catch (e) {
// // // //       print('❌ Error checking garage login: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> garageLogout() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_garageLoggedInKey, false);
// // // //       await prefs.remove(_garageEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error during garage logout: $e');
// // // //     }
// // // //   }
// // // // }

// // // // class TowProviderAuth {
// // // //   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
// // // //   static const String _towProviderEmailKey = 'towProviderEmail';

// // // //   static Future<void> saveTowProviderLogin(String email) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_towProviderLoggedInKey, true);
// // // //       await prefs.setString(_towProviderEmailKey, email);
// // // //       await AuthService.saveLoginData(email: email, role: 'tow_provider');
// // // //     } catch (e) {
// // // //       print('❌ Error saving tow provider login: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> isTowProviderLoggedIn() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_towProviderLoggedInKey) ?? false;
// // // //     } catch (e) {
// // // //       print('❌ Error checking tow provider login: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> towProviderLogout() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_towProviderLoggedInKey, false);
// // // //       await prefs.remove(_towProviderEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error during tow provider logout: $e');
// // // //     }
// // // //   }
// // // // }

// // // // class InsuranceAuth {
// // // //   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
// // // //   static const String _insuranceEmailKey = 'insuranceEmail';

// // // //   static Future<void> saveInsuranceLogin(String email) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_insuranceLoggedInKey, true);
// // // //       await prefs.setString(_insuranceEmailKey, email);
// // // //       await AuthService.saveLoginData(email: email, role: 'insurance');
// // // //     } catch (e) {
// // // //       print('❌ Error saving insurance login: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> isInsuranceLoggedIn() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_insuranceLoggedInKey) ?? false;
// // // //     } catch (e) {
// // // //       print('❌ Error checking insurance login: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> insuranceLogout() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_insuranceLoggedInKey, false);
// // // //       await prefs.remove(_insuranceEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error during insurance logout: $e');
// // // //     }
// // // //   }
// // // // }

// // // // class AdminAuth {
// // // //   static const String _adminLoggedInKey = 'adminIsLoggedIn';
// // // //   static const String _adminEmailKey = 'adminEmail';

// // // //   static Future<void> saveAdminLogin(String email) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_adminLoggedInKey, true);
// // // //       await prefs.setString(_adminEmailKey, email);
// // // //       await AuthService.saveLoginData(email: email, role: 'admin');
// // // //     } catch (e) {
// // // //       print('❌ Error saving admin login: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> isAdminLoggedIn() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_adminLoggedInKey) ?? false;
// // // //     } catch (e) {
// // // //       print('❌ Error checking admin login: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> adminLogout() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_adminLoggedInKey, false);
// // // //       await prefs.remove(_adminEmailKey);
// // // //     } catch (e) {
// // // //       print('❌ Error during admin logout: $e');
// // // //     }
// // // //   }
// // // // }

// // // // // Utility class for app settings
// // // // class AppSettings {
// // // //   static const String _themeModeKey = 'themeMode';
// // // //   static const String _languageKey = 'language';
// // // //   static const String _notificationKey = 'notificationsEnabled';

// // // //   // Theme mode
// // // //   static Future<void> setThemeMode(String themeMode) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setString(_themeModeKey, themeMode);
// // // //     } catch (e) {
// // // //       print('❌ Error saving theme mode: $e');
// // // //     }
// // // //   }

// // // //   static Future<String> getThemeMode() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_themeModeKey) ?? 'light';
// // // //     } catch (e) {
// // // //       print('❌ Error getting theme mode: $e');
// // // //       return 'light';
// // // //     }
// // // //   }

// // // //   // Language
// // // //   static Future<void> setLanguage(String language) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setString(_languageKey, language);
// // // //     } catch (e) {
// // // //       print('❌ Error saving language: $e');
// // // //     }
// // // //   }

// // // //   static Future<String> getLanguage() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getString(_languageKey) ?? 'en';
// // // //     } catch (e) {
// // // //       print('❌ Error getting language: $e');
// // // //       return 'en';
// // // //     }
// // // //   }

// // // //   // Notifications
// // // //   static Future<void> setNotificationsEnabled(bool enabled) async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setBool(_notificationKey, enabled);
// // // //     } catch (e) {
// // // //       print('❌ Error saving notification settings: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> getNotificationsEnabled() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       return prefs.getBool(_notificationKey) ?? true;
// // // //     } catch (e) {
// // // //       print('❌ Error getting notification settings: $e');
// // // //       return true;
// // // //     }
// // // //   }
// // // // }
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';

// // // class AuthService {
// // //   // Keys for SharedPreferences
// // //   static const String _isLoggedInKey = 'isLoggedIn';
// // //   static const String _userEmailKey = 'userEmail';
// // //   static const String _userRoleKey = 'userRole';
// // //   static const String _loginTimeKey = 'loginTime';
// // //   static const String _userIdKey = 'userId';
// // //   static const String _userNameKey = 'userName';

// // //   // Save login data
// // //   static Future<void> saveLoginData({
// // //     required String email,
// // //     String? role,
// // //     String? userId,
// // //     String? userName,
// // //   }) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_isLoggedInKey, true);
// // //       await prefs.setString(_userEmailKey, email);
// // //       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
// // //       if (role != null) {
// // //         await prefs.setString(_userRoleKey, role);
// // //       }
      
// // //       if (userId != null) {
// // //         await prefs.setString(_userIdKey, userId);
// // //       }
      
// // //       if (userName != null) {
// // //         await prefs.setString(_userNameKey, userName);
// // //       }
      
// // //       print('✅ Login data saved successfully for: $email');
// // //     } catch (e) {
// // //       print('❌ Error saving login data: $e');
// // //       throw Exception('Failed to save login data');
// // //     }
// // //   }

// // //   // Check if user is logged in
// // //   static Future<bool> checkValidLogin() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
// // //       if (isLoggedIn) {
// // //         // Optional: Check if login session is still valid (e.g., within 30 days)
// // //         final loginTime = prefs.getString(_loginTimeKey);
// // //         if (loginTime != null) {
// // //           final loginDateTime = DateTime.parse(loginTime);
// // //           final now = DateTime.now();
// // //           final difference = now.difference(loginDateTime);
          
// // //           // Session expires after 30 days (optional)
// // //           if (difference.inDays > 30) {
// // //             await logout();
// // //             return false;
// // //           }
// // //         }
// // //       }
      
// // //       return isLoggedIn;
// // //     } catch (e) {
// // //       print('❌ Error checking login status: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // Get user email
// // //   static Future<String?> getUserEmail() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_userEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error getting user email: $e');
// // //       return null;
// // //     }
// // //   }

// // //   // Get user role
// // //   static Future<String?> getUserRole() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_userRoleKey);
// // //     } catch (e) {
// // //       print('❌ Error getting user role: $e');
// // //       return null;
// // //     }
// // //   }

// // //   // Get user ID
// // //   static Future<String?> getUserId() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_userIdKey);
// // //     } catch (e) {
// // //       print('❌ Error getting user ID: $e');
// // //       return null;
// // //     }
// // //   }

// // //   // Get user name
// // //   static Future<String?> getUserName() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_userNameKey);
// // //     } catch (e) {
// // //       print('❌ Error getting user name: $e');
// // //       return null;
// // //     }
// // //   }

// // //   // Get login time
// // //   static Future<DateTime?> getLoginTime() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final loginTimeString = prefs.getString(_loginTimeKey);
// // //       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
// // //     } catch (e) {
// // //       print('❌ Error getting login time: $e');
// // //       return null;
// // //     }
// // //   }

// // //   // Main logout method - SIMPLE AND RELIABLE
// // //   static Future<void> logout() async {
// // //     try {
// // //       print('🔄 Starting logout process...');
      
// // //       // 1. Clear SharedPreferences
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_isLoggedInKey, false);
// // //       await prefs.remove(_userEmailKey);
// // //       await prefs.remove(_userRoleKey);
// // //       await prefs.remove(_userIdKey);
// // //       await prefs.remove(_userNameKey);
// // //       await prefs.remove(_loginTimeKey);
      
// // //       // 2. Clear role-specific data
// // //       await _clearRoleSpecificData();
      
// // //       // 3. Sign out from Firebase (if available)
// // //       await _signOutFromFirebase();
      
// // //       print('✅ Logout completed successfully');
// // //     } catch (e) {
// // //       print('❌ Error during logout: $e');
// // //       // Don't throw exception - we want logout to complete
// // //     }
// // //   }

// // //   // Clear role-specific data
// // //   static Future<void> _clearRoleSpecificData() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
      
// // //       // Clear all role-specific data
// // //       await prefs.remove('towProviderIsLoggedIn');
// // //       await prefs.remove('towProviderEmail');
// // //       await prefs.remove('vehicleOwnerIsLoggedIn');
// // //       await prefs.remove('vehicleOwnerEmail');
// // //       await prefs.remove('garageIsLoggedIn');
// // //       await prefs.remove('garageEmail');
// // //       await prefs.remove('insuranceIsLoggedIn');
// // //       await prefs.remove('insuranceEmail');
// // //       await prefs.remove('adminIsLoggedIn');
// // //       await prefs.remove('adminEmail');
      
// // //       print('✅ Role-specific data cleared');
// // //     } catch (e) {
// // //       print('⚠️ Error clearing role data: $e');
// // //     }
// // //   }

// // //   // Sign out from Firebase
// // //   static Future<void> _signOutFromFirebase() async {
// // //     try {
// // //       final FirebaseAuth auth = FirebaseAuth.instance;
// // //       if (auth.currentUser != null) {
// // //         await auth.signOut();
// // //         print('✅ Firebase signOut successful');
// // //       } else {
// // //         print('ℹ️ No user logged in Firebase');
// // //       }
// // //     } catch (e) {
// // //       print('⚠️ Firebase signOut error (non-critical): $e');
// // //       // Continue even if Firebase logout fails
// // //     }
// // //   }

// // //   // Clear all data (for debugging or app reset)
// // //   static Future<void> clearAllData() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.clear();
// // //       print('✅ All SharedPreferences data cleared');
// // //     } catch (e) {
// // //       print('❌ Error clearing all data: $e');
// // //     }
// // //   }

// // //   // Clear login data specifically
// // //   static Future<void> clearLoginData() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_isLoggedInKey, false);
// // //       await prefs.remove(_userEmailKey);
// // //       await prefs.remove(_userRoleKey);
// // //       await prefs.remove(_userIdKey);
// // //       await prefs.remove(_userNameKey);
// // //       await prefs.remove(_loginTimeKey);
      
// // //       print('✅ Login data cleared successfully');
// // //     } catch (e) {
// // //       print('❌ Error clearing login data: $e');
// // //       throw e;
// // //     }
// // //   }

// // //   // Check if first time app launch
// // //   static Future<bool> isFirstTime() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final isFirstTime = prefs.getBool('first_time') ?? true;
// // //       if (isFirstTime) {
// // //         await prefs.setBool('first_time', false);
// // //       }
// // //       return isFirstTime;
// // //     } catch (e) {
// // //       print('❌ Error checking first time: $e');
// // //       return true;
// // //     }
// // //   }

// // //   // Get all stored data (for debugging)
// // //   static Future<Map<String, dynamic>> getAllStoredData() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return {
// // //         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
// // //         'userEmail': prefs.getString(_userEmailKey),
// // //         'userRole': prefs.getString(_userRoleKey),
// // //         'userId': prefs.getString(_userIdKey),
// // //         'userName': prefs.getString(_userNameKey),
// // //         'loginTime': prefs.getString(_loginTimeKey),
// // //       };
// // //     } catch (e) {
// // //       print('❌ Error getting all stored data: $e');
// // //       return {};
// // //     }
// // //   }
// // // }

// // // // Role-specific SharedPreferences services
// // // class VehicleOwnerAuth {
// // //   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
// // //   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

// // //   static Future<void> saveVehicleOwnerLogin(String email) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
// // //       await prefs.setString(_vehicleOwnerEmailKey, email);
// // //       // Also save in main auth service
// // //       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
// // //     } catch (e) {
// // //       print('❌ Error saving vehicle owner login: $e');
// // //     }
// // //   }

// // //   static Future<bool> isVehicleOwnerLoggedIn() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
// // //     } catch (e) {
// // //       print('❌ Error checking vehicle owner login: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Future<void> vehicleOwnerLogout() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
// // //       await prefs.remove(_vehicleOwnerEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error during vehicle owner logout: $e');
// // //     }
// // //   }
// // // }

// // // class GarageAuth {
// // //   static const String _garageLoggedInKey = 'garageIsLoggedIn';
// // //   static const String _garageEmailKey = 'garageEmail';

// // //   static Future<void> saveGarageLogin(String email) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_garageLoggedInKey, true);
// // //       await prefs.setString(_garageEmailKey, email);
// // //       await AuthService.saveLoginData(email: email, role: 'garage');
// // //     } catch (e) {
// // //       print('❌ Error saving garage login: $e');
// // //     }
// // //   }

// // //   static Future<bool> isGarageLoggedIn() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_garageLoggedInKey) ?? false;
// // //     } catch (e) {
// // //       print('❌ Error checking garage login: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Future<void> garageLogout() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_garageLoggedInKey, false);
// // //       await prefs.remove(_garageEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error during garage logout: $e');
// // //     }
// // //   }
// // // }

// // // class TowProviderAuth {
// // //   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
// // //   static const String _towProviderEmailKey = 'towProviderEmail';

// // //   static Future<void> saveTowProviderLogin(String email) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_towProviderLoggedInKey, true);
// // //       await prefs.setString(_towProviderEmailKey, email);
// // //       await AuthService.saveLoginData(email: email, role: 'tow_provider');
// // //     } catch (e) {
// // //       print('❌ Error saving tow provider login: $e');
// // //     }
// // //   }

// // //   static Future<bool> isTowProviderLoggedIn() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_towProviderLoggedInKey) ?? false;
// // //     } catch (e) {
// // //       print('❌ Error checking tow provider login: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Future<void> towProviderLogout() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_towProviderLoggedInKey, false);
// // //       await prefs.remove(_towProviderEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error during tow provider logout: $e');
// // //     }
// // //   }
// // // }

// // // class InsuranceAuth {
// // //   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
// // //   static const String _insuranceEmailKey = 'insuranceEmail';

// // //   static Future<void> saveInsuranceLogin(String email) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_insuranceLoggedInKey, true);
// // //       await prefs.setString(_insuranceEmailKey, email);
// // //       await AuthService.saveLoginData(email: email, role: 'insurance');
// // //     } catch (e) {
// // //       print('❌ Error saving insurance login: $e');
// // //     }
// // //   }

// // //   static Future<bool> isInsuranceLoggedIn() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_insuranceLoggedInKey) ?? false;
// // //     } catch (e) {
// // //       print('❌ Error checking insurance login: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Future<void> insuranceLogout() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_insuranceLoggedInKey, false);
// // //       await prefs.remove(_insuranceEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error during insurance logout: $e');
// // //     }
// // //   }
// // // }

// // // class AdminAuth {
// // //   static const String _adminLoggedInKey = 'adminIsLoggedIn';
// // //   static const String _adminEmailKey = 'adminEmail';

// // //   static Future<void> saveAdminLogin(String email) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_adminLoggedInKey, true);
// // //       await prefs.setString(_adminEmailKey, email);
// // //       await AuthService.saveLoginData(email: email, role: 'admin');
// // //     } catch (e) {
// // //       print('❌ Error saving admin login: $e');
// // //     }
// // //   }

// // //   static Future<bool> isAdminLoggedIn() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_adminLoggedInKey) ?? false;
// // //     } catch (e) {
// // //       print('❌ Error checking admin login: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Future<void> adminLogout() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_adminLoggedInKey, false);
// // //       await prefs.remove(_adminEmailKey);
// // //     } catch (e) {
// // //       print('❌ Error during admin logout: $e');
// // //     }
// // //   }
// // // }

// // // // Utility class for app settings
// // // class AppSettings {
// // //   static const String _themeModeKey = 'themeMode';
// // //   static const String _languageKey = 'language';
// // //   static const String _notificationKey = 'notificationsEnabled';

// // //   // Theme mode
// // //   static Future<void> setThemeMode(String themeMode) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString(_themeModeKey, themeMode);
// // //     } catch (e) {
// // //       print('❌ Error saving theme mode: $e');
// // //     }
// // //   }

// // //   static Future<String> getThemeMode() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_themeModeKey) ?? 'light';
// // //     } catch (e) {
// // //       print('❌ Error getting theme mode: $e');
// // //       return 'light';
// // //     }
// // //   }

// // //   // Language
// // //   static Future<void> setLanguage(String language) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString(_languageKey, language);
// // //     } catch (e) {
// // //       print('❌ Error saving language: $e');
// // //     }
// // //   }

// // //   static Future<String> getLanguage() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getString(_languageKey) ?? 'en';
// // //     } catch (e) {
// // //       print('❌ Error getting language: $e');
// // //       return 'en';
// // //     }
// // //   }

// // //   // Notifications
// // //   static Future<void> setNotificationsEnabled(bool enabled) async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setBool(_notificationKey, enabled);
// // //     } catch (e) {
// // //       print('❌ Error saving notification settings: $e');
// // //     }
// // //   }

// // //   static Future<bool> getNotificationsEnabled() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       return prefs.getBool(_notificationKey) ?? true;
// // //     } catch (e) {
// // //       print('❌ Error getting notification settings: $e');
// // //       return true;
// // //     }
// // //   }
// // // }  




// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class AuthService {
// //   // Keys for SharedPreferences
// //   static const String _isLoggedInKey = 'isLoggedIn';
// //   static const String _userEmailKey = 'userEmail';
// //   static const String _userRoleKey = 'userRole';
// //   static const String _loginTimeKey = 'loginTime';
// //   static const String _userIdKey = 'userId';
// //   static const String _userNameKey = 'userName';

// //   // Save login data - FIXED PARAMETERS
// //   static Future<void> saveLoginData({
// //     required String email,
// //     String? role,
// //     String? userId,
// //     String? userName,
// //   }) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_isLoggedInKey, true);
// //       await prefs.setString(_userEmailKey, email);
// //       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
// //       if (role != null) {
// //         await prefs.setString(_userRoleKey, role);
// //       }
      
// //       if (userId != null) {
// //         await prefs.setString(_userIdKey, userId);
// //       }
      
// //       if (userName != null) {
// //         await prefs.setString(_userNameKey, userName);
// //       }
      
// //       print('✅ Login data saved successfully for: $email');
// //     } catch (e) {
// //       print('❌ Error saving login data: $e');
// //       throw Exception('Failed to save login data');
// //     }
// //   }

// //   // Check if user is logged in
// //   static Future<bool> checkValidLogin() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
// //       if (isLoggedIn) {
// //         // Optional: Check if login session is still valid (e.g., within 30 days)
// //         final loginTime = prefs.getString(_loginTimeKey);
// //         if (loginTime != null) {
// //           final loginDateTime = DateTime.parse(loginTime);
// //           final now = DateTime.now();
// //           final difference = now.difference(loginDateTime);
          
// //           // Session expires after 30 days (optional)
// //           if (difference.inDays > 30) {
// //             await logout();
// //             return false;
// //           }
// //         }
// //       }
      
// //       return isLoggedIn;
// //     } catch (e) {
// //       print('❌ Error checking login status: $e');
// //       return false;
// //     }
// //   }

// //   // Get user email
// //   static Future<String?> getUserEmail() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_userEmailKey);
// //     } catch (e) {
// //       print('❌ Error getting user email: $e');
// //       return null;
// //     }
// //   }

// //   // Get user role
// //   static Future<String?> getUserRole() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_userRoleKey);
// //     } catch (e) {
// //       print('❌ Error getting user role: $e');
// //       return null;
// //     }
// //   }

// //   // Get user ID
// //   static Future<String?> getUserId() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_userIdKey);
// //     } catch (e) {
// //       print('❌ Error getting user ID: $e');
// //       return null;
// //     }
// //   }

// //   // Get user name
// //   static Future<String?> getUserName() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_userNameKey);
// //     } catch (e) {
// //       print('❌ Error getting user name: $e');
// //       return null;
// //     }
// //   }

// //   // Get login time
// //   static Future<DateTime?> getLoginTime() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final loginTimeString = prefs.getString(_loginTimeKey);
// //       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
// //     } catch (e) {
// //       print('❌ Error getting login time: $e');
// //       return null;
// //     }
// //   }

// //   // Main logout method - SIMPLE AND RELIABLE
// //   static Future<void> logout() async {
// //     try {
// //       print('🔄 Starting logout process...');
      
// //       // 1. Clear SharedPreferences
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_isLoggedInKey, false);
// //       await prefs.remove(_userEmailKey);
// //       await prefs.remove(_userRoleKey);
// //       await prefs.remove(_userIdKey);
// //       await prefs.remove(_userNameKey);
// //       await prefs.remove(_loginTimeKey);
      
// //       // 2. Clear role-specific data
// //       await _clearRoleSpecificData();
      
// //       // 3. Sign out from Firebase (if available)
// //       await _signOutFromFirebase();
      
// //       print('✅ Logout completed successfully');
// //     } catch (e) {
// //       print('❌ Error during logout: $e');
// //       // Don't throw exception - we want logout to complete
// //     }
// //   }

// //   // Clear role-specific data
// //   static Future<void> _clearRoleSpecificData() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
      
// //       // Clear all role-specific data
// //       await prefs.remove('towProviderIsLoggedIn');
// //       await prefs.remove('towProviderEmail');
// //       await prefs.remove('vehicleOwnerIsLoggedIn');
// //       await prefs.remove('vehicleOwnerEmail');
// //       await prefs.remove('garageIsLoggedIn');
// //       await prefs.remove('garageEmail');
// //       await prefs.remove('insuranceIsLoggedIn');
// //       await prefs.remove('insuranceEmail');
// //       await prefs.remove('adminIsLoggedIn');
// //       await prefs.remove('adminEmail');
      
// //       print('✅ Role-specific data cleared');
// //     } catch (e) {
// //       print('⚠️ Error clearing role data: $e');
// //     }
// //   }

// //   // Sign out from Firebase
// //   static Future<void> _signOutFromFirebase() async {
// //     try {
// //       final FirebaseAuth auth = FirebaseAuth.instance;
// //       if (auth.currentUser != null) {
// //         await auth.signOut();
// //         print('✅ Firebase signOut successful');
// //       } else {
// //         print('ℹ️ No user logged in Firebase');
// //       }
// //     } catch (e) {
// //       print('⚠️ Firebase signOut error (non-critical): $e');
// //       // Continue even if Firebase logout fails
// //     }
// //   }

// //   // Clear all data (for debugging or app reset)
// //   static Future<void> clearAllData() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.clear();
// //       print('✅ All SharedPreferences data cleared');
// //     } catch (e) {
// //       print('❌ Error clearing all data: $e');
// //     }
// //   }

// //   // Clear login data specifically
// //   static Future<void> clearLoginData() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_isLoggedInKey, false);
// //       await prefs.remove(_userEmailKey);
// //       await prefs.remove(_userRoleKey);
// //       await prefs.remove(_userIdKey);
// //       await prefs.remove(_userNameKey);
// //       await prefs.remove(_loginTimeKey);
      
// //       print('✅ Login data cleared successfully');
// //     } catch (e) {
// //       print('❌ Error clearing login data: $e');
// //       throw e;
// //     }
// //   }

// //   // Check if first time app launch
// //   static Future<bool> isFirstTime() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final isFirstTime = prefs.getBool('first_time') ?? true;
// //       if (isFirstTime) {
// //         await prefs.setBool('first_time', false);
// //       }
// //       return isFirstTime;
// //     } catch (e) {
// //       print('❌ Error checking first time: $e');
// //       return true;
// //     }
// //   }

// //   // Get all stored data (for debugging)
// //   static Future<Map<String, dynamic>> getAllStoredData() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return {
// //         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
// //         'userEmail': prefs.getString(_userEmailKey),
// //         'userRole': prefs.getString(_userRoleKey),
// //         'userId': prefs.getString(_userIdKey),
// //         'userName': prefs.getString(_userNameKey),
// //         'loginTime': prefs.getString(_loginTimeKey),
// //       };
// //     } catch (e) {
// //       print('❌ Error getting all stored data: $e');
// //       return {};
// //     }
// //   }
// // }

// // // Role-specific SharedPreferences services
// // class VehicleOwnerAuth {
// //   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
// //   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

// //   static Future<void> saveVehicleOwnerLogin(String email) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
// //       await prefs.setString(_vehicleOwnerEmailKey, email);
// //       // Also save in main auth service
// //       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
// //     } catch (e) {
// //       print('❌ Error saving vehicle owner login: $e');
// //     }
// //   }

// //   static Future<bool> isVehicleOwnerLoggedIn() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
// //     } catch (e) {
// //       print('❌ Error checking vehicle owner login: $e');
// //       return false;
// //     }
// //   }

// //   static Future<void> vehicleOwnerLogout() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
// //       await prefs.remove(_vehicleOwnerEmailKey);
// //     } catch (e) {
// //       print('❌ Error during vehicle owner logout: $e');
// //     }
// //   }
// // }

// // class GarageAuth {
// //   static const String _garageLoggedInKey = 'garageIsLoggedIn';
// //   static const String _garageEmailKey = 'garageEmail';

// //   static Future<void> saveGarageLogin(String email) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_garageLoggedInKey, true);
// //       await prefs.setString(_garageEmailKey, email);
// //       await AuthService.saveLoginData(email: email, role: 'garage');
// //     } catch (e) {
// //       print('❌ Error saving garage login: $e');
// //     }
// //   }

// //   static Future<bool> isGarageLoggedIn() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_garageLoggedInKey) ?? false;
// //     } catch (e) {
// //       print('❌ Error checking garage login: $e');
// //       return false;
// //     }
// //   }

// //   static Future<void> garageLogout() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_garageLoggedInKey, false);
// //       await prefs.remove(_garageEmailKey);
// //     } catch (e) {
// //       print('❌ Error during garage logout: $e');
// //     }
// //   }
// // }

// // class TowProviderAuth {
// //   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
// //   static const String _towProviderEmailKey = 'towProviderEmail';

// //   static Future<void> saveTowProviderLogin(String email) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_towProviderLoggedInKey, true);
// //       await prefs.setString(_towProviderEmailKey, email);
// //       await AuthService.saveLoginData(email: email, role: 'tow_provider');
// //     } catch (e) {
// //       print('❌ Error saving tow provider login: $e');
// //     }
// //   }

// //   static Future<bool> isTowProviderLoggedIn() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_towProviderLoggedInKey) ?? false;
// //     } catch (e) {
// //       print('❌ Error checking tow provider login: $e');
// //       return false;
// //     }
// //   }

// //   static Future<void> towProviderLogout() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_towProviderLoggedInKey, false);
// //       await prefs.remove(_towProviderEmailKey);
// //     } catch (e) {
// //       print('❌ Error during tow provider logout: $e');
// //     }
// //   }
// // }

// // class InsuranceAuth {
// //   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
// //   static const String _insuranceEmailKey = 'insuranceEmail';

// //   static Future<void> saveInsuranceLogin(String email) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_insuranceLoggedInKey, true);
// //       await prefs.setString(_insuranceEmailKey, email);
// //       await AuthService.saveLoginData(email: email, role: 'insurance');
// //     } catch (e) {
// //       print('❌ Error saving insurance login: $e');
// //     }
// //   }

// //   static Future<bool> isInsuranceLoggedIn() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_insuranceLoggedInKey) ?? false;
// //     } catch (e) {
// //       print('❌ Error checking insurance login: $e');
// //       return false;
// //     }
// //   }

// //   static Future<void> insuranceLogout() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_insuranceLoggedInKey, false);
// //       await prefs.remove(_insuranceEmailKey);
// //     } catch (e) {
// //       print('❌ Error during insurance logout: $e');
// //     }
// //   }
// // }

// // class AdminAuth {
// //   static const String _adminLoggedInKey = 'adminIsLoggedIn';
// //   static const String _adminEmailKey = 'adminEmail';

// //   static Future<void> saveAdminLogin(String email) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_adminLoggedInKey, true);
// //       await prefs.setString(_adminEmailKey, email);
// //       await AuthService.saveLoginData(email: email, role: 'admin');
// //     } catch (e) {
// //       print('❌ Error saving admin login: $e');
// //     }
// //   }

// //   static Future<bool> isAdminLoggedIn() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_adminLoggedInKey) ?? false;
// //     } catch (e) {
// //       print('❌ Error checking admin login: $e');
// //       return false;
// //     }
// //   }

// //   static Future<void> adminLogout() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_adminLoggedInKey, false);
// //       await prefs.remove(_adminEmailKey);
// //     } catch (e) {
// //       print('❌ Error during admin logout: $e');
// //     }
// //   }
// // }

// // // Utility class for app settings
// // class AppSettings {
// //   static const String _themeModeKey = 'themeMode';
// //   static const String _languageKey = 'language';
// //   static const String _notificationKey = 'notificationsEnabled';

// //   // Theme mode
// //   static Future<void> setThemeMode(String themeMode) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString(_themeModeKey, themeMode);
// //     } catch (e) {
// //       print('❌ Error saving theme mode: $e');
// //     }
// //   }

// //   static Future<String> getThemeMode() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_themeModeKey) ?? 'light';
// //     } catch (e) {
// //       print('❌ Error getting theme mode: $e');
// //       return 'light';
// //     }
// //   }

// //   // Language
// //   static Future<void> setLanguage(String language) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString(_languageKey, language);
// //     } catch (e) {
// //       print('❌ Error saving language: $e');
// //     }
// //   }

// //   static Future<String> getLanguage() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getString(_languageKey) ?? 'en';
// //     } catch (e) {
// //       print('❌ Error getting language: $e');
// //       return 'en';
// //     }
// //   }

// //   // Notifications
// //   static Future<void> setNotificationsEnabled(bool enabled) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool(_notificationKey, enabled);
// //     } catch (e) {
// //       print('❌ Error saving notification settings: $e');
// //     }
// //   }

// //   static Future<bool> getNotificationsEnabled() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       return prefs.getBool(_notificationKey) ?? true;
// //     } catch (e) {
// //       print('❌ Error getting notification settings: $e');
// //       return true;
// //     }
// //   }
// // }


// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   // Keys for SharedPreferences
//   static const String _isLoggedInKey = 'isLoggedIn';
//   static const String _userEmailKey = 'userEmail';
//   static const String _userRoleKey = 'userRole';
//   static const String _loginTimeKey = 'loginTime';
//   static const String _userIdKey = 'userId';
//   static const String _userNameKey = 'userName';

//   // Save login data - FIXED PARAMETERS
//   static Future<void> saveLoginData({
//     required String email,
//     String? role,
//     String? userId,
//     String? userName,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, true);
//       await prefs.setString(_userEmailKey, email);
//       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
//       if (role != null) {
//         await prefs.setString(_userRoleKey, role);
//       }
      
//       if (userId != null) {
//         await prefs.setString(_userIdKey, userId);
//       }
      
//       if (userName != null) {
//         await prefs.setString(_userNameKey, userName);
//       }
      
//       print('✅ Login data saved successfully for: $email');
//     } catch (e) {
//       print('❌ Error saving login data: $e');
//       throw Exception('Failed to save login data');
//     }
//   }

//   // Check if user is logged in
//   static Future<bool> checkValidLogin() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
//       if (isLoggedIn) {
//         // Optional: Check if login session is still valid (e.g., within 30 days)
//         final loginTime = prefs.getString(_loginTimeKey);
//         if (loginTime != null) {
//           final loginDateTime = DateTime.parse(loginTime);
//           final now = DateTime.now();
//           final difference = now.difference(loginDateTime);
          
//           // Session expires after 30 days (optional)
//           if (difference.inDays > 30) {
//             await logout();
//             return false;
//           }
//         }
//       }
      
//       return isLoggedIn;
//     } catch (e) {
//       print('❌ Error checking login status: $e');
//       return false;
//     }
//   }

//   // Get user email
//   static Future<String?> getUserEmail() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userEmailKey);
//     } catch (e) {
//       print('❌ Error getting user email: $e');
//       return null;
//     }
//   }

//   // Get user role
//   static Future<String?> getUserRole() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userRoleKey);
//     } catch (e) {
//       print('❌ Error getting user role: $e');
//       return null;
//     }
//   }

//   // Get user ID
//   static Future<String?> getUserId() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userIdKey);
//     } catch (e) {
//       print('❌ Error getting user ID: $e');
//       return null;
//     }
//   }

//   // Get user name
//   static Future<String?> getUserName() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userNameKey);
//     } catch (e) {
//       print('❌ Error getting user name: $e');
//       return null;
//     }
//   }

//   // Get login time
//   static Future<DateTime?> getLoginTime() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final loginTimeString = prefs.getString(_loginTimeKey);
//       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
//     } catch (e) {
//       print('❌ Error getting login time: $e');
//       return null;
//     }
//   }

//   // Main logout method - SIMPLE AND RELIABLE
//   static Future<void> logout() async {
//     try {
//       print('🔄 Starting logout process...');
      
//       // 1. Clear SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, false);
//       await prefs.remove(_userEmailKey);
//       await prefs.remove(_userRoleKey);
//       await prefs.remove(_userIdKey);
//       await prefs.remove(_userNameKey);
//       await prefs.remove(_loginTimeKey);
      
//       // 2. Clear role-specific data
//       await _clearRoleSpecificData();
      
//       // 3. Sign out from Firebase (if available)
//       await _signOutFromFirebase();
      
//       print('✅ Logout completed successfully');
//     } catch (e) {
//       print('❌ Error during logout: $e');
//       // Don't throw exception - we want logout to complete
//     }
//   }

//   // Clear role-specific data
//   static Future<void> _clearRoleSpecificData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
      
//       // Clear all role-specific data
//       await prefs.remove('towProviderIsLoggedIn');
//       await prefs.remove('towProviderEmail');
//       await prefs.remove('vehicleOwnerIsLoggedIn');
//       await prefs.remove('vehicleOwnerEmail');
//       await prefs.remove('garageIsLoggedIn');
//       await prefs.remove('garageEmail');
//       await prefs.remove('insuranceIsLoggedIn');
//       await prefs.remove('insuranceEmail');
//       await prefs.remove('adminIsLoggedIn');
//       await prefs.remove('adminEmail');
      
//       print('✅ Role-specific data cleared');
//     } catch (e) {
//       print('⚠️ Error clearing role data: $e');
//     }
//   }

//   // Sign out from Firebase
//   static Future<void> _signOutFromFirebase() async {
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       if (auth.currentUser != null) {
//         await auth.signOut();
//         print('✅ Firebase signOut successful');
//       } else {
//         print('ℹ️ No user logged in Firebase');
//       }
//     } catch (e) {
//       print('⚠️ Firebase signOut error (non-critical): $e');
//       // Continue even if Firebase logout fails
//     }
//   }

//   // Clear all data (for debugging or app reset)
//   static Future<void> clearAllData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       print('✅ All SharedPreferences data cleared');
//     } catch (e) {
//       print('❌ Error clearing all data: $e');
//     }
//   }

//   // Clear login data specifically
//   static Future<void> clearLoginData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, false);
//       await prefs.remove(_userEmailKey);
//       await prefs.remove(_userRoleKey);
//       await prefs.remove(_userIdKey);
//       await prefs.remove(_userNameKey);
//       await prefs.remove(_loginTimeKey);
      
//       print('✅ Login data cleared successfully');
//     } catch (e) {
//       print('❌ Error clearing login data: $e');
//       throw e;
//     }
//   }

//   // Check if first time app launch
//   static Future<bool> isFirstTime() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isFirstTime = prefs.getBool('first_time') ?? true;
//       if (isFirstTime) {
//         await prefs.setBool('first_time', false);
//       }
//       return isFirstTime;
//     } catch (e) {
//       print('❌ Error checking first time: $e');
//       return true;
//     }
//   }

//   // Get all stored data (for debugging)
//   static Future<Map<String, dynamic>> getAllStoredData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return {
//         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
//         'userEmail': prefs.getString(_userEmailKey),
//         'userRole': prefs.getString(_userRoleKey),
//         'userId': prefs.getString(_userIdKey),
//         'userName': prefs.getString(_userNameKey),
//         'loginTime': prefs.getString(_loginTimeKey),
//       };
//     } catch (e) {
//       print('❌ Error getting all stored data: $e');
//       return {};
//     }
//   }
// }

// // Role-specific SharedPreferences services
// class VehicleOwnerAuth {
//   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
//   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

//   static Future<void> saveVehicleOwnerLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
//       await prefs.setString(_vehicleOwnerEmailKey, email);
//       // Also save in main auth service
//       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
//     } catch (e) {
//       print('❌ Error saving vehicle owner login: $e');
//     }
//   }

//   static Future<bool> isVehicleOwnerLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking vehicle owner login: $e');
//       return false;
//     }
//   }

//   static Future<void> vehicleOwnerLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
//       await prefs.remove(_vehicleOwnerEmailKey);
//     } catch (e) {
//       print('❌ Error during vehicle owner logout: $e');
//     }
//   }
// }

// class GarageAuth {
//   static const String _garageLoggedInKey = 'garageIsLoggedIn';
//   static const String _garageEmailKey = 'garageEmail';

//   static Future<void> saveGarageLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_garageLoggedInKey, true);
//       await prefs.setString(_garageEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'garage');
//     } catch (e) {
//       print('❌ Error saving garage login: $e');
//     }
//   }

//   static Future<bool> isGarageLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_garageLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking garage login: $e');
//       return false;
//     }
//   }

//   static Future<void> garageLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_garageLoggedInKey, false);
//       await prefs.remove(_garageEmailKey);
//     } catch (e) {
//       print('❌ Error during garage logout: $e');
//     }
//   }
// }

// class TowProviderAuth {
//   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
//   static const String _towProviderEmailKey = 'towProviderEmail';

//   static Future<void> saveTowProviderLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_towProviderLoggedInKey, true);
//       await prefs.setString(_towProviderEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'tow_provider');
//     } catch (e) {
//       print('❌ Error saving tow provider login: $e');
//     }
//   }

//   static Future<bool> isTowProviderLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_towProviderLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking tow provider login: $e');
//       return false;
//     }
//   }

//   static Future<void> towProviderLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_towProviderLoggedInKey, false);
//       await prefs.remove(_towProviderEmailKey);
//     } catch (e) {
//       print('❌ Error during tow provider logout: $e');
//     }
//   }
// }

// class InsuranceAuth {
//   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
//   static const String _insuranceEmailKey = 'insuranceEmail';

//   static Future<void> saveInsuranceLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_insuranceLoggedInKey, true);
//       await prefs.setString(_insuranceEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'insurance');
//     } catch (e) {
//       print('❌ Error saving insurance login: $e');
//     }
//   }

//   static Future<bool> isInsuranceLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_insuranceLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking insurance login: $e');
//       return false;
//     }
//   }

//   static Future<void> insuranceLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_insuranceLoggedInKey, false);
//       await prefs.remove(_insuranceEmailKey);
//     } catch (e) {
//       print('❌ Error during insurance logout: $e');
//     }
//   }
// }

// class AdminAuth {
//   static const String _adminLoggedInKey = 'adminIsLoggedIn';
//   static const String _adminEmailKey = 'adminEmail';

//   static Future<void> saveAdminLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_adminLoggedInKey, true);
//       await prefs.setString(_adminEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'admin');
//     } catch (e) {
//       print('❌ Error saving admin login: $e');
//     }
//   }

//   static Future<bool> isAdminLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_adminLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking admin login: $e');
//       return false;
//     }
//   }

//   static Future<void> adminLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_adminLoggedInKey, false);
//       await prefs.remove(_adminEmailKey);
//     } catch (e) {
//       print('❌ Error during admin logout: $e');
//     }
//   }
// }

// // Utility class for app settings
// class AppSettings {
//   static const String _themeModeKey = 'themeMode';
//   static const String _languageKey = 'language';
//   static const String _notificationKey = 'notificationsEnabled';

//   // Theme mode
//   static Future<void> setThemeMode(String themeMode) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_themeModeKey, themeMode);
//     } catch (e) {
//       print('❌ Error saving theme mode: $e');
//     }
//   }

//   static Future<String> getThemeMode() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_themeModeKey) ?? 'light';
//     } catch (e) {
//       print('❌ Error getting theme mode: $e');
//       return 'light';
//     }
//   }

//   // Language
//   static Future<void> setLanguage(String language) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_languageKey, language);
//     } catch (e) {
//       print('❌ Error saving language: $e');
//     }
//   }

//   static Future<String> getLanguage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_languageKey) ?? 'en';
//     } catch (e) {
//       print('❌ Error getting language: $e');
//       return 'en';
//     }
//   }

//   // Notifications
//   static Future<void> setNotificationsEnabled(bool enabled) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_notificationKey, enabled);
//     } catch (e) {
//       print('❌ Error saving notification settings: $e');
//     }
//   }

//   static Future<bool> getNotificationsEnabled() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_notificationKey) ?? true;
//     } catch (e) {
//       print('❌ Error getting notification settings: $e');
//       return true;
//     }
//   }
// }  


import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Keys for SharedPreferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userRoleKey = 'userRole';
  static const String _loginTimeKey = 'loginTime';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';

  // Save login data - FIXED PARAMETERS
  static Future<void> saveLoginData({
    required String email,
    String? role,
    String? userId,
    String? userName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
      if (role != null) {
        await prefs.setString(_userRoleKey, role);
      }
      
      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
      }
      
      if (userName != null) {
        await prefs.setString(_userNameKey, userName);
      }
      
      print('✅ Login data saved successfully for: $email');
    } catch (e) {
      print('❌ Error saving login data: $e');
      throw Exception('Failed to save login data');
    }
  }

  // Check if user is logged in
  static Future<bool> checkValidLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        // Optional: Check if login session is still valid (e.g., within 30 days)
        final loginTime = prefs.getString(_loginTimeKey);
        if (loginTime != null) {
          final loginDateTime = DateTime.parse(loginTime);
          final now = DateTime.now();
          final difference = now.difference(loginDateTime);
          
          // Session expires after 30 days (optional)
          if (difference.inDays > 30) {
            await logout();
            return false;
          }
        }
      }
      
      return isLoggedIn;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      print('❌ Error getting user email: $e');
      return null;
    }
  }

  // Get user role
  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      print('❌ Error getting user role: $e');
      return null;
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('❌ Error getting user ID: $e');
      return null;
    }
  }

  // Get user name
  static Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      print('❌ Error getting user name: $e');
      return null;
    }
  }

  // Get login time
  static Future<DateTime?> getLoginTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTimeString = prefs.getString(_loginTimeKey);
      return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
    } catch (e) {
      print('❌ Error getting login time: $e');
      return null;
    }
  }

  // Main logout method - SIMPLE AND RELIABLE
  static Future<void> logout() async {
    try {
      print('🔄 Starting logout process...');
      
      // 1. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userRoleKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_loginTimeKey);
      
      // 2. Clear role-specific data
      await _clearRoleSpecificData();
      
      // 3. Sign out from Firebase (if available)
      await _signOutFromFirebase();
      
      print('✅ Logout completed successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
      // Don't throw exception - we want logout to complete
    }
  }

  // Clear role-specific data
  static Future<void> _clearRoleSpecificData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all role-specific data
      await prefs.remove('towProviderIsLoggedIn');
      await prefs.remove('towProviderEmail');
      await prefs.remove('vehicleOwnerIsLoggedIn');
      await prefs.remove('vehicleOwnerEmail');
      await prefs.remove('garageIsLoggedIn');
      await prefs.remove('garageEmail');
      await prefs.remove('insuranceIsLoggedIn');
      await prefs.remove('insuranceEmail');
      await prefs.remove('adminIsLoggedIn');
      await prefs.remove('adminEmail');
      
      print('✅ Role-specific data cleared');
    } catch (e) {
      print('⚠️ Error clearing role data: $e');
    }
  }

  // Sign out from Firebase
  static Future<void> _signOutFromFirebase() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await auth.signOut();
        print('✅ Firebase signOut successful');
      } else {
        print('ℹ️ No user logged in Firebase');
      }
    } catch (e) {
      print('⚠️ Firebase signOut error (non-critical): $e');
      // Continue even if Firebase logout fails
    }
  }

  // Clear all data (for debugging or app reset)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ All SharedPreferences data cleared');
    } catch (e) {
      print('❌ Error clearing all data: $e');
    }
  }

  // Clear login data specifically
  static Future<void> clearLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userRoleKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_loginTimeKey);
      
      print('✅ Login data cleared successfully');
    } catch (e) {
      print('❌ Error clearing login data: $e');
      rethrow;
    }
  }

  // Check if first time app launch
  static Future<bool> isFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('first_time') ?? true;
      if (isFirstTime) {
        await prefs.setBool('first_time', false);
      }
      return isFirstTime;
    } catch (e) {
      print('❌ Error checking first time: $e');
      return true;
    }
  }

  // Get all stored data (for debugging)
  static Future<Map<String, dynamic>> getAllStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
        'userEmail': prefs.getString(_userEmailKey),
        'userRole': prefs.getString(_userRoleKey),
        'userId': prefs.getString(_userIdKey),
        'userName': prefs.getString(_userNameKey),
        'loginTime': prefs.getString(_loginTimeKey),
      };
    } catch (e) {
      print('❌ Error getting all stored data: $e');
      return {};
    }
  }
}

// Role-specific SharedPreferences services
class VehicleOwnerAuth {
  static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
  static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

  static Future<void> saveVehicleOwnerLogin(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_vehicleOwnerLoggedInKey, true);
      await prefs.setString(_vehicleOwnerEmailKey, email);
      // Also save in main auth service
      await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
    } catch (e) {
      print('❌ Error saving vehicle owner login: $e');
    }
  }

  static Future<bool> isVehicleOwnerLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking vehicle owner login: $e');
      return false;
    }
  }

  static Future<void> vehicleOwnerLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_vehicleOwnerLoggedInKey, false);
      await prefs.remove(_vehicleOwnerEmailKey);
    } catch (e) {
      print('❌ Error during vehicle owner logout: $e');
    }
  }
}

class GarageAuth {
  static const String _garageLoggedInKey = 'garageIsLoggedIn';
  static const String _garageEmailKey = 'garageEmail';

  static Future<void> saveGarageLogin(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_garageLoggedInKey, true);
      await prefs.setString(_garageEmailKey, email);
      await AuthService.saveLoginData(email: email, role: 'garage');
    } catch (e) {
      print('❌ Error saving garage login: $e');
    }
  }

  static Future<bool> isGarageLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_garageLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking garage login: $e');
      return false;
    }
  }

  static Future<void> garageLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_garageLoggedInKey, false);
      await prefs.remove(_garageEmailKey);
    } catch (e) {
      print('❌ Error during garage logout: $e');
    }
  }
}

class TowProviderAuth {
  static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
  static const String _towProviderEmailKey = 'towProviderEmail';

  static Future<void> saveTowProviderLogin(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_towProviderLoggedInKey, true);
      await prefs.setString(_towProviderEmailKey, email);
      await AuthService.saveLoginData(email: email, role: 'tow_provider');
    } catch (e) {
      print('❌ Error saving tow provider login: $e');
    }
  }

  static Future<bool> isTowProviderLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_towProviderLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking tow provider login: $e');
      return false;
    }
  }

  static Future<void> towProviderLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_towProviderLoggedInKey, false);
      await prefs.remove(_towProviderEmailKey);
    } catch (e) {
      print('❌ Error during tow provider logout: $e');
    }
  }
}

class InsuranceAuth {
  static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
  static const String _insuranceEmailKey = 'insuranceEmail';

  static Future<void> saveInsuranceLogin(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_insuranceLoggedInKey, true);
      await prefs.setString(_insuranceEmailKey, email);
      await AuthService.saveLoginData(email: email, role: 'insurance');
    } catch (e) {
      print('❌ Error saving insurance login: $e');
    }
  }

  static Future<bool> isInsuranceLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_insuranceLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking insurance login: $e');
      return false;
    }
  }

  static Future<void> insuranceLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_insuranceLoggedInKey, false);
      await prefs.remove(_insuranceEmailKey);
    } catch (e) {
      print('❌ Error during insurance logout: $e');
    }
  }
}

class AdminAuth {
  static const String _adminLoggedInKey = 'adminIsLoggedIn';
  static const String _adminEmailKey = 'adminEmail';

  static Future<void> saveAdminLogin(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adminLoggedInKey, true);
      await prefs.setString(_adminEmailKey, email);
      await AuthService.saveLoginData(email: email, role: 'admin');
    } catch (e) {
      print('❌ Error saving admin login: $e');
    }
  }

  static Future<bool> isAdminLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_adminLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking admin login: $e');
      return false;
    }
  }

  static Future<void> adminLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adminLoggedInKey, false);
      await prefs.remove(_adminEmailKey);
    } catch (e) {
      print('❌ Error during admin logout: $e');
    }
  }
}

// Utility class for app settings
class AppSettings {
  static const String _themeModeKey = 'themeMode';
  static const String _languageKey = 'language';
  static const String _notificationKey = 'notificationsEnabled';

  // Theme mode
  static Future<void> setThemeMode(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, themeMode);
    } catch (e) {
      print('❌ Error saving theme mode: $e');
    }
  }

  static Future<String> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_themeModeKey) ?? 'light';
    } catch (e) {
      print('❌ Error getting theme mode: $e');
      return 'light';
    }
  }

  // Language
  static Future<void> setLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    } catch (e) {
      print('❌ Error saving language: $e');
    }
  }

  static Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey) ?? 'en';
    } catch (e) {
      print('❌ Error getting language: $e');
      return 'en';
    }
  }

  // Notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationKey, enabled);
    } catch (e) {
      print('❌ Error saving notification settings: $e');
    }
  }

  static Future<bool> getNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationKey) ?? true;
    } catch (e) {
      print('❌ Error getting notification settings: $e');
      return true;
    }
  }
}