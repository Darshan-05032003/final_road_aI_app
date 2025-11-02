class PaymentModel {
  final String? transactionId;
  final String requestId;
  final String serviceType; // 'garage' or 'tow'
  final double amount;
  final String paymentStatus; // 'pending', 'paid', 'failed'
  final String? upiTransactionId;
  final String providerEmail;
  final String customerEmail;
  final String providerUpiId;
  final DateTime timestamp;
  final DateTime? completedAt;
  final DateTime? paidAt;
  final String? paymentMethod;
  final String? failureReason;

  PaymentModel({
    this.transactionId,
    required this.requestId,
    required this.serviceType,
    required this.amount,
    required this.paymentStatus,
    this.upiTransactionId,
    required this.providerEmail,
    required this.customerEmail,
    required this.providerUpiId,
    required this.timestamp,
    this.completedAt,
    this.paidAt,
    this.paymentMethod,
    this.failureReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'requestId': requestId,
      'serviceType': serviceType,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'upiTransactionId': upiTransactionId,
      'providerEmail': providerEmail,
      'customerEmail': customerEmail,
      'providerUpiId': providerUpiId,
      'timestamp': timestamp.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'failureReason': failureReason,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      transactionId: map['transactionId'],
      requestId: map['requestId'] ?? '',
      serviceType: map['serviceType'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
      upiTransactionId: map['upiTransactionId'],
      providerEmail: map['providerEmail'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      providerUpiId: map['providerUpiId'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      paidAt: map['paidAt'] != null ? DateTime.parse(map['paidAt']) : null,
      paymentMethod: map['paymentMethod'],
      failureReason: map['failureReason'],
    );
  }
}
