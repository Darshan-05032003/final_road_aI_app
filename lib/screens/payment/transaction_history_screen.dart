import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/models/payment_model.dart';
import 'package:smart_road_app/services/payment_service.dart';
import 'package:smart_road_app/services/receipt_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String userEmail;
  final String userRole; // 'customer' or 'provider'

  const TransactionHistoryScreen({
    super.key,
    required this.userEmail,
    required this.userRole,
  });

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final PaymentService _paymentService = PaymentService();
  final ReceiptService _receiptService = ReceiptService();

  List<PaymentModel> _transactions = [];
  bool _isLoading = true;
  String _selectedStatus = 'all';
  String _selectedServiceType = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _paymentService.getTransactionHistory(
        userEmail: widget.userEmail,
        userRole: widget.userRole,
        status: _selectedStatus == 'all' ? null : _selectedStatus,
        serviceType: _selectedServiceType == 'all' ? null : _selectedServiceType,
        startDate: _startDate,
        endDate: _endDate,
      );

      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transactions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionCard(_transactions[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(PaymentModel transaction) {
    final statusColor = _getStatusColor(transaction.paymentStatus);
    final taxAmount = _paymentService.calculateTax(transaction.amount);
    final totalAmount = _paymentService.calculateTotalWithTax(transaction.amount);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showTransactionDetails(transaction),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.serviceType.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(transaction.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          transaction.paymentStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.receipt, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'TXN: ${transaction.transactionId ?? "N/A"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (transaction.paymentStatus == 'paid')
                    TextButton.icon(
                      onPressed: () => _downloadReceipt(transaction),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Receipt'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'refunded_full':
      case 'refunded_partial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showTransactionDetails(PaymentModel transaction) {
    final taxAmount = _paymentService.calculateTax(transaction.amount);
    final totalAmount = _paymentService.calculateTotalWithTax(transaction.amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Transaction ID', transaction.transactionId ?? 'N/A'),
              const SizedBox(height: 8),
              _buildDetailRow('Request ID', transaction.requestId),
              const SizedBox(height: 8),
              _buildDetailRow('Service Type', transaction.serviceType.toUpperCase()),
              const SizedBox(height: 8),
              _buildDetailRow('Status', transaction.paymentStatus.toUpperCase()),
              const SizedBox(height: 8),
              _buildDetailRow('Date', DateFormat('dd MMM yyyy, hh:mm a').format(transaction.timestamp)),
              if (transaction.upiTransactionId != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('UPI TXN ID', transaction.upiTransactionId!),
              ],
              const Divider(height: 20),
              _buildDetailRow('Service Amount', '₹${transaction.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              _buildDetailRow('GST (18%)', '₹${taxAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (transaction.paymentStatus == 'paid')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _downloadReceipt(transaction);
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Receipt'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadReceipt(PaymentModel transaction) async {
    try {
      await _receiptService.generateReceipt(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating receipt: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Transactions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Filter
                const Text('Payment Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'paid', child: Text('Paid')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                    DropdownMenuItem(value: 'refunded_full', child: Text('Refunded')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      _selectedStatus = value ?? 'all';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Service Type Filter
                const Text('Service Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedServiceType,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'garage', child: Text('Garage')),
                    DropdownMenuItem(value: 'tow', child: Text('Tow')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      _selectedServiceType = value ?? 'all';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Date Range
                const Text('Date Range:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() {
                              _startDate = date;
                            });
                          }
                        },
                        child: Text(_startDate == null
                            ? 'Start Date'
                            : DateFormat('dd MMM yyyy').format(_startDate!)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() {
                              _endDate = date;
                            });
                          }
                        },
                        child: Text(_endDate == null
                            ? 'End Date'
                            : DateFormat('dd MMM yyyy').format(_endDate!)),
                      ),
                    ),
                  ],
                ),
                if (_startDate != null || _endDate != null)
                  TextButton(
                    onPressed: () {
                      setDialogState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: const Text('Clear Date Range'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  _selectedStatus = 'all';
                  _selectedServiceType = 'all';
                  _startDate = null;
                  _endDate = null;
                });
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _loadTransactions();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}

