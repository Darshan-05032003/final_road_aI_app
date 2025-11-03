import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:smart_road_app/admin/services/admin_data_service.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';
import 'package:smart_road_app/widgets/enhanced_card.dart';
import 'package:smart_road_app/widgets/enhanced_button.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AdminDataService _dataService = AdminDataService();
  final TextEditingController _searchController = TextEditingController();
  
  int _selectedTab = 0;
  String _selectedFilter = 'All Status';
  String _searchQuery = '';
  bool _isLoading = true;
  
  List<Map<String, dynamic>> _allUsers = [];
  Map<String, int> _usersCount = {};
  
  final List<String> _tabs = ['All Users', 'Vehicle Owners', 'Garages', 'Tow Providers', 'Insurance'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    
    try {
      final users = await _dataService.getAllUsers();
      final counts = await _dataService.getUsersCount();
      
      if (mounted) {
        setState(() {
          _allUsers = users;
          _usersCount = counts;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading users: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    List<Map<String, dynamic>> filtered = List.from(_allUsers);
    
    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final name = (user['name'] ?? '').toString().toLowerCase();
        final email = (user['email'] ?? '').toString().toLowerCase();
        final phone = (user['phone'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query) || phone.contains(query);
      }).toList();
    }
    
    // Status filter
    if (_selectedFilter != 'All Status') {
      filtered = filtered.where((user) => user['status'] == _selectedFilter).toList();
    }
    
    // Type filter
    if (_selectedTab == 1) {
      filtered = filtered.where((user) => user['type'] == 'Vehicle Owner').toList();
    } else if (_selectedTab == 2) {
      filtered = filtered.where((user) => user['type'] == 'Garage').toList();
    } else if (_selectedTab == 3) {
      filtered = filtered.where((user) => user['type'] == 'Tow Provider').toList();
    } else if (_selectedTab == 4) {
      filtered = filtered.where((user) => user['type'] == 'Insurance').toList();
    }
    
    return filtered;
  }

  int _getTabCount(int index) {
    switch (index) {
      case 0:
        return _allUsers.length;
      case 1:
        return _usersCount['vehicleOwners'] ?? 0;
      case 2:
        return _usersCount['garages'] ?? 0;
      case 3:
        return _usersCount['towProviders'] ?? 0;
      case 4:
        return _usersCount['insurance'] ?? 0;
      default:
        return 0;
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
        // Header with Stats
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
                children: [
                  _buildStatItem('Total', '${_usersCount['total'] ?? 0}', Colors.white),
                  _buildStatItem('Owners', '${_usersCount['vehicleOwners'] ?? 0}', Colors.white),
                  _buildStatItem('Garages', '${_usersCount['garages'] ?? 0}', Colors.white),
                  _buildStatItem('Providers', '${_usersCount['towProviders'] ?? 0}', Colors.white),
                  _buildStatItem('Insurance', '${_usersCount['insurance'] ?? 0}', Colors.white),
                ],
              ),
            ),
          ),
        ),

        // Search and Filter
        AppAnimations.fadeIn(
          delay: 50,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email, or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All Status'),
                        selected: _selectedFilter == 'All Status',
                        onSelected: (selected) {
                          setState(() => _selectedFilter = selected ? 'All Status' : 'All Status');
                        },
                        selectedColor: AppTheme.primaryPurple.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Active'),
                        selected: _selectedFilter == 'Active',
                        onSelected: (selected) {
                          setState(() => _selectedFilter = selected ? 'Active' : 'All Status');
                        },
                        selectedColor: AppTheme.completedColor.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.completedColor,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Pending'),
                        selected: _selectedFilter == 'Pending',
                        onSelected: (selected) {
                          setState(() => _selectedFilter = selected ? 'Pending' : 'All Status');
                        },
                        selectedColor: AppTheme.pendingColor.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.pendingColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tabs
        AppAnimations.fadeIn(
          delay: 100,
          child: Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final count = _getTabCount(index);
                return AppAnimations.fadeIn(
                  delay: index * 30,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == index ? AppTheme.primaryPurple : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _tabs[index],
                            style: TextStyle(
                              color: _selectedTab == index ? AppTheme.primaryPurple : Colors.grey[600],
                              fontWeight: _selectedTab == index ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          if (count > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _selectedTab == index
                                    ? AppTheme.primaryPurple
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  color: _selectedTab == index ? Colors.white : Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // User List
        Expanded(
          child: _filteredUsers.isEmpty
              ? AppAnimations.fadeIn(
                  child: _buildEmptyState(),
                )
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  color: AppTheme.primaryPurple,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      return AppAnimations.fadeIn(
                        delay: index * 30,
                        child: _buildUserCard(_filteredUsers[index]),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color textColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final color = user['avatarColor'] as Color? ?? AppTheme.primaryPurple;
    final timestamp = user['registrationDate'] as Timestamp?;
    final regDate = timestamp != null 
        ? DateFormat('MMM dd, yyyy').format(timestamp.toDate())
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: EnhancedCard(
        onTap: () => _showUserDetails(user),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (user['name'] ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user['name'] ?? 'Unknown',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusTag(status: user['status'] ?? 'Active'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user['email'] ?? 'N/A',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        user['phone'] ?? 'N/A',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        regDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      user['type'] ?? 'User',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () => _showUserDetails(user),
            ),
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
              Icons.people_outline,
              size: 64,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No users found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search query'
                : 'Users will appear here once registered',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
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
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (user['avatarColor'] as Color? ?? AppTheme.primaryPurple),
                          (user['avatarColor'] as Color? ?? AppTheme.primaryPurple)
                              .withValues(alpha: 0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (user['name'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? 'Unknown',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['type'] ?? 'User',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusTag(status: user['status'] ?? 'Active'),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Email', user['email'] ?? 'N/A', Icons.email),
              _buildDetailRow('Phone', user['phone'] ?? 'N/A', Icons.phone),
              _buildDetailRow('Registration Date', regDate, Icons.calendar_today),
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

  String get regDate {
    // This will be calculated per user in the card
    return 'N/A';
  }
}