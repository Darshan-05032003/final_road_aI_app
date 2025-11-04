import 'package:flutter/material.dart';
import 'package:smart_road_app/admin/services/admin_service.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';
import 'package:smart_road_app/widgets/enhanced_card.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  late TabController _tabController;
  bool _isLoading = true;
  
  String _timeRange = 'Monthly';
  String _serviceFilter = 'All Services';
  Map<String, dynamic> _analyticsData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Fixed: 3 tabs, not 4
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _adminService.getAnalyticsData(
        timeRange: _timeRange,
        serviceFilter: _serviceFilter,
      );
      if (mounted) {
        setState(() {
          _analyticsData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading analytics: $e');
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
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
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
                        child: const Icon(Icons.analytics, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadAnalytics,
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Cards
                AppAnimations.fadeIn(
                  delay: 50,
                  child: _buildKPISection(),
                ),

                const SizedBox(height: 24),

                // Tabs
                AppAnimations.fadeIn(
                  delay: 100,
                  child: EnhancedCard(
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: AppTheme.primaryPurple,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: AppTheme.primaryPurple,
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Services'),
                            Tab(text: 'Users'),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildOverviewTab(),
                              _buildServicesTab(),
                              _buildUsersTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    final kpis = _analyticsData['kpis'] ?? {};
    final totalServices = kpis['totalServices'] ?? 0;
    final activeUsers = kpis['activeUsers'] ?? 0;
    final revenue = kpis['revenue'] ?? 0.0;
    final completionRate = kpis['completionRate'] ?? 0.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildKPICard(
          'Total Services',
          '$totalServices',
          Icons.assignment_turned_in_rounded,
          AppTheme.primaryBlue,
        ),
        _buildKPICard(
          'Active Users',
          '$activeUsers',
          Icons.people_rounded,
          AppTheme.primaryTeal,
        ),
        _buildKPICard(
          'Total Revenue',
          '₹${revenue.toStringAsFixed(0)}',
          Icons.attach_money_rounded,
          AppTheme.successGradient.colors[0],
        ),
        _buildKPICard(
          'Completion Rate',
          '${completionRate.toStringAsFixed(1)}%',
          Icons.check_circle_rounded,
          AppTheme.primaryPurple,
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
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
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    final serviceDistribution = _analyticsData['serviceDistribution'] ?? {};
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...serviceDistribution.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDistributionBar(entry.key, entry.value as int),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(String label, int percentage) {
    final color = label.contains('Garage') ? AppTheme.garageServiceColor : AppTheme.towServiceColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTab() {
    final serviceDistribution = _analyticsData['serviceDistribution'] ?? {};
    final kpis = _analyticsData['kpis'] ?? {};
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard(
            'Total Services',
            '${kpis['totalServices'] ?? 0}',
            Icons.assignment,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            'Completion Rate',
            '${(kpis['completionRate'] ?? 0.0).toStringAsFixed(1)}%',
            Icons.check_circle,
            AppTheme.completedColor,
          ),
          const SizedBox(height: 12),
          Text(
            'By Service Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...serviceDistribution.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildServiceTypeCard(entry.key, entry.value as int),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    final usersCount = _analyticsData['usersCount'] ?? {};
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard(
            'Total Users',
            '${usersCount['total'] ?? 0}',
            Icons.people,
            AppTheme.primaryPurple,
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            'Vehicle Owners',
            '${usersCount['vehicleOwners'] ?? 0}',
            Icons.directions_car,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            'Garages',
            '${usersCount['garages'] ?? 0}',
            Icons.build_circle,
            AppTheme.garageServiceColor,
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            'Tow Providers',
            '${usersCount['towProviders'] ?? 0}',
            Icons.local_shipping,
            AppTheme.towServiceColor,
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            'Insurance',
            '${usersCount['insurance'] ?? 0}',
            Icons.shield,
            AppTheme.insuranceColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard(String type, int percentage) {
    final color = type.contains('Garage') ? AppTheme.garageServiceColor : AppTheme.towServiceColor;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type.contains('Garage') ? Icons.build_circle : Icons.local_shipping,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              type,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$percentage%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}