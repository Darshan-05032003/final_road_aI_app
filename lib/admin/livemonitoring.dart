import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_road_app/admin/services/admin_data_service.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';
import 'package:smart_road_app/widgets/enhanced_card.dart';
import 'package:smart_road_app/widgets/enhanced_button.dart';

class LiveMonitoringPage extends StatefulWidget {
  const LiveMonitoringPage({super.key});

  @override
  State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
}

class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
  final AdminDataService _dataService = AdminDataService();
  String _selectedFilter = 'All';
  bool _isLoading = true;
  List<Map<String, dynamic>> _activeServices = [];

  @override
  void initState() {
    super.initState();
    _loadActiveServices();
    // Auto-refresh every 10 seconds
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _loadActiveServices();
        _startAutoRefresh();
      }
    });
  }

  Future<void> _loadActiveServices() async {
    try {
      final services = await _dataService.getActiveServices();
      if (mounted) {
        setState(() {
          _activeServices = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading active services: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedFilter == 'All') return _activeServices;
    return _activeServices.where((service) {
      if (_selectedFilter == 'Emergency') {
        return service['type'] == 'Emergency';
      }
      return service['type'] == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _activeServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading active services...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Control Panel
        AppAnimations.fadeIn(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.secondaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
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
                            child: const Icon(Icons.map, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Live Monitoring',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Live',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Active Services',
                          '${_activeServices.length}',
                          Colors.white,
                          Icons.directions_car_rounded,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Garage',
                          '${_activeServices.where((s) => s['type'] == 'Garage Service').length}',
                          Colors.white,
                          Icons.build_circle,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Tow',
                          '${_activeServices.where((s) => s['type'] == 'Tow Service').length}',
                          Colors.white,
                          Icons.local_shipping,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', _selectedFilter == 'All'),
                        _buildFilterChip('Garage Service', _selectedFilter == 'Garage Service'),
                        _buildFilterChip('Tow Service', _selectedFilter == 'Tow Service'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Services List
        Expanded(
          child: _filteredServices.isEmpty
              ? AppAnimations.fadeIn(
                  child: _buildEmptyState(),
                )
              : RefreshIndicator(
                  onRefresh: _loadActiveServices,
                  color: AppTheme.primaryPurple,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      return AppAnimations.fadeIn(
                        delay: index * 30,
                        child: _buildServiceCard(_filteredServices[index]),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color textColor, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: textColor.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool value) {
          setState(() => _selectedFilter = value ? label : 'All');
        },
        selectedColor: Colors.white,
        checkmarkColor: AppTheme.primaryBlue,
        labelStyle: TextStyle(
          color: selected ? AppTheme.primaryBlue : Colors.white,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final serviceType = service['type'] ?? 'Service';
    final status = service['status'] ?? 'Pending';
    final timestamp = service['createdAt'] as Timestamp?;
    final createdAt = timestamp?.toDate() ?? DateTime.now();
    final timeAgo = _getTimeAgo(createdAt);
    final color = AppTheme.getServiceTypeColor(serviceType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: EnhancedCard(
        onTap: () => _showServiceDetails(service),
        showBorder: true,
        borderColor: color.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    serviceType.contains('Garage') ? Icons.build_circle : Icons.local_shipping,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceType,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Requested $timeAgo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                StatusTag(status: status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Customer: ${service['customer'] ?? 'Unknown'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    service['location'] ?? 'Location not available',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.directions_car_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  service['vehicle'] ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (service['problem'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        service['problem'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (service['provider'] != null && service['provider'] != 'Not Assigned') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.business_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Provider: ${service['provider']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.map_outlined,
              size: 64,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No active services',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Active service requests will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showServiceDetails(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppAnimations.slideInFromBottom(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Service Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Service Type', service['type'] ?? 'N/A', Icons.build_circle),
              _buildDetailRow('Status', service['status'] ?? 'N/A', Icons.info),
              _buildDetailRow('Customer', service['customer'] ?? 'N/A', Icons.person),
              _buildDetailRow('Location', service['location'] ?? 'N/A', Icons.location_on),
              _buildDetailRow('Vehicle', service['vehicle'] ?? 'N/A', Icons.directions_car),
              if (service['problem'] != null)
                _buildDetailRow('Problem', service['problem'] ?? 'N/A', Icons.description),
              if (service['provider'] != null && service['provider'] != 'Not Assigned')
                _buildDetailRow('Provider', service['provider'] ?? 'N/A', Icons.business),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}