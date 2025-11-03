import 'package:flutter/material.dart';
import 'package:smart_road_app/admin/services/admin_data_service.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';
import 'package:smart_road_app/widgets/enhanced_card.dart';

class ServiceProvidersPage extends StatefulWidget {
  const ServiceProvidersPage({super.key});

  @override
  State<ServiceProvidersPage> createState() => _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends State<ServiceProvidersPage> {
  final AdminDataService _dataService = AdminDataService();
  String _selectedFilter = 'All';
  bool _isLoading = true;
  List<Map<String, dynamic>> _providers = [];

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    
    try {
      final providers = await _dataService.getTopProviders(limit: 50);
      if (mounted) {
        setState(() {
          _providers = providers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading providers: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredProviders {
    if (_selectedFilter == 'All') return _providers;
    if (_selectedFilter == 'Tow Providers') {
      return _providers.where((p) => p['type'] == 'Tow Provider').toList();
    }
    if (_selectedFilter == 'Garage') {
      return _providers.where((p) => p['type'] == 'Garage').toList();
    }
    return _providers;
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
                            child: const Icon(Icons.business_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Service Providers',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadProviders,
                        tooltip: 'Refresh',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Total', '${_providers.length}', Colors.white),
                      ),
                      Expanded(
                        child: _buildStatItem('Garages', '${_providers.where((p) => p['type'] == 'Garage').length}', Colors.white),
                      ),
                      Expanded(
                        child: _buildStatItem('Tow', '${_providers.where((p) => p['type'] == 'Tow Provider').length}', Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', _selectedFilter == 'All'),
                        _buildFilterChip('Garage', _selectedFilter == 'Garage'),
                        _buildFilterChip('Tow Providers', _selectedFilter == 'Tow Providers'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Providers List
        Expanded(
          child: _filteredProviders.isEmpty
              ? AppAnimations.fadeIn(
                  child: _buildEmptyState(),
                )
              : RefreshIndicator(
                  onRefresh: _loadProviders,
                  color: AppTheme.primaryPurple,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProviders.length,
                    itemBuilder: (context, index) {
                      return AppAnimations.fadeIn(
                        delay: index * 30,
                        child: _buildProviderCard(_filteredProviders[index]),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
        checkmarkColor: AppTheme.primaryPurple,
        labelStyle: TextStyle(
          color: selected ? AppTheme.primaryPurple : Colors.white,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    final type = provider['type'] ?? 'Provider';
    final color = type == 'Garage' ? AppTheme.garageServiceColor : AppTheme.towServiceColor;
    final rating = provider['rating'] ?? 0.0;
    final services = provider['services'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: EnhancedCard(
        showBorder: true,
        borderColor: color.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      type == 'Garage' ? Icons.build_circle : Icons.local_shipping,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'] ?? 'Unknown',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber,),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '$services services',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    provider['email'] ?? 'N/A',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (provider['phone'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    provider['phone'] ?? 'N/A',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
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
              color: AppTheme.primaryPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.business_outlined,
              size: 64,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No providers found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Providers will appear here once registered',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}