import 'package:cloud_firestore/cloud_firestore.dart';
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
}
