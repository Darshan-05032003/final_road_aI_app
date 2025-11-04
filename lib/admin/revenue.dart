import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/admin/services/admin_data_service.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';
import 'package:smart_road_app/widgets/enhanced_card.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  final AdminDataService _dataService = AdminDataService();
  bool _isLoading = true;
  
  Map<String, dynamic> _revenueStats = {};
  List<Map<String, dynamic>> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadRevenueData();
  }

  Future<void> _loadRevenueData() async {
    setState(() => _isLoading = true);
    
    try {
      final stats = await _dataService.getRevenueStats();
      final transactions = await _dataService.getRecentTransactions(limit: 20);
      
      if (mounted) {
        setState(() {
          _revenueStats = stats;
          _recentTransactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading revenue data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
        ),
      );
    }

    return Column(
      children: [
        // Header
        AppAnimations.fadeIn(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.successGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.completedColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.attach_money_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Revenue Analytics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadRevenueData,
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadRevenueData,
            color: AppTheme.primaryPurple,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue Summary Cards
                  AppAnimations.fadeIn(
                    delay: 50,
                    child: _buildRevenueSummary(),
                  ),

                  const SizedBox(height: 24),

                  // Recent Transactions
                  AppAnimations.fadeIn(
                    delay: 100,
                    child: EnhancedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_recentTransactions.length} transactions',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_recentTransactions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No transactions yet',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ..._recentTransactions.take(10).map((transaction) {
                              return AppAnimations.fadeIn(
                                child: _buildTransactionItem(transaction),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueSummary() {
    final totalRevenue = _revenueStats['totalRevenue'] ?? 0.0;
    final todayRevenue = _revenueStats['todayRevenue'] ?? 0.0;
    final monthlyRevenue = _revenueStats['monthlyRevenue'] ?? 0.0;
    final totalTransactions = _revenueStats['totalTransactions'] ?? 0;
    final avgTransaction = _revenueStats['averageTransaction'] ?? 0.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildRevenueCard(
          'Total Revenue',
          '₹${totalRevenue.toStringAsFixed(0)}',
          Icons.account_balance_wallet_rounded,
          AppTheme.primaryPurple,
          'All time',
        ),
        _buildRevenueCard(
          'Today Revenue',
          '₹${todayRevenue.toStringAsFixed(0)}',
          Icons.today_rounded,
          AppTheme.successGradient.colors[0],
          'Today',
        ),
        _buildRevenueCard(
          'Monthly Revenue',
          '₹${monthlyRevenue.toStringAsFixed(0)}',
          Icons.calendar_month_rounded,
          AppTheme.primaryBlue,
          'This month',
        ),
        _buildRevenueCard(
          'Total Transactions',
          '$totalTransactions',
          Icons.receipt_long_rounded,
          AppTheme.primaryTeal,
          'Avg: ₹${avgTransaction.toStringAsFixed(0)}',
        ),
      ],
    );
  }

  Widget _buildRevenueCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return AppAnimations.scaleIn(
      child: EnhancedCard(
        backgroundColor: Colors.white,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] ?? 0.0;
    final status = transaction['status'] ?? 'pending';
    final timestamp = transaction['date'] as Timestamp?;
    final date = timestamp != null
        ? DateFormat('MMM dd, yyyy • HH:mm').format(timestamp.toDate())
        : 'N/A';
    final isPositive = amount >= 0;
    final statusColor = status == 'completed'
        ? AppTheme.completedColor
        : status == 'pending'
            ? AppTheme.pendingColor
            : AppTheme.rejectedColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPositive ? AppTheme.completedColor : AppTheme.rejectedColor)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: isPositive ? AppTheme.completedColor : AppTheme.rejectedColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['serviceType'] ?? 'Service',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction['customer'] ?? 'Unknown'} → ${transaction['provider'] ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}₹${amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPositive ? AppTheme.completedColor : AppTheme.rejectedColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}