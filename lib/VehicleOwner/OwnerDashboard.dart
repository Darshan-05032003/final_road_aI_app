// // // // import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// // // // import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/History.dart';
// // // // import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
// // // // import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
// // // // import 'package:smart_road_app/VehicleOwner/TowRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/ai.dart';
// // // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';

// // // // // Insurance Module Classes
// // // // class InsuranceModule {
// // // //   static List<Map<String, dynamic>> getInsuranceRequests() {
// // // //     return [
// // // //       {
// // // //         'id': 'INS001',
// // // //         'policyType': 'Comprehensive',
// // // //         'status': 'Active',
// // // //         'expiryDate': '2024-12-31',
// // // //         'vehicleNumber': 'MH12AB1234',
// // // //         'provider': 'ABC Insurance Co.',
// // // //         'premium': '\$450',
// // // //         'startDate': '2024-01-01',
// // // //       },
// // // //       {
// // // //         'id': 'INS002',
// // // //         'policyType': 'Third Party',
// // // //         'status': 'Pending',
// // // //         'expiryDate': '2024-06-30',
// // // //         'vehicleNumber': 'MH12CD5678',
// // // //         'provider': 'XYZ Insurance',
// // // //         'premium': '\$200',
// // // //         'startDate': '2024-01-15',
// // // //       },
// // // //     ];
// // // //   }
// // // // }

// // // // // Main Dashboard Class
// // // // class EnhancedVehicleDashboard extends StatefulWidget {
// // // //   const EnhancedVehicleDashboard({super.key});

// // // //   @override
// // // //   _EnhancedVehicleDashboardState createState() => _EnhancedVehicleDashboardState();
// // // // }

// // // // class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
// // // //     with SingleTickerProviderStateMixin {
// // // //   int _currentIndex = 0;
// // // //   late AnimationController _animationController;
// // // //   late Animation<double> _scaleAnimation;
// // // //   late Animation<double> _fadeAnimation;
// // // //   String? _userEmail;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _animationController = AnimationController(
// // // //       vsync: this,
// // // //       duration: Duration(milliseconds: 800),
// // // //     );
// // // //     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
// // // //       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
// // // //     );
// // // //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// // // //       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
// // // //     );
// // // //     _animationController.forward();
// // // //     _loadUserData();
// // // //   }

// // // //   Future<void> _loadUserData() async {
// // // //     try {
// // // //       String? userEmail = await AuthService.getUserEmail();
// // // //       setState(() {
// // // //         _userEmail = userEmail;
// // // //       });
// // // //       print('✅ Dashboard loaded for user: $_userEmail');
// // // //     } catch (e) {
// // // //       print('❌ Error loading user data in dashboard: $e');
// // // //     }
// // // //   }

// // // //   Map<String, dynamic> get _userData {
// // // //     return {
// // // //       'name': _userEmail?.split('@').first ?? 'User',
// // // //       'email': _userEmail ?? 'user@example.com',
// // // //       'vehicle': 'Toyota Camry 2022',
// // // //       'plan': 'Gold Plan',
// // // //       'memberSince': '2023',
// // // //       'points': 450,
// // // //       'nextService': '2024-02-20',
// // // //       'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901']
// // // //     };
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _animationController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.grey[50],
// // // //       appBar: _buildEnhancedAppBar(),
// // // //       drawer: _buildEnhancedDrawer(),
// // // //       body: FadeTransition(
// // // //         opacity: _fadeAnimation,
// // // //         child: ScaleTransition(
// // // //           scale: _scaleAnimation,
// // // //           child: _getCurrentScreen(),
// // // //         ),
// // // //       ),
// // // //       bottomNavigationBar: _buildEnhancedBottomNavigationBar(),
// // // //     );
// // // //   }

// // // //   AppBar _buildEnhancedAppBar() {
// // // //     return AppBar(
// // // //       title: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Text(
// // // //             'AutoConnect',
// // // //             style: TextStyle(
// // // //               fontWeight: FontWeight.w800,
// // // //               fontSize: 22,
// // // //               color: Colors.white,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             'Always here to help',
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               color: Colors.white70,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       backgroundColor: Color(0xFF6D28D9),
// // // //       foregroundColor: Colors.white,
// // // //       elevation: 0,
// // // //       shape: RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.only(
// // // //           bottomLeft: Radius.circular(20),
// // // //           bottomRight: Radius.circular(20),
// // // //         ),
// // // //       ),
// // // //       actions: [
// // // //         IconButton(
// // // //           icon: Icon(Icons.auto_awesome),
// // // //           onPressed: (){
// // // //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VehicleDamageAnalyzer()));
// // // //           },
// // // //           tooltip: 'AI Assistance',
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildEnhancedDrawer() {
// // // //     return Drawer(
// // // //       child: Container(
// // // //         decoration: BoxDecoration(
// // // //           gradient: LinearGradient(
// // // //             begin: Alignment.topLeft,
// // // //             end: Alignment.bottomRight,
// // // //             colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // // //           ),
// // // //         ),
// // // //         child: ListView(
// // // //           padding: EdgeInsets.zero,
// // // //           children: [
// // // //             _buildDrawerHeader(),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.dashboard_rounded,
// // // //               title: 'Dashboard',
// // // //               onTap: () => _navigateToIndex(0),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.security_rounded,
// // // //               title: 'Insurance',
// // // //               onTap: () => _navigateToIndex(3),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.build_circle_rounded,
// // // //               title: 'Spare Parts',
// // // //               onTap: _showSpareParts,
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.history_rounded,
// // // //               title: 'Service History',
// // // //               onTap: () => _navigateToIndex(2),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.logout_rounded,
// // // //               title: 'Logout',
// // // //               onTap: _logout,
// // // //               color: Colors.red[300],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDrawerHeader() {
// // // //     return Container(
// // // //       padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
// // // //       decoration: BoxDecoration(
// // // //         color: Color(0xFF5B21B6).withOpacity(0.8),
// // // //       ),
// // // //       child: Column(
// // // //         children: [
// // // //           CircleAvatar(
// // // //             radius: 40,
// // // //             backgroundColor: Colors.white,
// // // //             child: Icon(
// // // //               Icons.person_rounded,
// // // //               size: 50,
// // // //               color: Color(0xFF6D28D9),
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 16),
// // // //           Text(
// // // //             _userData['name'],
// // // //             style: TextStyle(
// // // //               color: Colors.white,
// // // //               fontSize: 20,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 4),
// // // //           Text(
// // // //             _userData['email'],
// // // //             style: TextStyle(
// // // //               color: Colors.white70,
// // // //               fontSize: 14,
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 8),
// // // //           Container(
// // // //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.amber.withOpacity(0.2),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //               border: Border.all(color: Colors.amber),
// // // //             ),
// // // //             child: Row(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
// // // //                 SizedBox(width: 4),
// // // //                 Text(
// // // //                   '${_userData['points']} Points',
// // // //                   style: TextStyle(
// // // //                     color: Colors.amber,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDrawerItem({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required VoidCallback onTap,
// // // //     Color? color,
// // // //   }) {
// // // //     return ListTile(
// // // //       leading: Container(
// // // //         width: 40,
// // // //         height: 40,
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white.withOpacity(0.1),
// // // //           borderRadius: BorderRadius.circular(10),
// // // //         ),
// // // //         child: Icon(icon, color: color ?? Colors.white70, size: 20),
// // // //       ),
// // // //       title: Text(
// // // //         title,
// // // //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
// // // //       ),
// // // //       onTap: onTap,
// // // //       hoverColor: Colors.white.withOpacity(0.1),
// // // //     );
// // // //   }

// // // //   Widget _getCurrentScreen() {
// // // //     switch (_currentIndex) {
// // // //       case 0:
// // // //         return EnhancedHomeScreenWithInsurance(
// // // //           userData: _userData,
// // // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // // //         );
// // // //       case 1:
// // // //         return EnhancedServicesScreen();
// // // //       case 2:
// // // //         return EnhancedHistoryScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // // //       case 3:
// // // //         return RequestInsuranceScreen();
// // // //       case 4:
// // // //         return EnhancedProfileScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // // //       default:
// // // //         return EnhancedHomeScreenWithInsurance(
// // // //           userData: _userData,
// // // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // // //         );
// // // //     }
// // // //   }

// // // //   Widget _buildEnhancedBottomNavigationBar() {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.only(
// // // //           topLeft: Radius.circular(20),
// // // //           topRight: Radius.circular(20),
// // // //         ),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.purple.withOpacity(0.1),
// // // //             blurRadius: 20,
// // // //             offset: Offset(0, -5),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: ClipRRect(
// // // //         borderRadius: BorderRadius.only(
// // // //           topLeft: Radius.circular(20),
// // // //           topRight: Radius.circular(20),
// // // //         ),
// // // //         child: BottomNavigationBar(
// // // //           currentIndex: _currentIndex,
// // // //           onTap: (index) {
// // // //             setState(() {
// // // //               _currentIndex = index;
// // // //               _animationController.reset();
// // // //               _animationController.forward();
// // // //             });
// // // //           },
// // // //           type: BottomNavigationBarType.fixed,
// // // //           backgroundColor: Colors.white,
// // // //           selectedItemColor: Color(0xFF6D28D9),
// // // //           unselectedItemColor: Colors.grey[600],
// // // //           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
// // // //           unselectedLabelStyle: TextStyle(fontSize: 12),
// // // //           items: [
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.home_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Home',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.handyman_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Services',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.history_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'History',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.security_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Insurance',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.person_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Profile',
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _navigateToIndex(int index) {
// // // //     setState(() {
// // // //       _currentIndex = index;
// // // //     });
// // // //     Navigator.pop(context);
// // // //   }

// // // //   void _showSpareParts() {
// // // //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SparePartsStore()));
// // // //     Navigator.pop(context);
// // // //   }

// // // //   // FIXED LOGOUT FUNCTION - 100% WORKING
// // // //   void _logout() async {
// // // //     print('🚪 Logout button pressed...');

// // // //     // Close drawer first
// // // //     Navigator.pop(context);

// // // //     // Show confirmation dialog
// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: false,
// // // //       builder: (BuildContext context) {
// // // //         return AlertDialog(
// // // //           title: Text('Logout Confirmation'),
// // // //           content: Text('Are you sure you want to logout?'),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.of(context).pop(); // Close dialog
// // // //                 print('❌ Logout cancelled by user');
// // // //               },
// // // //               child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// // // //             ),
// // // //             TextButton(
// // // //               onPressed: () async {
// // // //                 Navigator.of(context).pop(); // Close dialog
// // // //                 print('✅ User confirmed logout');

// // // //                 try {
// // // //                   // Show loading
// // // //                   showDialog(
// // // //                     context: context,
// // // //                     barrierDismissible: false,
// // // //                     builder: (BuildContext context) {
// // // //                       return Dialog(
// // // //                         child: Padding(
// // // //                           padding: EdgeInsets.all(20),
// // // //                           child: Row(
// // // //                             mainAxisSize: MainAxisSize.min,
// // // //                             children: [
// // // //                               CircularProgressIndicator(),
// // // //                               SizedBox(width: 20),
// // // //                               Text("Logging out..."),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       );
// // // //                     },
// // // //                   );

// // // //                   // 1. Clear shared preferences
// // // //                   print('🗑️ Clearing shared preferences...');
// // // //                   await AuthService.clearLoginData();

// // // //                   // 2. Sign out from Firebase
// // // //                   print('🔥 Signing out from Firebase...');
// // // //                   await FirebaseAuth.instance.signOut();

// // // //                   // 3. Close loading dialog
// // // //                   Navigator.of(context).pop();

// // // //                   // 4. Navigate to login page and remove all routes
// // // //                   print('🔄 Navigating to login page...');
// // // //                   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
// // // //   MaterialPageRoute(builder: (context) => VehicleLoginPage()),
// // // //   (Route<dynamic> route) => false,
// // // // );

// // // //                   print('🎉 Logout completed successfully!');

// // // //                 } catch (e) {
// // // //                   print('❌ Error during logout: $e');

// // // //                   // Close loading dialog if still open
// // // //                   if (Navigator.canPop(context)) {
// // // //                     Navigator.of(context).pop();
// // // //                   }

// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                       content: Text('Logout failed. Please try again.'),
// // // //                       backgroundColor: Colors.red,
// // // //                     ),
// // // //                   );
// // // //                 }
// // // //               },
// // // //               child: Text('Logout', style: TextStyle(color: Colors.red)),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // // // Enhanced Home Screen with Insurance Integration
// // // // class EnhancedHomeScreenWithInsurance extends StatelessWidget {
// // // //   final Map<String, dynamic> userData;
// // // //   final List<Map<String, dynamic>> insuranceRequests;

// // // //   const EnhancedHomeScreenWithInsurance({
// // // //     super.key,
// // // //     required this.userData,
// // // //     required this.insuranceRequests,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return SingleChildScrollView(
// // // //       padding: EdgeInsets.all(16),
// // // //       child: Column(
// // // //         children: [
// // // //           _buildWelcomeCard(),
// // // //           SizedBox(height: 20),
// // // //           _buildQuickActions(context),
// // // //           SizedBox(height: 20),
// // // //           _buildInsuranceReminder(context),
// // // //           SizedBox(height: 20),
// // // //           _buildQuickStats(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildWelcomeCard() {
// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: EdgeInsets.all(20),
// // // //       decoration: BoxDecoration(
// // // //         gradient: LinearGradient(
// // // //           begin: Alignment.topLeft,
// // // //           end: Alignment.bottomRight,
// // // //           colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // // //         ),
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Color(0xFF6D28D9).withOpacity(0.3),
// // // //             blurRadius: 20,
// // // //             offset: Offset(0, 8),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               CircleAvatar(
// // // //                 backgroundColor: Colors.white,
// // // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       'Welcome back, ${userData['name'].split(' ')[0]}! 👋',
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.bold,
// // // //                       ),
// // // //                     ),
// // // //                     Text(
// // // //                       'Your ${userData['plan']} is active',
// // // //                       style: TextStyle(color: Colors.white70),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           SizedBox(height: 15),
// // // //           Container(
// // // //             padding: EdgeInsets.all(12),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.white.withOpacity(0.1),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //             child: Row(
// // // //               children: [
// // // //                 Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
// // // //                 SizedBox(width: 8),
// // // //                 Text(
// // // //                   '${userData['points']} Reward Points',
// // // //                   style: TextStyle(color: Colors.white),
// // // //                 ),
// // // //                 Spacer(),
// // // //                 Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
// // // //                 SizedBox(width: 4),
// // // //                 Text(
// // // //                   'Next: ${userData['nextService']}',
// // // //                   style: TextStyle(color: Colors.white70, fontSize: 12),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildQuickActions(BuildContext context) {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.security_rounded,
// // // //             title: 'Insurance',
// // // //             color: Colors.purple,
// // // //             onTap: () => Navigator.push(
// // // //               context,
// // // //               MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.location_on_rounded,
// // // //             title: 'Track Service',
// // // //             color: Colors.blue,
// // // //             onTap: () => _showComingSoon(context, 'Track Service'),
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.schedule_rounded,
// // // //             title: 'Schedule',
// // // //             color: Colors.green,
// // // //             onTap: () => _showComingSoon(context, 'Schedule'),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildQuickActionItem({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required Color color,
// // // //     VoidCallback? onTap,
// // // //   }) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white,
// // // //           borderRadius: BorderRadius.circular(15),
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: Colors.grey.withOpacity(0.1),
// // // //               blurRadius: 10,
// // // //               offset: Offset(0, 3),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Container(
// // // //               padding: EdgeInsets.all(8),
// // // //               decoration: BoxDecoration(
// // // //                 color: color.withOpacity(0.1),
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, color: color, size: 20),
// // // //             ),
// // // //             SizedBox(height: 8),
// // // //             Text(
// // // //               title,
// // // //               style: TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 color: Colors.grey[700],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildInsuranceReminder(BuildContext context) {
// // // //     final activePolicy = insuranceRequests.firstWhere(
// // // //       (policy) => policy['status'] == 'Active',
// // // //       orElse: () => {},
// // // //     );

// // // //     if (activePolicy.isEmpty) {
// // // //       return Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.orange[50],
// // // //           borderRadius: BorderRadius.circular(15),
// // // //           border: Border.all(color: Colors.orange),
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             Icon(Icons.warning_amber_rounded, color: Colors.orange),
// // // //             SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     'No Active Insurance',
// // // //                     style: TextStyle(
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.orange[800],
// // // //                     ),
// // // //                   ),
// // // //                   Text(
// // // //                     'Get your vehicle insured today',
// // // //                     style: TextStyle(color: Colors.orange[700], fontSize: 12),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => Navigator.push(
// // // //                 context,
// // // //                 MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // // //               ),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: Colors.orange,
// // // //                 foregroundColor: Colors.white,
// // // //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // //               ),
// // // //               child: Text('Get Insurance'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     }

// // // //     return Container();
// // // //   }

// // // //   Widget _buildQuickStats() {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Services Used',
// // // //             value: '3',
// // // //             subtitle: 'This month',
// // // //             color: Color(0xFF6D28D9),
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Insurance',
// // // //             value: 'Active',
// // // //             subtitle: 'Comprehensive',
// // // //             color: Colors.green,
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Savings',
// // // //             value: '\$85',
// // // //             subtitle: 'Total',
// // // //             color: Colors.blue,
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildStatCard({
// // // //     required String title,
// // // //     required String value,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //   }) {
// // // //     return Container(
// // // //       padding: EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(15),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.grey.withOpacity(0.1),
// // // //             blurRadius: 10,
// // // //             offset: Offset(0, 3),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Container(
// // // //             padding: EdgeInsets.all(6),
// // // //             decoration: BoxDecoration(
// // // //               color: color.withOpacity(0.1),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: Icon(Icons.trending_up_rounded, color: color, size: 16),
// // // //           ),
// // // //           SizedBox(height: 8),
// // // //           Text(
// // // //             value,
// // // //             style: TextStyle(
// // // //               fontSize: 18,
// // // //               fontWeight: FontWeight.bold,
// // // //               color: color,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             title,
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               color: Colors.grey[600],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showComingSoon(BuildContext context, String feature) {
// // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // //       SnackBar(
// // // //         content: Text('$feature feature coming soon!'),
// // // //         backgroundColor: Color(0xFF6D28D9),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // Enhanced Services Screen
// // // // class EnhancedServicesScreen extends StatelessWidget {
// // // //   const EnhancedServicesScreen({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       body: CustomScrollView(
// // // //         slivers: [
// // // //           SliverList(
// // // //             delegate: SliverChildListDelegate([
// // // //               Padding(
// // // //                 padding: EdgeInsets.all(16),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     _buildEmergencyServices(context),
// // // //                     SizedBox(height: 20),
// // // //                     Text(
// // // //                       'All Services',
// // // //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ]),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildEmergencyServices(BuildContext context) {
// // // //     return Card(
// // // //       elevation: 4,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // // //       child: Padding(
// // // //         padding: EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               'Emergency Services',
// // // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // // //             ),
// // // //             SizedBox(height: 12),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: _buildEmergencyServiceCard(
// // // //                     icon: Icons.local_shipping_rounded,
// // // //                     title: 'Tow Service',
// // // //                     subtitle: 'Vehicle towing',
// // // //                     color: Color(0xFF6D28D9),
// // // //                     onTap: () => Navigator.push(
// // // //                       context,
// // // //                       MaterialPageRoute(builder: (context) => TowServiceRequestScreen()),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(width: 12),
// // // //                 Expanded(
// // // //                   child: _buildEmergencyServiceCard(
// // // //                     icon: Icons.handyman_rounded,
// // // //                     title: 'Garage Service',
// // // //                     subtitle: 'Mechanic & repair',
// // // //                     color: Color(0xFFF59E0B),
// // // //                     onTap: () => Navigator.push(
// // // //                       context,
// // // //                       MaterialPageRoute(builder: (context) => GarageServiceRequestScreen()),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildEmergencyServiceCard({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: color.withOpacity(0.1),
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           border: Border.all(color: color.withOpacity(0.3)),
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Container(
// // // //               padding: EdgeInsets.all(12),
// // // //               decoration: BoxDecoration(
// // // //                 color: color,
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, color: Colors.white, size: 24),
// // // //             ),
// // // //             SizedBox(height: 8),
// // // //             Text(
// // // //               title,
// // // //               style: TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.bold,
// // // //                 color: color,
// // // //               ),
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //             Text(
// // // //               subtitle,
// // // //               style: TextStyle(
// // // //                 fontSize: 10,
// // // //                 color: Colors.grey[600],
// // // //               ),
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// // // // import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/History.dart';
// // // // import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
// // // // import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
// // // // import 'package:smart_road_app/VehicleOwner/TowRequest.dart';
// // // // import 'package:smart_road_app/VehicleOwner/ai.dart';
// // // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:geolocator/geolocator.dart';

// // // // // Insurance Module Classes
// // // // class InsuranceModule {
// // // //   static List<Map<String, dynamic>> getInsuranceRequests() {
// // // //     return [
// // // //       {
// // // //         'id': 'INS001',
// // // //         'policyType': 'Comprehensive',
// // // //         'status': 'Active',
// // // //         'expiryDate': '2024-12-31',
// // // //         'vehicleNumber': 'MH12AB1234',
// // // //         'provider': 'ABC Insurance Co.',
// // // //         'premium': '\$450',
// // // //         'startDate': '2024-01-01',
// // // //       },
// // // //       {
// // // //         'id': 'INS002',
// // // //         'policyType': 'Third Party',
// // // //         'status': 'Pending',
// // // //         'expiryDate': '2024-06-30',
// // // //         'vehicleNumber': 'MH12CD5678',
// // // //         'provider': 'XYZ Insurance',
// // // //         'premium': '\$200',
// // // //         'startDate': '2024-01-15',
// // // //       },
// // // //     ];
// // // //   }
// // // // }

// // // // // Main Dashboard Class
// // // // class EnhancedVehicleDashboard extends StatefulWidget {
// // // //   const EnhancedVehicleDashboard({super.key});

// // // //   @override
// // // //   _EnhancedVehicleDashboardState createState() => _EnhancedVehicleDashboardState();
// // // // }

// // // // class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
// // // //     with SingleTickerProviderStateMixin {
// // // //   int _currentIndex = 0;
// // // //   late AnimationController _animationController;
// // // //   late Animation<double> _scaleAnimation;
// // // //   late Animation<double> _fadeAnimation;
// // // //   String? _userEmail;
// // // //   Position? _currentPosition;
// // // //   String _currentLocation = 'Fetching location...';
// // // //   bool _locationLoading = false;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _animationController = AnimationController(
// // // //       vsync: this,
// // // //       duration: Duration(milliseconds: 800),
// // // //     );
// // // //     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
// // // //       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
// // // //     );
// // // //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// // // //       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
// // // //     );
// // // //     _animationController.forward();
// // // //     _loadUserData();
// // // //     _getCurrentLocation();
// // // //   }

// // // //   Future<void> _loadUserData() async {
// // // //     try {
// // // //       String? userEmail = await AuthService.getUserEmail();
// // // //       setState(() {
// // // //         _userEmail = userEmail;
// // // //       });
// // // //       print('✅ Dashboard loaded for user: $_userEmail');
// // // //     } catch (e) {
// // // //       print('❌ Error loading user data in dashboard: $e');
// // // //     }
// // // //   }

// // // //   Future<void> _getCurrentLocation() async {
// // // //     setState(() {
// // // //       _locationLoading = true;
// // // //     });

// // // //     try {
// // // //       // Check permission
// // // //       LocationPermission permission = await Geolocator.checkPermission();
// // // //       if (permission == LocationPermission.denied) {
// // // //         permission = await Geolocator.requestPermission();
// // // //         if (permission == LocationPermission.denied) {
// // // //           setState(() {
// // // //             _currentLocation = 'Location permission denied';
// // // //             _locationLoading = false;
// // // //           });
// // // //           return;
// // // //         }
// // // //       }

// // // //       if (permission == LocationPermission.deniedForever) {
// // // //         setState(() {
// // // //           _currentLocation = 'Location permission permanently denied';
// // // //           _locationLoading = false;
// // // //         });
// // // //         return;
// // // //       }

// // // //       // Get current position
// // // //       Position position = await Geolocator.getCurrentPosition(
// // // //         desiredAccuracy: LocationAccuracy.high,
// // // //       );

// // // //       setState(() {
// // // //         _currentPosition = position;
// // // //         _currentLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
// // // //         _locationLoading = false;
// // // //       });

// // // //     } catch (e) {
// // // //       print('Error getting location: $e');
// // // //       setState(() {
// // // //         _currentLocation = 'Unable to fetch location';
// // // //         _locationLoading = false;
// // // //       });
// // // //     }
// // // //   }

// // // //   Map<String, dynamic> get _userData {
// // // //     return {
// // // //       'name': _userEmail?.split('@').first ?? 'User',
// // // //       'email': _userEmail ?? 'user@example.com',
// // // //       'vehicle': 'Toyota Camry 2022',
// // // //       'plan': 'Gold Plan',
// // // //       'memberSince': '2023',
// // // //       'points': 450,
// // // //       'nextService': '2024-02-20',
// // // //       'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901']
// // // //     };
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _animationController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.grey[50],
// // // //       appBar: _buildEnhancedAppBar(),
// // // //       drawer: _buildEnhancedDrawer(),
// // // //       body: FadeTransition(
// // // //         opacity: _fadeAnimation,
// // // //         child: ScaleTransition(
// // // //           scale: _scaleAnimation,
// // // //           child: _getCurrentScreen(),
// // // //         ),
// // // //       ),
// // // //       bottomNavigationBar: _buildEnhancedBottomNavigationBar(),
// // // //     );
// // // //   }

// // // //   AppBar _buildEnhancedAppBar() {
// // // //     return AppBar(
// // // //       title: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Text(
// // // //             'AutoConnect',
// // // //             style: TextStyle(
// // // //               fontWeight: FontWeight.w800,
// // // //               fontSize: 22,
// // // //               color: Colors.white,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             'Always here to help',
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               color: Colors.white70,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       backgroundColor: Color(0xFF6D28D9),
// // // //       foregroundColor: Colors.white,
// // // //       elevation: 0,
// // // //       shape: RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.only(
// // // //           bottomLeft: Radius.circular(20),
// // // //           bottomRight: Radius.circular(20),
// // // //         ),
// // // //       ),
// // // //       actions: [
// // // //         IconButton(
// // // //           icon: Icon(Icons.location_on),
// // // //           onPressed: _getCurrentLocation,
// // // //           tooltip: 'Refresh Location',
// // // //         ),
// // // //         IconButton(
// // // //           icon: Icon(Icons.auto_awesome),
// // // //           onPressed: (){
// // // //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VehicleDamageAnalyzer()));
// // // //           },
// // // //           tooltip: 'AI Assistance',
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildEnhancedDrawer() {
// // // //     return Drawer(
// // // //       child: Container(
// // // //         decoration: BoxDecoration(
// // // //           gradient: LinearGradient(
// // // //             begin: Alignment.topLeft,
// // // //             end: Alignment.bottomRight,
// // // //             colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // // //           ),
// // // //         ),
// // // //         child: ListView(
// // // //           padding: EdgeInsets.zero,
// // // //           children: [
// // // //             _buildDrawerHeader(),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.dashboard_rounded,
// // // //               title: 'Dashboard',
// // // //               onTap: () => _navigateToIndex(0),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.security_rounded,
// // // //               title: 'Insurance',
// // // //               onTap: () => _navigateToIndex(3),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.build_circle_rounded,
// // // //               title: 'Spare Parts',
// // // //               onTap: (){
// // // //                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SparePartsStore()));
// // // //               }
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.history_rounded,
// // // //               title: 'Service History',
// // // //               onTap: () => _navigateToIndex(2),
// // // //             ),
// // // //             _buildDrawerItem(
// // // //               icon: Icons.logout_rounded,
// // // //               title: 'Logout',
// // // //               onTap: _logout,
// // // //               color: Colors.red[300],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDrawerHeader() {
// // // //     return Container(
// // // //       padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
// // // //       decoration: BoxDecoration(
// // // //         color: Color(0xFF5B21B6).withOpacity(0.8),
// // // //       ),
// // // //       child: Column(
// // // //         children: [
// // // //           CircleAvatar(
// // // //             radius: 40,
// // // //             backgroundColor: Colors.white,
// // // //             child: Icon(
// // // //               Icons.person_rounded,
// // // //               size: 50,
// // // //               color: Color(0xFF6D28D9),
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 16),
// // // //           Text(
// // // //             _userData['name'],
// // // //             style: TextStyle(
// // // //               color: Colors.white,
// // // //               fontSize: 20,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 4),
// // // //           Text(
// // // //             _userData['email'],
// // // //             style: TextStyle(
// // // //               color: Colors.white70,
// // // //               fontSize: 14,
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 8),
// // // //           Container(
// // // //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.amber.withOpacity(0.2),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //               border: Border.all(color: Colors.amber),
// // // //             ),
// // // //             child: Row(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
// // // //                 SizedBox(width: 4),
// // // //                 Text(
// // // //                   '${_userData['points']} Points',
// // // //                   style: TextStyle(
// // // //                     color: Colors.amber,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDrawerItem({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required VoidCallback onTap,
// // // //     Color? color,
// // // //   }) {
// // // //     return ListTile(
// // // //       leading: Container(
// // // //         width: 40,
// // // //         height: 40,
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white.withOpacity(0.1),
// // // //           borderRadius: BorderRadius.circular(10),
// // // //         ),
// // // //         child: Icon(icon, color: color ?? Colors.white70, size: 20),
// // // //       ),
// // // //       title: Text(
// // // //         title,
// // // //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
// // // //       ),
// // // //       onTap: onTap,
// // // //       hoverColor: Colors.white.withOpacity(0.1),
// // // //     );
// // // //   }

// // // //   Widget _getCurrentScreen() {
// // // //     switch (_currentIndex) {
// // // //       case 0:
// // // //         return EnhancedHomeScreenWithInsurance(
// // // //           userData: _userData,
// // // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // // //           currentPosition: _currentPosition,
// // // //           currentLocation: _currentLocation,
// // // //           locationLoading: _locationLoading,
// // // //           onGarageServiceTap: _navigateToNearbyGarages,
// // // //         );
// // // //       case 1:
// // // //         return EnhancedServicesScreen(
// // // //           currentPosition: _currentPosition,
// // // //           currentLocation: _currentLocation,
// // // //           locationLoading: _locationLoading,
// // // //           userEmail: _userEmail,
// // // //         );
// // // //       case 2:
// // // //         return EnhancedHistoryScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // // //       case 3:
// // // //         return RequestInsuranceScreen();
// // // //       case 4:
// // // //         return EnhancedProfileScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // // //       default:
// // // //         return EnhancedHomeScreenWithInsurance(
// // // //           userData: _userData,
// // // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // // //           currentPosition: _currentPosition,
// // // //           currentLocation: _currentLocation,
// // // //           locationLoading: _locationLoading,
// // // //           onGarageServiceTap: _navigateToNearbyGarages,
// // // //         );
// // // //     }
// // // //   }

// // // //   void _navigateToNearbyGarages() {
// // // //     if (_currentPosition == null) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: Text('Please wait for location to load'),
// // // //           backgroundColor: Colors.orange,
// // // //         ),
// // // //       );
// // // //       return;
// // // //     }

// // // //     Navigator.push(
// // // //       context,
// // // //       MaterialPageRoute(
// // // //         builder: (context) => NearbyGaragesScreen(
// // // //           userLocation: _currentPosition!,
// // // //           userEmail: _userEmail,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildEnhancedBottomNavigationBar() {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.only(
// // // //           topLeft: Radius.circular(20),
// // // //           topRight: Radius.circular(20),
// // // //         ),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.purple.withOpacity(0.1),
// // // //             blurRadius: 20,
// // // //             offset: Offset(0, -5),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: ClipRRect(
// // // //         borderRadius: BorderRadius.only(
// // // //           topLeft: Radius.circular(20),
// // // //           topRight: Radius.circular(20),
// // // //         ),
// // // //         child: BottomNavigationBar(
// // // //           currentIndex: _currentIndex,
// // // //           onTap: (index) {
// // // //             setState(() {
// // // //               _currentIndex = index;
// // // //               _animationController.reset();
// // // //               _animationController.forward();
// // // //             });
// // // //           },
// // // //           type: BottomNavigationBarType.fixed,
// // // //           backgroundColor: Colors.white,
// // // //           selectedItemColor: Color(0xFF6D28D9),
// // // //           unselectedItemColor: Colors.grey[600],
// // // //           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
// // // //           unselectedLabelStyle: TextStyle(fontSize: 12),
// // // //           items: [
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.home_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Home',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.handyman_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Services',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.history_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'History',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.security_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Insurance',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.person_rounded),
// // // //               activeIcon: Container(
// // // //                 padding: EdgeInsets.all(8),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // // //                   shape: BoxShape.circle,
// // // //                 ),
// // // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               label: 'Profile',
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _navigateToIndex(int index) {
// // // //     setState(() {
// // // //       _currentIndex = index;
// // // //     });
// // // //     Navigator.pop(context);
// // // //   }

// // // //   void _showSpareParts() {
// // // //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SparePartsStore()));
// // // //     Navigator.pop(context);
// // // //   }

// // // //   // FIXED LOGOUT FUNCTION - 100% WORKING
// // // //   void _logout() async {
// // // //     print('🚪 Logout button pressed...');

// // // //     // Close drawer first
// // // //     Navigator.pop(context);

// // // //     // Show confirmation dialog
// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: false,
// // // //       builder: (BuildContext context) {
// // // //         return AlertDialog(
// // // //           title: Text('Logout Confirmation'),
// // // //           content: Text('Are you sure you want to logout?'),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.of(context).pop(); // Close dialog
// // // //                 print('❌ Logout cancelled by user');
// // // //               },
// // // //               child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// // // //             ),
// // // //             TextButton(
// // // //               onPressed: () async {
// // // //                 Navigator.of(context).pop(); // Close dialog
// // // //                 print('✅ User confirmed logout');

// // // //                 try {
// // // //                   // Show loading
// // // //                   showDialog(
// // // //                     context: context,
// // // //                     barrierDismissible: false,
// // // //                     builder: (BuildContext context) {
// // // //                       return Dialog(
// // // //                         child: Padding(
// // // //                           padding: EdgeInsets.all(20),
// // // //                           child: Row(
// // // //                             mainAxisSize: MainAxisSize.min,
// // // //                             children: [
// // // //                               CircularProgressIndicator(),
// // // //                               SizedBox(width: 20),
// // // //                               Text("Logging out..."),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       );
// // // //                     },
// // // //                   );

// // // //                   // 1. Clear shared preferences
// // // //                   print('🗑️ Clearing shared preferences...');
// // // //                   await AuthService.clearLoginData();

// // // //                   // 2. Sign out from Firebase
// // // //                   print('🔥 Signing out from Firebase...');
// // // //                   await FirebaseAuth.instance.signOut();

// // // //                   // 3. Close loading dialog
// // // //                   Navigator.of(context).pop();

// // // //                   // 4. Navigate to login page and remove all routes
// // // //                   print('🔄 Navigating to login page...');
// // // //                   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
// // // //                     MaterialPageRoute(builder: (context) => VehicleLoginPage()),
// // // //                     (Route<dynamic> route) => false,
// // // //                   );

// // // //                   print('🎉 Logout completed successfully!');

// // // //                 } catch (e) {
// // // //                   print('❌ Error during logout: $e');

// // // //                   // Close loading dialog if still open
// // // //                   if (Navigator.canPop(context)) {
// // // //                     Navigator.of(context).pop();
// // // //                   }

// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                       content: Text('Logout failed. Please try again.'),
// // // //                       backgroundColor: Colors.red,
// // // //                     ),
// // // //                   );
// // // //                 }
// // // //               },
// // // //               child: Text('Logout', style: TextStyle(color: Colors.red)),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // // // Enhanced Home Screen with Insurance Integration
// // // // class EnhancedHomeScreenWithInsurance extends StatelessWidget {
// // // //   final Map<String, dynamic> userData;
// // // //   final List<Map<String, dynamic>> insuranceRequests;
// // // //   final Position? currentPosition;
// // // //   final String currentLocation;
// // // //   final bool locationLoading;
// // // //   final VoidCallback onGarageServiceTap;

// // // //   const EnhancedHomeScreenWithInsurance({
// // // //     super.key,
// // // //     required this.userData,
// // // //     required this.insuranceRequests,
// // // //     required this.currentPosition,
// // // //     required this.currentLocation,
// // // //     required this.locationLoading,
// // // //     required this.onGarageServiceTap,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return SingleChildScrollView(
// // // //       padding: EdgeInsets.all(16),
// // // //       child: Column(
// // // //         children: [
// // // //           _buildWelcomeCard(),
// // // //           SizedBox(height: 20),
// // // //           _buildLocationCard(),
// // // //           SizedBox(height: 20),
// // // //           _buildQuickActions(context),
// // // //           SizedBox(height: 20),
// // // //           _buildInsuranceReminder(context),
// // // //           SizedBox(height: 20),
// // // //           _buildQuickStats(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildWelcomeCard() {
// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: EdgeInsets.all(20),
// // // //       decoration: BoxDecoration(
// // // //         gradient: LinearGradient(
// // // //           begin: Alignment.topLeft,
// // // //           end: Alignment.bottomRight,
// // // //           colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // // //         ),
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Color(0xFF6D28D9).withOpacity(0.3),
// // // //             blurRadius: 20,
// // // //             offset: Offset(0, 8),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               CircleAvatar(
// // // //                 backgroundColor: Colors.white,
// // // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // // //               ),
// // // //               SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       'Welcome back, ${userData['name'].split(' ')[0]}! 👋',
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.bold,
// // // //                       ),
// // // //                     ),
// // // //                     Text(
// // // //                       'Your ${userData['plan']} is active',
// // // //                       style: TextStyle(color: Colors.white70),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           SizedBox(height: 15),
// // // //           Container(
// // // //             padding: EdgeInsets.all(12),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.white.withOpacity(0.1),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //             child: Row(
// // // //               children: [
// // // //                 Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
// // // //                 SizedBox(width: 8),
// // // //                 Text(
// // // //                   '${userData['points']} Reward Points',
// // // //                   style: TextStyle(color: Colors.white),
// // // //                 ),
// // // //                 Spacer(),
// // // //                 Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
// // // //                 SizedBox(width: 4),
// // // //                 Text(
// // // //                   'Next: ${userData['nextService']}',
// // // //                   style: TextStyle(color: Colors.white70, fontSize: 12),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildLocationCard() {
// // // //     return Card(
// // // //       elevation: 3,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //       child: Padding(
// // // //         padding: EdgeInsets.all(16),
// // // //         child: Row(
// // // //           children: [
// // // //             Icon(
// // // //               Icons.location_on,
// // // //               color: Color(0xFF6D28D9),
// // // //               size: 24,
// // // //             ),
// // // //             SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     'Current Location',
// // // //                     style: TextStyle(
// // // //                       fontSize: 14,
// // // //                       fontWeight: FontWeight.w500,
// // // //                       color: Colors.grey[700],
// // // //                     ),
// // // //                   ),
// // // //                   SizedBox(height: 4),
// // // //                   locationLoading
// // // //                       ? Row(
// // // //                           children: [
// // // //                             SizedBox(
// // // //                               width: 16,
// // // //                               height: 16,
// // // //                               child: CircularProgressIndicator(strokeWidth: 2),
// // // //                             ),
// // // //                             SizedBox(width: 8),
// // // //                             Text(
// // // //                               'Fetching location...',
// // // //                               style: TextStyle(
// // // //                                 fontSize: 12,
// // // //                                 color: Colors.grey[500],
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         )
// // // //                       : Text(
// // // //                           currentLocation,
// // // //                           style: TextStyle(
// // // //                             fontSize: 12,
// // // //                             color: Colors.grey[600],
// // // //                           ),
// // // //                         ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             if (currentPosition != null)
// // // //               Icon(
// // // //                 Icons.check_circle,
// // // //                 color: Colors.green,
// // // //                 size: 20,
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildQuickActions(BuildContext context) {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.handyman_rounded,
// // // //             title: 'Garage Service',
// // // //             color: Color(0xFF6D28D9),
// // // //             onTap: onGarageServiceTap,
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.security_rounded,
// // // //             title: 'Insurance',
// // // //             color: Colors.purple,
// // // //             onTap: () => Navigator.push(
// // // //               context,
// // // //               MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildQuickActionItem(
// // // //             icon: Icons.local_shipping_rounded,
// // // //             title: 'Tow Service',
// // // //             color: Colors.blue,
// // // //             onTap: () => Navigator.push(
// // // //               context,
// // // //               MaterialPageRoute(builder: (context) => TowServiceRequestScreen()),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildQuickActionItem({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required Color color,
// // // //     VoidCallback? onTap,
// // // //   }) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white,
// // // //           borderRadius: BorderRadius.circular(15),
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: Colors.grey.withOpacity(0.1),
// // // //               blurRadius: 10,
// // // //               offset: Offset(0, 3),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Container(
// // // //               padding: EdgeInsets.all(8),
// // // //               decoration: BoxDecoration(
// // // //                 color: color.withOpacity(0.1),
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, color: color, size: 20),
// // // //             ),
// // // //             SizedBox(height: 8),
// // // //             Text(
// // // //               title,
// // // //               style: TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 color: Colors.grey[700],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildInsuranceReminder(BuildContext context) {
// // // //     final activePolicy = insuranceRequests.firstWhere(
// // // //       (policy) => policy['status'] == 'Active',
// // // //       orElse: () => {},
// // // //     );

// // // //     if (activePolicy.isEmpty) {
// // // //       return Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.orange[50],
// // // //           borderRadius: BorderRadius.circular(15),
// // // //           border: Border.all(color: Colors.orange),
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             Icon(Icons.warning_amber_rounded, color: Colors.orange),
// // // //             SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     'No Active Insurance',
// // // //                     style: TextStyle(
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.orange[800],
// // // //                     ),
// // // //                   ),
// // // //                   Text(
// // // //                     'Get your vehicle insured today',
// // // //                     style: TextStyle(color: Colors.orange[700], fontSize: 12),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => Navigator.push(
// // // //                 context,
// // // //                 MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // // //               ),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: Colors.orange,
// // // //                 foregroundColor: Colors.white,
// // // //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // //               ),
// // // //               child: Text('Get Insurance'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     }

// // // //     return Container();
// // // //   }

// // // //   Widget _buildQuickStats() {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Services Used',
// // // //             value: '3',
// // // //             subtitle: 'This month',
// // // //             color: Color(0xFF6D28D9),
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Insurance',
// // // //             value: 'Active',
// // // //             subtitle: 'Comprehensive',
// // // //             color: Colors.green,
// // // //           ),
// // // //         ),
// // // //         SizedBox(width: 12),
// // // //         Expanded(
// // // //           child: _buildStatCard(
// // // //             title: 'Savings',
// // // //             value: '\$85',
// // // //             subtitle: 'Total',
// // // //             color: Colors.blue,
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildStatCard({
// // // //     required String title,
// // // //     required String value,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //   }) {
// // // //     return Container(
// // // //       padding: EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(15),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.grey.withOpacity(0.1),
// // // //             blurRadius: 10,
// // // //             offset: Offset(0, 3),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Container(
// // // //             padding: EdgeInsets.all(6),
// // // //             decoration: BoxDecoration(
// // // //               color: color.withOpacity(0.1),
// // // //               borderRadius: BorderRadius.circular(8),
// // // //             ),
// // // //             child: Icon(Icons.trending_up_rounded, color: color, size: 16),
// // // //           ),
// // // //           SizedBox(height: 8),
// // // //           Text(
// // // //             value,
// // // //             style: TextStyle(
// // // //               fontSize: 18,
// // // //               fontWeight: FontWeight.bold,
// // // //               color: color,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             title,
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               color: Colors.grey[600],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showComingSoon(BuildContext context, String feature) {
// // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // //       SnackBar(
// // // //         content: Text('$feature feature coming soon!'),
// // // //         backgroundColor: Color(0xFF6D28D9),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // Enhanced Services Screen
// // // // class EnhancedServicesScreen extends StatelessWidget {
// // // //   final Position? currentPosition;
// // // //   final String currentLocation;
// // // //   final bool locationLoading;
// // // //   final String? userEmail;

// // // //   const EnhancedServicesScreen({
// // // //     super.key,
// // // //     required this.currentPosition,
// // // //     required this.currentLocation,
// // // //     required this.locationLoading,
// // // //     required this.userEmail,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       body: CustomScrollView(
// // // //         slivers: [
// // // //           SliverList(
// // // //             delegate: SliverChildListDelegate([
// // // //               Padding(
// // // //                 padding: EdgeInsets.all(16),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     _buildLocationCard(),
// // // //                     SizedBox(height: 20),
// // // //                     _buildEmergencyServices(context),
// // // //                     SizedBox(height: 20),
// // // //                     Text(
// // // //                       'All Services',
// // // //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ]),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildLocationCard() {
// // // //     return Card(
// // // //       elevation: 3,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //       child: Padding(
// // // //         padding: EdgeInsets.all(16),
// // // //         child: Row(
// // // //           children: [
// // // //             Icon(
// // // //               Icons.location_on,
// // // //               color: Color(0xFF6D28D9),
// // // //               size: 24,
// // // //             ),
// // // //             SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     'Current Location',
// // // //                     style: TextStyle(
// // // //                       fontSize: 14,
// // // //                       fontWeight: FontWeight.w500,
// // // //                       color: Colors.grey[700],
// // // //                     ),
// // // //                   ),
// // // //                   SizedBox(height: 4),
// // // //                   locationLoading
// // // //                       ? Row(
// // // //                           children: [
// // // //                             SizedBox(
// // // //                               width: 16,
// // // //                               height: 16,
// // // //                               child: CircularProgressIndicator(strokeWidth: 2),
// // // //                             ),
// // // //                             SizedBox(width: 8),
// // // //                             Text(
// // // //                               'Fetching location...',
// // // //                               style: TextStyle(
// // // //                                 fontSize: 12,
// // // //                                 color: Colors.grey[500],
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         )
// // // //                       : Text(
// // // //                           currentLocation,
// // // //                           style: TextStyle(
// // // //                             fontSize: 12,
// // // //                             color: Colors.grey[600],
// // // //                           ),
// // // //                         ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             if (currentPosition != null)
// // // //               Icon(
// // // //                 Icons.check_circle,
// // // //                 color: Colors.green,
// // // //                 size: 20,
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildEmergencyServices(BuildContext context) {
// // // //     return Card(
// // // //       elevation: 4,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // // //       child: Padding(
// // // //         padding: EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               'Emergency Services',
// // // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // // //             ),
// // // //             SizedBox(height: 12),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: _buildEmergencyServiceCard(
// // // //                     icon: Icons.local_shipping_rounded,
// // // //                     title: 'Tow Service',
// // // //                     subtitle: 'Vehicle towing',
// // // //                     color: Color(0xFF6D28D9),
// // // //                     onTap: () => Navigator.push(
// // // //                       context,
// // // //                       MaterialPageRoute(builder: (context) => TowServiceRequestScreen()),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(width: 12),
// // // //                 Expanded(
// // // //                   child: _buildEmergencyServiceCard(
// // // //                     icon: Icons.handyman_rounded,
// // // //                     title: 'Garage Service',
// // // //                     subtitle: 'Mechanic & repair',
// // // //                     color: Color(0xFFF59E0B),
// // // //                     onTap: () {
// // // //                       if (currentPosition == null) {
// // // //                         ScaffoldMessenger.of(context).showSnackBar(
// // // //                           SnackBar(
// // // //                             content: Text('Please wait for location to load'),
// // // //                             backgroundColor: Colors.orange,
// // // //                           ),
// // // //                         );
// // // //                         return;
// // // //                       }
// // // //                       Navigator.push(
// // // //                         context,
// // // //                         MaterialPageRoute(
// // // //                           builder: (context) => NearbyGaragesScreen(
// // // //                             userLocation: currentPosition!,
// // // //                             userEmail: userEmail,
// // // //                           ),
// // // //                         ),
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildEmergencyServiceCard({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: color.withOpacity(0.1),
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           border: Border.all(color: color.withOpacity(0.3)),
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Container(
// // // //               padding: EdgeInsets.all(12),
// // // //               decoration: BoxDecoration(
// // // //                 color: color,
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, color: Colors.white, size: 24),
// // // //             ),
// // // //             SizedBox(height: 8),
// // // //             Text(
// // // //               title,
// // // //               style: TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.bold,
// // // //                 color: color,
// // // //               ),
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //             Text(
// // // //               subtitle,
// // // //               style: TextStyle(
// // // //                 fontSize: 10,
// // // //                 color: Colors.grey[600],
// // // //               ),
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// // // import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
// // // import 'package:smart_road_app/VehicleOwner/History.dart';
// // // import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// // // import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
// // // import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
// // // import 'package:smart_road_app/VehicleOwner/ai.dart';
// // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:geolocator/geolocator.dart';

// // // // Import the tow service screens

// // // import "package:smart_road_app/VehicleOwner/TowRequest.dart";
// // // import 'package:smart_road_app/VehicleOwner/nearby_tow_provider_screen.dart';

// // // // Insurance Module Classes
// // // class InsuranceModule {
// // //   static List<Map<String, dynamic>> getInsuranceRequests() {
// // //     return [
// // //       {
// // //         'id': 'INS001',
// // //         'policyType': 'Comprehensive',
// // //         'status': 'Active',
// // //         'expiryDate': '2024-12-31',
// // //         'vehicleNumber': 'MH12AB1234',
// // //         'provider': 'ABC Insurance Co.',
// // //         'premium': '\$450',
// // //         'startDate': '2024-01-01',
// // //       },
// // //       {
// // //         'id': 'INS002',
// // //         'policyType': 'Third Party',
// // //         'status': 'Pending',
// // //         'expiryDate': '2024-06-30',
// // //         'vehicleNumber': 'MH12CD5678',
// // //         'provider': 'XYZ Insurance',
// // //         'premium': '\$200',
// // //         'startDate': '2024-01-15',
// // //       },
// // //     ];
// // //   }
// // // }

// // // // Main Dashboard Class
// // // class EnhancedVehicleDashboard extends StatefulWidget {
// // //   const EnhancedVehicleDashboard({super.key});

// // //   @override
// // //   _EnhancedVehicleDashboardState createState() => _EnhancedVehicleDashboardState();
// // // }

// // // class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
// // //     with SingleTickerProviderStateMixin {
// // //   int _currentIndex = 0;
// // //   late AnimationController _animationController;
// // //   late Animation<double> _scaleAnimation;
// // //   late Animation<double> _fadeAnimation;
// // //   String? _userEmail;
// // //   Position? _currentPosition;
// // //   String _currentLocation = 'Fetching location...';
// // //   bool _locationLoading = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _animationController = AnimationController(
// // //       vsync: this,
// // //       duration: Duration(milliseconds: 800),
// // //     );
// // //     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
// // //       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
// // //     );
// // //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// // //       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
// // //     );
// // //     _animationController.forward();
// // //     _loadUserData();
// // //     _getCurrentLocation();
// // //   }

// // //   Future<void> _loadUserData() async {
// // //     try {
// // //       String? userEmail = await AuthService.getUserEmail();
// // //       setState(() {
// // //         _userEmail = userEmail;
// // //       });
// // //       print('✅ Dashboard loaded for user: $_userEmail');
// // //     } catch (e) {
// // //       print('❌ Error loading user data in dashboard: $e');
// // //     }
// // //   }

// // //   Future<void> _getCurrentLocation() async {
// // //     setState(() {
// // //       _locationLoading = true;
// // //     });

// // //     try {
// // //       // Check permission
// // //       LocationPermission permission = await Geolocator.checkPermission();
// // //       if (permission == LocationPermission.denied) {
// // //         permission = await Geolocator.requestPermission();
// // //         if (permission == LocationPermission.denied) {
// // //           setState(() {
// // //             _currentLocation = 'Location permission denied';
// // //             _locationLoading = false;
// // //           });
// // //           return;
// // //         }
// // //       }

// // //       if (permission == LocationPermission.deniedForever) {
// // //         setState(() {
// // //           _currentLocation = 'Location permission permanently denied';
// // //           _locationLoading = false;
// // //         });
// // //         return;
// // //       }

// // //       // Get current position
// // //       Position position = await Geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.high,
// // //       );

// // //       setState(() {
// // //         _currentPosition = position;
// // //         _currentLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
// // //         _locationLoading = false;
// // //       });

// // //     } catch (e) {
// // //       print('Error getting location: $e');
// // //       setState(() {
// // //         _currentLocation = 'Unable to fetch location';
// // //         _locationLoading = false;
// // //       });
// // //     }
// // //   }

// // //   Map<String, dynamic> get _userData {
// // //     return {
// // //       'name': _userEmail?.split('@').first ?? 'User',
// // //       'email': _userEmail ?? 'user@example.com',
// // //       'vehicle': 'Toyota Camry 2022',
// // //       'plan': 'Gold Plan',
// // //       'memberSince': '2023',
// // //       'points': 450,
// // //       'nextService': '2024-02-20',
// // //       'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901']
// // //     };
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _animationController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[50],
// // //       appBar: _buildEnhancedAppBar(),
// // //       drawer: _buildEnhancedDrawer(),
// // //       body: FadeTransition(
// // //         opacity: _fadeAnimation,
// // //         child: ScaleTransition(
// // //           scale: _scaleAnimation,
// // //           child: _getCurrentScreen(),
// // //         ),
// // //       ),
// // //       bottomNavigationBar: _buildEnhancedBottomNavigationBar(),
// // //     );
// // //   }

// // //   AppBar _buildEnhancedAppBar() {
// // //     return AppBar(
// // //       title: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             'AutoConnect',
// // //             style: TextStyle(
// // //               fontWeight: FontWeight.w800,
// // //               fontSize: 22,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           Text(
// // //             'Always here to help',
// // //             style: TextStyle(
// // //               fontSize: 12,
// // //               color: Colors.white70,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       backgroundColor: Color(0xFF6D28D9),
// // //       foregroundColor: Colors.white,
// // //       elevation: 0,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.only(
// // //           bottomLeft: Radius.circular(20),
// // //           bottomRight: Radius.circular(20),
// // //         ),
// // //       ),
// // //       actions: [
// // //         IconButton(
// // //           icon: Icon(Icons.location_on),
// // //           onPressed: _getCurrentLocation,
// // //           tooltip: 'Refresh Location',
// // //         ),
// // //         IconButton(
// // //           icon: Icon(Icons.auto_awesome),
// // //           onPressed: (){
// // //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VehicleDamageAnalyzer()));
// // //           },
// // //           tooltip: 'AI Assistance',
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildEnhancedDrawer() {
// // //     return Drawer(
// // //       child: Container(
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             begin: Alignment.topLeft,
// // //             end: Alignment.bottomRight,
// // //             colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // //           ),
// // //         ),
// // //         child: ListView(
// // //           padding: EdgeInsets.zero,
// // //           children: [
// // //             _buildDrawerHeader(),
// // //             _buildDrawerItem(
// // //               icon: Icons.dashboard_rounded,
// // //               title: 'Dashboard',
// // //               onTap: () => _navigateToIndex(0),
// // //             ),
// // //             _buildDrawerItem(
// // //               icon: Icons.security_rounded,
// // //               title: 'Insurance',
// // //               onTap: () => _navigateToIndex(3),
// // //             ),
// // //             _buildDrawerItem(
// // //               icon: Icons.build_circle_rounded,
// // //               title: 'Spare Parts',
// // //               onTap: _showSpareParts,
// // //             ),
// // //             _buildDrawerItem(
// // //               icon: Icons.history_rounded,
// // //               title: 'Service History',
// // //               onTap: () => _navigateToIndex(2),
// // //             ),
// // //             _buildDrawerItem(
// // //               icon: Icons.logout_rounded,
// // //               title: 'Logout',
// // //               onTap: _logout,
// // //               color: Colors.red[300],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDrawerHeader() {
// // //     return Container(
// // //       padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
// // //       decoration: BoxDecoration(
// // //         color: Color(0xFF5B21B6).withOpacity(0.8),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           CircleAvatar(
// // //             radius: 40,
// // //             backgroundColor: Colors.white,
// // //             child: Icon(
// // //               Icons.person_rounded,
// // //               size: 50,
// // //               color: Color(0xFF6D28D9),
// // //             ),
// // //           ),
// // //           SizedBox(height: 16),
// // //           Text(
// // //             _userData['name'],
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 20,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           SizedBox(height: 4),
// // //           Text(
// // //             _userData['email'],
// // //             style: TextStyle(
// // //               color: Colors.white70,
// // //               fontSize: 14,
// // //             ),
// // //           ),
// // //           SizedBox(height: 8),
// // //           Container(
// // //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //             decoration: BoxDecoration(
// // //               color: Colors.amber.withOpacity(0.2),
// // //               borderRadius: BorderRadius.circular(12),
// // //               border: Border.all(color: Colors.amber),
// // //             ),
// // //             child: Row(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
// // //                 SizedBox(width: 4),
// // //                 Text(
// // //                   '${_userData['points']} Points',
// // //                   style: TextStyle(
// // //                     color: Colors.amber,
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDrawerItem({
// // //     required IconData icon,
// // //     required String title,
// // //     required VoidCallback onTap,
// // //     Color? color,
// // //   }) {
// // //     return ListTile(
// // //       leading: Container(
// // //         width: 40,
// // //         height: 40,
// // //         decoration: BoxDecoration(
// // //           color: Colors.white.withOpacity(0.1),
// // //           borderRadius: BorderRadius.circular(10),
// // //         ),
// // //         child: Icon(icon, color: color ?? Colors.white70, size: 20),
// // //       ),
// // //       title: Text(
// // //         title,
// // //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
// // //       ),
// // //       onTap: onTap,
// // //       hoverColor: Colors.white.withOpacity(0.1),
// // //     );
// // //   }

// // //   Widget _getCurrentScreen() {
// // //     switch (_currentIndex) {
// // //       case 0:
// // //         return EnhancedHomeScreenWithInsurance(
// // //           userData: _userData,
// // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // //           currentPosition: _currentPosition,
// // //           currentLocation: _currentLocation,
// // //           locationLoading: _locationLoading,
// // //           onGarageServiceTap: _navigateToNearbyGarages,
// // //           onTowServiceTap: _navigateToNearbyTowProviders,
// // //         );
// // //       case 1:
// // //         return EnhancedServicesScreen(
// // //           currentPosition: _currentPosition,
// // //           currentLocation: _currentLocation,
// // //           locationLoading: _locationLoading,
// // //           userEmail: _userEmail,
// // //           onTowServiceTap: _navigateToNearbyTowProviders,
// // //           onGarageServiceTap: _navigateToNearbyGarages,
// // //         );
// // //       case 2:
// // //         return EnhancedHistoryScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // //       case 3:
// // //         return RequestInsuranceScreen();
// // //       case 4:
// // //         return EnhancedProfileScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
// // //       default:
// // //         return EnhancedHomeScreenWithInsurance(
// // //           userData: _userData,
// // //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// // //           currentPosition: _currentPosition,
// // //           currentLocation: _currentLocation,
// // //           locationLoading: _locationLoading,
// // //           onGarageServiceTap: _navigateToNearbyGarages,
// // //           onTowServiceTap: _navigateToNearbyTowProviders,
// // //         );
// // //     }
// // //   }

// // //   void _navigateToNearbyGarages() {
// // //     if (_currentPosition == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Please wait for location to load'),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (context) => NearbyGaragesScreen(
// // //           userLocation: _currentPosition!,
// // //           userEmail: _userEmail,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _navigateToNearbyTowProviders() {
// // //     if (_currentPosition == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Please wait for location to load'),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (context) => NearbyTowProvidersScreen(
// // //           userLocation: _currentPosition!,
// // //           userEmail: _userEmail,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEnhancedBottomNavigationBar() {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.only(
// // //           topLeft: Radius.circular(20),
// // //           topRight: Radius.circular(20),
// // //         ),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.purple.withOpacity(0.1),
// // //             blurRadius: 20,
// // //             offset: Offset(0, -5),
// // //           ),
// // //         ],
// // //       ),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.only(
// // //           topLeft: Radius.circular(20),
// // //           topRight: Radius.circular(20),
// // //         ),
// // //         child: BottomNavigationBar(
// // //           currentIndex: _currentIndex,
// // //           onTap: (index) {
// // //             setState(() {
// // //               _currentIndex = index;
// // //               _animationController.reset();
// // //               _animationController.forward();
// // //             });
// // //           },
// // //           type: BottomNavigationBarType.fixed,
// // //           backgroundColor: Colors.white,
// // //           selectedItemColor: Color(0xFF6D28D9),
// // //           unselectedItemColor: Colors.grey[600],
// // //           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
// // //           unselectedLabelStyle: TextStyle(fontSize: 12),
// // //           items: [
// // //             BottomNavigationBarItem(
// // //               icon: Icon(Icons.home_rounded),
// // //               activeIcon: Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               label: 'Home',
// // //             ),
// // //             BottomNavigationBarItem(
// // //               icon: Icon(Icons.handyman_rounded),
// // //               activeIcon: Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               label: 'Services',
// // //             ),
// // //             BottomNavigationBarItem(
// // //               icon: Icon(Icons.history_rounded),
// // //               activeIcon: Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               label: 'History',
// // //             ),
// // //             BottomNavigationBarItem(
// // //               icon: Icon(Icons.security_rounded),
// // //               activeIcon: Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               label: 'Insurance',
// // //             ),
// // //             BottomNavigationBarItem(
// // //               icon: Icon(Icons.person_rounded),
// // //               activeIcon: Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// // //                   shape: BoxShape.circle,
// // //                 ),
// // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               label: 'Profile',
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _navigateToIndex(int index) {
// // //     setState(() {
// // //       _currentIndex = index;
// // //     });
// // //     Navigator.pop(context);
// // //   }

// // //   void _showSpareParts() {
// // //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SparePartsStore()));
// // //     Navigator.pop(context);
// // //   }

// // //   // FIXED LOGOUT FUNCTION - 100% WORKING
// // //   void _logout() async {
// // //     print('🚪 Logout button pressed...');

// // //     // Close drawer first
// // //     Navigator.pop(context);

// // //     // Show confirmation dialog
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: Text('Logout Confirmation'),
// // //           content: Text('Are you sure you want to logout?'),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.of(context).pop(); // Close dialog
// // //                 print('❌ Logout cancelled by user');
// // //               },
// // //               child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// // //             ),
// // //             TextButton(
// // //               onPressed: () async {
// // //                 Navigator.of(context).pop(); // Close dialog
// // //                 print('✅ User confirmed logout');

// // //                 try {
// // //                   // Show loading
// // //                   showDialog(
// // //                     context: context,
// // //                     barrierDismissible: false,
// // //                     builder: (BuildContext context) {
// // //                       return Dialog(
// // //                         child: Padding(
// // //                           padding: EdgeInsets.all(20),
// // //                           child: Row(
// // //                             mainAxisSize: MainAxisSize.min,
// // //                             children: [
// // //                               CircularProgressIndicator(),
// // //                               SizedBox(width: 20),
// // //                               Text("Logging out..."),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       );
// // //                     },
// // //                   );

// // //                   // 1. Clear shared preferences
// // //                   print('🗑️ Clearing shared preferences...');
// // //                   await AuthService.clearLoginData();

// // //                   // 2. Sign out from Firebase
// // //                   print('🔥 Signing out from Firebase...');
// // //                   await FirebaseAuth.instance.signOut();

// // //                   // 3. Close loading dialog
// // //                   Navigator.of(context).pop();

// // //                   // 4. Navigate to login page and remove all routes
// // //                   print('🔄 Navigating to login page...');
// // //                   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
// // //                     MaterialPageRoute(builder: (context) => VehicleLoginPage()),
// // //                     (Route<dynamic> route) => false,
// // //                   );

// // //                   print('🎉 Logout completed successfully!');

// // //                 } catch (e) {
// // //                   print('❌ Error during logout: $e');

// // //                   // Close loading dialog if still open
// // //                   if (Navigator.canPop(context)) {
// // //                     Navigator.of(context).pop();
// // //                   }

// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                       content: Text('Logout failed. Please try again.'),
// // //                       backgroundColor: Colors.red,
// // //                     ),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text('Logout', style: TextStyle(color: Colors.red)),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // // Enhanced Home Screen with Insurance Integration
// // // class EnhancedHomeScreenWithInsurance extends StatelessWidget {
// // //   final Map<String, dynamic> userData;
// // //   final List<Map<String, dynamic>> insuranceRequests;
// // //   final Position? currentPosition;
// // //   final String currentLocation;
// // //   final bool locationLoading;
// // //   final VoidCallback onGarageServiceTap;
// // //   final VoidCallback onTowServiceTap;

// // //   const EnhancedHomeScreenWithInsurance({
// // //     super.key,
// // //     required this.userData,
// // //     required this.insuranceRequests,
// // //     required this.currentPosition,
// // //     required this.currentLocation,
// // //     required this.locationLoading,
// // //     required this.onGarageServiceTap,
// // //     required this.onTowServiceTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SingleChildScrollView(
// // //       padding: EdgeInsets.all(16),
// // //       child: Column(
// // //         children: [
// // //           _buildWelcomeCard(),
// // //           SizedBox(height: 20),
// // //           _buildLocationCard(),
// // //           SizedBox(height: 20),
// // //           _buildQuickActions(context),
// // //           SizedBox(height: 20),
// // //           _buildInsuranceReminder(context),
// // //           SizedBox(height: 20),
// // //           _buildQuickStats(),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildWelcomeCard() {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           begin: Alignment.topLeft,
// // //           end: Alignment.bottomRight,
// // //           colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// // //         ),
// // //         borderRadius: BorderRadius.circular(20),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Color(0xFF6D28D9).withOpacity(0.3),
// // //             blurRadius: 20,
// // //             offset: Offset(0, 8),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               CircleAvatar(
// // //                 backgroundColor: Colors.white,
// // //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// // //               ),
// // //               SizedBox(width: 12),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Welcome back, ${userData['name'].split(' ')[0]}! 👋',
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                     Text(
// // //                       'Your ${userData['plan']} is active',
// // //                       style: TextStyle(color: Colors.white70),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           SizedBox(height: 15),
// // //           Container(
// // //             padding: EdgeInsets.all(12),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white.withOpacity(0.1),
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
// // //                 SizedBox(width: 8),
// // //                 Text(
// // //                   '${userData['points']} Reward Points',
// // //                   style: TextStyle(color: Colors.white),
// // //                 ),
// // //                 Spacer(),
// // //                 Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
// // //                 SizedBox(width: 4),
// // //                 Text(
// // //                   'Next: ${userData['nextService']}',
// // //                   style: TextStyle(color: Colors.white70, fontSize: 12),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildLocationCard() {
// // //     return Card(
// // //       elevation: 3,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Row(
// // //           children: [
// // //             Icon(
// // //               Icons.location_on,
// // //               color: Color(0xFF6D28D9),
// // //               size: 24,
// // //             ),
// // //             SizedBox(width: 12),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'Current Location',
// // //                     style: TextStyle(
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.w500,
// // //                       color: Colors.grey[700],
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 4),
// // //                   locationLoading
// // //                       ? Row(
// // //                           children: [
// // //                             SizedBox(
// // //                               width: 16,
// // //                               height: 16,
// // //                               child: CircularProgressIndicator(strokeWidth: 2),
// // //                             ),
// // //                             SizedBox(width: 8),
// // //                             Text(
// // //                               'Fetching location...',
// // //                               style: TextStyle(
// // //                                 fontSize: 12,
// // //                                 color: Colors.grey[500],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         )
// // //                       : Text(
// // //                           currentLocation,
// // //                           style: TextStyle(
// // //                             fontSize: 12,
// // //                             color: Colors.grey[600],
// // //                           ),
// // //                         ),
// // //                 ],
// // //               ),
// // //             ),
// // //             if (currentPosition != null)
// // //               Icon(
// // //                 Icons.check_circle,
// // //                 color: Colors.green,
// // //                 size: 20,
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildQuickActions(BuildContext context) {
// // //     return Row(
// // //       children: [
// // //         Expanded(
// // //           child: _buildQuickActionItem(
// // //             icon: Icons.handyman_rounded,
// // //             title: 'Garage Service',
// // //             color: Color(0xFF6D28D9),
// // //             onTap: onGarageServiceTap,
// // //           ),
// // //         ),
// // //         SizedBox(width: 12),
// // //         Expanded(
// // //           child: _buildQuickActionItem(
// // //             icon: Icons.security_rounded,
// // //             title: 'Insurance',
// // //             color: Colors.purple,
// // //             onTap: () => Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // //             ),
// // //           ),
// // //         ),
// // //         SizedBox(width: 12),
// // //         Expanded(
// // //           child: _buildQuickActionItem(
// // //             icon: Icons.local_shipping_rounded,
// // //             title: 'Tow Service',
// // //             color: Colors.blue,
// // //             onTap: onTowServiceTap,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildQuickActionItem({
// // //     required IconData icon,
// // //     required String title,
// // //     required Color color,
// // //     VoidCallback? onTap,
// // //   }) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: Container(
// // //         padding: EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(15),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.grey.withOpacity(0.1),
// // //               blurRadius: 10,
// // //               offset: Offset(0, 3),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             Container(
// // //               padding: EdgeInsets.all(8),
// // //               decoration: BoxDecoration(
// // //                 color: color.withOpacity(0.1),
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(icon, color: color, size: 20),
// // //             ),
// // //             SizedBox(height: 8),
// // //             Text(
// // //               title,
// // //               style: TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: Colors.grey[700],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInsuranceReminder(BuildContext context) {
// // //     final activePolicy = insuranceRequests.firstWhere(
// // //       (policy) => policy['status'] == 'Active',
// // //       orElse: () => {},
// // //     );

// // //     if (activePolicy.isEmpty) {
// // //       return Container(
// // //         padding: EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Colors.orange[50],
// // //           borderRadius: BorderRadius.circular(15),
// // //           border: Border.all(color: Colors.orange),
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Icon(Icons.warning_amber_rounded, color: Colors.orange),
// // //             SizedBox(width: 12),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'No Active Insurance',
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.orange[800],
// // //                     ),
// // //                   ),
// // //                   Text(
// // //                     'Get your vehicle insured today',
// // //                     style: TextStyle(color: Colors.orange[700], fontSize: 12),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () => Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// // //               ),
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.orange,
// // //                 foregroundColor: Colors.white,
// // //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //               ),
// // //               child: Text('Get Insurance'),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }

// // //     return Container();
// // //   }

// // //   Widget _buildQuickStats() {
// // //     return Row(
// // //       children: [
// // //         Expanded(
// // //           child: _buildStatCard(
// // //             title: 'Services Used',
// // //             value: '3',
// // //             subtitle: 'This month',
// // //             color: Color(0xFF6D28D9),
// // //           ),
// // //         ),
// // //         SizedBox(width: 12),
// // //         Expanded(
// // //           child: _buildStatCard(
// // //             title: 'Insurance',
// // //             value: 'Active',
// // //             subtitle: 'Comprehensive',
// // //             color: Colors.green,
// // //           ),
// // //         ),
// // //         SizedBox(width: 12),
// // //         Expanded(
// // //           child: _buildStatCard(
// // //             title: 'Savings',
// // //             value: '\$85',
// // //             subtitle: 'Total',
// // //             color: Colors.blue,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildStatCard({
// // //     required String title,
// // //     required String value,
// // //     required String subtitle,
// // //     required Color color,
// // //   }) {
// // //     return Container(
// // //       padding: EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(15),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.withOpacity(0.1),
// // //             blurRadius: 10,
// // //             offset: Offset(0, 3),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             padding: EdgeInsets.all(6),
// // //             decoration: BoxDecoration(
// // //               color: color.withOpacity(0.1),
// // //               borderRadius: BorderRadius.circular(8),
// // //             ),
// // //             child: Icon(Icons.trending_up_rounded, color: color, size: 16),
// // //           ),
// // //           SizedBox(height: 8),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //               color: color,
// // //             ),
// // //           ),
// // //           Text(
// // //             title,
// // //             style: TextStyle(
// // //               fontSize: 12,
// // //               color: Colors.grey[600],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _showComingSoon(BuildContext context, String feature) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text('$feature feature coming soon!'),
// // //         backgroundColor: Color(0xFF6D28D9),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Enhanced Services Screen
// // // class EnhancedServicesScreen extends StatelessWidget {
// // //   final Position? currentPosition;
// // //   final String currentLocation;
// // //   final bool locationLoading;
// // //   final String? userEmail;
// // //   final VoidCallback onTowServiceTap;
// // //   final VoidCallback onGarageServiceTap;

// // //   const EnhancedServicesScreen({
// // //     super.key,
// // //     required this.currentPosition,
// // //     required this.currentLocation,
// // //     required this.locationLoading,
// // //     required this.userEmail,
// // //     required this.onTowServiceTap,
// // //     required this.onGarageServiceTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return CustomScrollView(
// // //       slivers: [
// // //         SliverToBoxAdapter(
// // //           child: Padding(
// // //             padding: EdgeInsets.all(16),
// // //             child: Column(
// // //               children: [
// // //                 _buildLocationCard(),
// // //                 SizedBox(height: 20),
// // //                 _buildEmergencyServices(context),
// // //                 SizedBox(height: 20),
// // //                 Text(
// // //                   'All Services',
// // //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildLocationCard() {
// // //     return Card(
// // //       elevation: 3,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Row(
// // //           children: [
// // //             Icon(
// // //               Icons.location_on,
// // //               color: Color(0xFF6D28D9),
// // //               size: 24,
// // //             ),
// // //             SizedBox(width: 12),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'Current Location',
// // //                     style: TextStyle(
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.w500,
// // //                       color: Colors.grey[700],
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 4),
// // //                   locationLoading
// // //                       ? Row(
// // //                           children: [
// // //                             SizedBox(
// // //                               width: 16,
// // //                               height: 16,
// // //                               child: CircularProgressIndicator(strokeWidth: 2),
// // //                             ),
// // //                             SizedBox(width: 8),
// // //                             Text(
// // //                               'Fetching location...',
// // //                               style: TextStyle(
// // //                                 fontSize: 12,
// // //                                 color: Colors.grey[500],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         )
// // //                       : Text(
// // //                           currentLocation,
// // //                           style: TextStyle(
// // //                             fontSize: 12,
// // //                             color: Colors.grey[600],
// // //                           ),
// // //                         ),
// // //                 ],
// // //               ),
// // //             ),
// // //             if (currentPosition != null)
// // //               Icon(
// // //                 Icons.check_circle,
// // //                 color: Colors.green,
// // //                 size: 20,
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmergencyServices(BuildContext context) {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Emergency Services',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: _buildEmergencyServiceCard(
// // //                     icon: Icons.local_shipping_rounded,
// // //                     title: 'Tow Service',
// // //                     subtitle: 'Vehicle towing',
// // //                     color: Color(0xFF6D28D9),
// // //                     onTap: onTowServiceTap,
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: _buildEmergencyServiceCard(
// // //                     icon: Icons.handyman_rounded,
// // //                     title: 'Garage Service',
// // //                     subtitle: 'Mechanic & repair',
// // //                     color: Color(0xFFF59E0B),
// // //                     onTap: onGarageServiceTap,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmergencyServiceCard({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //     required Color color,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: Container(
// // //         padding: EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: color.withOpacity(0.1),
// // //           borderRadius: BorderRadius.circular(12),
// // //           border: Border.all(color: color.withOpacity(0.3)),
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             Container(
// // //               padding: EdgeInsets.all(12),
// // //               decoration: BoxDecoration(
// // //                 color: color,
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(icon, color: Colors.white, size: 24),
// // //             ),
// // //             SizedBox(height: 8),
// // //             Text(
// // //               title,
// // //               style: TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: color,
// // //               ),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //             Text(
// // //               subtitle,
// // //               style: TextStyle(
// // //                 fontSize: 10,
// // //                 color: Colors.grey[600],
// // //               ),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'dart:async';

// // import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// // import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
// // import 'package:smart_road_app/VehicleOwner/History.dart';
// // import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// // import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
// // import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
// // import 'package:smart_road_app/VehicleOwner/ai.dart';
// // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';

// // // Import the tow service screens
// // import "package:smart_road_app/VehicleOwner/TowRequest.dart";
// // import 'package:smart_road_app/VehicleOwner/nearby_tow_provider_screen.dart';

// // // Insurance Module Classes
// // class InsuranceModule {
// //   static List<Map<String, dynamic>> getInsuranceRequests() {
// //     return [
// //       {
// //         'id': 'INS001',
// //         'policyType': 'Comprehensive',
// //         'status': 'Active',
// //         'expiryDate': '2024-12-31',
// //         'vehicleNumber': 'MH12AB1234',
// //         'provider': 'ABC Insurance Co.',
// //         'premium': '\$450',
// //         'startDate': '2024-01-01',
// //       },
// //       {
// //         'id': 'INS002',
// //         'policyType': 'Third Party',
// //         'status': 'Pending',
// //         'expiryDate': '2024-06-30',
// //         'vehicleNumber': 'MH12CD5678',
// //         'provider': 'XYZ Insurance',
// //         'premium': '\$200',
// //         'startDate': '2024-01-15',
// //       },
// //     ];
// //   }
// // }

// // // Main Dashboard Class
// // class EnhancedVehicleDashboard extends StatefulWidget {
// //   const EnhancedVehicleDashboard({super.key});

// //   @override
// //   _EnhancedVehicleDashboardState createState() =>
// //       _EnhancedVehicleDashboardState();
// // }

// // class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
// //     with SingleTickerProviderStateMixin {
// //   int _currentIndex = 0;
// //   late AnimationController _animationController;
// //   late Animation<double> _scaleAnimation;
// //   late Animation<double> _fadeAnimation;
// //   String? _userEmail;
// //   Position? _currentPosition;
// //   String _currentLocation = 'Fetching location...';
// //   bool _locationLoading = false;
// //   String _locationAddress = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 800),
// //     );
// //     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
// //       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
// //     );
// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
// //     );
// //     _animationController.forward();
// //     _loadUserData();
// //     _initializeLocation();
// //   }

// //   Future<void> _loadUserData() async {
// //     try {
// //       String? userEmail = await AuthService.getUserEmail();
// //       setState(() {
// //         _userEmail = userEmail;
// //       });
// //       print('✅ Dashboard loaded for user: $_userEmail');
// //     } catch (e) {
// //       print('❌ Error loading user data in dashboard: $e');
// //     }
// //   }

// //   Future<void> _initializeLocation() async {
// //     // Check if location service is enabled
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       setState(() {
// //         _currentLocation = 'Location services are disabled';
// //         _locationLoading = false;
// //       });
// //       return;
// //     }

// //     await _getCurrentLocation();
// //   }

// //   Future<void> _getCurrentLocation() async {
// //     setState(() {
// //       _locationLoading = true;
// //     });

// //     try {
// //       // Check and request location permissions
// //       LocationPermission permission = await Geolocator.checkPermission();

// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //         if (permission == LocationPermission.denied) {
// //           setState(() {
// //             _currentLocation = 'Location permission denied';
// //             _locationLoading = false;
// //           });
// //           _showLocationPermissionDialog();
// //           return;
// //         }
// //       }

// //       if (permission == LocationPermission.deniedForever) {
// //         setState(() {
// //           _currentLocation = 'Location permission permanently denied';
// //           _locationLoading = false;
// //         });
// //         _showLocationPermissionDialog();
// //         return;
// //       }

// //       // Get current position with better accuracy and timeout
// //       Position position =
// //           await Geolocator.getCurrentPosition(
// //             desiredAccuracy: LocationAccuracy.best,
// //             timeLimit: Duration(seconds: 15),
// //           ).timeout(
// //             Duration(seconds: 20),
// //             onTimeout: () {
// //               throw TimeoutException('Location request timed out');
// //             },
// //           );

// //       // Get address from coordinates
// //       String address = await _getAddressFromLatLng(position);

// //       setState(() {
// //         _currentPosition = position;
// //         _currentLocation =
// //             '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// //         _locationAddress = address;
// //         _locationLoading = false;
// //       });

// //       print('📍 Location fetched: $_currentLocation');
// //       print('🏠 Address: $address');
// //     } on TimeoutException catch (e) {
// //       print('⏰ Location timeout: $e');
// //       setState(() {
// //         _currentLocation = 'Location timeout. Please try again.';
// //         _locationLoading = false;
// //       });
// //     } catch (e) {
// //       print('❌ Error getting location: $e');
// //       setState(() {
// //         _currentLocation = 'Unable to fetch location: ${e.toString()}';
// //         _locationLoading = false;
// //       });
// //     }
// //   }

// //   Future<String> _getAddressFromLatLng(Position position) async {
// //     try {
// //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //         position.latitude,
// //         position.longitude,
// //       );

// //       if (placemarks.isNotEmpty) {
// //         Placemark place = placemarks.first;
// //         return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
// //       }
// //       return 'Address not available';
// //     } catch (e) {
// //       print('Error getting address: $e');
// //       return 'Address not available';
// //     }
// //   }

// //   void _showLocationPermissionDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Location Permission Required'),
// //           content: Text(
// //             'This app needs location permission to show nearby services. Please enable location permissions in app settings.',
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 Geolocator.openAppSettings();
// //               },
// //               child: Text('Open Settings'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Map<String, dynamic> get _userData {
// //     return {
// //       'name': _userEmail?.split('@').first ?? 'User',
// //       'email': _userEmail ?? 'user@example.com',
// //       'vehicle': 'Toyota Camry 2022',
// //       'plan': 'Gold Plan',
// //       'memberSince': '2023',
// //       'points': 450,
// //       'nextService': '2024-02-20',
// //       'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901'],
// //     };
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: _buildEnhancedAppBar(),
// //       drawer: _buildEnhancedDrawer(),
// //       body: FadeTransition(
// //         opacity: _fadeAnimation,
// //         child: ScaleTransition(
// //           scale: _scaleAnimation,
// //           child: _getCurrentScreen(),
// //         ),
// //       ),
// //       bottomNavigationBar: _buildEnhancedBottomNavigationBar(),
// //     );
// //   }

// //   AppBar _buildEnhancedAppBar() {
// //     return AppBar(
// //       title: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'AutoConnect',
// //             style: TextStyle(
// //               fontWeight: FontWeight.w800,
// //               fontSize: 22,
// //               color: Colors.white,
// //             ),
// //           ),
// //           Text(
// //             'Always here to help',
// //             style: TextStyle(fontSize: 12, color: Colors.white70),
// //           ),
// //         ],
// //       ),
// //       backgroundColor: Color(0xFF6D28D9),
// //       foregroundColor: Colors.white,
// //       elevation: 0,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.only(
// //           bottomLeft: Radius.circular(20),
// //           bottomRight: Radius.circular(20),
// //         ),
// //       ),
// //       actions: [
// //         IconButton(
// //           icon: Icon(Icons.location_on),
// //           onPressed: _getCurrentLocation,
// //           tooltip: 'Refresh Location',
// //         ),
// //         IconButton(
// //           icon: Icon(Icons.auto_awesome),
// //           onPressed: () {
// //             Navigator.of(context).push(
// //               MaterialPageRoute(builder: (context) => VehicleDamageAnalyzer()),
// //             );
// //           },
// //           tooltip: 'AI Assistance',
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildEnhancedDrawer() {
// //     return Drawer(
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// //           ),
// //         ),
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             _buildDrawerHeader(),
// //             _buildDrawerItem(
// //               icon: Icons.dashboard_rounded,
// //               title: 'Dashboard',
// //               onTap: () => _navigateToIndex(0),
// //             ),
// //             _buildDrawerItem(
// //               icon: Icons.security_rounded,
// //               title: 'Insurance',
// //               onTap: () => _navigateToIndex(3),
// //             ),
// //             _buildDrawerItem(
// //               icon: Icons.build_circle_rounded,
// //               title: 'Spare Parts',
// //               onTap: _showSpareParts,
// //             ),
// //             _buildDrawerItem(
// //               icon: Icons.history_rounded,
// //               title: 'Service History',
// //               onTap: () => _navigateToIndex(2),
// //             ),
// //             _buildDrawerItem(
// //               icon: Icons.logout_rounded,
// //               title: 'Logout',
// //               onTap: _logout,
// //               color: Colors.red[300],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDrawerHeader() {
// //     return Container(
// //       padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
// //       decoration: BoxDecoration(color: Color(0xFF5B21B6).withOpacity(0.8)),
// //       child: Column(
// //         children: [
// //           CircleAvatar(
// //             radius: 40,
// //             backgroundColor: Colors.white,
// //             child: Icon(
// //               Icons.person_rounded,
// //               size: 50,
// //               color: Color(0xFF6D28D9),
// //             ),
// //           ),
// //           SizedBox(height: 16),
// //           Text(
// //             _userData['name'],
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           SizedBox(height: 4),
// //           Text(
// //             _userData['email'],
// //             style: TextStyle(color: Colors.white70, fontSize: 14),
// //           ),
// //           SizedBox(height: 8),
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: Colors.amber.withOpacity(0.2),
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(color: Colors.amber),
// //             ),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
// //                 SizedBox(width: 4),
// //                 Text(
// //                   '${_userData['points']} Points',
// //                   style: TextStyle(
// //                     color: Colors.amber,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDrawerItem({
// //     required IconData icon,
// //     required String title,
// //     required VoidCallback onTap,
// //     Color? color,
// //   }) {
// //     return ListTile(
// //       leading: Container(
// //         width: 40,
// //         height: 40,
// //         decoration: BoxDecoration(
// //           color: Colors.white.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Icon(icon, color: color ?? Colors.white70, size: 20),
// //       ),
// //       title: Text(
// //         title,
// //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
// //       ),
// //       onTap: onTap,
// //       hoverColor: Colors.white.withOpacity(0.1),
// //     );
// //   }

// //   Widget _getCurrentScreen() {
// //     switch (_currentIndex) {
// //       case 0:
// //         return EnhancedHomeScreenWithInsurance(
// //           userData: _userData,
// //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// //           currentPosition: _currentPosition,
// //           currentLocation: _currentLocation,
// //           locationAddress: _locationAddress,
// //           locationLoading: _locationLoading,
// //           onGarageServiceTap: _navigateToNearbyGarages,
// //           onTowServiceTap: _navigateToNearbyTowProviders,
// //           onRefreshLocation: _getCurrentLocation,
// //         );
// //       case 1:
// //         return EnhancedServicesScreen(
// //           currentPosition: _currentPosition,
// //           currentLocation: _currentLocation,
// //           locationAddress: _locationAddress,
// //           locationLoading: _locationLoading,
// //           userEmail: _userEmail,
// //           onTowServiceTap: _navigateToNearbyTowProviders,
// //           onGarageServiceTap: _navigateToNearbyGarages,
// //           onRefreshLocation: _getCurrentLocation,
// //         );
// //       case 2:
// //         return EnhancedHistoryScreen(
// //           userEmail: _userEmail ?? 'avi@gmail.com',
// //           serviceHistory: [],
// //         );
// //       case 3:
// //         return RequestInsuranceScreen();
// //       case 4:
// //         return EnhancedProfileScreen(
// //           userEmail: _userEmail ?? 'avi@gmail.com',
// //           serviceHistory: [],
// //         );
// //       default:
// //         return EnhancedHomeScreenWithInsurance(
// //           userData: _userData,
// //           insuranceRequests: InsuranceModule.getInsuranceRequests(),
// //           currentPosition: _currentPosition,
// //           currentLocation: _currentLocation,
// //           locationAddress: _locationAddress,
// //           locationLoading: _locationLoading,
// //           onGarageServiceTap: _navigateToNearbyGarages,
// //           onTowServiceTap: _navigateToNearbyTowProviders,
// //           onRefreshLocation: _getCurrentLocation,
// //         );
// //     }
// //   }

// //   void _navigateToNearbyGarages() {
// //     if (_currentPosition == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please wait for location to load'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => NearbyGaragesScreen(
// //           userLocation: _currentPosition!,
// //           userEmail: _userEmail,
// //         ),
// //       ),
// //     );
// //   }

// //   void _navigateToNearbyTowProviders() {
// //     if (_currentPosition == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please wait for location to load'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => NearbyTowProvidersScreen(
// //           userLocation: _currentPosition!,
// //           userEmail: _userEmail,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEnhancedBottomNavigationBar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(20),
// //           topRight: Radius.circular(20),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.purple.withOpacity(0.1),
// //             blurRadius: 20,
// //             offset: Offset(0, -5),
// //           ),
// //         ],
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(20),
// //           topRight: Radius.circular(20),
// //         ),
// //         child: BottomNavigationBar(
// //           currentIndex: _currentIndex,
// //           onTap: (index) {
// //             setState(() {
// //               _currentIndex = index;
// //               _animationController.reset();
// //               _animationController.forward();
// //             });
// //           },
// //           type: BottomNavigationBarType.fixed,
// //           backgroundColor: Colors.white,
// //           selectedItemColor: Color(0xFF6D28D9),
// //           unselectedItemColor: Colors.grey[600],
// //           selectedLabelStyle: TextStyle(
// //             fontWeight: FontWeight.w600,
// //             fontSize: 12,
// //           ),
// //           unselectedLabelStyle: TextStyle(fontSize: 12),
// //           items: [
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.home_rounded),
// //               activeIcon: Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               label: 'Home',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.handyman_rounded),
// //               activeIcon: Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               label: 'Services',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.history_rounded),
// //               activeIcon: Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               label: 'History',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.security_rounded),
// //               activeIcon: Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               label: 'Insurance',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.person_rounded),
// //               activeIcon: Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF6D28D9).withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               label: 'Profile',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _navigateToIndex(int index) {
// //     setState(() {
// //       _currentIndex = index;
// //     });
// //     Navigator.pop(context);
// //   }

// //   void _showSpareParts() {
// //     Navigator.of(
// //       context,
// //     ).push(MaterialPageRoute(builder: (context) => SparePartsStore()));
// //     Navigator.pop(context);
// //   }

// //   void _logout() async {
// //     print('🚪 Logout button pressed...');

// //     Navigator.pop(context);

// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Logout Confirmation'),
// //           content: Text('Are you sure you want to logout?'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 print('❌ Logout cancelled by user');
// //               },
// //               child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 Navigator.of(context).pop();
// //                 print('✅ User confirmed logout');

// //                 try {
// //                   showDialog(
// //                     context: context,
// //                     barrierDismissible: false,
// //                     builder: (BuildContext context) {
// //                       return Dialog(
// //                         child: Padding(
// //                           padding: EdgeInsets.all(20),
// //                           child: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               CircularProgressIndicator(),
// //                               SizedBox(width: 20),
// //                               Text("Logging out..."),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   );

// //                   print('🗑️ Clearing shared preferences...');
// //                   await AuthService.clearLoginData();

// //                   print('🔥 Signing out from Firebase...');
// //                   await FirebaseAuth.instance.signOut();

// //                   Navigator.of(context).pop();

// //                   print('🔄 Navigating to login page...');
// //                   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
// //                     MaterialPageRoute(builder: (context) => VehicleLoginPage()),
// //                     (Route<dynamic> route) => false,
// //                   );

// //                   print('🎉 Logout completed successfully!');
// //                 } catch (e) {
// //                   print('❌ Error during logout: $e');

// //                   if (Navigator.canPop(context)) {
// //                     Navigator.of(context).pop();
// //                   }

// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text('Logout failed. Please try again.'),
// //                       backgroundColor: Colors.red,
// //                     ),
// //                   );
// //                 }
// //               },
// //               child: Text('Logout', style: TextStyle(color: Colors.red)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // // Enhanced Home Screen with Insurance Integration
// // class EnhancedHomeScreenWithInsurance extends StatelessWidget {
// //   final Map<String, dynamic> userData;
// //   final List<Map<String, dynamic>> insuranceRequests;
// //   final Position? currentPosition;
// //   final String currentLocation;
// //   final String locationAddress;
// //   final bool locationLoading;
// //   final VoidCallback onGarageServiceTap;
// //   final VoidCallback onTowServiceTap;
// //   final VoidCallback onRefreshLocation;

// //   const EnhancedHomeScreenWithInsurance({
// //     super.key,
// //     required this.userData,
// //     required this.insuranceRequests,
// //     required this.currentPosition,
// //     required this.currentLocation,
// //     required this.locationAddress,
// //     required this.locationLoading,
// //     required this.onGarageServiceTap,
// //     required this.onTowServiceTap,
// //     required this.onRefreshLocation,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildWelcomeCard(),
// //           SizedBox(height: 20),
// //           _buildLocationCard(),
// //           SizedBox(height: 20),
// //           _buildQuickActions(context),
// //           SizedBox(height: 20),
// //           _buildInsuranceReminder(context),
// //           SizedBox(height: 20),
// //           _buildQuickStats(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildWelcomeCard() {
// //     return Container(
// //       width: double.infinity,
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Color(0xFF6D28D9).withOpacity(0.3),
// //             blurRadius: 20,
// //             offset: Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               CircleAvatar(
// //                 backgroundColor: Colors.white,
// //                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// //               ),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Welcome back, ${userData['name'].split(' ')[0]}! 👋',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     Text(
// //                       'Your ${userData['plan']} is active',
// //                       style: TextStyle(color: Colors.white70),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 15),
// //           Container(
// //             padding: EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Row(
// //               children: [
// //                 Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   '${userData['points']} Reward Points',
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //                 Spacer(),
// //                 Icon(
// //                   Icons.calendar_today_rounded,
// //                   color: Colors.white70,
// //                   size: 14,
// //                 ),
// //                 SizedBox(width: 4),
// //                 Text(
// //                   'Next: ${userData['nextService']}',
// //                   style: TextStyle(color: Colors.white70, fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLocationCard() {
// //     return Card(
// //       elevation: 3,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 24),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: Text(
// //                     'Current Location',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.grey[700],
// //                     ),
// //                   ),
// //                 ),
// //                 if (currentPosition != null)
// //                   Icon(Icons.check_circle, color: Colors.green, size: 20),
// //               ],
// //             ),
// //             SizedBox(height: 8),
// //             locationLoading
// //                 ? Row(
// //                     children: [
// //                       SizedBox(
// //                         width: 16,
// //                         height: 16,
// //                         child: CircularProgressIndicator(strokeWidth: 2),
// //                       ),
// //                       SizedBox(width: 8),
// //                       Text(
// //                         'Fetching location...',
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[500]),
// //                       ),
// //                     ],
// //                   )
// //                 : Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         currentLocation,
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.grey[600],
// //                           fontFamily: 'Monospace',
// //                         ),
// //                       ),
// //                       if (locationAddress.isNotEmpty)
// //                         Padding(
// //                           padding: EdgeInsets.only(top: 4),
// //                           child: Text(
// //                             locationAddress,
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.grey[700],
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                             maxLines: 2,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //             SizedBox(height: 8),
// //             ElevatedButton.icon(
// //               onPressed: onRefreshLocation,
// //               icon: Icon(Icons.refresh, size: 16),
// //               label: Text('Refresh Location'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Color(0xFF6D28D9),
// //                 foregroundColor: Colors.white,
// //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                 textStyle: TextStyle(fontSize: 12),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildQuickActions(BuildContext context) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: _buildQuickActionItem(
// //             icon: Icons.handyman_rounded,
// //             title: 'Garage Service',
// //             color: Color(0xFF6D28D9),
// //             onTap: onGarageServiceTap,
// //           ),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(
// //           child: _buildQuickActionItem(
// //             icon: Icons.security_rounded,
// //             title: 'Insurance',
// //             color: Colors.purple,
// //             onTap: () => Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(
// //           child: _buildQuickActionItem(
// //             icon: Icons.local_shipping_rounded,
// //             title: 'Tow Service',
// //             color: Colors.blue,
// //             onTap: onTowServiceTap,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildQuickActionItem({
// //     required IconData icon,
// //     required String title,
// //     required Color color,
// //     VoidCallback? onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(15),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               blurRadius: 10,
// //               offset: Offset(0, 3),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: color.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(icon, color: color, size: 20),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.grey[700],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInsuranceReminder(BuildContext context) {
// //     final activePolicy = insuranceRequests.firstWhere(
// //       (policy) => policy['status'] == 'Active',
// //       orElse: () => {},
// //     );

// //     if (activePolicy.isEmpty) {
// //       return Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.orange[50],
// //           borderRadius: BorderRadius.circular(15),
// //           border: Border.all(color: Colors.orange),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(Icons.warning_amber_rounded, color: Colors.orange),
// //             SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'No Active Insurance',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.orange[800],
// //                     ),
// //                   ),
// //                   Text(
// //                     'Get your vehicle insured today',
// //                     style: TextStyle(color: Colors.orange[700], fontSize: 12),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => RequestInsuranceScreen(),
// //                 ),
// //               ),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.orange,
// //                 foregroundColor: Colors.white,
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //               ),
// //               child: Text('Get Insurance'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return Container();
// //   }

// //   Widget _buildQuickStats() {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: _buildStatCard(
// //             title: 'Services Used',
// //             value: '3',
// //             subtitle: 'This month',
// //             color: Color(0xFF6D28D9),
// //           ),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(
// //           child: _buildStatCard(
// //             title: 'Insurance',
// //             value: 'Active',
// //             subtitle: 'Comprehensive',
// //             color: Colors.green,
// //           ),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(
// //           child: _buildStatCard(
// //             title: 'Savings',
// //             value: '\$85',
// //             subtitle: 'Total',
// //             color: Colors.blue,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStatCard({
// //     required String title,
// //     required String value,
// //     required String subtitle,
// //     required Color color,
// //   }) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: EdgeInsets.all(6),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Icon(Icons.trending_up_rounded, color: color, size: 16),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //           Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // Enhanced Services Screen
// // class EnhancedServicesScreen extends StatelessWidget {
// //   final Position? currentPosition;
// //   final String currentLocation;
// //   final String locationAddress;
// //   final bool locationLoading;
// //   final String? userEmail;
// //   final VoidCallback onTowServiceTap;
// //   final VoidCallback onGarageServiceTap;
// //   final VoidCallback onRefreshLocation;

// //   const EnhancedServicesScreen({
// //     super.key,
// //     required this.currentPosition,
// //     required this.currentLocation,
// //     required this.locationAddress,
// //     required this.locationLoading,
// //     required this.userEmail,
// //     required this.onTowServiceTap,
// //     required this.onGarageServiceTap,
// //     required this.onRefreshLocation,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return CustomScrollView(
// //       slivers: [
// //         SliverToBoxAdapter(
// //           child: Padding(
// //             padding: EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 _buildLocationCard(),
// //                 SizedBox(height: 20),
// //                 _buildEmergencyServices(context),
// //                 SizedBox(height: 20),
// //                 Text(
// //                   'All Services',
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildLocationCard() {
// //     return Card(
// //       elevation: 3,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 24),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: Text(
// //                     'Current Location',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.grey[700],
// //                     ),
// //                   ),
// //                 ),
// //                 if (currentPosition != null)
// //                   Icon(Icons.check_circle, color: Colors.green, size: 20),
// //               ],
// //             ),
// //             SizedBox(height: 8),
// //             locationLoading
// //                 ? Row(
// //                     children: [
// //                       SizedBox(
// //                         width: 16,
// //                         height: 16,
// //                         child: CircularProgressIndicator(strokeWidth: 2),
// //                       ),
// //                       SizedBox(width: 8),
// //                       Text(
// //                         'Fetching location...',
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[500]),
// //                       ),
// //                     ],
// //                   )
// //                 : Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         currentLocation,
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.grey[600],
// //                           fontFamily: 'Monospace',
// //                         ),
// //                       ),
// //                       if (locationAddress.isNotEmpty)
// //                         Padding(
// //                           padding: EdgeInsets.only(top: 4),
// //                           child: Text(
// //                             locationAddress,
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.grey[700],
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                             maxLines: 2,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //             SizedBox(height: 8),
// //             ElevatedButton.icon(
// //               onPressed: onRefreshLocation,
// //               icon: Icon(Icons.refresh, size: 16),
// //               label: Text('Refresh Location'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Color(0xFF6D28D9),
// //                 foregroundColor: Colors.white,
// //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                 textStyle: TextStyle(fontSize: 12),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmergencyServices(BuildContext context) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Emergency Services',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF6D28D9),
// //               ),
// //             ),
// //             SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: _buildEmergencyServiceCard(
// //                     icon: Icons.local_shipping_rounded,
// //                     title: 'Tow Service',
// //                     subtitle: 'Vehicle towing',
// //                     color: Color(0xFF6D28D9),
// //                     onTap: onTowServiceTap,
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: _buildEmergencyServiceCard(
// //                     icon: Icons.handyman_rounded,
// //                     title: 'Garage Service',
// //                     subtitle: 'Mechanic & repair',
// //                     color: Color(0xFFF59E0B),
// //                     onTap: onGarageServiceTap,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmergencyServiceCard({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //     required Color color,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: color.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: color.withOpacity(0.3)),
// //         ),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: color,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(icon, color: Colors.white, size: 24),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //                 color: color,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             Text(
// //               subtitle,
// //               style: TextStyle(fontSize: 10, color: Colors.grey[600]),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:smart_road_app/core/language/app_localizations.dart';
// import 'package:smart_road_app/core/language/language_selector.dart';
// import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
// import 'package:smart_road_app/VehicleOwner/History.dart';
// import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
// import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
// import 'package:smart_road_app/VehicleOwner/ai.dart';
// import 'package:smart_road_app/controller/sharedprefrence.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:smart_road_app/VehicleOwner/nearby_tow_provider_screen.dart';
// import 'package:smart_road_app/VehicleOwner/notification.dart';

// // Insurance Module Classes
// class InsuranceModule {
//   static List<Map<String, dynamic>> getInsuranceRequests() {
//     return [
//       {
//         'id': 'INS001',
//         'policyType': 'Comprehensive',
//         'status': 'Active',
//         'expiryDate': '2024-12-31',
//         'vehicleNumber': 'MH12AB1234',
//         'provider': 'ABC Insurance Co.',
//         'premium': '\$450',
//         'startDate': '2024-01-01',
//       },
//       {
//         'id': 'INS002',
//         'policyType': 'Third Party',
//         'status': 'Pending',
//         'expiryDate': '2024-06-30',
//         'vehicleNumber': 'MH12CD5678',
//         'provider': 'XYZ Insurance',
//         'premium': '\$200',
//         'startDate': '2024-01-15',
//       },
//     ];
//   }
// }

// // Notification Service for Owner
// class OwnerNotificationService {
//   static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

//   // Get unread notification count for user
//   static Stream<int> getUnreadNotificationCount(String userId) {
//     return _dbRef
//         .child('notifications')
//         .child(userId.replaceAll(RegExp(r'[\.#\$\[\]]'), '_'))
//         .orderByChild('read')
//         .equalTo(false)
//         .onValue
//         .map((event) {
//       if (event.snapshot.value == null) return 0;
//       final Map<dynamic, dynamic> notifications = event.snapshot.value as Map<dynamic, dynamic>;
//       return notifications.length;
//     });
//   }

//   // Mark notification as read
//   static Future<void> markAsRead(String userId, String notificationId) async {
//     await _dbRef
//         .child('notifications')
//         .child(userId.replaceAll(RegExp(r'[\.#\$\[\]]'), '_'))
//         .child(notificationId)
//         .update({'read': true});
//   }
// }

// // Main Dashboard Class
// class EnhancedVehicleDashboard extends StatefulWidget {
//   const EnhancedVehicleDashboard({super.key});

//   @override
//   _EnhancedVehicleDashboardState createState() => _EnhancedVehicleDashboardState();
// }

// class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
//     with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   String? _userEmail;
//   String? _userId;
//   Position? _currentPosition;
//   String _currentLocation = 'Fetching location...';
//   bool _locationLoading = false;
//   String _locationAddress = '';
//   int _unreadNotifications = 0;
//   StreamSubscription<int>? _notificationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//     _loadUserData();
//     _initializeLocation();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       final user = FirebaseAuth.instance.currentUser;

//       setState(() {
//         _userEmail = userEmail;
//         _userId = user?.uid;
//       });

//       print('✅ Dashboard loaded for user: $_userEmail');

//       // Start listening to notifications
//       if (_userId != null) {
//         _startNotificationListener();
//       }
//     } catch (e) {
//       print('❌ Error loading user data in dashboard: $e');
//     }
//   }

//   void _startNotificationListener() {
//     _notificationSubscription?.cancel();
//     _notificationSubscription = OwnerNotificationService
//         .getUnreadNotificationCount(_userId!)
//         .listen((count) {
//       if (mounted) {
//         setState(() {
//           _unreadNotifications = count;
//         });
//       }
//     });
//   }

//   Future<void> _initializeLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _currentLocation = 'Location services are disabled';
//         _locationLoading = false;
//       });
//       return;
//     }
//     await _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _locationLoading = true;
//     });

//     try {
//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _currentLocation = 'Location permission denied';
//             _locationLoading = false;
//           });
//           _showLocationPermissionDialog();
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _currentLocation = 'Location permission permanently denied';
//           _locationLoading = false;
//         });
//         _showLocationPermissionDialog();
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//         timeLimit: Duration(seconds: 15),
//       ).timeout(Duration(seconds: 20), onTimeout: () {
//         throw TimeoutException('Location request timed out');
//       });

//       String address = await _getAddressFromLatLng(position);

//       setState(() {
//         _currentPosition = position;
//         _currentLocation = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
//         _locationAddress = address;
//         _locationLoading = false;
//       });

//     } on TimeoutException catch (e) {
//       print('⏰ Location timeout: $e');
//       setState(() {
//         _currentLocation = 'Location timeout. Please try again.';
//         _locationLoading = false;
//       });
//     } catch (e) {
//       print('❌ Error getting location: $e');
//       setState(() {
//         _currentLocation = 'Unable to fetch location: ${e.toString()}';
//         _locationLoading = false;
//       });
//     }
//   }

//   Future<String> _getAddressFromLatLng(Position position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
//       }
//       return 'Address not available';
//     } catch (e) {
//       print('Error getting address: $e');
//       return 'Address not available';
//     }
//   }

//   void _showLocationPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final localizations = AppLocalizations.of(context);
//         return AlertDialog(
//           title: Text(localizations?.translate('location_permission_required') ?? 'Location Permission Required'),
//           content: Text(localizations?.translate('location_permission_message') ?? 'This app needs location permission to show nearby services. Please enable location permissions in app settings.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(localizations?.translate('cancel') ?? 'Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Geolocator.openAppSettings();
//               },
//               child: Text(localizations?.translate('open_settings') ?? 'Open Settings'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _navigateToNotifications() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => NotificationsPage()),
//     );
//   }

//   Map<String, dynamic> get _userData {
//     return {
//       'name': _userEmail?.split('@').first ?? 'User',
//       'email': _userEmail ?? 'user@example.com',
//       'vehicle': 'Toyota Camry 2022',
//       'plan': 'Gold Plan',
//       'memberSince': '2023',
//       'points': 450,
//       'nextService': '2024-02-20',
//       'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901']
//     };
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _notificationSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _buildEnhancedAppBar(localizations),
//       drawer: _buildEnhancedDrawer(localizations),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: _getCurrentScreen(localizations),
//         ),
//       ),
//       bottomNavigationBar: _buildEnhancedBottomNavigationBar(localizations),
//     );
//   }

//   AppBar _buildEnhancedAppBar(AppLocalizations? localizations) {
//     return AppBar(
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'AutoConnect',
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               fontSize: 22,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             localizations?.translate('always_here_to_help') ?? 'Always here to help',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color(0xFF6D28D9),
//       foregroundColor: Colors.white,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       actions: [
//         // NOTIFICATION ICON WITH BADGE
//         Stack(
//           children: [
//             IconButton(
//               icon: Icon(Icons.notifications_outlined),
//               onPressed: _navigateToNotifications,
//               tooltip: localizations?.translate('notifications') ?? 'Notifications',
//             ),
//             if (_unreadNotifications > 0)
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   constraints: BoxConstraints(
//                     minWidth: 16,
//                     minHeight: 16,
//                   ),
//                   child: Text(
//                     _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         IconButton(
//           icon: Icon(Icons.location_on),
//           onPressed: _getCurrentLocation,
//           tooltip: localizations?.translate('refresh_location') ?? 'Refresh Location',
//         ),
//         IconButton(
//           icon: Icon(Icons.auto_awesome),
//           onPressed: (){
//             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdvancedAIAssistantScreen()));
//           },
//           tooltip: 'AI Assistance',
//         ),
//         LanguageSelector(),
//       ],
//     );
//   }

//   Widget _buildEnhancedDrawer(AppLocalizations? localizations) {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
//           ),
//         ),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             _buildDrawerHeader(localizations),
//             _buildDrawerItem(
//               icon: Icons.dashboard_rounded,
//               title: localizations?.dashboard ?? 'Dashboard',
//               onTap: () => _navigateToIndex(0),
//             ),
//             _buildDrawerItem(
//               icon: Icons.notifications_rounded,
//               title: '${localizations?.translate('notifications') ?? 'Notifications'} ${_unreadNotifications > 0 ? '($_unreadNotifications)' : ''}',
//               onTap: _navigateToNotifications,
//             ),
//             _buildDrawerItem(
//               icon: Icons.security_rounded,
//               title: localizations?.translate('insurance') ?? 'Insurance',
//               onTap: () => _navigateToIndex(3),
//             ),
//             _buildDrawerItem(
//               icon: Icons.build_circle_rounded,
//               title: localizations?.translate('spare_parts') ?? 'Spare Parts',
//               onTap: _showSpareParts,
//             ),
//             _buildDrawerItem(
//               icon: Icons.history_rounded,
//               title: localizations?.history ?? 'Service History',
//               onTap: () => _navigateToIndex(2),
//             ),
//             _buildDrawerItem(
//               icon: Icons.logout_rounded,
//               title: localizations?.logout ?? 'Logout',
//               onTap: _logout,
//               color: Colors.red[300],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(AppLocalizations? localizations) {
//     return Container(
//       padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
//       decoration: BoxDecoration(
//         color: Color(0xFF5B21B6).withOpacity(0.8),
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.white,
//             child: Icon(
//               Icons.person_rounded,
//               size: 50,
//               color: Color(0xFF6D28D9),
//             ),
//           ),
//           SizedBox(height: 16),
//           Text(
//             _userData['name'],
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             _userData['email'],
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           SizedBox(height: 8),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.amber.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.amber),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
//                 SizedBox(width: 4),
//                 Text(
//                   '${_userData['points']} ${localizations?.translate('reward_points') ?? 'Points'}',
//                   style: TextStyle(
//                     color: Colors.amber,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Notification badge in drawer header
//           if (_unreadNotifications > 0) ...[
//             SizedBox(height: 8),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.red),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.notifications_active, color: Colors.red, size: 16),
//                   SizedBox(width: 4),
//                   Text(
//                     '$_unreadNotifications ${localizations?.translate('unread_notifications') ?? 'unread'}',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: color ?? Colors.white70, size: 20),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//       hoverColor: Colors.white.withOpacity(0.1),
//     );
//   }

//   Widget _getCurrentScreen(AppLocalizations? localizations) {
//     switch (_currentIndex) {
//       case 0:
//         return EnhancedHomeScreenWithInsurance(
//           userData: _userData,
//           insuranceRequests: InsuranceModule.getInsuranceRequests(),
//           currentPosition: _currentPosition,
//           currentLocation: _currentLocation,
//           locationAddress: _locationAddress,
//           locationLoading: _locationLoading,
//           onGarageServiceTap: _navigateToNearbyGarages,
//           onTowServiceTap: _navigateToNearbyTowProviders,
//           onRefreshLocation: _getCurrentLocation,
//           unreadNotifications: _unreadNotifications,
//           onNotificationTap: _navigateToNotifications,
//         );
//       case 1:
//         return EnhancedServicesScreen(
//           currentPosition: _currentPosition,
//           currentLocation: _currentLocation,
//           locationAddress: _locationAddress,
//           locationLoading: _locationLoading,
//           userEmail: _userEmail,
//           onTowServiceTap: _navigateToNearbyTowProviders,
//           onGarageServiceTap: _navigateToNearbyGarages,
//           onRefreshLocation: _getCurrentLocation,
//           unreadNotifications: _unreadNotifications,
//           onNotificationTap: _navigateToNotifications,
//         );
//       case 2:
//         return EnhancedHistoryScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
//       case 3:
//         return RequestInsuranceScreen();
//       case 4:
//         return EnhancedProfileScreen(userEmail: _userEmail ?? 'avi@gmail.com', serviceHistory: []);
//       default:
//         return EnhancedHomeScreenWithInsurance(
//           userData: _userData,
//           insuranceRequests: InsuranceModule.getInsuranceRequests(),
//           currentPosition: _currentPosition,
//           currentLocation: _currentLocation,
//           locationAddress: _locationAddress,
//           locationLoading: _locationLoading,
//           onGarageServiceTap: _navigateToNearbyGarages,
//           onTowServiceTap: _navigateToNearbyTowProviders,
//           onRefreshLocation: _getCurrentLocation,
//           unreadNotifications: _unreadNotifications,
//           onNotificationTap: _navigateToNotifications,
//         );
//     }
//   }

//   void _navigateToNearbyGarages() {
//     if (_currentPosition == null) {
//       final localizations = AppLocalizations.of(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(localizations?.translate('wait_for_location') ?? 'Please wait for location to load'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NearbyGaragesScreen(
//           userLocation: _currentPosition!,
//           userEmail: _userEmail,
//         ),
//       ),
//     );
//   }

//   void _navigateToNearbyTowProviders() {
//     if (_currentPosition == null) {
//       final localizations = AppLocalizations.of(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(localizations?.translate('wait_for_location') ?? 'Please wait for location to load'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NearbyTowProvidersScreen(
//           userLocation: _currentPosition!,
//           userEmail: _userEmail,
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedBottomNavigationBar(AppLocalizations? localizations) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.1),
//             blurRadius: 20,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//               _animationController.reset();
//               _animationController.forward();
//             });
//           },
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           selectedItemColor: Color(0xFF6D28D9),
//           unselectedItemColor: Colors.grey[600],
//           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//           unselectedLabelStyle: TextStyle(fontSize: 12),
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_rounded),
//               activeIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
//               ),
//               label: localizations?.dashboard ?? 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.handyman_rounded),
//               activeIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
//               ),
//               label: localizations?.services ?? 'Services',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.history_rounded),
//               activeIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
//               ),
//               label: localizations?.history ?? 'History',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.security_rounded),
//               activeIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
//               ),
//               label: localizations?.translate('insurance') ?? 'Insurance',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_rounded),
//               activeIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//               ),
//               label: localizations?.profile ?? 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToIndex(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     Navigator.pop(context);
//   }

//   void _showSpareParts() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SparePartsStore()));
//     Navigator.pop(context);
//   }

//   void _logout() async {
//     print('🚪 Logout button pressed...');

//     Navigator.pop(context);

//     final localizations = AppLocalizations.of(context);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(localizations?.translate('logout_confirmation') ?? 'Logout Confirmation'),
//           content: Text(localizations?.translate('logout_confirm_message') ?? 'Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 print('❌ Logout cancelled by user');
//               },
//               child: Text(localizations?.translate('cancel') ?? 'Cancel', style: TextStyle(color: Colors.grey[600])),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 print('✅ User confirmed logout');

//                 try {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         child: Padding(
//                           padding: EdgeInsets.all(20),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(),
//                               SizedBox(width: 20),
//                               Text(localizations?.translate('logging_out') ?? "Logging out..."),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );

//                   print('🗑️ Clearing shared preferences...');
//                   await AuthService.clearLoginData();

//                   print('🔥 Signing out from Firebase...');
//                   await FirebaseAuth.instance.signOut();

//                   Navigator.of(context).pop();

//                   print('🔄 Navigating to login page...');
//                   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => VehicleLoginPage()),
//                     (Route<dynamic> route) => false,
//                   );

//                   print('🎉 Logout completed successfully!');

//                 } catch (e) {
//                   print('❌ Error during logout: $e');

//                   if (Navigator.canPop(context)) {
//                     Navigator.of(context).pop();
//                   }

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(localizations?.translate('logout_failed') ?? 'Logout failed. Please try again.'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: Text(localizations?.logout ?? 'Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // Enhanced Home Screen with Insurance Integration
// class EnhancedHomeScreenWithInsurance extends StatelessWidget {
//   final Map<String, dynamic> userData;
//   final List<Map<String, dynamic>> insuranceRequests;
//   final Position? currentPosition;
//   final String currentLocation;
//   final String locationAddress;
//   final bool locationLoading;
//   final VoidCallback onGarageServiceTap;
//   final VoidCallback onTowServiceTap;
//   final VoidCallback onRefreshLocation;
//   final int unreadNotifications;
//   final VoidCallback onNotificationTap;

//   const EnhancedHomeScreenWithInsurance({
//     super.key,
//     required this.userData,
//     required this.insuranceRequests,
//     required this.currentPosition,
//     required this.currentLocation,
//     required this.locationAddress,
//     required this.locationLoading,
//     required this.onGarageServiceTap,
//     required this.onTowServiceTap,
//     required this.onRefreshLocation,
//     required this.unreadNotifications,
//     required this.onNotificationTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context);

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildWelcomeCard(localizations),
//           SizedBox(height: 20),
//           _buildLocationCard(localizations),
//           SizedBox(height: 20),
//           _buildQuickActions(context, localizations),
//           SizedBox(height: 20),
//           _buildInsuranceReminder(context, localizations),
//           SizedBox(height: 20),
//           _buildQuickStats(localizations),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard(AppLocalizations? localizations) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF6D28D9).withOpacity(0.3),
//             blurRadius: 20,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${localizations?.translate('welcome_back') ?? 'Welcome back'}, ${userData['name'].split(' ')[0]}! 👋',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       localizations?.translate('your_plan_active') ?? 'Your plan is active',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//               // Notification indicator on welcome card
//               if (unreadNotifications > 0)
//                 GestureDetector(
//                   onTap: onNotificationTap,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       unreadNotifications > 9 ? '9+' : '$unreadNotifications',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 15),
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
//                 SizedBox(width: 8),
//                 Text(
//                   '${userData['points']} ${localizations?.translate('reward_points') ?? 'Reward Points'}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 Spacer(),
//                 Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
//                 SizedBox(width: 4),
//                 Text(
//                   '${localizations?.translate('next_service') ?? 'Next'}: ${userData['nextService']}',
//                   style: TextStyle(color: Colors.white70, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationCard(AppLocalizations? localizations) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   color: Color(0xFF6D28D9),
//                   size: 24,
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     localizations?.translate('current_location') ?? 'Current Location',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ),
//                 if (currentPosition != null)
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 20,
//                   ),
//               ],
//             ),
//             SizedBox(height: 8),
//             locationLoading
//                 ? Row(
//                     children: [
//                       SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         localizations?.translate('fetching_location') ?? 'Fetching location...',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         currentLocation,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                           fontFamily: 'Monospace',
//                         ),
//                       ),
//                       if (locationAddress.isNotEmpty)
//                         Padding(
//                           padding: EdgeInsets.only(top: 4),
//                           child: Text(
//                             locationAddress,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                     ],
//                   ),
//             SizedBox(height: 8),
//             ElevatedButton.icon(
//               onPressed: onRefreshLocation,
//               icon: Icon(Icons.refresh, size: 16),
//               label: Text(localizations?.translate('refresh_location') ?? 'Refresh Location'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF6D28D9),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 textStyle: TextStyle(fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActions(BuildContext context, AppLocalizations? localizations) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildQuickActionItem(
//             icon: Icons.handyman_rounded,
//             title: localizations?.translate('garage_service') ?? 'Garage Service',
//             color: Color(0xFF6D28D9),
//             onTap: onGarageServiceTap,
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: _buildQuickActionItem(
//             icon: Icons.security_rounded,
//             title: localizations?.translate('insurance') ?? 'Insurance',
//             color: Colors.purple,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
//             ),
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: _buildQuickActionItem(
//             icon: Icons.local_shipping_rounded,
//             title: localizations?.translate('tow_service') ?? 'Tow Service',
//             color: Colors.blue,
//             onTap: onTowServiceTap,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionItem({
//     required IconData icon,
//     required String title,
//     required Color color,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInsuranceReminder(BuildContext context, AppLocalizations? localizations) {
//     final activePolicy = insuranceRequests.firstWhere(
//       (policy) => policy['status'] == 'Active',
//       orElse: () => {},
//     );

//     if (activePolicy.isEmpty) {
//       return Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.orange[50],
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.orange),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.orange),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     localizations?.translate('no_active_insurance') ?? 'No Active Insurance',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange[800],
//                     ),
//                   ),
//                   Text(
//                     localizations?.translate('get_vehicle_insured') ?? 'Get your vehicle insured today',
//                     style: TextStyle(color: Colors.orange[700], fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               child: Text(localizations?.translate('get_insurance') ?? 'Get Insurance'),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container();
//   }

//   Widget _buildQuickStats(AppLocalizations? localizations) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             title: localizations?.translate('services_used') ?? 'Services Used',
//             value: '3',
//             subtitle: localizations?.translate('this_month') ?? 'This month',
//             color: Color(0xFF6D28D9),
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             title: localizations?.translate('insurance') ?? 'Insurance',
//             value: 'Active',
//             subtitle: 'Comprehensive',
//             color: Colors.green,
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             title: localizations?.translate('savings') ?? 'Savings',
//             value: '\$85',
//             subtitle: localizations?.translate('total') ?? 'Total',
//             color: Colors.blue,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required String subtitle,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.trending_up_rounded, color: color, size: 16),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Enhanced Services Screen
// class EnhancedServicesScreen extends StatelessWidget {
//   final Position? currentPosition;
//   final String currentLocation;
//   final String locationAddress;
//   final bool locationLoading;
//   final String? userEmail;
//   final VoidCallback onTowServiceTap;
//   final VoidCallback onGarageServiceTap;
//   final VoidCallback onRefreshLocation;
//   final int unreadNotifications;
//   final VoidCallback onNotificationTap;

//   const EnhancedServicesScreen({
//     super.key,
//     required this.currentPosition,
//     required this.currentLocation,
//     required this.locationAddress,
//     required this.locationLoading,
//     required this.userEmail,
//     required this.onTowServiceTap,
//     required this.onGarageServiceTap,
//     required this.onRefreshLocation,
//     required this.unreadNotifications,
//     required this.onNotificationTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context);

//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildLocationCard(localizations),
//                 SizedBox(height: 20),
//                 _buildEmergencyServices(context, localizations),
//                 SizedBox(height: 20),
//                 Text(
//                   localizations?.translate('all_services') ?? 'All Services',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationCard(AppLocalizations? localizations) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   color: Color(0xFF6D28D9),
//                   size: 24,
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     localizations?.translate('current_location') ?? 'Current Location',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ),
//                 if (currentPosition != null)
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 20,
//                   ),
//               ],
//             ),
//             SizedBox(height: 8),
//             locationLoading
//                 ? Row(
//                     children: [
//                       SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         localizations?.translate('fetching_location') ?? 'Fetching location...',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         currentLocation,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                           fontFamily: 'Monospace',
//                         ),
//                       ),
//                       if (locationAddress.isNotEmpty)
//                         Padding(
//                           padding: EdgeInsets.only(top: 4),
//                           child: Text(
//                             locationAddress,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                     ],
//                   ),
//             SizedBox(height: 8),
//             ElevatedButton.icon(
//               onPressed: onRefreshLocation,
//               icon: Icon(Icons.refresh, size: 16),
//               label: Text(localizations?.translate('refresh_location') ?? 'Refresh Location'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF6D28D9),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 textStyle: TextStyle(fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmergencyServices(BuildContext context, AppLocalizations? localizations) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               localizations?.translate('emergency_services') ?? 'Emergency Services',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildEmergencyServiceCard(
//                     icon: Icons.local_shipping_rounded,
//                     title: localizations?.translate('tow_service') ?? 'Tow Service',
//                     subtitle: localizations?.translate('vehicle_towing') ?? 'Vehicle towing',
//                     color: Color(0xFF6D28D9),
//                     onTap: onTowServiceTap,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: _buildEmergencyServiceCard(
//                     icon: Icons.handyman_rounded,
//                     title: localizations?.translate('garage_service') ?? 'Garage Service',
//                     subtitle: localizations?.translate('mechanic_repair') ?? 'Mechanic & repair',
//                     color: Color(0xFFF59E0B),
//                     onTap: onGarageServiceTap,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmergencyServiceCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: Colors.white, size: 24),
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';
import 'package:smart_road_app/core/language/language_selector.dart';
import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
import 'package:smart_road_app/VehicleOwner/GarageRequest.dart';
import 'package:smart_road_app/VehicleOwner/History.dart';
import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
import 'package:smart_road_app/VehicleOwner/ProfilePage.dart';
import 'package:smart_road_app/VehicleOwner/SpareParts.dart';
import 'package:smart_road_app/VehicleOwner/ai.dart';
import 'package:smart_road_app/screens/payment/payment_options_screen.dart';
import 'package:smart_road_app/services/cache_sync_service.dart';
import 'package:smart_road_app/controller/sharedprefrence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_road_app/screens/chat/chat_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_road_app/VehicleOwner/nearby_tow_provider_screen.dart';
import 'package:smart_road_app/VehicleOwner/notification.dart';
import 'package:smart_road_app/main_dashboard.dart';

// Insurance Module Classes
class InsuranceModule {
  static List<Map<String, dynamic>> getInsuranceRequests() {
    return [
      {
        'id': 'INS001',
        'policyType': 'Comprehensive',
        'status': 'Active',
        'expiryDate': '2024-12-31',
        'vehicleNumber': 'MH12AB1234',
        'provider': 'ABC Insurance Co.',
        'premium': '\$450',
        'startDate': '2024-01-01',
      },
      {
        'id': 'INS002',
        'policyType': 'Third Party',
        'status': 'Pending',
        'expiryDate': '2024-06-30',
        'vehicleNumber': 'MH12CD5678',
        'provider': 'XYZ Insurance',
        'premium': '\$200',
        'startDate': '2024-01-15',
      },
    ];
  }
}

// Notification Service for Owner
class OwnerNotificationService {
  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Get unread notification count for user
  static Stream<int> getUnreadNotificationCount(String userId) {
    return _dbRef
        .child('notifications')
        .child(userId.replaceAll(RegExp(r'[\.#\$\[\]]'), '_'))
        .orderByChild('read')
        .equalTo(false)
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return 0;
          final Map<dynamic, dynamic> notifications =
              event.snapshot.value as Map<dynamic, dynamic>;
          return notifications.length;
        });
  }

  // Mark notification as read
  static Future<void> markAsRead(String userId, String notificationId) async {
    await _dbRef
        .child('notifications')
        .child(userId.replaceAll(RegExp(r'[\.#\$\[\]]'), '_'))
        .child(notificationId)
        .update({'read': true});
  }
}

// Main Dashboard Class
class EnhancedVehicleDashboard extends StatefulWidget {
  const EnhancedVehicleDashboard({super.key});

  @override
  _EnhancedVehicleDashboardState createState() =>
      _EnhancedVehicleDashboardState();
}

class _EnhancedVehicleDashboardState extends State<EnhancedVehicleDashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String? _userEmail;
  String? _userId;
  Position? _currentPosition;
  String _currentLocation = 'Fetching location...';
  bool _locationLoading = false;
  String _locationAddress = '';
  int _unreadNotifications = 0;
  StreamSubscription<int>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _loadUserData();
    _initializeLocation();
  }

  Future<void> _loadUserData() async {
    try {
      String? userEmail = await AuthService.getUserEmail();
      final user = FirebaseAuth.instance.currentUser;

      setState(() {
        _userEmail = userEmail;
        _userId = user?.uid;
      });

      print('✅ Dashboard loaded for user: $_userEmail');

      // Start listening to notifications
      if (_userId != null) {
        _startNotificationListener();
      }
    } catch (e) {
      print('❌ Error loading user data in dashboard: $e');
    }
  }

  void _startNotificationListener() {
    _notificationSubscription?.cancel();
    _notificationSubscription =
        OwnerNotificationService.getUnreadNotificationCount(_userId!).listen((
          count,
        ) {
          if (mounted) {
            setState(() {
              _unreadNotifications = count;
            });
          }
        });
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Location services are disabled';
        _locationLoading = false;
      });
      return;
    }
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentLocation = 'Location permission denied';
            _locationLoading = false;
          });
          _showLocationPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = 'Location permission permanently denied';
          _locationLoading = false;
        });
        _showLocationPermissionDialog();
        return;
      }

      Position position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 15),
          ).timeout(
            Duration(seconds: 20),
            onTimeout: () {
              throw TimeoutException('Location request timed out');
            },
          );

      String address = await _getAddressFromLatLng(position);

      setState(() {
        _currentPosition = position;
        _currentLocation =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _locationAddress = address;
        _locationLoading = false;
      });
    } on TimeoutException catch (e) {
      print('⏰ Location timeout: $e');
      setState(() {
        _currentLocation = 'Location timeout. Please try again.';
        _locationLoading = false;
      });
    } catch (e) {
      print('❌ Error getting location: $e');
      setState(() {
        _currentLocation = 'Unable to fetch location: ${e.toString()}';
        _locationLoading = false;
      });
    }
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
      }
      return 'Address not available';
    } catch (e) {
      print('Error getting address: $e');
      return 'Address not available';
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(
            localizations?.translate('location_permission_required') ??
                'Location Permission Required',
          ),
          content: Text(
            localizations?.translate('location_permission_message') ??
                'This app needs location permission to show nearby services. Please enable location permissions in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations?.translate('cancel') ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text(
                localizations?.translate('open_settings') ?? 'Open Settings',
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationsPage()),
    );
  }

  Map<String, dynamic> get _userData {
    return {
      'name': _userEmail?.split('@').first ?? 'User',
      'email': _userEmail ?? 'user@example.com',
      'vehicle': 'Toyota Camry 2022',
      'plan': 'Gold Plan',
      'memberSince': '2023',
      'points': 450,
      'nextService': '2024-02-20',
      'emergencyContacts': ['+1-234-567-8900', '+1-234-567-8901'],
    };
  }

  String? get _garageName => null;

  @override
  void dispose() {
    _animationController.dispose();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildEnhancedAppBar(localizations),
      drawer: _buildEnhancedDrawer(localizations),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _getCurrentScreen(localizations),
        ),
      ),
      bottomNavigationBar: _buildEnhancedBottomNavigationBar(localizations),
    );
  }

  AppBar _buildEnhancedAppBar(AppLocalizations? localizations) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AutoConnect',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          Text(
            localizations?.translate('always_here_to_help') ??
                'Always here to help',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      backgroundColor: Color(0xFF6D28D9),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      actions: [
        // NOTIFICATION ICON WITH BADGE
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: _navigateToNotifications,
              tooltip:
                  localizations?.translate('notifications') ?? 'Notifications',
            ),
            if (_unreadNotifications > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.location_on),
          onPressed: _getCurrentLocation,
          tooltip:
              localizations?.translate('refresh_location') ??
              'Refresh Location',
        ),
        IconButton(
          icon: Icon(Icons.auto_awesome),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AdvancedAIAssistantScreen(),
              ),
            );
          },
          tooltip: 'AI Assistance',
        ),
        LanguageSelector(),
      ],
    );
  }

  Widget _buildEnhancedDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(localizations),
            _buildDrawerItem(
              icon: Icons.dashboard_rounded,
              title: localizations?.dashboard ?? 'Dashboard',
              onTap: () => _navigateToIndex(0),
            ),
            _buildDrawerItem(
              icon: Icons.notifications_rounded,
              title:
                  '${localizations?.translate('notifications') ?? 'Notifications'} ${_unreadNotifications > 0 ? '($_unreadNotifications)' : ''}',
              onTap: _navigateToNotifications,
            ),
            _buildDrawerItem(
              icon: Icons.security_rounded,
              title: localizations?.translate('insurance') ?? 'Insurance',
              onTap: () => _navigateToIndex(3),
            ),
            _buildDrawerItem(
              icon: Icons.build_circle_rounded,
              title: localizations?.translate('spare_parts') ?? 'Spare Parts',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SparePartsStore()),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.history_rounded,
              title: localizations?.history ?? 'Service History',
              onTap: () => _navigateToIndex(2),
            ),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: localizations?.logout ?? 'Logout',
              onTap: _logout,
              color: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(AppLocalizations? localizations) {
    return Container(
      padding: EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(color: Color(0xFF5B21B6).withOpacity(0.8)),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_rounded,
              size: 50,
              color: Color(0xFF6D28D9),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _userData['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _userData['email'],
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(
                  '${_userData['points']} ${localizations?.translate('reward_points') ?? 'Points'}',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Notification badge in drawer header
          if (_unreadNotifications > 0) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_active, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '$_unreadNotifications ${localizations?.translate('unread_notifications') ?? 'unread'}',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? Colors.white70, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }

  Widget _getCurrentScreen(AppLocalizations? localizations) {
    switch (_currentIndex) {
      case 0:
        return EnhancedHomeScreenWithInsurance(
          userData: _userData,
          insuranceRequests: InsuranceModule.getInsuranceRequests(),
          currentPosition: _currentPosition,
          currentLocation: _currentLocation,
          locationAddress: _locationAddress,
          locationLoading: _locationLoading,
          onGarageServiceTap: _navigateToNearbyGarages,
          onTowServiceTap: _navigateToNearbyTowProviders,
          onRefreshLocation: _getCurrentLocation,
          unreadNotifications: _unreadNotifications,
          onNotificationTap: _navigateToNotifications,
        );
      case 1:
        return EnhancedServicesScreen(
          currentPosition: _currentPosition,
          currentLocation: _currentLocation,
          locationAddress: _locationAddress,
          locationLoading: _locationLoading,
          userEmail: _userEmail,
          onTowServiceTap: _navigateToNearbyTowProviders,
          onGarageServiceTap: _navigateToNearbyGarages,
          onRefreshLocation: _getCurrentLocation,
          unreadNotifications: _unreadNotifications,
          onNotificationTap: _navigateToNotifications,
        );
      case 2:
        return EnhancedHistoryScreen(
          userEmail: _userEmail ?? 'avi@gmail.com',
          serviceHistory: [],
          garageName: _garageName,
        );
      case 3:
        return RequestInsuranceScreen();
      case 4:
        return EnhancedProfileScreen(
          userEmail: _userEmail ?? 'avi@gmail.com',
          serviceHistory: [],
        );
      default:
        return EnhancedHomeScreenWithInsurance(
          userData: _userData,
          insuranceRequests: InsuranceModule.getInsuranceRequests(),
          currentPosition: _currentPosition,
          currentLocation: _currentLocation,
          locationAddress: _locationAddress,
          locationLoading: _locationLoading,
          onGarageServiceTap: _navigateToNearbyGarages,
          onTowServiceTap: _navigateToNearbyTowProviders,
          onRefreshLocation: _getCurrentLocation,
          unreadNotifications: _unreadNotifications,
          onNotificationTap: _navigateToNotifications,
        );
    }
  }

  void _navigateToNearbyGarages() {
    if (_currentPosition == null) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations?.translate('wait_for_location') ??
                'Please wait for location to load',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NearbyGaragesScreen(
          userLocation: _currentPosition!,
          userEmail: _userEmail,
        ),
      ),
    );
  }

  void _navigateToNearbyTowProviders() {
    if (_currentPosition == null) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations?.translate('wait_for_location') ??
                'Please wait for location to load',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NearbyTowProvidersScreen(
          userLocation: _currentPosition!,
          userEmail: _userEmail,
        ),
      ),
    );
  }

  Widget _buildEnhancedBottomNavigationBar(AppLocalizations? localizations) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _animationController.reset();
              _animationController.forward();
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF6D28D9),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.home_rounded, color: Color(0xFF6D28D9)),
              ),
              label: localizations?.dashboard ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handyman_rounded),
              activeIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
              ),
              label: localizations?.services ?? 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_rounded, color: Color(0xFF6D28D9)),
              ),
              label: localizations?.history ?? 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security_rounded),
              activeIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
              ),
              label: localizations?.translate('insurance') ?? 'Insurance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
              ),
              label: localizations?.profile ?? 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context);
  }

  void _showSpareParts() {
    Navigator.pop(context);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SparePartsStore()));
  }

  void _logout() async {
    print('🚪 Logout button pressed...');

    Navigator.pop(context);

    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations?.translate('logout_confirmation') ??
                'Logout Confirmation',
          ),
          content: Text(
            localizations?.translate('logout_confirm_message') ??
                'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('❌ Logout cancelled by user');
              },
              child: Text(
                localizations?.translate('cancel') ?? 'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                print('✅ User confirmed logout');

                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Text(
                                localizations?.translate('logging_out') ??
                                    "Logging out...",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  print('🗑️ Clearing shared preferences...');
                  await AuthService.clearLoginData();

                  print('🔥 Signing out from Firebase...');
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pop();

                  print('🔄 Navigating to login page...');
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => VehicleLoginPage()),
                    (Route<dynamic> route) => false,
                  );

                  print('🎉 Logout completed successfully!');
                } catch (e) {
                  print('❌ Error during logout: $e');

                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations?.translate('logout_failed') ??
                            'Logout failed. Please try again.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                localizations?.logout ?? 'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Enhanced Home Screen with Insurance Integration
class EnhancedHomeScreenWithInsurance extends StatefulWidget {
  const EnhancedHomeScreenWithInsurance({
    super.key,
    required this.userData,
    required this.insuranceRequests,
    required this.currentPosition,
    required this.currentLocation,
    required this.locationAddress,
    required this.locationLoading,
    required this.onGarageServiceTap,
    required this.onTowServiceTap,
    required this.onRefreshLocation,
    required this.unreadNotifications,
    required this.onNotificationTap,
  });
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> insuranceRequests;
  final Position? currentPosition;
  final String currentLocation;
  final String locationAddress;
  final bool locationLoading;
  final VoidCallback onGarageServiceTap;
  final VoidCallback onTowServiceTap;
  final VoidCallback onRefreshLocation;
  final int unreadNotifications;
  final VoidCallback onNotificationTap;

  @override
  State<EnhancedHomeScreenWithInsurance> createState() =>
      _EnhancedHomeScreenWithInsuranceState();
}

class _EnhancedHomeScreenWithInsuranceState
    extends State<EnhancedHomeScreenWithInsurance>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for jumping effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create jumping animation
    _jumpAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start repeating animation
    _startJumpingAnimation();
  }

  void _startJumpingAnimation() {
    _animationController.repeat(reverse: true);
  }

  void _navigateToMainDashboard() {
    // Navigate to main dashboard screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => MainAiDashboard()));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWelcomeCard(localizations),
          SizedBox(height: 20),
          _buildLocationCard(localizations),
          SizedBox(height: 20),
          _buildQuickActions(context, localizations),
          SizedBox(height: 20),
          _buildInsuranceReminder(context, localizations),
          SizedBox(height: 20),
          _buildQuickStats(localizations),
          SizedBox(height: 20),
          _buildAICard(localizations), // AI Card at the bottom
        ],
      ),
    );
  }

  // AI Card with Jumping Animation
  Widget _buildAICard(AppLocalizations? localizations) {
    return AnimatedBuilder(
      animation: _jumpAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _jumpAnimation.value),
          child: GestureDetector(
            onTap: _navigateToMainDashboard,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // AI Icon with pulse effect
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations?.translate('ai_assistant') ??
                              'AI Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          localizations?.translate(
                                'ai_assistant_description',
                              ) ??
                              'Get smart recommendations and instant help',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6D28D9).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations?.translate('welcome_back') ?? 'Welcome back'}, ${widget.userData['name'].split(' ')[0]}! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localizations?.translate('your_plan_active') ??
                          'Your plan is active',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Notification indicator on welcome card
              if (widget.unreadNotifications > 0)
                GestureDetector(
                  onTap: widget.onNotificationTap,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.unreadNotifications > 9
                          ? '9+'
                          : '${widget.unreadNotifications}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
                SizedBox(width: 8),
                Text(
                  '${widget.userData['points']} ${localizations?.translate('reward_points') ?? 'Reward Points'}',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white70,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  '${localizations?.translate('next_service') ?? 'Next'}: ${widget.userData['nextService']}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(AppLocalizations? localizations) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations?.translate('current_location') ??
                        'Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                if (widget.currentPosition != null)
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            SizedBox(height: 8),
            widget.locationLoading
                ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        localizations?.translate('fetching_location') ??
                            'Fetching location...',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentLocation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Monospace',
                        ),
                      ),
                      if (widget.locationAddress.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            widget.locationAddress,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: widget.onRefreshLocation,
              icon: Icon(Icons.refresh, size: 16),
              label: Text(
                localizations?.translate('refresh_location') ??
                    'Refresh Location',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    AppLocalizations? localizations,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.handyman_rounded,
            title:
                localizations?.translate('garage_service') ?? 'Garage Service',
            color: Color(0xFF6D28D9),
            onTap: widget.onGarageServiceTap,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.security_rounded,
            title: localizations?.translate('insurance') ?? 'Insurance',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestInsuranceScreen()),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionItem(
            icon: Icons.local_shipping_rounded,
            title: localizations?.translate('tow_service') ?? 'Tow Service',
            color: Colors.blue,
            onTap: widget.onTowServiceTap,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceReminder(
    BuildContext context,
    AppLocalizations? localizations,
  ) {
    // FIXED: Use widget.insuranceRequests instead of the null getter
    final List<Map<String, dynamic>> insuranceRequests =
        widget.insuranceRequests;

    if (insuranceRequests.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.translate('no_active_insurance') ??
                        'No Active Insurance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Text(
                    localizations?.translate('get_vehicle_insured') ??
                        'Get your vehicle insured today',
                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestInsuranceScreen(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                localizations?.translate('get_insurance') ?? 'Get Insurance',
              ),
            ),
          ],
        ),
      );
    }

    // Check if there's any active policy
    final activePolicy = insuranceRequests.firstWhere(
      (policy) => policy['status'] == 'Active',
      orElse: () => <String, dynamic>{},
    );

    if (activePolicy.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.translate('no_active_insurance') ??
                        'No Active Insurance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Text(
                    localizations?.translate('get_vehicle_insured') ??
                        'Get your vehicle insured today',
                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestInsuranceScreen(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                localizations?.translate('get_insurance') ?? 'Get Insurance',
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildQuickStats(AppLocalizations? localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('services_used') ?? 'Services Used',
            value: '3',
            subtitle: localizations?.translate('this_month') ?? 'This month',
            color: Color(0xFF6D28D9),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('insurance') ?? 'Insurance',
            value: 'Active',
            subtitle: 'Comprehensive',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('savings') ?? 'Savings',
            value: '\$85',
            subtitle: localizations?.translate('total') ?? 'Total',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.trending_up_rounded, color: color, size: 16),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// Enhanced Services Screen
class EnhancedServicesScreen extends StatefulWidget {
  const EnhancedServicesScreen({
    super.key,
    required this.currentPosition,
    required this.currentLocation,
    required this.locationAddress,
    required this.locationLoading,
    required this.userEmail,
    required this.onTowServiceTap,
    required this.onGarageServiceTap,
    required this.onRefreshLocation,
    required this.unreadNotifications,
    required this.onNotificationTap,
  });
  final Position? currentPosition;
  final String currentLocation;
  final String locationAddress;
  final bool locationLoading;
  final String? userEmail;
  final VoidCallback onTowServiceTap;
  final VoidCallback onGarageServiceTap;
  final VoidCallback onRefreshLocation;
  final int unreadNotifications;
  final VoidCallback onNotificationTap;

  @override
  State<EnhancedServicesScreen> createState() => _EnhancedServicesScreenState();
}

class _EnhancedServicesScreenState extends State<EnhancedServicesScreen> {
  final CacheSyncService _cacheSync = CacheSyncService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _allServices = [];
  bool _isLoadingServices = true;
  StreamSubscription<QuerySnapshot>? _garageSubscription;
  StreamSubscription<QuerySnapshot>? _towSubscription;

  @override
  void initState() {
    super.initState();
    _loadAllServices();
    _setupRealtimeListeners();
  }

  @override
  void dispose() {
    _garageSubscription?.cancel();
    _towSubscription?.cancel();
    super.dispose();
  }

  void _setupRealtimeListeners() {
    if (widget.userEmail == null || widget.userEmail!.isEmpty) {
      return;
    }

    final userEmail = widget.userEmail!;

    // Listen to garage requests in real-time
    _garageSubscription = _firestore
        .collection('owner')
        .doc(userEmail)
        .collection('garagerequest')
        .snapshots()
        .listen((snapshot) {
          _handleRealtimeUpdate(snapshot, 'Garage Service');
        });

    // Listen to tow requests in real-time
    _towSubscription = _firestore
        .collection('owner')
        .doc(userEmail)
        .collection('towrequest')
        .snapshots()
        .listen((snapshot) {
          _handleRealtimeUpdate(snapshot, 'Tow Service');
        });
  }

  void _handleRealtimeUpdate(QuerySnapshot snapshot, String serviceType) {
    if (!mounted) return;

    try {
      // Process all documents from the snapshot
      final updatedServices = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Determine service type
        final determinedServiceType = serviceType == 'Garage Service'
            ? (data.containsKey('garageName') || data.containsKey('garageEmail')
                  ? 'Garage Service'
                  : serviceType)
            : serviceType;

        return {
          ...data,
          'id': doc.id,
          'serviceType': determinedServiceType,
          'requestId': data['requestId'] ?? doc.id,
          'status': _normalizeStatus(data['status'] ?? 'pending'),
          'userEmail': widget.userEmail,
          // Ensure provider email is preserved for chat button
          'garageEmail': data['garageEmail'] ?? data['assignedGarage'] ?? '',
          'providerEmail':
              data['providerEmail'] ?? data['assignedProvider'] ?? '',
        };
      }).toList();

      // Update the existing services list
      setState(() {
        // Create a map to track services by requestId to avoid duplicates
        final Map<String, Map<String, dynamic>> servicesMap = {};

        // Add existing services (excluding the type being updated)
        for (var service in _allServices) {
          if (service['serviceType'] != serviceType) {
            final requestId = service['requestId'] ?? service['id'] ?? '';
            if (requestId.isNotEmpty) {
              servicesMap[requestId] = service;
            }
          }
        }

        // Add/update services from the real-time snapshot
        for (var service in updatedServices) {
          final requestId = service['requestId'] ?? service['id'] ?? '';
          if (requestId.isNotEmpty) {
            servicesMap[requestId] = service;
          }
        }

        // Convert map back to list
        final allServices = servicesMap.values.toList();

        // Filter to show only ongoing services (not completed or rejected)
        final currentServices = allServices.where((service) {
          final status = (service['status'] as String?)?.toLowerCase() ?? '';
          final normalizedStatus = _normalizeStatus(status);

          // Exclude completed and rejected services
          if (normalizedStatus == 'completed' ||
              normalizedStatus == 'rejected' ||
              status.contains('complete') ||
              status.contains('reject') ||
              status.contains('cancel')) {
            return false;
          }

          // Include all other statuses (pending, in process, accepted, confirmed, assigned, etc.)
          return true;
        }).toList();

        // Sort by creation date (newest first)
        currentServices.sort((a, b) {
          final aDate = _parseTimestamp(a['createdAt']);
          final bDate = _parseTimestamp(b['createdAt']);
          return bDate.compareTo(aDate);
        });

        _allServices = currentServices;
        _isLoadingServices = false;
      });

      print(
        '✅ Real-time update: ${updatedServices.length} $serviceType services updated',
      );
    } catch (e) {
      print('❌ Error handling real-time update: $e');
    }
  }

  Future<void> _loadAllServices() async {
    if (widget.userEmail == null || widget.userEmail!.isEmpty) {
      setState(() {
        _isLoadingServices = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoadingServices = true;
      });

      // Use cache-first loading (loads from SQLite instantly, syncs with Firestore in background)
      final allServices = await _cacheSync.getServiceRequests(
        userEmail: widget.userEmail!,
        useCache: true,
        syncInBackground: true,
      );

      // Normalize and format the data
      final formattedServices = allServices.map((service) {
        return {
          ...service,
          'serviceType':
              service['serviceType'] ??
              (service.containsKey('garageName') ||
                      service.containsKey('garageEmail')
                  ? 'Garage Service'
                  : 'Tow Service'),
          'requestId': service['requestId'] ?? service['id'],
          'status': _normalizeStatus(service['status'] ?? 'pending'),
        };
      }).toList();

      // Filter to show only ongoing services (not completed or rejected)
      final currentServices = formattedServices.where((service) {
        final status = (service['status'] as String?)?.toLowerCase() ?? '';
        final normalizedStatus = _normalizeStatus(status);

        // Include only ongoing services: pending, in process, accepted, confirmed, assigned
        // Exclude completed and rejected services (they go to history)
        if (normalizedStatus == 'completed' ||
            normalizedStatus == 'rejected' ||
            status.contains('complete') ||
            status.contains('reject') ||
            status.contains('cancel')) {
          return false;
        }

        // Include all other statuses (pending, in process, accepted, confirmed, assigned, etc.)
        return true;
      }).toList();

      // Sort by creation date (newest first)
      currentServices.sort((a, b) {
        final aDate = _parseTimestamp(a['createdAt']);
        final bDate = _parseTimestamp(b['createdAt']);
        return bDate.compareTo(aDate);
      });

      setState(() {
        _allServices = currentServices;
        _isLoadingServices = false;
      });
    } catch (e) {
      print('Error loading all services: $e');
      setState(() {
        _isLoadingServices = false;
      });
    }
  }

  String _normalizeStatus(String status) {
    final normalized = status.toLowerCase().trim();
    if (normalized.contains('pending') || normalized == 'pending') {
      return 'pending';
    } else if (normalized.contains('process') ||
        normalized == 'in process' ||
        normalized == 'accepted' ||
        normalized == 'confirmed') {
      return 'in process';
    } else if (normalized.contains('complete') || normalized == 'completed') {
      return 'completed';
    } else if (normalized.contains('reject') ||
        normalized == 'rejected' ||
        normalized == 'cancelled') {
      return 'rejected';
    }
    return normalized;
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLocationCard(localizations),
                SizedBox(height: 20),
                _buildEmergencyServices(context, localizations),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations?.translate('current_service') ??
                          'Current Service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _loadAllServices,
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
        if (_isLoadingServices)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_allServices.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No active services',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All completed services are shown in History',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildServiceCard(_allServices[index], localizations);
            }, childCount: _allServices.length),
          ),
      ],
    );
  }

  Widget _buildLocationCard(AppLocalizations? localizations) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations?.translate('current_location') ??
                        'Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                if (widget.currentPosition != null)
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            SizedBox(height: 8),
            widget.locationLoading
                ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        localizations?.translate('fetching_location') ??
                            'Fetching location...',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentLocation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Monospace',
                        ),
                      ),
                      if (widget.locationAddress.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            widget.locationAddress,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: widget.onRefreshLocation,
              icon: Icon(Icons.refresh, size: 16),
              label: Text(
                localizations?.translate('refresh_location') ??
                    'Refresh Location',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServices(
    BuildContext context,
    AppLocalizations? localizations,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations?.translate('emergency_services') ??
                  'Emergency Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildEmergencyServiceCard(
                    icon: Icons.local_shipping_rounded,
                    title:
                        localizations?.translate('tow_service') ??
                        'Tow Service',
                    subtitle:
                        localizations?.translate('vehicle_towing') ??
                        'Vehicle towing',
                    color: Color(0xFF6D28D9),
                    onTap: widget.onTowServiceTap,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildEmergencyServiceCard(
                    icon: Icons.handyman_rounded,
                    title:
                        localizations?.translate('garage_service') ??
                        'Garage Service',
                    subtitle:
                        localizations?.translate('mechanic_repair') ??
                        'Mechanic & repair',
                    color: Color(0xFFF59E0B),
                    onTap: widget.onGarageServiceTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    Map<String, dynamic> service,
    AppLocalizations? localizations,
  ) {
    final serviceType = service['serviceType'] ?? 'Service';
    final status = service['status'] ?? 'pending';
    final requestId = service['requestId'] ?? service['id'] ?? 'N/A';
    final vehicleNumber = service['vehicleNumber'] ?? 'Not Specified';
    final createdAt = _parseTimestamp(service['createdAt']);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    // Get service-specific details
    String? providerName;
    String? serviceDescription;

    if (serviceType == 'Garage Service') {
      providerName =
          service['garageName'] ?? service['assignedGarage'] ?? 'Not Assigned';
      serviceDescription =
          service['problemDescription'] ??
          service['description'] ??
          service['serviceType'] ??
          'Garage Service';
    } else if (serviceType == 'Tow Service') {
      providerName =
          service['providerName'] ??
          service['towProviderName'] ??
          'Not Assigned';
      serviceDescription =
          service['description'] ?? service['issue'] ?? 'Tow Service';
    }

    // Parse payment information
    final paymentStatus = service['paymentStatus'] ?? 'pending';
    final serviceAmount = _parseDouble(service['serviceAmount']);
    final totalAmount = _parseDouble(service['totalAmount']);
    final providerUpiId = service['providerUpiId']?.toString() ?? '';
    final providerEmail =
        (service['garageEmail'] ?? service['providerEmail'] ?? '').toString();

    // Check if payment button should be shown
    final shouldShowPayButton =
        (status.toLowerCase() == 'completed' || status == 'Completed') &&
        paymentStatus.toString().toLowerCase() == 'pending' &&
        serviceAmount != null &&
        serviceAmount > 0 &&
        providerUpiId.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Type and Status Tags
          Row(
            children: [
              _buildServiceTypeTag(serviceType),
              SizedBox(width: 8),
              _buildStatusTag(status),
              Spacer(),
              Text(
                dateFormat.format(createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Request ID
          Text(
            'Request ID: $requestId',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          // Vehicle Number
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 16,
                  color: Color(0xFF6D28D9),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehicleNumber,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Service Description
          if (serviceDescription != null)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 238, 231, 231),
                  width: 1,
                ),
              ),
              child: Text(
                serviceDescription,
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(height: 12),
          // Provider Name
          if (providerName != null)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.business, size: 16, color: Colors.teal),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    providerName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          // Chat Button - Show when service is accepted or in progress
          if ((status.toLowerCase() == 'accepted' ||
                  status.toLowerCase() == 'in process' ||
                  status.toLowerCase() == 'confirmed') &&
              providerEmail.isNotEmpty) ...[
            SizedBox(height: 16),
            Divider(height: 1),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openChat(
                  context,
                  requestId: requestId,
                  userEmail: widget.userEmail ?? '',
                  userName: service['name'] ?? 'Customer',
                  otherPartyEmail: providerEmail,
                  otherPartyName: providerName ?? 'Provider',
                  serviceType: serviceType,
                ),
                icon: Icon(Icons.chat),
                label: Text('Chat with Provider'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF6D28D9),
                  side: BorderSide(color: Color(0xFF6D28D9)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
          // Pay Now Button - Show when service is completed with pending payment
          if (shouldShowPayButton) ...[
            SizedBox(height: 16),
            Divider(height: 1),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentOptionsScreen(
                        requestId: requestId,
                        serviceType: serviceType == 'Garage Service'
                            ? 'garage'
                            : 'tow',
                        amount: serviceAmount,
                        providerUpiId: providerUpiId,
                        providerEmail: providerEmail,
                        customerEmail: widget.userEmail ?? '',
                        providerName: providerName,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.payment),
                label: Text(
                  'Pay Now ₹${totalAmount?.toStringAsFixed(2) ?? serviceAmount.toStringAsFixed(2)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceTypeTag(String serviceType) {
    final isGarage = serviceType == 'Garage Service';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isGarage
            ? Color(0xFFF59E0B).withOpacity(0.15)
            : Color(0xFF6D28D9).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isGarage ? Color(0xFFF59E0B) : Color(0xFF6D28D9),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGarage ? Icons.build_circle : Icons.local_shipping,
            size: 14,
            color: isGarage ? Color(0xFFF59E0B) : Color(0xFF6D28D9),
          ),
          SizedBox(width: 4),
          Text(
            serviceType,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isGarage ? Color(0xFFF59E0B) : Color(0xFF6D28D9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange[800]!;
        icon = Icons.pending;
        displayText = 'Pending';
        break;
      case 'in process':
        backgroundColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue[800]!;
        icon = Icons.hourglass_empty;
        displayText = 'In Process';
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
        displayText = 'Completed';
        break;
      case 'rejected':
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red[800]!;
        icon = Icons.cancel;
        displayText = 'Rejected';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[800]!;
        icon = Icons.help_outline;
        displayText = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(
    BuildContext context, {
    required String requestId,
    required String userEmail,
    required String userName,
    required String otherPartyEmail,
    required String otherPartyName,
    required String serviceType,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          requestId: requestId,
          userEmail: userEmail,
          userName: userName,
          otherPartyEmail: otherPartyEmail,
          otherPartyName: otherPartyName,
          serviceType: serviceType,
        ),
      ),
    );
  }
}

// Status Tag Widget
class StatusTag extends StatelessWidget {
  const StatusTag({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange[800]!;
        icon = Icons.pending;
        displayText = 'Pending';
        break;
      case 'in process':
        backgroundColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue[800]!;
        icon = Icons.hourglass_empty;
        displayText = 'In Process';
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
        displayText = 'Completed';
        break;
      case 'rejected':
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red[800]!;
        icon = Icons.cancel;
        displayText = 'Rejected';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[800]!;
        icon = Icons.help_outline;
        displayText = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Service Type Card Widget
class ServiceTypeCard extends StatelessWidget {
  const ServiceTypeCard({
    super.key,
    required this.serviceType,
    required this.onTap,
    required this.child,
  });
  final String serviceType;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(padding: EdgeInsets.all(16), child: child),
      ),
    );
  }
}

// Gradient Button Widget
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.icon,
    required this.gradient,
    required this.onPressed,
    this.fullWidth = false,
  });
  final String text;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
