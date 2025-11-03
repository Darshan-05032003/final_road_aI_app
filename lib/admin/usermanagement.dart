// usermanagement.dart
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  int _selectedTab = 0;
  String _selectedFilter = 'All Status';
  String _searchQuery = '';
  final List<String> _tabs = ['All Users', 'Pending Approval', 'Vehicle Owners', 'Tow Providers', 'Mechanics'];
  
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '+1 234 567 8900',
      'type': 'Vehicle Owner',
      'status': 'Pending',
      'registrationDate': '2024-01-15',
      'region': 'New York',
      'avatarColor': Colors.blue,
      'documents': ['ID Card', 'Driving License'],
    },
    {
      'id': '2',
      'name': 'Sarah Wilson',
      'email': 'sarah.w@email.com',
      'phone': '+1 234 567 8901',
      'type': 'Tow Provider',
      'status': 'Active',
      'registrationDate': '2024-01-10',
      'region': 'California',
      'avatarColor': Colors.green,
      'documents': ['Business License', 'Insurance'],
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    List<Map<String, dynamic>> filtered = List.from(_users);
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) =>
        user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        user['phone'].toString().contains(_searchQuery)
      ).toList();
    }
    
    if (_selectedFilter != 'All Status') {
      filtered = filtered.where((user) => user['status'] == _selectedFilter).toList();
    }
    
    if (_selectedTab == 1) {
      filtered = filtered.where((user) => user['status'] == 'Pending').toList();
    } else if (_selectedTab == 2) {
      filtered = filtered.where((user) => user['type'] == 'Vehicle Owner').toList();
    } else if (_selectedTab == 3) {
      filtered = filtered.where((user) => user['type'] == 'Tow Provider').toList();
    } else if (_selectedTab == 4) {
      filtered = filtered.where((user) => user['type'] == 'Mechanic').toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Stats
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              _buildStatItem('Total Users', _users.length.toString(), Colors.blue),
              _buildStatItem('Pending', _users.where((u) => u['status'] == 'Pending').length.toString(), Colors.orange),
              _buildStatItem('Active', _users.where((u) => u['status'] == 'Active').length.toString(), Colors.green),
              _buildStatItem('Rejected', _users.where((u) => u['status'] == 'Rejected').length.toString(), Colors.red),
            ],
          ),
        ),

        // Filter and Search
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(_selectedFilter),
                      selected: _selectedFilter != 'All Status',
                      onSelected: (selected) {
                        setState(() => _selectedFilter = selected ? _selectedFilter : 'All Status');
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(label: const Text('All Regions'), onSelected: (bool value) {  },),
                    const SizedBox(width: 8),
                    FilterChip(label: const Text('All Time'), onSelected: (bool value) {  },),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tabs
        Container(
          height: 50,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              final count = _getTabCount(index);
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == index ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          color: _selectedTab == index ? Colors.blue : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _selectedTab == index ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: _selectedTab == index ? Colors.white : Colors.grey[700],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // User List
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(_filteredUsers[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user['avatarColor'].withOpacity(0.2),
          child: Icon(Icons.person, color: user['avatarColor']),
        ),
        title: Text(user['name']),
        subtitle: Text('${user['type']} • ${user['email']}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(user['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user['status'],
            style: TextStyle(
              color: _getStatusColor(user['status']),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No users found'),
          SizedBox(height: 8),
          Text('Try adjusting your search or filters'),
        ],
      ),
    );
  }

  int _getTabCount(int tabIndex) {
    switch (tabIndex) {
      case 1: return _users.where((u) => u['status'] == 'Pending').length;
      case 2: return _users.where((u) => u['type'] == 'Vehicle Owner').length;
      case 3: return _users.where((u) => u['type'] == 'Tow Provider').length;
      case 4: return _users.where((u) => u['type'] == 'Mechanic').length;
      default: return 0;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}