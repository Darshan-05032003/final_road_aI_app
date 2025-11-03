import 'package:flutter/material.dart';
import 'package:smart_road_app/screens/payment/upi_payment_handler.dart';
import 'package:smart_road_app/services/payment_service.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final String requestId;
  final String serviceType;
  final double amount;
  final String providerUpiId;
  final String providerEmail;
  final String customerEmail;
  final String? providerName;

  const PaymentOptionsScreen({
    super.key,
    required this.requestId,
    required this.serviceType,
    required this.amount,
    required this.providerUpiId,
    required this.providerEmail,
    required this.customerEmail,
    this.providerName,
  });

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  final PaymentService _paymentService = PaymentService();
  final UpiPaymentHandler _upiHandler = UpiPaymentHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAmountCard(),
            const SizedBox(height: 20),
            _buildPaymentMethodsSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    final taxAmount = _paymentService.calculateTax(widget.amount);
    final totalAmount = _paymentService.calculateTotalWithTax(widget.amount);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service Amount:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                '₹${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GST (18%):',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                '₹${taxAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          Text(
                '₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
                  fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
              ),
            ],
          ),
          if (widget.providerName != null) ...[
            const SizedBox(height: 12),
            Text(
              'Payment to: ${widget.providerName}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(
            icon: Icons.account_balance_wallet,
            title: 'UPI',
            subtitle: 'Pay using UPI apps',
            isRecommended: true,
            onTap: () => _handleUpiPayment(),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            icon: Icons.credit_card,
            title: 'Credit / Debit Card',
            subtitle: 'Coming soon',
            isRecommended: false,
            isComingSoon: true,
            onTap: () => _showComingSoon('Card payment coming soon'),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            icon: Icons.account_balance,
            title: 'Net Banking',
            subtitle: 'Coming soon',
            isRecommended: false,
            isComingSoon: true,
            onTap: () => _showComingSoon('Net banking coming soon'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isRecommended,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRecommended ? Colors.blue : Colors.grey[300]!,
            width: isRecommended ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRecommended ? Colors.blue[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isRecommended ? Colors.blue : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isComingSoon ? Colors.grey : Colors.black,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isComingSoon ? 'Coming soon' : subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isComingSoon ? Colors.grey : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpiPayment() async {
    try {
      // Show UPI apps selection
      final selectedApp = await _showUpiAppsDialog();

      if (selectedApp == null) {
        return;
      }

      // Process UPI payment
      final result = await _upiHandler.initiatePayment(
        amount: widget.amount,
        upiId: widget.providerUpiId,
        merchantName: widget.providerName ?? 'Service Provider',
        transactionNote: 'Payment for ${widget.serviceType} service',
        upiApp: selectedApp,
      );

      // Handle payment result
      await _handlePaymentResult(result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showUpiAppsDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select UPI App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUpiAppOption('phonepe', 'PhonePe'),
            _buildUpiAppOption('googlepay', 'Google Pay'),
            _buildUpiAppOption('paytm', 'Paytm'),
            _buildUpiAppOption('bhim', 'BHIM'),
            _buildUpiAppOption('all', 'Any UPI App'),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiAppOption(String value, String label) {
    return ListTile(
      title: Text(label),
      onTap: () => Navigator.pop(context, value),
    );
  }

  Future<void> _handlePaymentResult(Map<String, dynamic> result) async {
    if (!mounted) return;

    final status = result['status'] as String;

    if (status == 'SUCCESS') {
      // Payment successful
      final transactionId = result['transactionId'] as String?;
      final upiTransactionId = result['upiTransactionId'] as String?;

      try {
        // Verify payment status
        if (transactionId != null) {
          final verification = await _paymentService.verifyPaymentStatus(transactionId);
          if (!verification['verified'] || verification['status'] != 'paid') {
            // Payment verification failed - update status
            await _paymentService.updatePaymentStatus(
              transactionId,
              'pending',
              failureReason: 'Payment verification pending',
            );
          }
        }

        // Calculate tax and total
        final taxAmount = _paymentService.calculateTax(widget.amount);
        final totalAmount = _paymentService.calculateTotalWithTax(widget.amount);

        // Save payment transaction
        await _paymentService.updateRequestPaymentInfo(
          widget.requestId,
          widget.serviceType,
          widget.customerEmail,
          {
            'paymentStatus': 'paid',
            'paymentTransactionId': transactionId,
            'upiTransactionId': upiTransactionId,
            'paidAt': DateTime.now().toIso8601String(),
            'paymentMethod': 'UPI',
            'serviceAmount': widget.amount,
            'taxAmount': taxAmount,
            'totalAmount': totalAmount,
          },
        );

        // Send notifications
        await _paymentService.sendPaymentNotification(
          widget.customerEmail.replaceAll(RegExp(r'[\.#\$\[\]]'), '_'),
          'Payment Successful ✅',
          'Your payment of ₹${widget.amount} has been received',
          'payment_success',
          widget.requestId,
        );

        // Show success screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                amount: widget.amount,
                transactionId: transactionId ?? 'N/A',
                requestId: widget.requestId,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving payment: $e'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } else if (status == 'FAILED') {
      // Payment failed
      final errorMessage = result['message'] as String? ?? 'Payment failed';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } else {
      // Payment cancelled
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;
  final String transactionId;
  final String requestId;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.transactionId,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Transaction ID', transactionId),
                      const SizedBox(height: 8),
                      _buildInfoRow('Request ID', requestId),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
