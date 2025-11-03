// analytics.dart
import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _timeRange = 'Monthly';
  final String _selectedMetric = 'All Services';

  final List<String> _timeRanges = ['Daily', 'Weekly', 'Monthly', 'Quarterly'];
  final List<String> _metrics = ['All Services', 'Tow', 'Mechanic', 'Emergency', 'Fuel'];

  // Sample data
  final Map<String, dynamic> _analyticsData = {
    'kpis': {
      'totalServices': 1847,
      'responseTime': 12.4,
      'satisfactionRate': 94.2,
      'revenue': 45200,
      'activeUsers': 1247,
      'completionRate': 92.5,
      'emergencyResponse': 6.5,
      'revenueGrowth': 12,
    },
    'serviceDistribution': {
      'Tow Service': 45,
      'Mechanic': 30,
      'Emergency': 15,
      'Fuel Delivery': 8,
      'Insurance': 2,
    },
    'topProviders': [
      {'name': 'City Tow Services', 'rating': 4.9, 'services': 247, 'revenue': 12500},
      {'name': 'Mobile Mechanics', 'rating': 4.8, 'services': 198, 'revenue': 9800},
      {'name': 'Quick Fuel Co.', 'rating': 4.7, 'services': 156, 'revenue': 6200},
      {'name': 'Emergency Assist', 'rating': 4.9, 'services': 132, 'revenue': 8500},
      {'name': 'Pro Auto Care', 'rating': 4.6, 'services': 121, 'revenue': 5800},
    ],
    'performanceTrends': [
      {'month': 'Jan', 'services': 420, 'revenue': 9800, 'satisfaction': 92},
      {'month': 'Feb', 'services': 380, 'revenue': 8900, 'satisfaction': 91},
      {'month': 'Mar', 'services': 450, 'revenue': 10500, 'satisfaction': 93},
      {'month': 'Apr', 'services': 520, 'revenue': 12200, 'satisfaction': 94},
      {'month': 'May', 'services': 580, 'revenue': 13500, 'satisfaction': 95},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Time Range Selector
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics Dashboard',
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
                    value: _timeRange,
                    onChanged: (String? value) => setState(() => _timeRange = value!),
                    items: _timeRanges.map((String range) {
                      return DropdownMenuItem<String>(
                        value: range,
                        child: Text(range),
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
                // KPI Cards Grid
                _buildKPISection(),

                const SizedBox(height: 24),

                // Tabs for different analytics views
                Container(
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
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Colors.blue,
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Performance'),
                          Tab(text: 'Providers'),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOverviewTab(),
                            _buildPerformanceTab(),
                            _buildProvidersTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Metrics
                _buildQuickMetrics(),

                const SizedBox(height: 24),

                // Export & Actions
                _buildExportSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _getCrossAxisCount(context),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: _getChildAspectRatio(context),
      children: [
        _buildKPICard(
          'Total Services',
          '${_analyticsData['kpis']['totalServices']}',
          Icons.assignment_turned_in,
          Colors.blue,
          '+15%',
          'vs last month',
        ),
        _buildKPICard(
          'Avg Response Time',
          '${_analyticsData['kpis']['responseTime']} min',
          Icons.timer,
          Colors.green,
          '-8%',
          'faster response',
        ),
        _buildKPICard(
          'Satisfaction Rate',
          '${_analyticsData['kpis']['satisfactionRate']}%',
          Icons.thumb_up,
          Colors.orange,
          '+2%',
          'improvement',
        ),
        _buildKPICard(
          'Revenue',
          '\$${(_analyticsData['kpis']['revenue'] / 1000).toStringAsFixed(1)}K',
          Icons.attach_money,
          Colors.purple,
          '+${_analyticsData['kpis']['revenueGrowth']}%',
          'growth',
        ),
        if (MediaQuery.of(context).size.width > 600) ...[
          _buildKPICard(
            'Active Users',
            '${_analyticsData['kpis']['activeUsers']}',
            Icons.people,
            Colors.teal,
            '+12%',
            'more users',
          ),
          _buildKPICard(
            'Completion Rate',
            '${_analyticsData['kpis']['completionRate']}%',
            Icons.check_circle,
            Colors.pink,
            '+5%',
            'better completion',
          ),
        ],
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, String change, String changeLabel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change.contains('+') ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change.contains('+') ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: change.contains('+') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: TextStyle(
                        color: change.contains('+') ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
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
          const SizedBox(height: 4),
          Text(
            changeLabel,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Service Distribution and Trend Chart would go here
          // Implementation details would be similar to your original code
          Text('Overview Content'),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Performance Content'),
        ],
      ),
    );
  }

  Widget _buildProvidersTab() {
    final List<dynamic> providers = _analyticsData['topProviders'];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Top Performing Providers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...providers.map((provider) => _buildProviderCard(provider)),
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.business, color: Colors.blue),
        ),
        title: Text(provider['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(provider['rating'].toString()),
                const SizedBox(width: 16),
                const Icon(Icons.assignment, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${provider['services']} services'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${provider['revenue']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(
              'revenue',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMetrics() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInsightChip('Peak Hours: 8-10 AM', Icons.access_time, Colors.orange),
              _buildInsightChip('Top Region: Downtown', Icons.location_on, Colors.blue),
              _buildInsightChip('Best Rating: 4.9/5', Icons.star, Colors.amber),
              _buildInsightChip('Fastest: Emergency', Icons.flash_on, Colors.green),
              _buildInsightChip('Growth: +38% MoM', Icons.trending_up, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Analytics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Download detailed reports in multiple formats',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('PDF'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.table_chart, size: 16),
                label: const Text('CSV'),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 1.5;
    if (width > 800) return 1.3;
    return 1.1;
  }
}