// livemonitoring.dart
import 'package:flutter/material.dart';

class LiveMonitoringPage extends StatefulWidget {
  const LiveMonitoringPage({super.key});

  @override
  State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
}

class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
  String _selectedFilter = 'All';
  final bool _showHeatmap = false;
  final int _selectedService = -1;

  final List<Map<String, dynamic>> _activeServices = [
    {
      'id': '1',
      'type': 'Tow Service',
      'customer': 'John Doe',
      'status': 'On the way',
      'duration': '12 mins ago',
      'location': 'Downtown, Manhattan',
      'provider': 'City Tow Services',
      'eta': '8 min',
      'distance': '2.3 km',
      'priority': 'High',
      'coordinates': {'x': 120, 'y': 180},
      'vehicle': 'Toyota Camry 2020',
      'issue': 'Flat tire',
    },
    {
      'id': '2',
      'type': 'Emergency',
      'customer': 'Sarah Wilson',
      'status': 'SOS Active',
      'duration': '2 mins ago',
      'location': 'Highway I-95',
      'provider': 'Emergency Response',
      'eta': '5 min',
      'distance': '1.2 km',
      'priority': 'Critical',
      'coordinates': {'x': 200, 'y': 250},
      'vehicle': 'Honda Civic 2019',
      'issue': 'Accident - Minor injuries',
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedFilter == 'All') return _activeServices;
    return _activeServices.where((service) => service['type'] == _selectedFilter).toList();
  }

  void _showServiceDetails(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control Panel
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              // Quick Stats
              Row(
                children: [
                  _buildStatItem('Active', '${_activeServices.length}', Colors.blue, Icons.directions_car),
                  _buildStatItem('SOS', '${_activeServices.where((s) => s['type'] == 'Emergency').length}', Colors.red, Icons.warning),
                  _buildStatItem('Completed', '23', Colors.green, Icons.check_circle),
                  _buildStatItem('Avg ETA', '8 min', Colors.orange, Icons.timer),
                ],
              ),
              const SizedBox(height: 12),
              // Controls
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedFilter == 'All',
                          onSelected: (selected) => setState(() => _selectedFilter = 'All'),
                        ),
                        FilterChip(
                          label: const Text('Emergency'),
                          selected: _selectedFilter == 'Emergency',
                          onSelected: (selected) => setState(() => _selectedFilter = 'Emergency'),
                        ),
                        FilterChip(
                          label: const Text('Tow'),
                          selected: _selectedFilter == 'Tow Service',
                          onSelected: (selected) => setState(() => _selectedFilter = 'Tow Service'),
                        ),
                        FilterChip(
                          label: const Text('Mechanic'),
                          selected: _selectedFilter == 'Mechanic',
                          onSelected: (selected) => setState(() => _selectedFilter = 'Mechanic'),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {},
                    tooltip: 'Refresh Map',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Services List
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Services (${_filteredServices.length})', 
                         style: Theme.of(context).textTheme.headlineSmall),
                    Row(
                      children: [
                        Icon(Icons.sort, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('Sort by: ETA', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredServices.isEmpty 
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _filteredServices.length,
                          itemBuilder: (context, index) {
                            return _buildServiceCard(_filteredServices[index], index);
                          },
                        ),
                ),
              ],
            ),
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

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getServiceColor(service['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getServiceColor(service['type']).withOpacity(0.3)),
          ),
          child: Icon(
            _getServiceIcon(service['type']),
            color: _getServiceColor(service['type']),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                service['type'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(service['priority']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                service['priority'],
                style: TextStyle(
                  color: _getPriorityColor(service['priority']),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Customer: ${service['customer']}'),
            Text('Location: ${service['location']}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('ETA: ${service['eta']}', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.phone, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                const Text('Call', style: TextStyle(fontSize: 12, color: Colors.blue)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(service['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                service['status'],
                style: TextStyle(
                  color: _getStatusColor(service['status']),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(service['duration'], style: TextStyle(color: Colors.grey[600], fontSize: 10)),
          ],
        ),
        onTap: () => _showServiceDetails(service),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No Active Services',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'All services are completed or no matches found',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getServiceColor(String type) {
    switch (type) {
      case 'Emergency': return Colors.red;
      case 'Tow Service': return Colors.orange;
      case 'Mechanic': return Colors.green;
      case 'Insurance': return Colors.blue;
      case 'Fuel Delivery': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.green;
      case 'In progress': return Colors.blue;
      case 'On the way': return Colors.orange;
      case 'SOS Active': return Colors.red;
      case 'Pending': return Colors.grey;
      default: return Colors.purple;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.blue;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'Tow Service': return Icons.local_shipping;
      case 'Mechanic': return Icons.handyman;
      case 'Emergency': return Icons.warning;
      case 'Insurance': return Icons.security;
      case 'Fuel Delivery': return Icons.local_gas_station;
      default: return Icons.help;
    }
  }
}

class ServiceDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
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
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getServiceColor(service['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getServiceIcon(service['type']),
                  color: _getServiceColor(service['type']),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service['type'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Service #${service['id']}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(service['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service['status'],
                  style: TextStyle(
                    color: _getStatusColor(service['status']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailRow('Customer', service['customer'], Icons.person),
          _buildDetailRow('Vehicle', service['vehicle'], Icons.directions_car),
          _buildDetailRow('Issue', service['issue'], Icons.info),
          _buildDetailRow('Location', service['location'], Icons.location_on),
          _buildDetailRow('Provider', service['provider'], Icons.business),
          _buildDetailRow('ETA', service['eta'], Icons.timer),
          _buildDetailRow('Distance', service['distance'], Icons.space_dashboard),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: const Text('Call Customer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Color _getServiceColor(String type) {
    switch (type) {
      case 'Emergency': return Colors.red;
      case 'Tow Service': return Colors.orange;
      case 'Mechanic': return Colors.green;
      case 'Insurance': return Colors.blue;
      case 'Fuel Delivery': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.green;
      case 'In progress': return Colors.blue;
      case 'On the way': return Colors.orange;
      case 'SOS Active': return Colors.red;
      case 'Pending': return Colors.grey;
      default: return Colors.purple;
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'Tow Service': return Icons.local_shipping;
      case 'Mechanic': return Icons.handyman;
      case 'Emergency': return Icons.warning;
      case 'Insurance': return Icons.security;
      case 'Fuel Delivery': return Icons.local_gas_station;
      default: return Icons.help;
    }
  }
}