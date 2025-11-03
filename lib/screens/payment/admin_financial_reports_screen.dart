import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/services/payment_service.dart';

class AdminFinancialReportsScreen extends StatefulWidget {
  const AdminFinancialReportsScreen({super.key});

  @override
  State<AdminFinancialReportsScreen> createState() =>
      _AdminFinancialReportsScreenState();
}

class _AdminFinancialReportsScreenState
    extends State<AdminFinancialReportsScreen> {
  final PaymentService _paymentService = PaymentService();
  Map<String, dynamic>? _reports;
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedServiceType = 'all';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reports = await _paymentService.getFinancialReports(
        startDate: _startDate,
        endDate: _endDate,
        serviceType: _selectedServiceType == 'all'
            ? null
            : _selectedServiceType,
      );

      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reports: $e'),
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
        title: const Text('Financial Reports'),
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadReports),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports == null || _reports!.containsKey('error')
          ? _buildErrorState()
          : RefreshIndicator(
              onRefresh: _loadReports,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildRevenueBreakdown(),
                    const SizedBox(height: 24),
                    _buildServiceTypeBreakdown(),
                    const SizedBox(height: 24),
                    _buildDailyRevenueChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error loading reports',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _loadReports, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalRevenue = (_reports!['totalRevenue'] ?? 0.0).toDouble();
    final totalTax = (_reports!['totalTax'] ?? 0.0).toDouble();
    final totalTransactions = _reports!['totalTransactions'] ?? 0;
    final paidTransactions = _reports!['paidTransactions'] ?? 0;
    final successRate = (_reports!['successRate'] ?? 0.0).toDouble();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Revenue',
                '₹${totalRevenue.toStringAsFixed(2)}',
                Colors.green,
                Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Tax (GST)',
                '₹${totalTax.toStringAsFixed(2)}',
                Colors.blue,
                Icons.receipt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Transactions',
                totalTransactions.toString(),
                Colors.orange,
                Icons.swap_horiz,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Success Rate',
                '${successRate.toStringAsFixed(1)}%',
                Colors.purple,
                Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    final paidTransactions = _reports!['paidTransactions'] ?? 0;
    final failedTransactions = _reports!['failedTransactions'] ?? 0;
    final pendingTransactions = _reports!['pendingTransactions'] ?? 0;
    final totalTransactions = _reports!['totalTransactions'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Status Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Paid',
              paidTransactions,
              Colors.green,
              totalTransactions,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Pending',
              pendingTransactions,
              Colors.orange,
              totalTransactions,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Failed',
              failedTransactions,
              Colors.red,
              totalTransactions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, Color color, int total) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildServiceTypeBreakdown() {
    final breakdown =
        _reports!['serviceTypeBreakdown'] as Map<String, dynamic>? ?? {};

    if (breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Type Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...breakdown.entries.map((entry) {
              final amount = (entry.value as num).toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '₹${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRevenueChart() {
    final dailyRevenue =
        _reports!['dailyRevenue'] as Map<String, dynamic>? ?? {};

    if (dailyRevenue.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No daily revenue data available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    final sortedEntries = dailyRevenue.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Revenue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...sortedEntries.take(7).map((entry) {
              final amount = (entry.value as num).toDouble();
              final maxAmount = dailyRevenue.values
                  .map((v) => (v as num).toDouble())
                  .reduce((a, b) => a > b ? a : b);
              final percentage = maxAmount > 0
                  ? (amount / maxAmount) * 100
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '₹${amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Reports'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Service Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                const Text(
                  'Date Range:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                        child: Text(
                          _startDate == null
                              ? 'Start Date'
                              : DateFormat('dd MMM yyyy').format(_startDate!),
                        ),
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
                        child: Text(
                          _endDate == null
                              ? 'End Date'
                              : DateFormat('dd MMM yyyy').format(_endDate!),
                        ),
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
                _loadReports();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
