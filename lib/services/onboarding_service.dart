import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _permissionsExplainedKey = 'permissions_explained';

  /// Check if onboarding has been completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingCompletedKey) ?? false;
    } catch (e) {
      print('❌ Error checking onboarding status: $e');
      return false;
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      print('✅ Onboarding marked as completed');
    } catch (e) {
      print('❌ Error completing onboarding: $e');
    }
  }

  /// Check if permissions have been explained
  static Future<bool> arePermissionsExplained() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_permissionsExplainedKey) ?? false;
    } catch (e) {
      print('❌ Error checking permissions explanation status: $e');
      return false;
    }
  }

  /// Mark permissions as explained
  static Future<void> markPermissionsExplained() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_permissionsExplainedKey, true);
      print('✅ Permissions explanation marked as shown');
    } catch (e) {
      print('❌ Error marking permissions as explained: $e');
    }
  }

  /// Reset onboarding (for testing purposes)
  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      await prefs.remove(_permissionsExplainedKey);
      print('✅ Onboarding reset');
    } catch (e) {
      print('❌ Error resetting onboarding: $e');
    }
  }
}

