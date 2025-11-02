import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Map<String, dynamic> _providerData = {};
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      String userEmail = currentUser.email!;

      DocumentSnapshot profileSnapshot = await _firestore
          .collection('tow')
          .doc(userEmail)
          .collection('profile')
          .doc('provider_details')
          .get();

      if (!profileSnapshot.exists) {
        // If no profile data exists, create default data structure
        setState(() {
          _providerData = _getDefaultProviderData(currentUser);
          _isLoading = false;
        });
        return;
      }

      Map<String, dynamic> firestoreData = profileSnapshot.data() as Map<String, dynamic>;
      
      // Enhance with calculated fields
      setState(() {
        _providerData = _enhanceProviderData(firestoreData, currentUser);
        _isLoading = false;
      });

    } catch (e) {
      print('Error loading provider data: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getDefaultProviderData(User user) {
    return {
      'driverName': user.displayName ?? 'Provider Name',
      'email': user.email ?? 'No email',
      'truckNumber': 'Not assigned',
      'truckType': 'Not specified',
      'location': 'Not specified',
      'status': 'inactive',
      'rating': 0.0,
      'totalJobs': 0,
      'isOnline': false,
      'serviceArea': 'Not specified',
      'phone': 'Not provided',
      'earnings': 0.0,
      'successRate': 0.0,
    };
  }

  Map<String, dynamic> _enhanceProviderData(Map<String, dynamic> data, User user) {
    // Calculate additional fields for display
    double rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
    int totalJobs = (data['totalJobs'] as int?) ?? 0;
    double earnings = (data['earnings'] as num?)?.toDouble() ?? 0.0;
    double successRate = (data['successRate'] as num?)?.toDouble() ?? 
        (totalJobs > 0 ? ((totalJobs - (data['failedJobs'] as int? ?? 0)) / totalJobs * 100) : 0.0);

    return {
      'driverName': data['driverName'] ?? user.displayName ?? 'Provider Name',
      'email': data['email'] ?? user.email ?? 'No email',
      'truckNumber': data['truckNumber'] ?? 'Not assigned',
      'truckType': data['truckType'] ?? 'Not specified',
      'location': data['location'] ?? data['serviceArea'] ?? 'Not specified',
      'status': data['status'] ?? 'inactive',
      'rating': rating,
      'totalJobs': totalJobs,
      'isOnline': data['isOnline'] ?? false,
      'serviceArea': data['serviceArea'] ?? 'Not specified',
      'phone': data['phone'] ?? 'Not provided',
      'earnings': earnings,
      'successRate': successRate,
      'userId': data['userId'] ?? user.uid,
    };
  }

  void _handleLogout() async {
    try {
      await _auth.signOut();
      // Navigate to login screen or handle logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
      // You can add navigation logic here
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleEditProfile() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to edit profile screen'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (_isLoading) {
      return _buildLoadingState(isTablet);
    }

    if (_hasError) {
      return _buildErrorState(isTablet);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          _buildProfileHeader(isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          _buildStatsSection(isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          _buildMenuItems(isTablet),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading Profile...',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 64 : 48,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to load profile',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProviderData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7E57C2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isTablet ? 50 : 40,
            backgroundColor: Color(0xFF7E57C2).withOpacity(0.1),
            child: Icon(Icons.person, size: isTablet ? 40 : 32, color: Color(0xFF7E57C2)),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _providerData['driverName'] ?? 'Provider Name',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _providerData['truckType'] ?? 'Tow Truck Operator',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_shipping, size: 16, color: Color(0xFF7E57C2)),
                    SizedBox(width: 4),
                    Text(
                      'Truck #${_providerData['truckNumber'] ?? 'Not assigned'}',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.phone, size: 16, color: Color(0xFF7E57C2)),
                    SizedBox(width: 4),
                    Text(
                      _providerData['phone'] ?? 'Not provided',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _providerData['status'] == 'active' 
                        ? Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _providerData['status'] == 'active' ? Icons.verified : Icons.pending,
                        color: _providerData['status'] == 'active' ? Color(0xFF4CAF50) : Colors.orange,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _providerData['status'] == 'active' ? 'Verified Provider' : 'Pending Verification',
                        style: TextStyle(
                          color: _providerData['status'] == 'active' ? Color(0xFF4CAF50) : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF7E57C2), size: isTablet ? 28 : 24),
            onPressed: _handleEditProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            _providerData['totalJobs']?.toString() ?? '0', 
            'Total Jobs', 
            Icons.work, 
            isTablet
          ),
          _buildStatItem(
            _providerData['rating']?.toStringAsFixed(1) ?? '0.0', 
            'Rating', 
            Icons.star, 
            isTablet
          ),
          _buildStatItem(
            '\$${_providerData['earnings']?.toStringAsFixed(0) ?? '0'}', 
            'Earnings', 
            Icons.attach_money, 
            isTablet
          ),
          _buildStatItem(
            '${_providerData['successRate']?.toStringAsFixed(0) ?? '0'}%', 
            'Success', 
            Icons.check_circle, 
            isTablet
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, bool isTablet) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 12 : 8),
          decoration: BoxDecoration(
            color: Color(0xFF7E57C2).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF7E57C2), size: isTablet ? 20 : 16),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(bool isTablet) {
    final menuItems = [
      _MenuItem(Icons.work, 'Job History', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.attach_money, 'Earnings & Reports', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.business, 'Service Areas', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.local_shipping, 'Vehicle Details', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.notifications, 'Notifications', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.help, 'Help & Support', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.security, 'Privacy & Security', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.settings, 'Settings', Icons.chevron_right, onTap: () {}),
      _MenuItem(Icons.logout, 'Logout', Icons.chevron_right, 
          isLogout: true, onTap: _handleLogout),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: menuItems.map((item) => _buildMenuTile(item, isTablet)).toList(),
      ),
    );
  }

  Widget _buildMenuTile(_MenuItem item, bool isTablet) {
    return ListTile(
      leading: Container(
        width: isTablet ? 48 : 40,
        height: isTablet ? 48 : 40,
        decoration: BoxDecoration(
          color: item.isLogout ? Color(0xFFF44336).withOpacity(0.1) : 
                 Color(0xFF7E57C2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        ),
        child: Icon(
          item.icon,
          color: item.isLogout ? Color(0xFFF44336) : Color(0xFF7E57C2),
          size: isTablet ? 20 : 18,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: item.isLogout ? Color(0xFFF44336) : Color(0xFF333333),
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 18 : 16,
        ),
      ),
      trailing: Icon(
        item.trailingIcon,
        color: item.isLogout ? Color(0xFFF44336) : Color(0xFF666666),
        size: isTablet ? 24 : 20,
      ),
      onTap: item.onTap,
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final IconData trailingIcon;
  final bool isLogout;
  final VoidCallback onTap;

  _MenuItem(this.icon, this.title, this.trailingIcon, {
    this.isLogout = false,
    required this.onTap,
  });
}