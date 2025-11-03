import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore show Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_road_app/models/payment_model.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  /// Save payment transaction to Firestore
  Future<String> savePaymentTransaction(PaymentModel payment) async {
    try {
      final transactionId =
          payment.transactionId ??
          'PAY${DateTime.now().millisecondsSinceEpoch}';

      final paymentData = payment.toMap();
      paymentData['transactionId'] = transactionId;

      // Save to payments collection
      await _firestore
          .collection('payments')
          .doc(transactionId)
          .set(paymentData);

      return transactionId;
    } catch (e) {
      print('❌ Error saving payment transaction: $e');
      rethrow;
    }
  }

  /// Update payment status
  Future<void> updatePaymentStatus(
    String transactionId,
    String status, {
    String? upiTransactionId,
    String? failureReason,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'paymentStatus': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (status == 'paid' && upiTransactionId != null) {
        updateData['upiTransactionId'] = upiTransactionId;
        updateData['paidAt'] = DateTime.now().toIso8601String();
        updateData['paymentMethod'] = 'UPI';
      }

      if (status == 'failed' && failureReason != null) {
        updateData['failureReason'] = failureReason;
      }

      await _firestore
          .collection('payments')
          .doc(transactionId)
          .update(updateData);
    } catch (e) {
      print('❌ Error updating payment status: $e');
      rethrow;
    }
  }

  /// Update service request with payment info
  Future<void> updateRequestPaymentInfo(
    String requestId,
    String serviceType,
    String customerEmail,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      // Update in owner's request collection
      final ownerRequestQuery = await _firestore
          .collection('owner')
          .doc(customerEmail)
          .collection(serviceType == 'garage' ? 'garagerequest' : 'towrequest')
          .where('requestId', isEqualTo: requestId)
          .limit(1)
          .get();

      if (ownerRequestQuery.docs.isNotEmpty) {
        await ownerRequestQuery.docs.first.reference.update({
          ...paymentData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Update in provider's collection if garage
      if (serviceType == 'garage') {
        // Try to find in garage collection
        final garageRequestsQuery = await _firestore
            .collectionGroup('service_requests')
            .where('requestId', isEqualTo: requestId)
            .limit(1)
            .get();

        if (garageRequestsQuery.docs.isNotEmpty) {
          await garageRequestsQuery.docs.first.reference.update({
            ...paymentData,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Update in Realtime Database
      await _databaseRef
          .child('${serviceType}_requests')
          .child(requestId)
          .update({
            ...paymentData,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });
    } catch (e) {
      print('❌ Error updating request payment info: $e');
      rethrow;
    }
  }

  /// Get payment status for a request
  Future<Map<String, dynamic>?> getPaymentStatus(
    String requestId,
    String customerEmail,
    String serviceType,
  ) async {
    try {
      final paymentQuery = await _firestore
          .collection('payments')
          .where('requestId', isEqualTo: requestId)
          .where('customerEmail', isEqualTo: customerEmail)
          .limit(1)
          .get();

      if (paymentQuery.docs.isNotEmpty) {
        return paymentQuery.docs.first.data();
      }
      return null;
    } catch (e) {
      print('❌ Error getting payment status: $e');
      return null;
    }
  }

  /// Send payment notification
  Future<void> sendPaymentNotification(
    String userId,
    String title,
    String message,
    String type,
    String requestId,
  ) async {
    try {
      final notificationRef = _databaseRef
          .child('notifications')
          .child(userId)
          .push();

      await notificationRef.set({
        'id': notificationRef.key,
        'requestId': requestId,
        'title': title,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'read': false,
        'type': type,
      });
    } catch (e) {
      print('❌ Error sending payment notification: $e');
    }
  }

  /// Verify payment status - Check if payment was successful
  Future<Map<String, dynamic>> verifyPaymentStatus(String transactionId) async {
    try {
      final paymentDoc = await _firestore
          .collection('payments')
          .doc(transactionId)
          .get();

      if (!paymentDoc.exists) {
        return {
          'verified': false,
          'status': 'not_found',
          'message': 'Transaction not found',
        };
      }

      final paymentData = paymentDoc.data()!;
      final status = paymentData['paymentStatus'] as String? ?? 'pending';
      final upiTransactionId = paymentData['upiTransactionId'] as String?;

      return {
        'verified': true,
        'status': status,
        'paymentData': paymentData,
        'upiTransactionId': upiTransactionId,
        'message': status == 'paid'
            ? 'Payment verified successfully'
            : status == 'failed'
                ? 'Payment failed'
                : 'Payment pending verification',
      };
    } catch (e) {
      print('❌ Error verifying payment status: $e');
      return {
        'verified': false,
        'status': 'error',
        'message': 'Error verifying payment: $e',
      };
    }
  }

  /// Process refund for a payment
  Future<Map<String, dynamic>> processRefund({
    required String transactionId,
    required double refundAmount,
    required String reason,
    String? processedBy,
  }) async {
    try {
      // Get payment details
      final paymentDoc = await _firestore
          .collection('payments')
          .doc(transactionId)
          .get();

      if (!paymentDoc.exists) {
        return {
          'success': false,
          'message': 'Transaction not found',
        };
      }

      final paymentData = paymentDoc.data()!;
      final currentStatus = paymentData['paymentStatus'] as String? ?? 'pending';
      final originalAmount = (paymentData['amount'] ?? 0.0).toDouble();

      // Validate refund
      if (currentStatus != 'paid') {
        return {
          'success': false,
          'message': 'Cannot refund a payment that is not completed',
        };
      }

      if (refundAmount > originalAmount) {
        return {
          'success': false,
          'message': 'Refund amount cannot exceed original payment amount',
        };
      }

      // Create refund record
      final refundId = 'REF${DateTime.now().millisecondsSinceEpoch}';
      final refundData = {
        'refundId': refundId,
        'transactionId': transactionId,
        'originalAmount': originalAmount,
        'refundAmount': refundAmount,
        'reason': reason,
        'status': 'pending',
        'processedBy': processedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'requestId': paymentData['requestId'],
        'customerEmail': paymentData['customerEmail'],
        'providerEmail': paymentData['providerEmail'],
      };

      await _firestore.collection('refunds').doc(refundId).set(refundData);

      // Update payment status to refunded (partial or full)
      final newStatus = refundAmount == originalAmount ? 'refunded_full' : 'refunded_partial';
      await _firestore.collection('payments').doc(transactionId).update({
        'paymentStatus': newStatus,
        'refundAmount': refundAmount,
        'refundId': refundId,
        'refundedAt': FieldValue.serverTimestamp(),
        'refundReason': reason,
      });

      // Send notifications
      await sendPaymentNotification(
        paymentData['customerEmail'].toString().replaceAll(RegExp(r'[\.#\$\[\]]'), '_'),
        'Refund Processed 💰',
        'Refund of ₹${refundAmount.toStringAsFixed(2)} has been processed for transaction $transactionId',
        'refund',
        paymentData['requestId'] ?? '',
      );

      return {
        'success': true,
        'refundId': refundId,
        'message': 'Refund processed successfully',
      };
    } catch (e) {
      print('❌ Error processing refund: $e');
      return {
        'success': false,
        'message': 'Error processing refund: $e',
      };
    }
  }

  /// Get transaction history for a user
  Future<List<PaymentModel>> getTransactionHistory({
    required String userEmail,
    String? userRole, // 'customer' or 'provider'
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? serviceType,
    int limit = 50,
  }) async {
    try {
      firestore.Query query = _firestore.collection('payments');

      // Filter by user role
      if (userRole == 'customer') {
        query = query.where('customerEmail', isEqualTo: userEmail);
      } else if (userRole == 'provider') {
        query = query.where('providerEmail', isEqualTo: userEmail);
      }

      // Filter by status
      if (status != null && status.isNotEmpty) {
        query = query.where('paymentStatus', isEqualTo: status);
      }

      // Filter by service type
      if (serviceType != null && serviceType.isNotEmpty) {
        query = query.where('serviceType', isEqualTo: serviceType);
      }

      // Order by timestamp descending
      query = query.orderBy('timestamp', descending: true).limit(limit);

      final querySnapshot = await query.get();

      final transactions = <PaymentModel>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Filter by date range if provided
        if (startDate != null || endDate != null) {
          final timestamp = data['timestamp'] as String?;
          if (timestamp != null) {
            final transactionDate = DateTime.parse(timestamp);
            if (startDate != null && transactionDate.isBefore(startDate)) {
              continue;
            }
            if (endDate != null && transactionDate.isAfter(endDate)) {
              continue;
            }
          }
        }
        transactions.add(PaymentModel.fromMap(data));
      }

      return transactions;
    } catch (e) {
      print('❌ Error getting transaction history: $e');
      return [];
    }
  }

  /// Calculate tax for an amount (GST - 18%)
  double calculateTax(double amount, {double taxRate = 0.18}) {
    return amount * taxRate;
  }

  /// Calculate total amount with tax
  double calculateTotalWithTax(double amount, {double taxRate = 0.18}) {
    return amount + calculateTax(amount, taxRate: taxRate);
  }

  /// Get financial reports for admin
  Future<Map<String, dynamic>> getFinancialReports({
    DateTime? startDate,
    DateTime? endDate,
    String? serviceType,
  }) async {
    try {
      firestore.Query query = _firestore.collection('payments');

      // Filter by date range
      if (startDate != null) {
        query = query.where('timestamp',
            isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.where('timestamp',
            isLessThanOrEqualTo: endDate.toIso8601String());
      }

      // Filter by service type
      if (serviceType != null && serviceType.isNotEmpty) {
        query = query.where('serviceType', isEqualTo: serviceType);
      }

      final querySnapshot = await query.get();

      double totalRevenue = 0.0;
      double totalTax = 0.0;
      int totalTransactions = 0;
      int paidTransactions = 0;
      int failedTransactions = 0;
      int pendingTransactions = 0;
      final serviceTypeBreakdown = <String, double>{};
      final dailyRevenue = <String, double>{};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] ?? 0.0).toDouble();
        final status = data['paymentStatus'] as String? ?? 'pending';
        final serviceTypeItem = data['serviceType'] as String? ?? 'unknown';
        final timestamp = data['timestamp'] as String?;

        totalTransactions++;

        if (status == 'paid') {
          paidTransactions++;
          totalRevenue += amount;
          totalTax += calculateTax(amount);
          
          // Service type breakdown
          serviceTypeBreakdown[serviceTypeItem] =
              (serviceTypeBreakdown[serviceTypeItem] ?? 0.0) + amount;

          // Daily revenue breakdown
          if (timestamp != null) {
            final date = DateTime.parse(timestamp);
            final dateKey =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            dailyRevenue[dateKey] = (dailyRevenue[dateKey] ?? 0.0) + amount;
          }
        } else if (status == 'failed') {
          failedTransactions++;
        } else {
          pendingTransactions++;
        }
      }

      return {
        'totalRevenue': totalRevenue,
        'totalTax': totalTax,
        'totalTransactions': totalTransactions,
        'paidTransactions': paidTransactions,
        'failedTransactions': failedTransactions,
        'pendingTransactions': pendingTransactions,
        'serviceTypeBreakdown': serviceTypeBreakdown,
        'dailyRevenue': dailyRevenue,
        'successRate': totalTransactions > 0
            ? (paidTransactions / totalTransactions) * 100
            : 0.0,
      };
    } catch (e) {
      print('❌ Error getting financial reports: $e');
      return {
        'error': 'Error generating reports: $e',
      };
    }
  }
}
