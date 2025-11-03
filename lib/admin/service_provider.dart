// service_providers.dart
import 'package:flutter/material.dart';

class ServiceProvidersPage extends StatefulWidget {
  const ServiceProvidersPage({super.key});

  @override
  State<ServiceProvidersPage> createState() => _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends State<ServiceProvidersPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Tow Providers', 'Garages', 'Active', 'Inactive'];

  // Sample data for service providers
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'City Tow Services',
      'type': 'Tow Provider',
      'totalUsers': 1247,
      'completedServices': 856,
      'rating': 4.9,
      'status': 'Active',
      'joinDate': '2023-05-15',
      'revenue': 12500,
      'responseTime': '8.2 min',
      'specialization': ['Car Towing', 'Roadside Assistance', 'Recovery'],
      'coverage': ['Manhattan', 'Brooklyn', 'Queens'],
    },
    {
      'id': '2',
      'name': 'Pro Auto Garage',
      'type': 'Garage',
      'totalUsers': 892,
      'completedServices': 623,
      'rating': 4.7,
      'status': 'Active',
      'joinDate': '2023-08-22',
      'revenue': 9800,
      'responseTime': '15.5 min',
      'specialization': ['Engine Repair', 'Brake Service', 'Oil Change'],
      'coverage': ['Manhattan', 'Bronx'],
    },
    {
      'id': '3',
      'name': 'Quick Tow Express',
      'type': 'Tow Provider',
      'totalUsers': 567,
      'completedServices': 421,
      'rating': 4.8,
      'status': 'Active',
      'joinDate': '2024-01-10',
      'revenue': 7200,
      'responseTime': '6.8 min',
      'specialization': ['Motorcycle Towing', 'Light Duty'],
      'coverage': ['Manhattan', 'New Jersey'],
    },
    {
      'id': '4',
      'name': 'Master Mechanics',
      'type': 'Garage',
      'totalUsers': 734,
      'completedServices': 512,
      'rating': 4.6,
      'status': 'Inactive',
      'joinDate': '2023-11-05',
      'revenue': 6500,
      'responseTime': '12.3 min',
      'specialization': ['Transmission', 'Electrical', 'Diagnostics'],
      'coverage': ['Brooklyn', 'Queens'],
    },
    {
      'id': '5',
      'name': 'Emergency Roadside Help',
      'type': 'Tow Provider',
      'totalUsers': 345,
      'completedServices': 289,
      'rating': 4.9,
      'status': 'Active',
      'joinDate': '2024-02-18',
      'revenue': 4200,
      'responseTime': '5.2 min',
      'specialization': ['24/7 Emergency', 'Lockout Service', 'Jump Start'],
      'coverage': ['All NYC Areas'],
    },
  ];

  List<Map<String, dynamic>> get _filteredProviders {
    if (_selectedFilter == 'All') return _providers;
    if (_selectedFilter == 'Tow Providers') {
      return _providers.where((provider) => provider['type'] == 'Tow Provider').toList();
    }
    if (_selectedFilter == 'Garages') {
      return _providers.where((provider) => provider['type'] == 'Garage').toList();
    }
    if (_selectedFilter == 'Active') {
      return _providers.where((provider) => provider['status'] == 'Active').toList();
    }
    if (_selectedFilter == 'Inactive') {
      return _providers.where((provider) => provider['status'] == 'Inactive').toList();
    }
    return _providers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Stats
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              // Quick Stats
              Row(
                children: [
                  _buildStatItem('Total Providers', _providers.length.toString(), Colors.blue, Icons.business),
                  _buildStatItem('Tow Providers', 
                    _providers.where((p) => p['type'] == 'Tow Provider').length.toString(), 
                    Colors.orange, Icons.local_shipping),
                  _buildStatItem('Garages', 
                    _providers.where((p) => p['type'] == 'Garage').length.toString(), 
                    Colors.green, Icons.garage),
                  _buildStatItem('Active', 
                    _providers.where((p) => p['status'] == 'Active').length.toString(), 
                    Colors.teal, Icons.check_circle),
                ],
              ),
              const SizedBox(height: 16),
              // Overall Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOverallStat('Total Users Served', '3,785', Icons.people, Colors.blue),
                    _buildOverallStat('Completed Services', '2,701', Icons.assignment_turned_in, Colors.green),
                    _buildOverallStat('Avg Rating', '4.8/5', Icons.star, Colors.amber),
                    _buildOverallStat('Total Revenue', '\$40,200', Icons.attach_money, Colors.purple),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filters
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Providers List
        Expanded(
          child: _filteredProviders.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredProviders.length,
                  itemBuilder: (context, index) {
                    return _buildProviderCard(_filteredProviders[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getProviderColor(provider['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    _getProviderIcon(provider['type']),
                    color: _getProviderColor(provider['type']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getProviderColor(provider['type']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              provider['type'],
                              style: TextStyle(
                                color: _getProviderColor(provider['type']),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(provider['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              provider['status'],
                              style: TextStyle(
                                color: _getStatusColor(provider['status']),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(provider['rating'].toString()),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Joined ${provider['joinDate']}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Key Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProviderMetric('Users Served', provider['totalUsers'].toString(), Icons.people, Colors.blue),
                _buildProviderMetric('Services Done', provider['completedServices'].toString(), Icons.assignment_turned_in, Colors.green),
                _buildProviderMetric('Revenue', '\$${provider['revenue']}', Icons.attach_money, Colors.purple),
                _buildProviderMetric('Response Time', provider['responseTime'], Icons.timer, Colors.orange),
              ],
            ),

            const SizedBox(height: 16),

            // Specialization and Coverage
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Specialization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (provider['specialization'] as List<dynamic>).map((spec) {
                          return Chip(
                            label: Text(spec.toString(), style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.blue[50],
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Coverage Areas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (provider['coverage'] as List<dynamic>).map((area) {
                          return Chip(
                            label: Text(area.toString(), style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.green[50],
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.analytics, size: 16),
                    label: const Text('Analytics'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text('Contact'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderMetric(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No providers found'),
          SizedBox(height: 8),
          Text('Try adjusting your filters'),
        ],
      ),
    );
  }

  Color _getProviderColor(String type) {
    switch (type) {
      case 'Tow Provider': return Colors.orange;
      case 'Garage': return Colors.green;
      default: return Colors.blue;
    }
  }

  IconData _getProviderIcon(String type) {
    switch (type) {
      case 'Tow Provider': return Icons.local_shipping;
      case 'Garage': return Icons.garage;
      default: return Icons.business;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Inactive': return Colors.red;
      default: return Colors.grey;
    }
  }
}