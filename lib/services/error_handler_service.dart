import 'package:flutter/material.dart';

/// Error Handler Service for better error management
/// Note: To enable Crashlytics, add firebase_crashlytics package
class ErrorHandlerService {
  static final ErrorHandlerService _instance = ErrorHandlerService._internal();
  factory ErrorHandlerService() => _instance;
  ErrorHandlerService._internal();

  /// Show user-friendly error message
  static void showError(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
      ),
    );
  }
  
  /// Show success message
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  /// Log error to crashlytics
  /// To enable: Add firebase_crashlytics package and uncomment below
  static Future<void> logError(dynamic error, StackTrace? stackTrace, {String? reason}) async {
    // Ready for Firebase Crashlytics integration
    // try {
    //   await FirebaseCrashlytics.instance.recordError(
    //     error,
    //     stackTrace,
    //     reason: reason,
    //     fatal: false,
    //   );
    // } catch (e) {
    //   print('Error logging to Crashlytics: $e');
    // }
  }
  
  /// Handle network error
  static String getNetworkErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}
