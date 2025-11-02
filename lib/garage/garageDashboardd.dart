// import 'package:smart_road_app/garage/notification.dart';
// import 'package:smart_road_app/garage/salesreports.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // Import your screens (make sure these files exist)
// import 'package:smart_road_app/garage/booking.dart';
// import 'package:smart_road_app/garage/serviceRequest.dart';
// import 'package:smart_road_app/garage/spareParts.dart';
// import 'package:smart_road_app/garage/inventory.dart';
// import 'package:smart_road_app/garage/profile.dart';

// // Mock AuthService since it wasn't provided
// class AuthService {
//   static Future<String?> getUserEmail() async {
//     return FirebaseAuth.instance.currentUser?.email;
//   }

//   static Future<void> signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       // Navigate to login screen or home screen after sign out
//       // Navigator.pushAndRemoveUntil(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => LoginScreen()),
//       //   (route) => false,
//       // );
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }
// }

// class GarageDashboard extends StatefulWidget {
//   const GarageDashboard({super.key});

//   @override
//   _GarageDashboardState createState() => _GarageDashboardState();
// }

// class _GarageDashboardState extends State<GarageDashboard> {
//   int _currentIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _userEmail;

//   // Dashboard statistics
//   int totalParts = 0;
//   int pendingBookings = 0;
//   int confirmedOrders = 0;
//   int outOfStock = 0;
//   bool _isLoading = true;

//   final List<Widget> _screens = [
//     const GarageHomeScreen(),
//     const SparePartsScreen(),
//     const BookingsScreen(),
//     const InventoryScreen(),
//     const ServiceRequestsScreen(),
//   ];

//   final List<String> _screenTitles = [
//     'Dashboard',
//     'Spare Parts',
//     'Bookings',
//     'Inventory',
//     'Garage Request',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await _loadUserData();
//     await _loadDashboardData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       setState(() {
//         _userEmail = userEmail;
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//       setState(() {
//         _userEmail = _auth.currentUser?.email;
//       });
//     }
//   }

//   Future<void> _loadDashboardData() async {
//     try {
//       if (_userEmail == null) {
//         await _loadUserData();
//         if (_userEmail == null) {
//           _loadLocalData();
//           return;
//         }
//       }

//       print('Loading dashboard data for user: $_userEmail');

//       // Get spare parts count
//       final partsSnapshot = await _firestore
//           .collection('garage')
//           .doc(_userEmail)
//           .collection('spareparts')
//           .get();

//       // Get bookings count by status
//       final bookingsSnapshot = await _firestore
//           .collection('garage')
//           .doc(_userEmail)
//           .collection('shop')
//           .get();

//       // Calculate statistics
//       int totalPartsCount = partsSnapshot.docs.length;

//       int pendingBookingsCount = bookingsSnapshot.docs
//           .where((doc) => (doc.data()['status'] as String?) == 'Pending')
//           .length;

//       int confirmedOrdersCount = bookingsSnapshot.docs.where((doc) {
//         String? status = doc.data()['status'] as String?;
//         return status == 'Confirmed' || status == 'Dispatched';
//       }).length;

//       int outOfStockCount = partsSnapshot.docs
//           .where((doc) => (doc.data()['stock'] as num?)?.toInt() == 0)
//           .length;

//       setState(() {
//         totalParts = totalPartsCount;
//         pendingBookings = pendingBookingsCount;
//         confirmedOrders = confirmedOrdersCount;
//         outOfStock = outOfStockCount;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading dashboard data: $e');
//       _loadLocalData();
//     }
//   }

//   void _loadLocalData() {
//     setState(() {
//       totalParts = 156;
//       pendingBookings = 12;
//       confirmedOrders = 8;
//       outOfStock = 5;
//       _isLoading = false;
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   void _navigateToServiceRequest() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ServiceRequestsScreen()),
//     );
//   }

//   void _navigateToProfile() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ProfilePage()),
//     );
//   }

//   void _navigateToSalesReports() {
//     // Navigate to Sales Reports screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SalesReportsScreen()),
//     );
//   }

//   void _navigateToDocuments() {
//     // Navigate to Documents screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const DocumentsScreen()),
//     );
//   }

//   void _navigateToSettings() {
//     // Navigate to Settings screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SettingsScreen()),
//     );
//   }

//   void _navigateToHelpSupport() {
//     // Navigate to Help & Support screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
//     );
//   }

//   void _handleLogout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 AuthService.signOut(context);
//               },
//               child: const Text('Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: _isLoading ? _buildLoadingState() : _screens[_currentIndex],
//       bottomNavigationBar: _buildBottomNavBar(),
//       drawer: _buildDrawer(),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(color: Color(0xFF2563EB)),
//           const SizedBox(height: 16),
//           Text(
//             'Loading dashboard...',
//             style: TextStyle(color: Colors.grey[600], fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       leading: IconButton(
//         icon: const Icon(Icons.menu, color: Color(0xFF2563EB)),
//         onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//       ),
//       title: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2563EB).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.build_circle, color: Color(0xFF2563EB)),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             _screenTitles[_currentIndex],
//             style: const TextStyle(
//               color: Color(0xFF1E293B),
//               fontWeight: FontWeight.w700,
//               fontSize: 20,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: Badge(
//             label: Text(pendingBookings.toString()),
//             backgroundColor: const Color(0xFFEF4444),
//             child: const Icon(
//               Icons.notifications_none,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NotificationsScreen(),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             // Header
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.only(
//                 top: 60,
//                 bottom: 20,
//                 left: 20,
//                 right: 20,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: const Icon(
//                       Icons.build_circle,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'AutoCare Garage',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Premium Automotive Services',
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'Online',
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Menu Items
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
//                   _buildDrawerItem(Icons.inventory_2, 'Spare Parts', 1),
//                   _buildDrawerItem(
//                     Icons.book_online,
//                     'Bookings',
//                     2,
//                     badgeCount: pendingBookings,
//                   ),
//                   _buildDrawerItem(Icons.warehouse, 'Inventory', 3),
//                   _buildDrawerItem(
//                     Icons.build_circle,
//                     'Garage Request',
//                     -1,
//                     onTap: _navigateToServiceRequest,
//                   ),
//                   _buildDrawerItem(
//                     Icons.person,
//                     'Profile',
//                     -1,
//                     onTap: _navigateToProfile,
//                   ),
//                   _buildDrawerItem(
//                     Icons.analytics,
//                     'Sales Reports',
//                     -1,
//                     onTap: _navigateToSalesReports,
//                   ),
//                   _buildDrawerItem(
//                     Icons.document_scanner,
//                     'Documents',
//                     -1,
//                     onTap: _navigateToDocuments,
//                   ),
//                   _buildDrawerItem(
//                     Icons.settings,
//                     'Settings',
//                     -1,
//                     onTap: _navigateToSettings,
//                   ),
//                   _buildDrawerItem(
//                     Icons.help,
//                     'Help & Support',
//                     -1,
//                     onTap: _navigateToHelpSupport,
//                   ),

//                   // Divider
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 10,
//                     ),
//                     child: Divider(color: const Color(0xFFE2E8F0)),
//                   ),

//                   _buildDrawerItem(
//                     Icons.logout,
//                     'Logout',
//                     -1,
//                     isLogout: true,
//                     onTap: _handleLogout,
//                   ),
//                 ],
//               ),
//             ),

//             // Footer
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: const Column(
//                 children: [
//                   Text(
//                     'Garage Pro v1.0.0',
//                     style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '© 2024 AutoCare Services',
//                     style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     IconData icon,
//     String title,
//     int index, {
//     int badgeCount = 0,
//     bool isLogout = false,
//     VoidCallback? onTap,
//   }) {
//     bool isSelected = _currentIndex == index;
//     Color itemColor = isLogout
//         ? const Color(0xFFEF4444)
//         : const Color(0xFF1E293B);

//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFF2563EB).withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//           border: isSelected
//               ? Border.all(color: const Color(0xFF2563EB).withOpacity(0.3))
//               : null,
//         ),
//         child: Icon(
//           icon,
//           color: isSelected ? const Color(0xFF2563EB) : itemColor,
//           size: 20,
//         ),
//       ),
//       title: Row(
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: isSelected ? const Color(0xFF2563EB) : itemColor,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//           if (badgeCount > 0) ...[
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEF4444),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 badgeCount.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//       trailing: isSelected
//           ? const Icon(Icons.check, color: Color(0xFF2563EB), size: 16)
//           : const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 16),
//       onTap:
//           onTap ??
//           () {
//             Navigator.pop(context); // Close drawer
//             if (index >= 0 && index < _screens.length) {
//               _onItemTapped(index);
//             }
//           },
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 15,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: _onItemTapped,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           selectedItemColor: const Color(0xFF2563EB),
//           unselectedItemColor: const Color(0xFF94A3B8),
//           selectedLabelStyle: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//           unselectedLabelStyle: const TextStyle(fontSize: 12),
//           items: [
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard),
//               label: 'Home',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.inventory_2),
//               label: 'Parts',
//             ),
//             BottomNavigationBarItem(
//               icon: Badge(
//                 label: Text(pendingBookings.toString()),
//                 backgroundColor: const Color(0xFFEF4444),
//                 child: const Icon(Icons.book_online),
//               ),
//               label: 'Bookings',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.warehouse),
//               label: 'Inventory',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Garage Request',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GarageHomeScreen extends StatefulWidget {
//   const GarageHomeScreen({super.key});

//   @override
//   _GarageHomeScreenState createState() => _GarageHomeScreenState();
// }

// class _GarageHomeScreenState extends State<GarageHomeScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _userEmail;

//   List<SummaryCard> summaryData = [];
//   bool _isLoading = true;

//   final List<QuickAction> quickActions = [
//     QuickAction('Add New Part', Icons.add, const Color(0xFF2563EB), () {}),
//     QuickAction(
//       'Manage Bookings',
//       Icons.book_online,
//       const Color(0xFF10B981),
//       () {},
//     ),
//     QuickAction(
//       'View Reports',
//       Icons.analytics,
//       const Color(0xFF8B5CF6),
//       () {},
//     ),
//     QuickAction(
//       'Low Stock Alert',
//       Icons.notifications_active,
//       const Color(0xFFF59E0B),
//       () {},
//     ),
//   ];

//   final List<Activity> recentActivities = [
//     Activity(
//       'New booking received for Brake Pads',
//       '10:30 AM',
//       Icons.notifications,
//       const Color(0xFF2563EB),
//     ),
//     Activity(
//       'Stock running low for Air Filters',
//       '09:15 AM',
//       Icons.warning,
//       const Color(0xFFF59E0B),
//     ),
//     Activity(
//       'Order #ORD-123 marked as completed',
//       'Yesterday',
//       Icons.check_circle,
//       const Color(0xFF10B981),
//     ),
//     Activity(
//       'Payment received for Service #456',
//       'Yesterday',
//       Icons.payment,
//       const Color(0xFF8B5CF6),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         _loadLocalData();
//         return;
//       }

//       _userEmail = user.email;

//       // Get spare parts count
//       final partsSnapshot = await _firestore
//           .collection('garage')
//           .doc(_userEmail)
//           .collection('spareparts')
//           .get();

//       // Get bookings count by status
//       final bookingsSnapshot = await _firestore
//           .collection('garage')
//           .doc(_userEmail)
//           .collection('shop')
//           .get();

//       // Calculate statistics
//       int totalPartsCount = partsSnapshot.docs.length;
//       int pendingBookingsCount = bookingsSnapshot.docs
//           .where((doc) => (doc.data()['status'] as String?) == 'Pending')
//           .length;
//       int confirmedOrdersCount = bookingsSnapshot.docs.where((doc) {
//         String? status = doc.data()['status'] as String?;
//         return status == 'Confirmed' || status == 'Dispatched';
//       }).length;
//       int outOfStockCount = partsSnapshot.docs
//           .where((doc) => (doc.data()['stock'] as num?)?.toInt() == 0)
//           .length;

//       setState(() {
//         summaryData = [
//           SummaryCard(
//             'Total Parts',
//             totalPartsCount.toString(),
//             Icons.inventory_2,
//             const Color(0xFF2563EB),
//           ),
//           SummaryCard(
//             'Pending Bookings',
//             pendingBookingsCount.toString(),
//             Icons.pending_actions,
//             const Color(0xFFF59E0B),
//           ),
//           SummaryCard(
//             'Confirmed Orders',
//             confirmedOrdersCount.toString(),
//             Icons.assignment_turned_in,
//             const Color(0xFF10B981),
//           ),
//           SummaryCard(
//             'Out of Stock',
//             outOfStockCount.toString(),
//             Icons.warning,
//             const Color(0xFFEF4444),
//           ),
//         ];
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading home screen data: $e');
//       _loadLocalData();
//     }
//   }

//   void _loadLocalData() {
//     setState(() {
//       summaryData = [
//         SummaryCard(
//           'Total Parts',
//           '156',
//           Icons.inventory_2,
//           const Color(0xFF2563EB),
//         ),
//         SummaryCard(
//           'Pending Bookings',
//           '12',
//           Icons.pending_actions,
//           const Color(0xFFF59E0B),
//         ),
//         SummaryCard(
//           'Confirmed Orders',
//           '8',
//           Icons.assignment_turned_in,
//           const Color(0xFF10B981),
//         ),
//         SummaryCard(
//           'Out of Stock',
//           '5',
//           Icons.warning,
//           const Color(0xFFEF4444),
//         ),
//       ];
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? _buildLoadingState()
//         : SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildWelcomeCard(),
//                 const SizedBox(height: 24),
//                 _buildSummaryGrid(),
//                 const SizedBox(height: 24),
//                 _buildQuickActions(),
//                 const SizedBox(height: 24),
//                 _buildRecentActivity(),
//               ],
//             ),
//           );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(color: Color(0xFF2563EB)),
//           const SizedBox(height: 16),
//           Text(
//             'Loading dashboard...',
//             style: TextStyle(color: Colors.grey[600], fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2563EB).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.white.withOpacity(0.2),
//             child: const Icon(
//               Icons.build_circle,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Welcome, AutoCare Garage!',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Ready to manage your spare parts business?',
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${summaryData.isNotEmpty ? summaryData[1].value : '0'} Pending Bookings',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.verified, color: Colors.white, size: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.2,
//       ),
//       itemCount: summaryData.length,
//       itemBuilder: (context, index) {
//         return _buildSummaryCard(summaryData[index]);
//       },
//     );
//   }

//   Widget _buildSummaryCard(SummaryCard data) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: data.color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(data.icon, color: data.color, size: 20),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.value,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   data.title,
//                   style: const TextStyle(
//                     color: Color(0xFF64748B),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1E293B),
//           ),
//         ),
//         const SizedBox(height: 16),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.4,
//           ),
//           itemCount: quickActions.length,
//           itemBuilder: (context, index) {
//             return _buildQuickActionCard(quickActions[index]);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionCard(QuickAction action) {
//     return GestureDetector(
//       onTap: action.onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: action.color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(action.icon, color: action.color, size: 24),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 action.title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                   fontSize: 14,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Recent Activity',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const NotificationsScreen(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 'View All',
//                 style: TextStyle(
//                   color: Color(0xFF2563EB),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         ...recentActivities.map((activity) => _buildActivityItem(activity)),
//       ],
//     );
//   }

//   Widget _buildActivityItem(Activity activity) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: activity.color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(activity.icon, color: activity.color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   activity.title,
//                   style: const TextStyle(
//                     color: Color(0xFF1E293B),
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   activity.time,
//                   style: const TextStyle(
//                     color: Color(0xFF64748B),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Data Models for Dashboard
// class SummaryCard {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const SummaryCard(this.title, this.value, this.icon, this.color);
// }

// class QuickAction {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const QuickAction(this.title, this.icon, this.color, this.onTap);
// }

// class Activity {
//   final String title;
//   final String time;
//   final IconData icon;
//   final Color color;

//   const Activity(this.title, this.time, this.icon, this.color);
// }

// class DocumentsScreen extends StatelessWidget {
//   const DocumentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Documents')),
//       body: const Center(child: Text('Documents Screen')),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: const Center(child: Text('Settings Screen')),
//     );
//   }
// }

// class HelpSupportScreen extends StatelessWidget {
//   const HelpSupportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Help & Support')),
//       body: const Center(child: Text('Help & Support Screen')),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';
import 'package:smart_road_app/core/language/language_selector.dart';
import 'package:smart_road_app/garage/notification.dart';
import 'package:smart_road_app/garage/salesreports.dart';
import 'package:smart_road_app/garage/booking.dart';
import 'package:smart_road_app/garage/serviceRequest.dart';
import 'package:smart_road_app/garage/spareParts.dart';
import 'package:smart_road_app/garage/inventory.dart';
import 'package:smart_road_app/garage/profile.dart';
import 'package:smart_road_app/Login/GarageLoginScreen.dart';

class AuthService {
  static Future<String?> getUserEmail() async {
    return FirebaseAuth.instance.currentUser?.email;
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      // Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('garageIsLoggedIn', false);
      await prefs.remove('garageUserEmail');
      
      // Navigate back to login screen
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GarageLoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error signing out: $e');
      // Even if there's an error, try to navigate back to login
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GarageLoginPage()),
          (route) => false,
        );
      }
    }
  }
}

class GarageDashboard extends StatefulWidget {
  const GarageDashboard({super.key});

  @override
  _GarageDashboardState createState() => _GarageDashboardState();
}

class _GarageDashboardState extends State<GarageDashboard> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  
  int totalParts = 0;
  int pendingBookings = 0;
  int confirmedOrders = 0;
  int outOfStock = 0;
  bool _isLoading = true;

  final List<Widget> _screens = [
    const GarageHomeScreen(),
    const SparePartsScreen(),
    const BookingsScreen(),
    const InventoryScreen(),
    const ServiceRequestsScreen(),
  ];

  final List<String> _screenTitles = [
    'Dashboard',
    'Spare Parts',
    'Bookings',
    'Inventory',
    'Garage Request'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _loadDashboardData();
  }

  Future<void> _loadUserData() async {
    try {
      String? userEmail = await AuthService.getUserEmail();
      setState(() {
        _userEmail = userEmail;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _userEmail = _auth.currentUser?.email;
      });
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      if (_userEmail == null) {
        await _loadUserData();
        if (_userEmail == null) {
          _loadLocalData();
          return;
        }
      }

      final partsSnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail)
          .collection('spareparts')
          .get();

      final bookingsSnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail)
          .collection('shop')
          .get();

      int totalPartsCount = partsSnapshot.docs.length;
      
      int pendingBookingsCount = bookingsSnapshot.docs
          .where((doc) => (doc.data()['status'] as String?) == 'Pending')
          .length;
      
      int confirmedOrdersCount = bookingsSnapshot.docs
          .where((doc) {
            String? status = doc.data()['status'] as String?;
            return status == 'Confirmed' || status == 'Dispatched';
          })
          .length;
      
      int outOfStockCount = partsSnapshot.docs
          .where((doc) => (doc.data()['stock'] as num?)?.toInt() == 0)
          .length;

      setState(() {
        totalParts = totalPartsCount;
        pendingBookings = pendingBookingsCount;
        confirmedOrders = confirmedOrdersCount;
        outOfStock = outOfStockCount;
        _isLoading = false;
      });

    } catch (e) {
      print('Error loading dashboard data: $e');
      _loadLocalData();
    }
  }

  void _loadLocalData() {
    setState(() {
      totalParts = 156;
      pendingBookings = 12;
      confirmedOrders = 8;
      outOfStock = 5;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToServiceRequest() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) =>  ServiceRequestsScreen())
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void _navigateToSalesReports() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SalesReportsScreen()),
    );
  }

  void _navigateToDocuments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DocumentsScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToHelpSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
    );
  }

  void _handleLogout() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations?.logout ?? 'Logout'),
          content: Text(localizations?.translate('logout_confirm_message') ?? 'Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AuthService.signOut(context);
              },
              child: Text(localizations?.logout ?? 'Logout', style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(localizations),
      body: _isLoading 
          ? _buildLoadingState(localizations)
          : _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(localizations),
      drawer: _buildDrawer(localizations),
    );
  }

  Widget _buildLoadingState(AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF2563EB)),
          const SizedBox(height: 16),
          Text(
            localizations?.translate('loading') ?? 'Loading dashboard...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations? localizations) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF2563EB)),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.build_circle, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Text(
            _getTranslatedScreenTitle(_currentIndex, localizations),
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Badge(
            label: Text(pendingBookings.toString()),
            backgroundColor: const Color(0xFFEF4444),
            child: const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
          },
        ),
        LanguageSelector(),
      ],
    );
  }

  String _getTranslatedScreenTitle(int index, AppLocalizations? localizations) {
    switch (index) {
      case 0:
        return localizations?.dashboard ?? 'Dashboard';
      case 1:
        return localizations?.translate('spare_parts') ?? 'Spare Parts';
      case 2:
        return localizations?.translate('bookings') ?? 'Bookings';
      case 3:
        return localizations?.translate('inventory') ?? 'Inventory';
      case 4:
        return localizations?.translate('garage_request') ?? 'Garage Request';
      default:
        return _screenTitles[index];
    }
  }

  Widget _buildDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.build_circle, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations?.translate('auto_care_garage') ?? 'AutoCare Garage',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations?.translate('premium_automotive_services') ?? 'Premium Automotive Services',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localizations?.translate('online_status') ?? 'Online',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.dashboard, localizations?.dashboard ?? 'Dashboard', 0, localizations),
                  _buildDrawerItem(Icons.inventory_2, localizations?.translate('spare_parts') ?? 'Spare Parts', 1, localizations),
                  _buildDrawerItem(Icons.book_online, localizations?.translate('bookings') ?? 'Bookings', 2, localizations, badgeCount: pendingBookings),
                  _buildDrawerItem(Icons.warehouse, localizations?.translate('inventory') ?? 'Inventory', 3, localizations),
                  _buildDrawerItem(Icons.build_circle, localizations?.translate('garage_request') ?? 'Garage Request', -1, localizations, onTap: _navigateToServiceRequest),
                  _buildDrawerItem(Icons.person, localizations?.profile ?? 'Profile', -1, localizations, onTap: _navigateToProfile),
                  _buildDrawerItem(Icons.analytics, localizations?.translate('sales_reports') ?? 'Sales Reports', -1, localizations, onTap: _navigateToSalesReports),
                  _buildDrawerItem(Icons.document_scanner, localizations?.translate('documents') ?? 'Documents', -1, localizations, onTap: _navigateToDocuments),
                  _buildDrawerItem(Icons.settings, localizations?.translate('settings') ?? 'Settings', -1, localizations, onTap: _navigateToSettings),
                  _buildDrawerItem(Icons.help, localizations?.translate('help_support') ?? 'Help & Support', -1, localizations, onTap: _navigateToHelpSupport),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(color: const Color(0xFFE2E8F0)),
                  ),
                  
                  _buildDrawerItem(Icons.logout, localizations?.logout ?? 'Logout', -1, localizations, isLogout: true, onTap: _handleLogout),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                children: [
                  Text(
                    'Garage Pro v1.0.0',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2024 AutoCare Services',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
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

  Widget _buildDrawerItem(IconData icon, String title, int index, AppLocalizations? localizations, {int badgeCount = 0, bool isLogout = false, VoidCallback? onTap}) {
    bool isSelected = _currentIndex == index;
    Color itemColor = isLogout ? const Color(0xFFEF4444) : const Color(0xFF1E293B);
    
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: const Color(0xFF2563EB).withOpacity(0.3)) : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF2563EB) : itemColor,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2563EB) : itemColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (badgeCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: isSelected 
          ? const Icon(Icons.check, color: Color(0xFF2563EB), size: 16)
          : const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 16),
      onTap: onTap ?? () {
        Navigator.pop(context);
        if (index >= 0 && index < _screens.length) {
          _onItemTapped(index);
        }
      },
    );
  }

  Widget _buildBottomNavBar(AppLocalizations? localizations) {
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
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: localizations?.dashboard ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory_2),
              label: localizations?.translate('spare_parts') ?? 'Parts',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text(pendingBookings.toString()),
                backgroundColor: const Color(0xFFEF4444),
                child: const Icon(Icons.book_online),
              ),
              label: localizations?.translate('bookings') ?? 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.warehouse),
              label: localizations?.translate('inventory') ?? 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: localizations?.translate('garage_request') ?? 'Garage Request',
            ),
          ],
        ),
      ),
    );
  }
}

class GarageHomeScreen extends StatefulWidget {
  const GarageHomeScreen({super.key});

  @override
  _GarageHomeScreenState createState() => _GarageHomeScreenState();
}

class _GarageHomeScreenState extends State<GarageHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  
  List<SummaryCard> summaryData = [];
  bool _isLoading = true;

  final List<QuickAction> quickActions = [
    QuickAction('Add New Part', Icons.add, const Color(0xFF2563EB), () {}),
    QuickAction('Manage Bookings', Icons.book_online, const Color(0xFF10B981), () {}),
    QuickAction('View Reports', Icons.analytics, const Color(0xFF8B5CF6), () {}),
    QuickAction('Low Stock Alert', Icons.notifications_active, const Color(0xFFF59E0B), () {}),
  ];

  final List<Activity> recentActivities = [
    Activity('New booking received for Brake Pads', '10:30 AM', Icons.notifications, const Color(0xFF2563EB)),
    Activity('Stock running low for Air Filters', '09:15 AM', Icons.warning, const Color(0xFFF59E0B)),
    Activity('Order #ORD-123 marked as completed', 'Yesterday', Icons.check_circle, const Color(0xFF10B981)),
    Activity('Payment received for Service #456', 'Yesterday', Icons.payment, const Color(0xFF8B5CF6)),
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _loadLocalData();
        return;
      }

      _userEmail = user.email;

      final partsSnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail)
          .collection('spareparts')
          .get();

      final bookingsSnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail)
          .collection('shop')
          .get();

      int totalPartsCount = partsSnapshot.docs.length;
      int pendingBookingsCount = bookingsSnapshot.docs
          .where((doc) => (doc.data()['status'] as String?) == 'Pending')
          .length;
      int confirmedOrdersCount = bookingsSnapshot.docs
          .where((doc) {
            String? status = doc.data()['status'] as String?;
            return status == 'Confirmed' || status == 'Dispatched';
          })
          .length;
      int outOfStockCount = partsSnapshot.docs
          .where((doc) => (doc.data()['stock'] as num?)?.toInt() == 0)
          .length;

      setState(() {
        summaryData = [
          SummaryCard('Total Parts', totalPartsCount.toString(), Icons.inventory_2, const Color(0xFF2563EB)),
          SummaryCard('Pending Bookings', pendingBookingsCount.toString(), Icons.pending_actions, const Color(0xFFF59E0B)),
          SummaryCard('Confirmed Orders', confirmedOrdersCount.toString(), Icons.assignment_turned_in, const Color(0xFF10B981)),
          SummaryCard('Out of Stock', outOfStockCount.toString(), Icons.warning, const Color(0xFFEF4444)),
        ];
        _isLoading = false;
      });

    } catch (e) {
      print('Error loading home screen data: $e');
      _loadLocalData();
    }
  }

  void _loadLocalData() {
    setState(() {
      summaryData = [
        SummaryCard('Total Parts', '156', Icons.inventory_2, const Color(0xFF2563EB)),
        SummaryCard('Pending Bookings', '12', Icons.pending_actions, const Color(0xFFF59E0B)),
        SummaryCard('Confirmed Orders', '8', Icons.assignment_turned_in, const Color(0xFF10B981)),
        SummaryCard('Out of Stock', '5', Icons.warning, const Color(0xFFEF4444)),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return _isLoading
        ? _buildLoadingState(localizations)
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(localizations),
                const SizedBox(height: 24),
                _buildSummaryGrid(localizations),
                const SizedBox(height: 24),
                _buildQuickActions(localizations),
                const SizedBox(height: 24),
                _buildRecentActivity(localizations),
              ],
            ),
          );
  }

  Widget _buildLoadingState(AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF2563EB)),
          const SizedBox(height: 16),
          Text(
            localizations?.translate('loading') ?? 'Loading dashboard...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.build_circle, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations?.translate('welcome') ?? 'Welcome'}, ${localizations?.translate('auto_care_garage') ?? 'AutoCare Garage'}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizations?.translate('ready_to_manage_business') ?? 'Ready to manage your spare parts business?',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${summaryData.isNotEmpty ? summaryData[1].value : '0'} ${localizations?.translate('pending_bookings') ?? 'Pending Bookings'}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(AppLocalizations? localizations) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: summaryData.length,
      itemBuilder: (context, index) {
        return _buildSummaryCard(summaryData[index], localizations);
      },
    );
  }

  Widget _buildSummaryCard(SummaryCard data, AppLocalizations? localizations) {
    String translatedTitle = data.title;
    if (data.title == 'Total Parts') {
      translatedTitle = localizations?.translate('total_parts') ?? data.title;
    } else if (data.title == 'Pending Bookings') {
      translatedTitle = localizations?.translate('pending_bookings') ?? data.title;
    } else if (data.title == 'Confirmed Orders') {
      translatedTitle = localizations?.translate('confirmed_orders') ?? data.title;
    } else if (data.title == 'Out of Stock') {
      translatedTitle = localizations?.translate('out_of_stock') ?? data.title;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translatedTitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.translate('quick_actions') ?? 'Quick Actions',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            return _buildQuickActionCard(quickActions[index], localizations);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(QuickAction action, AppLocalizations? localizations) {
    String translatedTitle = action.title;
    if (action.title == 'Add New Part') {
      translatedTitle = localizations?.translate('add_new_part') ?? action.title;
    } else if (action.title == 'Manage Bookings') {
      translatedTitle = localizations?.translate('manage_bookings') ?? action.title;
    } else if (action.title == 'View Reports') {
      translatedTitle = localizations?.translate('view_reports_garage') ?? action.title;
    } else if (action.title == 'Low Stock Alert') {
      translatedTitle = localizations?.translate('low_stock_alert') ?? action.title;
    }

    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: action.color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                translatedTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.translate('recent_activity') ?? 'Recent Activity',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
              },
              child: Text(
                localizations?.translate('view_all') ?? 'View All',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...recentActivities.map((activity) => _buildActivityItem(activity)),
      ],
    );
  }

  Widget _buildActivityItem(Activity activity) {
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
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(activity.icon, color: activity.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.time,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard(this.title, this.value, this.icon, this.color);
}

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickAction(this.title, this.icon, this.color, this.onTap);
}

class Activity {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const Activity(this.title, this.time, this.icon, this.color);
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations?.translate('documents') ?? 'Documents')),
      body: const Center(child: Text('Documents Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations?.translate('settings') ?? 'Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations?.translate('help_support') ?? 'Help & Support')),
      body: const Center(child: Text('Help & Support Screen')),
    );
  }
}