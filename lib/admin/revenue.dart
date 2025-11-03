// revenue.dart
import 'package:flutter/material.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  String _selectedPeriod = 'Monthly';
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  final Map<String, dynamic> _revenueData = {
    'summary': {
      'totalRevenue': 45287,
      'subscription': 12450,
      'commission': 28637,
      'transactionFees': 4200,
      'growthRate': 12.5,
      'previousPeriod': 40250,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (String? value) => setState(() => _selectedPeriod = value!),
                    items: _periods.map((String period) {
                      return DropdownMenuItem<String>(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Revenue Cards
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildRevenueCard(
                      'Total Revenue',
                      '\$${_revenueData['summary']['totalRevenue']}',
                      Icons.attach_money,
                      Colors.purple,
                      '+${_revenueData['summary']['growthRate']}%',
                    ),
                    _buildRevenueCard(
                      'Subscription',
                      '\$${_revenueData['summary']['subscription']}',
                      Icons.subscriptions,
                      Colors.blue,
                      '+15.7%',
                    ),
                    _buildRevenueCard(
                      'Commission',
                      '\$${_revenueData['summary']['commission']}',
                      Icons.percent,
                      Colors.green,
                      '+8.2%',
                    ),
                    _buildRevenueCard(
                      'Transaction Fees',
                      '\$${_revenueData['summary']['transactionFees']}',
                      Icons.payment,
                      Colors.orange,
                      '+5.3%',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Additional revenue content would go here
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text('Revenue Trends and Analytics'),
                      // Add more revenue-specific widgets here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change.contains('+') ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change.contains('+') ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: change.contains('+') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: change.contains('+') ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}