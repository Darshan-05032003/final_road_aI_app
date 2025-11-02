import 'package:smart_road_app/ToeProvider/homescreen.dart';
import 'package:smart_road_app/ToeProvider/jobscreen.dart';
import 'package:smart_road_app/ToeProvider/profilescreen.dart';
import 'package:smart_road_app/ToeProvider/requestScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TowProviderApp extends StatelessWidget {
  const TowProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TowAssist Pro - Provider',
      theme: ThemeData(
        primaryColor: const Color(0xFF7E57C2),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        fontFamily: 'Inter',
      ),
      home: const MainDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic> _providerData = {};
  bool _isLoading = true;
  int _badgeCount = 0;

  final List<Widget> _screens = [
    const ProviderHomeScreen(),
    const IncomingRequestsScreen(),
    const ActiveJobsScreen(),
    const ProviderProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProviderData();
    _loadBadgeCount();
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
        setState(() {
          _providerData = _getDefaultProviderData(currentUser);
          _isLoading = false;
        });
        return;
      }

      Map<String, dynamic> firestoreData =
          profileSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _providerData = _enhanceProviderData(firestoreData, currentUser);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading provider data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBadgeCount() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Query for pending requests to show badge count
        QuerySnapshot pendingRequests = await _firestore
            .collection('tow_requests')
            .where('providerEmail', isEqualTo: currentUser.email)
            .where('status', isEqualTo: 'pending')
            .get();

        setState(() {
          _badgeCount = pendingRequests.docs.length;
        });
      }
    } catch (e) {
      print('Error loading badge count: $e');
    }
  }

  Map<String, dynamic> _getDefaultProviderData(User user) {
    return {
      'driverName': user.displayName ?? 'Provider',
      'email': user.email ?? 'No email',
      'truckNumber': 'Not assigned',
      'truckType': 'Tow Truck Operator',
      'status': 'active',
      'rating': 4.8,
      'totalJobs': 0,
      'totalEarnings': 0.0,
      'successRate': 0.0,
    };
  }

  Map<String, dynamic> _enhanceProviderData(
    Map<String, dynamic> data,
    User user,
  ) {
    double rating = (data['rating'] as num?)?.toDouble() ?? 4.8;
    int totalJobs = (data['totalJobs'] as int?) ?? 0;
    double totalEarnings = (data['totalEarnings'] as num?)?.toDouble() ?? 0.0;
    double successRate = (data['successRate'] as num?)?.toDouble() ?? 0.0;

    return {
      'driverName': data['driverName'] ?? user.displayName ?? 'Provider',
      'email': data['email'] ?? user.email ?? 'No email',
      'truckNumber': data['truckNumber'] ?? 'Not assigned',
      'truckType': data['truckType'] ?? 'Tow Truck Operator',
      'status': data['status'] ?? 'active',
      'rating': rating,
      'totalJobs': totalJobs,
      'totalEarnings': totalEarnings,
      'successRate': successRate,
      'phone': data['phone'] ?? 'Not provided',
      'location': data['location'] ?? data['serviceArea'] ?? 'Not specified',
      'userId': data['userId'] ?? user.uid,
    };
  }

  void _handleLogout() async {
    try {
      await _auth.signOut();
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(screenWidth),
      drawer: _buildDrawer(screenWidth),
      body: _isLoading
          ? _buildLoadingState(screenWidth)
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_currentIndex],
            ),
      bottomNavigationBar: _buildBottomNavBar(screenWidth),
    );
  }

  Widget _buildLoadingState(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Dashboard...',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth > 600 ? screenWidth * 0.6 : screenWidth * 0.8,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth > 600 ? 30 : 25,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _providerData['driverName'] ?? 'Provider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth > 600 ? 20 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _providerData['truckType'] ??
                                  'Tow Truck Operator',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: screenWidth > 600 ? 14 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${_providerData['rating']?.toStringAsFixed(1) ?? '0.0'} Rating',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth > 600 ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FF),
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDrawerStat(
                    _providerData['totalJobs']?.toString() ?? '0',
                    'Jobs',
                    screenWidth,
                  ),
                  _buildDrawerStat(
                    '\$${_providerData['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                    'Earned',
                    screenWidth,
                  ),
                  _buildDrawerStat(
                    '${_providerData['successRate']?.toStringAsFixed(0) ?? '0'}%',
                    'Success',
                    screenWidth,
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerSection('WORK MANAGEMENT', [
                      _buildDrawerItem(
                        icon: Icons.dashboard,
                        title: 'Dashboard',
                        onTap: () {
                          setState(() => _currentIndex = 0);
                          Navigator.pop(context);
                        },
                        isSelected: _currentIndex == 0,
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.request_quote,
                        title: 'Incoming Requests',
                        badgeCount: _badgeCount,
                        onTap: () {
                          setState(() => _currentIndex = 1);
                          Navigator.pop(context);
                        },
                        isSelected: _currentIndex == 1,
                        screenWidth: screenWidth,
                      ),
                      _buildDrawerItem(
                        icon: Icons.work,
                        title: 'Active Jobs',
                        onTap: () {
                          setState(() => _currentIndex = 2);
                          Navigator.pop(context);
                        },
                        isSelected: _currentIndex == 2,
                        screenWidth: screenWidth,
                      ),

                      _buildDrawerItem(
                        icon: Icons.settings,
                        title: 'App Settings',
                        onTap: () {
                          _showAppSettings(context);
                        },
                        screenWidth: screenWidth,
                      ),

                      _buildDrawerItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        isLogout: true,
                        onTap: () {
                          _showLogoutConfirmation(context);
                        },
                        screenWidth: screenWidth,
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Text(
                    'TowAssist Pro v1.0.0',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provider Mode',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isLogout = false,
    int? badgeCount,
    required double screenWidth,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: screenWidth > 600 ? 44 : 36,
          height: screenWidth > 600 ? 44 : 36,
          decoration: BoxDecoration(
            color: isLogout
                ? const Color(0xFFF44336).withOpacity(0.1)
                : isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout
                ? const Color(0xFFF44336)
                : isSelected
                ? Colors.white
                : Theme.of(context).primaryColor,
            size: screenWidth > 600 ? 20 : 18,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? const Color(0xFFF44336) : const Color(0xFF333333),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: screenWidth > 600 ? 16 : 14,
          ),
        ),
        trailing: badgeCount != null && badgeCount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF44336),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Icon(
                Icons.chevron_right,
                color: isLogout ? const Color(0xFFF44336) : Colors.grey[600],
                size: screenWidth > 600 ? 20 : 18,
              ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildDrawerStat(String value, String label, double screenWidth) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: screenWidth > 600 ? 12 : 10,
          ),
        ),
      ],
    );
  }

  // Drawer Navigation Methods
  void _showJobHistory(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.history, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Job History'),
          ],
        ),
        content: const Text(
          'Job history feature will be implemented in the next update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEarningsReport(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Earnings Report',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildEarningsOverview(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildEarningItem('Today', '\$165.00', '3 jobs'),
                  _buildEarningItem('This Week', '\$845.00', '15 jobs'),
                  _buildEarningItem(
                    'This Month',
                    '\$${_providerData['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                    '${_providerData['totalJobs'] ?? '0'} jobs',
                  ),
                  _buildEarningItem(
                    'Total',
                    '\$${_providerData['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                    '${_providerData['totalJobs'] ?? '0'} jobs',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '\$${_providerData['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_providerData['totalJobs'] ?? '0'} completed jobs',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningItem(String period, String amount, String jobs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                period,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                jobs,
                style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    Navigator.pop(context);
    // Implementation for payment methods
  }

  void _showRevenueAnalytics(BuildContext context) {
    Navigator.pop(context);
    // Implementation for revenue analytics
  }

  void _showMyVehicles(BuildContext context) {
    Navigator.pop(context);
    // Implementation for my vehicles
  }

  void _showServiceAreas(BuildContext context) {
    Navigator.pop(context);
    // Implementation for service areas
  }

  void _showWorkingHours(BuildContext context) {
    Navigator.pop(context);
    // Implementation for working hours
  }

  void _showPricingRates(BuildContext context) {
    Navigator.pop(context);
    // Implementation for pricing rates
  }

  void _showHelpSupport(BuildContext context) {
    Navigator.pop(context);
    // Implementation for help & support
  }

  void _showContactAdmin(BuildContext context) {
    Navigator.pop(context);
    // Implementation for contact admin
  }

  void _showReportIssue(BuildContext context) {
    Navigator.pop(context);
    // Implementation for report issue
  }

  void _showAppSettings(BuildContext context) {
    Navigator.pop(context);
    // Implementation for app settings
  }

  void _showPrivacySecurity(BuildContext context) {
    Navigator.pop(context);
    // Implementation for privacy & security
  }

  void _showLogoutConfirmation(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.logout, color: Color(0xFFF44336)),
            const SizedBox(width: 8),
            const Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_shipping,
              color: Theme.of(context).primaryColor,
              size: screenWidth > 600 ? 28 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'TowAssist Pro',
            style: TextStyle(
              color: const Color(0xFF333333),
              fontWeight: FontWeight.w700,
              fontSize: screenWidth > 600 ? 22 : 18,
            ),
          ),
        ],
      ),
      // actions: [
      //   _buildAppBarAction(Icons.notifications_none, screenWidth),
      //   _buildAppBarAction(Icons.history, screenWidth),
      //   if (screenWidth > 600) _buildAppBarAction(Icons.support_agent, screenWidth),
      // ],
    );
  }

  Widget _buildAppBarAction(IconData icon, double screenWidth) {
    return IconButton(
      icon: Icon(
        icon,
        color: const Color(0xFF666666),
        size: screenWidth > 600 ? 28 : 24,
      ),
      onPressed: () {},
    );
  }

  Widget _buildBottomNavBar(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: const Color(0xFF999999),
          selectedLabelStyle: TextStyle(
            fontSize: screenWidth > 600 ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: screenWidth > 600 ? 14 : 12,
          ),
          iconSize: screenWidth > 600 ? 28 : 24,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: _badgeCount > 0
                  ? Badge(
                      label: Text(_badgeCount.toString()),
                      child: const Icon(Icons.request_quote_outlined),
                    )
                  : const Icon(Icons.request_quote_outlined),
              activeIcon: _badgeCount > 0
                  ? Badge(
                      label: Text(_badgeCount.toString()),
                      child: const Icon(Icons.request_quote),
                    )
                  : const Icon(Icons.request_quote),
              label: 'Requests',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Jobs',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
