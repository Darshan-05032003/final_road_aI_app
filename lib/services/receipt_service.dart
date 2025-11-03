import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/models/payment_model.dart';
import 'package:smart_road_app/services/payment_service.dart';

class ReceiptService {
  final PaymentService _paymentService = PaymentService();

  /// Generate PDF receipt for a payment
  Future<void> generateReceipt(PaymentModel payment) async {
    try {
      // Calculate tax and totals
      final taxAmount = _paymentService.calculateTax(payment.amount);
      final totalAmount = _paymentService.calculateTotalWithTax(payment.amount);

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blueGrey700,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Payment Receipt',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Smart Road App',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Receipt Details
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Transaction Info
                      _buildReceiptRow('Receipt Number:', payment.transactionId ?? 'N/A'),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Date:', DateFormat('dd MMM yyyy, hh:mm a').format(payment.timestamp)),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Payment Status:', payment.paymentStatus.toUpperCase()),
                      if (payment.upiTransactionId != null) ...[
                        pw.SizedBox(height: 10),
                        _buildReceiptRow('UPI Transaction ID:', payment.upiTransactionId!),
                      ],
                      pw.Divider(height: 30),
                      
                      // Service Info
                      pw.Text(
                        'Service Details',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Request ID:', payment.requestId),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Service Type:', payment.serviceType.toUpperCase()),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Customer Email:', payment.customerEmail),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Provider Email:', payment.providerEmail),
                      pw.Divider(height: 30),

                      // Payment Breakdown
                      pw.Text(
                        'Payment Breakdown',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Service Amount:', '₹${payment.amount.toStringAsFixed(2)}'),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('GST (18%):', '₹${taxAmount.toStringAsFixed(2)}'),
                      pw.Divider(height: 10),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Total Amount:',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              '₹${totalAmount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 30),

                      // Footer
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Thank you for using Smart Road App!',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'This is a computer-generated receipt.',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Share or save the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('❌ Error generating receipt: $e');
      rethrow;
    }
  }

  pw.Widget _buildReceiptRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// Generate receipt as bytes (for downloading/sharing)
  Future<Uint8List> generateReceiptBytes(PaymentModel payment) async {
    try {
      final taxAmount = _paymentService.calculateTax(payment.amount);
      final totalAmount = _paymentService.calculateTotalWithTax(payment.amount);

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blueGrey700,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Payment Receipt',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Smart Road App',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Receipt Details
                pw.Padding(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildReceiptRow('Receipt Number:', payment.transactionId ?? 'N/A'),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Date:', DateFormat('dd MMM yyyy, hh:mm a').format(payment.timestamp)),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Payment Status:', payment.paymentStatus.toUpperCase()),
                      if (payment.upiTransactionId != null) ...[
                        pw.SizedBox(height: 10),
                        _buildReceiptRow('UPI Transaction ID:', payment.upiTransactionId!),
                      ],
                      pw.Divider(height: 30),
                      pw.Text(
                        'Service Details',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Request ID:', payment.requestId),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Service Type:', payment.serviceType.toUpperCase()),
                      pw.Divider(height: 30),
                      pw.Text(
                        'Payment Breakdown',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('Service Amount:', '₹${payment.amount.toStringAsFixed(2)}'),
                      pw.SizedBox(height: 10),
                      _buildReceiptRow('GST (18%):', '₹${taxAmount.toStringAsFixed(2)}'),
                      pw.Divider(height: 10),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Total Amount:',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              '₹${totalAmount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Thank you for using Smart Road App!',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      print('❌ Error generating receipt bytes: $e');
      rethrow;
    }
  }
}

