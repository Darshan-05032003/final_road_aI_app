import 'package:upi_india/upi_india.dart';

class UpiPaymentHandler {
  final UpiIndia _upiIndia = UpiIndia();

  /// Initialize UPI payment
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String upiId,
    required String merchantName,
    required String transactionNote,
    String upiApp = 'all',
  }) async {
    try {
      // Validate UPI ID
      if (!_isValidUpiId(upiId)) {
        return {'status': 'FAILED', 'message': 'Invalid UPI ID format'};
      }

      // Create UPI request
      final transactionRefId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      UpiApp app;
      switch (upiApp.toLowerCase()) {
        case 'phonepe':
          app = UpiApp.phonePe;
          break;
        case 'googlepay':
          app = UpiApp.googlePay;
          break;
        case 'paytm':
          app = UpiApp.paytm;
          break;
        case 'bhim':
          app = UpiApp.bhim;
          break;
        default:
          // For 'all', we'll let user select from available apps
          app = UpiApp.googlePay; // Default fallback
      }

      // Launch UPI payment
      final response = await _upiIndia.startTransaction(
        app: app,
        receiverUpiId: upiId,
        receiverName: merchantName,
        transactionRefId: transactionRefId,
        transactionNote: transactionNote,
        amount: amount,
      );

      // Handle response
      return _processUpiResponse(response, transactionRefId);
    } catch (e) {
      return {'status': 'FAILED', 'message': 'Payment initiation failed: $e'};
    }
  }

  /// Process UPI payment response
  Map<String, dynamic> _processUpiResponse(
    UpiResponse response,
    String transactionRefId,
  ) {
    if (response.status == UpiPaymentStatus.SUCCESS) {
      // For version 3.0.1, check available properties
      String? upiTransactionId = transactionRefId;
      String responseCode = '';
      String approvalRefNo = '';

      // Try to get transaction details from response
      try {
        // These properties may not exist in all versions, so use try-catch
        if (response.responseCode != null) {
          responseCode = response.responseCode!;
        }
        if (response.approvalRefNo != null) {
          approvalRefNo = response.approvalRefNo!;
        }
        // txnId might not be available, use transactionRefId as fallback
        upiTransactionId = transactionRefId;
      } catch (e) {
        // If properties don't exist, use defaults
        upiTransactionId = transactionRefId;
      }

      return {
        'status': 'SUCCESS',
        'transactionId': transactionRefId,
        'upiTransactionId': upiTransactionId,
        'responseCode': responseCode,
        'approvalRefNo': approvalRefNo,
        'message': 'Payment successful',
      };
    } else if (response.status == UpiPaymentStatus.FAILURE) {
      String errorMessage = 'Payment failed';
      try {
        // Try to get error message if available
        if (response.responseCode != null) {
          errorMessage = 'Payment failed: ${response.responseCode}';
        }
      } catch (e) {
        errorMessage = 'Payment failed';
      }

      return {
        'status': 'FAILED',
        'message': errorMessage,
        'transactionId': transactionRefId,
      };
    } else {
      return {
        'status': 'CANCELLED',
        'message': 'Payment cancelled by user',
        'transactionId': transactionRefId,
      };
    }
  }

  /// Validate UPI ID format
  bool _isValidUpiId(String upiId) {
    // UPI ID format: username@payername
    // Example: user@paytm, user@ybl, user@okaxis
    final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
    return upiRegex.hasMatch(upiId.trim());
  }

  /// Check if UPI apps are available
  Future<List<UpiApp>> getAvailableUpiApps() async {
    try {
      return await _upiIndia.getAllUpiApps();
    } catch (e) {
      print('Error getting UPI apps: $e');
      return [];
    }
  }
}
