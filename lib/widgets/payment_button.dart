import 'package:flutter/material.dart';
import 'package:smart_road_app/screens/payment/payment_options_screen.dart';

class PaymentButton extends StatelessWidget {

  const PaymentButton({
    super.key,
    required this.requestId,
    required this.serviceType,
    required this.amount,
    required this.providerUpiId,
    required this.providerEmail,
    required this.customerEmail,
    this.providerName,
  });
  final String requestId;
  final String serviceType;
  final double amount;
  final String providerUpiId;
  final String providerEmail;
  final String customerEmail;
  final String? providerName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentOptionsScreen(
              requestId: requestId,
              serviceType: serviceType,
              amount: amount,
              providerUpiId: providerUpiId,
              providerEmail: providerEmail,
              customerEmail: customerEmail,
              providerName: providerName,
            ),
          ),
        );
      },
      icon: const Icon(Icons.payment, color: Colors.white),
      label: Text(
        'Pay ₹${amount.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }

  /// Static method to check if payment button should be shown
  static bool shouldShowPaymentButton(Map<String, dynamic> request) {
    final status = (request['status'] as String?)?.toLowerCase() ?? '';
    final paymentStatus =
        (request['paymentStatus'] as String?)?.toLowerCase() ?? '';
    final amount = request['serviceAmount'] as num?;
    final upiId = request['providerUpiId'] as String?;

    return status == 'completed' &&
        paymentStatus != 'paid' &&
        amount != null &&
        amount > 0 &&
        upiId != null &&
        upiId.isNotEmpty;
  }
}
