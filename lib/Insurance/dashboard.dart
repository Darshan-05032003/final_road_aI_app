// // import 'package:smart_road_app/Login/InsuranceLogin.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/material.dart';

// // class DashboardScreen extends StatefulWidget {
// //   const DashboardScreen({super.key});

// //   @override
// //   _DashboardScreenState createState() => _DashboardScreenState();
// // }

// // class _DashboardScreenState extends State<DashboardScreen> {
// //   bool _isAIEnabled = true;

// //   // Firebase instances
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

// //   // Data variables
// //   Map<String, dynamic> _analyticsData = {
// //     'totalClaims': 0,
// //     'pendingClaims': 0,
// //     'approvedClaims': 0,
// //     'rejectedClaims': 0,
// //     'totalPayouts': 0,
// //     'approvalRate': 0,
// //     'aiAccuracy': 98,
// //     'avgProcessingTime': 0.0,
// //     'customerSatisfaction': 0.0,
// //     'revenue': 0,
// //     'activePolicies': 0,
// //     'renewalRate': 0,
// //   };

// //   int _notificationCount = 0;
// //   List<Activity> _activities = [];
// //   bool _isLoading = true;

// //   final List<Map<String, dynamic>> _quickActions = [
// //     {'title': 'New Claim', 'icon': Icons.add_circle, 'color': Color(0xFF7E57C2), 'action': 'create_claim'},
// //     {'title': 'Quick Approve', 'icon': Icons.bolt, 'color': Color(0xFF4CAF50), 'action': 'quick_approve'},
// //     {'title': 'Fraud Scan', 'icon': Icons.security, 'color': Color(0xFFFFA000), 'action': 'fraud_scan'},
// //     {'title': 'Export Report', 'icon': Icons.download, 'color': Color(0xFF2196F3), 'action': 'export_report'},
// //     {'title': 'Customer Chat', 'icon': Icons.chat, 'color': Color(0xFF9C27B0), 'action': 'customer_chat'},
// //     {'title': 'Policy Review', 'icon': Icons.policy, 'color': Color(0xFFF44336), 'action': 'policy_review'},
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeData();
// //   }

// //   void _initializeData() {
// //     _loadUserData();
// //     _loadAnalyticsData();
// //     _loadRecentActivities();
// //     _startNotificationListener();
// //   }

// //   void _loadUserData() async {
// //     // You can load user-specific data here if needed
// //   }

// //   void _loadAnalyticsData() async {
// //     try {
// //       final user = _auth.currentUser;
// //       if (user == null) return;

// //       // Fetch claims data from Firestore
// //       final claimsSnapshot = await _firestore
// //           .collection('owner')
// //           .doc(user.email)
// //           .collection('claims')
// //           .get();

// //       int totalClaims = claimsSnapshot.docs.length;
// //       int pendingClaims = 0;
// //       int approvedClaims = 0;
// //       int rejectedClaims = 0;
// //       double totalPayouts = 0;

// //       for (var doc in claimsSnapshot.docs) {
// //         final data = doc.data();
// //         final status = data['status'] ?? 'pending';
// //         final amount = double.tryParse(data['amount']?.toString() ?? '0') ?? 0;

// //         if (status == 'pending') pendingClaims++;
// //         if (status == 'approved') {
// //           approvedClaims++;
// //           totalPayouts += amount;
// //         }
// //         if (status == 'rejected') rejectedClaims++;
// //       }

// //       // Fetch policies data
// //       final policiesSnapshot = await _firestore
// //           .collection('owner')
// //           .doc(user.email)
// //           .collection('policies')
// //           .get();

// //       int activePolicies = policiesSnapshot.docs.length;

// //       // Calculate derived metrics
// //       double approvalRate = totalClaims > 0 ? (approvedClaims / totalClaims) * 100 : 0;
// //       double renewalRate = 87.0; // This would come from your business logic

// //       if (mounted) {
// //         setState(() {
// //           _analyticsData = {
// //             'totalClaims': totalClaims,
// //             'pendingClaims': pendingClaims,
// //             'approvedClaims': approvedClaims,
// //             'rejectedClaims': rejectedClaims,
// //             'totalPayouts': totalPayouts,
// //             'approvalRate': approvalRate,
// //             'aiAccuracy': 98,
// //             'avgProcessingTime': 2.4,
// //             'customerSatisfaction': 4.8,
// //             'revenue': totalPayouts * 1.2, // Example calculation
// //             'activePolicies': activePolicies,
// //             'renewalRate': renewalRate,
// //           };
// //           _isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading analytics data: $e');
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   void _loadRecentActivities() async {
// //     try {
// //       final user = _auth.currentUser;
// //       if (user == null) return;

// //       final activitiesSnapshot = await _firestore
// //           .collection('owner')
// //           .doc(user.email)
// //           .collection('activities')
// //           .orderBy('timestamp', descending: true)
// //           .limit(5)
// //           .get();

// //       List<Activity> activities = [];

// //       for (var doc in activitiesSnapshot.docs) {
// //         final data = doc.data();
// //         activities.add(Activity(
// //           data['title'] ?? 'Activity',
// //           data['description'] ?? '',
// //           _getTimeAgo(data['timestamp']?.toDate() ?? DateTime.now()),
// //           _getActivityIcon(data['type'] ?? 'general'),
// //           _getActivityColor(data['type'] ?? 'general'),
// //         ));
// //       }

// //       // Add default activities if no data found
// //       if (activities.isEmpty) {
// //         activities = [
// //           Activity('System Ready', 'Dashboard initialized successfully', 'Just now', Icons.check_circle, Colors.green),
// //           Activity('Welcome', 'Welcome to Insurance Dashboard', 'Today', Icons.emoji_events, Colors.blue),
// //         ];
// //       }

// //       if (mounted) {
// //         setState(() {
// //           _activities = activities;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading activities: $e');
// //       // Set default activities on error
// //       if (mounted) {
// //         setState(() {
// //           _activities = [
// //             Activity('System Ready', 'Dashboard initialized successfully', 'Just now', Icons.check_circle, Colors.green),
// //           ];
// //         });
// //       }
// //     }
// //   }

// //   void _startNotificationListener() {
// //     final user = _auth.currentUser;
// //     if (user == null) return;

// //     _dbRef.child('notifications').child(user.uid).onValue.listen((event) {
// //       final data = event.snapshot.value as Map<dynamic, dynamic>?;
// //       int count = 0;

// //       if (data != null) {
// //         data.forEach((key, value) {
// //           if (value is Map && value['read'] == false) {
// //             count++;
// //           }
// //         });
// //       }

// //       if (mounted) {
// //         setState(() {
// //           _notificationCount = count;
// //         });
// //       }
// //     });
// //   }

// //   IconData _getActivityIcon(String type) {
// //     switch (type) {
// //       case 'claim_approved': return Icons.check_circle;
// //       case 'claim_submitted': return Icons.add_circle;
// //       case 'payment_processed': return Icons.payment;
// //       case 'document_uploaded': return Icons.upload;
// //       case 'policy_updated': return Icons.policy;
// //       default: return Icons.notifications;
// //     }
// //   }

// //   Color _getActivityColor(String type) {
// //     switch (type) {
// //       case 'claim_approved': return Colors.green;
// //       case 'claim_submitted': return Colors.orange;
// //       case 'payment_processed': return Colors.green;
// //       case 'document_uploaded': return Colors.blue;
// //       case 'policy_updated': return Colors.purple;
// //       default: return Colors.grey;
// //     }
// //   }

// //   String _getTimeAgo(DateTime date) {
// //     final now = DateTime.now();
// //     final difference = now.difference(date);

// //     if (difference.inSeconds < 60) return 'Just now';
// //     if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
// //     if (difference.inHours < 24) return '${difference.inHours}h ago';
// //     if (difference.inDays < 7) return '${difference.inDays}d ago';
// //     return '${difference.inDays ~/ 7}w ago';
// //   }

// //   void _handleQuickAction(String action) {
// //     switch (action) {
// //       case 'create_claim':
// //         _showMessage('Create New Claim');
// //         break;
// //       case 'quick_approve':
// //         _showMessage('Quick Approval Mode');
// //         break;
// //       case 'fraud_scan':
// //         _showMessage('Running Fraud Scan');
// //         break;
// //       case 'export_report':
// //         _showMessage('Exporting Report');
// //         break;
// //       case 'customer_chat':
// //         _showMessage('Opening Customer Chat');
// //         break;
// //       case 'policy_review':
// //         _showMessage('Reviewing Policies');
// //         break;
// //     }
// //   }

// //   void _showMessage(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         behavior: SnackBarBehavior.floating,
// //       ),
// //     );
// //   }

// //   void _navigateToNotifications() {
// //     final user = _auth.currentUser;
// //     if (user == null) {
// //       _showMessage('Please login to view notifications');
// //       return;
// //     }

// //     // Navigate to your notifications page
// //     // Uncomment and replace with your actual notifications page
// //     // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
// //     _showMessage('Navigating to Notifications Page');
// //   }

// //   void _navigateToProfile() {
// //     _showMessage('Navigating to Profile');
// //   }

// //   void _navigateToSettings() {
// //     _showMessage('Navigating to Settings');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Insurance Dashboard'),
// //         backgroundColor: Color(0xFF7E57C2),
// //         foregroundColor: Colors.white,
// //         elevation: 0,
// //         actions: [
// //           // Notification Icon with Badge
// //           Stack(
// //             children: [
// //               IconButton(
// //                 icon: Icon(Icons.notifications_outlined),
// //                 onPressed: _navigateToNotifications,
// //               ),
// //               if (_notificationCount > 0)
// //                 Positioned(
// //                   right: 8,
// //                   top: 8,
// //                   child: Container(
// //                     padding: EdgeInsets.all(2),
// //                     decoration: BoxDecoration(
// //                       color: Colors.red,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     constraints: BoxConstraints(
// //                       minWidth: 16,
// //                       minHeight: 16,
// //                     ),
// //                     child: Text(
// //                       _notificationCount > 9 ? '9+' : _notificationCount.toString(),
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           IconButton(
// //             icon: Icon(_isAIEnabled ? Icons.auto_awesome : Icons.auto_awesome_outlined),
// //             onPressed: () => setState(() => _isAIEnabled = !_isAIEnabled),
// //           ),
// //           PopupMenuButton<String>(
// //             icon: Icon(Icons.more_vert),
// //             onSelected: (value) {
// //               switch (value) {
// //                 case 'profile':
// //                   _navigateToProfile();
// //                   break;
// //                 case 'settings':
// //                   _navigateToSettings();
// //                   break;
// //                 case 'logout':
// //                   _logout();
// //                   break;
// //               }
// //             },
// //             itemBuilder: (BuildContext context) => [
// //               PopupMenuItem<String>(
// //                 value: 'profile',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.person, color: Colors.grey[700]),
// //                     SizedBox(width: 8),
// //                     Text('Profile'),
// //                   ],
// //                 ),
// //               ),
// //               PopupMenuItem<String>(
// //                 value: 'settings',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.settings, color: Colors.grey[700]),
// //                     SizedBox(width: 8),
// //                     Text('Settings'),
// //                   ],
// //                 ),
// //               ),
// //               PopupMenuDivider(),
// //               PopupMenuItem<String>(
// //                 value: 'logout',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.logout, color: Colors.red),
// //                     SizedBox(width: 8),
// //                     Text('Logout', style: TextStyle(color: Colors.red)),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //       body: _isLoading
// //           ? _buildLoadingIndicator()
// //           : SingleChildScrollView(
// //               padding: EdgeInsets.all(16),
// //               child: Column(
// //                 children: [
// //                   _buildWelcomeCard(),
// //                   SizedBox(height: 20),
// //                   _buildQuickStats(),
// //                   SizedBox(height: 20),
// //                   _buildQuickActionsGrid(),
// //                   SizedBox(height: 20),
// //                   _buildAIInsights(),
// //                   SizedBox(height: 20),
// //                   _buildRecentActivities(),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildLoadingIndicator() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(
// //             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
// //           ),
// //           SizedBox(height: 20),
// //           Text(
// //             'Loading Dashboard...',
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Colors.grey[600],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _logout() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Logout'),
// //         content: Text('Are you sure you want to logout?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               Navigator.of(context).pushAndRemoveUntil(
// //                 MaterialPageRoute(builder: (context) => InsuranceLoginPage()),
// //                 (route) => false,
// //               );
// //             },
// //             style: TextButton.styleFrom(foregroundColor: Colors.red),
// //             child: Text('Logout'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildWelcomeCard() {
// //     final user = _auth.currentUser;
// //     final userName = user?.displayName ?? 'User';
// //     final userEmail = user?.email ?? '';

// //     return Container(
// //       padding: EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)]),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [BoxShadow(color: Color(0xFF7E57C2).withOpacity(0.3), blurRadius: 20, offset: Offset(0, 6))],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Welcome back, $userName!',
// //                     style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
// //                 SizedBox(height: 4),
// //                 Text(userEmail, style: TextStyle(color: Colors.white70, fontSize: 14)),
// //                 SizedBox(height: 8),
// //                 Text('You have ${_analyticsData['pendingClaims']} pending claims that need your attention.',
// //                      style: TextStyle(color: Colors.white70, fontSize: 16)),
// //                 SizedBox(height: 16),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: [
// //                     _buildMetricChip('AI Active', Icons.auto_awesome),
// //                     _buildMetricChip('${_analyticsData['aiAccuracy']}% Accuracy', Icons.verified),
// //                     _buildMetricChip('${_analyticsData['activePolicies']} Policies', Icons.policy),
// //                     _buildMetricChip('\$${(_analyticsData['revenue']/1000).toStringAsFixed(0)}K Revenue', Icons.attach_money),
// //                     if (_notificationCount > 0)
// //                       _buildMetricChip('$_notificationCount Notifications', Icons.notifications),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Container(
// //             width: 80,
// //             height: 80,
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.2),
// //               shape: BoxShape.circle
// //             ),
// //             child: Icon(Icons.analytics, color: Colors.white, size: 40),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMetricChip(String text, IconData icon) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.2),
// //         borderRadius: BorderRadius.circular(12)
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, color: Colors.white, size: 14),
// //           SizedBox(width: 6),
// //           Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
// //         ]
// //       ),
// //     );
// //   }

// //   Widget _buildQuickStats() {
// //     return GridView.count(
// //       shrinkWrap: true,
// //       physics: NeverScrollableScrollPhysics(),
// //       crossAxisCount: 2,
// //       crossAxisSpacing: 16,
// //       mainAxisSpacing: 16,
// //       childAspectRatio: 1.2,
// //       children: [
// //         _buildStatCard('Total Claims', _analyticsData['totalClaims'].toString(), Icons.assignment, Color(0xFF7E57C2)),
// //         _buildStatCard('Pending', _analyticsData['pendingClaims'].toString(), Icons.pending_actions, Color(0xFFFFA000)),
// //         _buildStatCard('Approved', _analyticsData['approvedClaims'].toString(), Icons.thumb_up, Color(0xFF4CAF50)),
// //         _buildStatCard('Notifications', _notificationCount.toString(), Icons.notifications, Color(0xFF2196F3)),
// //       ],
// //     );
// //   }

// //   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Container(
// //             padding: EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8)
// //             ),
// //             child: Icon(icon, color: color, size: 20),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
// //               SizedBox(height: 4),
// //               Text(title, style: TextStyle(color: Color(0xFF666666), fontSize: 12)),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildQuickActionsGrid() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
// //             if (_notificationCount > 0)
// //               TextButton(
// //                 onPressed: _navigateToNotifications,
// //                 child: Text(
// //                   'View Notifications',
// //                   style: TextStyle(color: Color(0xFF7E57C2), fontWeight: FontWeight.w500),
// //                 ),
// //               ),
// //           ],
// //         ),
// //         SizedBox(height: 16),
// //         GridView.count(
// //           shrinkWrap: true,
// //           physics: NeverScrollableScrollPhysics(),
// //           crossAxisCount: 3,
// //           crossAxisSpacing: 12,
// //           mainAxisSpacing: 12,
// //           childAspectRatio: 1.2,
// //           children: _quickActions.map((action) => _buildQuickActionItem(action)).toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildQuickActionItem(Map<String, dynamic> action) {
// //     return GestureDetector(
// //       onTap: () => _handleQuickAction(action['action']),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(12),
// //           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: action['color'].withOpacity(0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(action['icon'], color: action['color'], size: 24),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               action['title'],
// //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAIInsights() {
// //     return Container(
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(children: [
// //             Icon(Icons.auto_awesome, color: Color(0xFF7E57C2)),
// //             SizedBox(width: 8),
// //             Text('AI Insights & Predictions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
// //             Spacer(),
// //             Switch(
// //               value: _isAIEnabled,
// //               onChanged: (value) => setState(() => _isAIEnabled = value),
// //               activeThumbColor: Color(0xFF7E57C2)
// //             ),
// //           ]),
// //           SizedBox(height: 16),
// //           _buildAIPredictionItem('Fraud Risk Alert', '${_analyticsData['pendingClaims']} claims need review', Icons.warning, Colors.orange),
// //           _buildAIPredictionItem('Approval Rate', '${_analyticsData['approvalRate'].toStringAsFixed(1)}% claim approval rate', Icons.trending_up, Colors.green),
// //           _buildAIPredictionItem('Revenue', '\$${_analyticsData['revenue'].toStringAsFixed(0)} total revenue', Icons.attach_money, Colors.purple),
// //           if (_notificationCount > 0)
// //             _buildAIPredictionItem('Notifications', '$_notificationCount unread notifications', Icons.notifications, Colors.blue),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAIPredictionItem(String title, String subtitle, IconData icon, Color color) {
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 12),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.05),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: color.withOpacity(0.2)),
// //       ),
// //       child: Row(children: [
// //         Container(
// //           padding: EdgeInsets.all(8),
// //           decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
// //           child: Icon(icon, color: color, size: 16),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
// //           Text(subtitle, style: TextStyle(color: Color(0xFF666666), fontSize: 12)),
// //         ])),
// //         Icon(Icons.chevron_right, color: Color(0xFF999999)),
// //       ]),
// //     );
// //   }

// //   Widget _buildRecentActivities() {
// //     return Container(
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
// //       ),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //           Text('Recent Activities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
// //           TextButton(
// //             onPressed: _navigateToNotifications,
// //             child: Text('View All', style: TextStyle(color: Color(0xFF7E57C2), fontWeight: FontWeight.w500))
// //           ),
// //         ]),
// //         SizedBox(height: 16),
// //         ..._activities.map((activity) => _buildActivityItem(activity)),
// //         if (_notificationCount > 0)
// //           _buildActivityItem(
// //             Activity(
// //               'New Notifications',
// //               'You have $_notificationCount unread notifications',
// //               'Just now',
// //               Icons.notifications,
// //               Colors.blue
// //             ),
// //           ),
// //       ]),
// //     );
// //   }

// //   Widget _buildActivityItem(Activity activity) {
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 12),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(color: Color(0xFFF5F5F7), borderRadius: BorderRadius.circular(12)),
// //       child: Row(children: [
// //         Container(
// //           padding: EdgeInsets.all(8),
// //           decoration: BoxDecoration(color: activity.color.withOpacity(0.1), shape: BoxShape.circle),
// //           child: Icon(activity.icon, color: activity.color, size: 16),
// //         ),
// //         SizedBox(width: 12),
// //         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Text(activity.title, style: TextStyle(fontWeight: FontWeight.w500)),
// //           Text(activity.description, style: TextStyle(color: Color(0xFF666666), fontSize: 12)),
// //         ])),
// //         Text(activity.time, style: TextStyle(color: Color(0xFF999999), fontSize: 11)),
// //       ]),
// //     );
// //   }
// // }

// // class Activity {
// //   final String title;
// //   final String description;
// //   final String time;
// //   final IconData icon;
// //   final Color color;

// //   Activity(this.title, this.description, this.time, this.icon, this.color);
// // }

// import 'package:smart_road_app/Login/InsuranceLogin.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool _isAIEnabled = true;

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

//   // Data variables
//   Map<String, dynamic> _analyticsData = {
//     'totalClaims': 0,
//     'pendingClaims': 0,
//     'approvedClaims': 0,
//     'rejectedClaims': 0,
//     'totalPayouts': 0,
//     'approvalRate': 0,
//     'aiAccuracy': 98,
//     'avgProcessingTime': 0.0,
//     'customerSatisfaction': 0.0,
//     'revenue': 0,
//     'activePolicies': 0,
//     'renewalRate': 0,
//   };

//   int _notificationCount = 0;
//   List<Activity> _activities = [];
//   bool _isLoading = true;
//   String? _userEmail;

//   final List<Map<String, dynamic>> _quickActions = [
//     {
//       'title': 'New Insurance',
//       'icon': Icons.add_circle,
//       'color': Color(0xFF7E57C2),
//       'action': 'create_insurance',
//     },
//     {
//       'title': 'Track Request',
//       'icon': Icons.track_changes,
//       'color': Color(0xFF4CAF50),
//       'action': 'track_request',
//     },
//     {
//       'title': 'Document Upload',
//       'icon': Icons.upload,
//       'color': Color(0xFFFFA000),
//       'action': 'document_upload',
//     },
//     {
//       'title': 'Export Report',
//       'icon': Icons.download,
//       'color': Color(0xFF2196F3),
//       'action': 'export_report',
//     },
//     {
//       'title': 'Support Chat',
//       'icon': Icons.chat,
//       'color': Color(0xFF9C27B0),
//       'action': 'customer_chat',
//     },
//     {
//       'title': 'Policy Review',
//       'icon': Icons.policy,
//       'color': Color(0xFFF44336),
//       'action': 'policy_review',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   void _initializeData() {
//     _loadUserData();
//     _loadAnalyticsData();
//     _loadRecentActivities();
//     _startNotificationListener();
//   }

//   void _loadUserData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         setState(() {
//           _userEmail = user.email;
//         });
//       }
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }

//   void _loadAnalyticsData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) return;

//       // Fetch real data from Firestore
//       final claimsSnapshot = await _firestore
//           .collection('vehicle_owners')
//           .doc(user.email)
//           .collection('insurance_requests')
//           .get();

//       int totalClaims = claimsSnapshot.docs.length;
//       int pendingClaims = 0;
//       int approvedClaims = 0;
//       int rejectedClaims = 0;
//       double totalPayouts = 0;

//       for (var doc in claimsSnapshot.docs) {
//         final data = doc.data();
//         final status = data['status'] ?? 'pending';
//         final amount =
//             double.tryParse(
//               data['quoteAmount']?.toString() ??
//                   data['estimatedPremium']?.toString() ??
//                   '0',
//             ) ??
//             0;

//         if (status == 'pending_review' || status == 'under_review')
//           pendingClaims++;
//         if (status == 'active' || status == 'completed') {
//           approvedClaims++;
//           totalPayouts += amount;
//         }
//         if (status == 'rejected') rejectedClaims++;
//       }

//       // Calculate derived metrics
//       double approvalRate = totalClaims > 0
//           ? (approvedClaims / totalClaims) * 100
//           : 0;
//       double renewalRate = approvedClaims > 0
//           ? ((approvedClaims - 2) / approvedClaims) * 100
//           : 85.0;

//       if (mounted) {
//         setState(() {
//           _analyticsData = {
//             'totalClaims': totalClaims,
//             'pendingClaims': pendingClaims,
//             'approvedClaims': approvedClaims,
//             'rejectedClaims': rejectedClaims,
//             'totalPayouts': totalPayouts,
//             'approvalRate': approvalRate,
//             'aiAccuracy': 98,
//             'avgProcessingTime': 2.4,
//             'customerSatisfaction': 4.8,
//             'revenue': totalPayouts * 1.2,
//             'activePolicies': approvedClaims,
//             'renewalRate': renewalRate,
//           };
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error loading analytics data: $e');
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _loadRecentActivities() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) return;

//       final activitiesSnapshot = await _firestore
//           .collection('vehicle_owners')
//           .doc(user.email)
//           .collection('insurance_requests')
//           .orderBy('createdAt', descending: true)
//           .limit(5)
//           .get();

//       List<Activity> activities = [];

//       for (var doc in activitiesSnapshot.docs) {
//         final data = doc.data();
//         final status = data['status'] ?? 'pending_review';
//         activities.add(
//           Activity(
//             'Insurance Request ${data['requestId']?.toString().substring(0, 8) ?? ''}',
//             'Status: ${_formatStatus(status)} - ${data['vehicleNumber'] ?? ''}',
//             _getTimeAgo(data['createdAt']?.toDate() ?? DateTime.now()),
//             _getActivityIcon(status),
//             _getActivityColor(status),
//           ),
//         );
//       }

//       // Add default activities if no data found
//       if (activities.isEmpty) {
//         activities = [
//           Activity(
//             'Welcome to Insurance Dashboard',
//             'Get started by submitting your first insurance request',
//             'Just now',
//             Icons.emoji_events,
//             Colors.blue,
//           ),
//           Activity(
//             'System Ready',
//             'Your dashboard is fully operational',
//             'Today',
//             Icons.check_circle,
//             Colors.green,
//           ),
//         ];
//       }

//       if (mounted) {
//         setState(() {
//           _activities = activities;
//         });
//       }
//     } catch (e) {
//       print('Error loading activities: $e');
//       if (mounted) {
//         setState(() {
//           _activities = [
//             Activity(
//               'System Ready',
//               'Dashboard initialized successfully',
//               'Just now',
//               Icons.check_circle,
//               Colors.green,
//             ),
//           ];
//         });
//       }
//     }
//   }

//   void _startNotificationListener() {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     _dbRef.child('notifications').child(user.uid).onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//       int count = 0;

//       if (data != null) {
//         data.forEach((key, value) {
//           if (value is Map && value['read'] == false) {
//             count++;
//           }
//         });
//       }

//       if (mounted) {
//         setState(() {
//           _notificationCount = count;
//         });
//       }
//     });
//   }

//   String _formatStatus(String status) {
//     switch (status) {
//       case 'pending_review':
//         return 'Pending Review';
//       case 'under_review':
//         return 'Under Review';
//       case 'quotes_received':
//         return 'Quotes Received';
//       case 'policy_selected':
//         return 'Policy Selected';
//       case 'payment_pending':
//         return 'Payment Pending';
//       case 'active':
//         return 'Policy Active';
//       case 'completed':
//         return 'Completed';
//       default:
//         return status;
//     }
//   }

//   IconData _getActivityIcon(String type) {
//     switch (type) {
//       case 'active':
//         return Icons.check_circle;
//       case 'completed':
//         return Icons.verified;
//       case 'pending_review':
//         return Icons.pending;
//       case 'under_review':
//         return Icons.search;
//       default:
//         return Icons.notifications;
//     }
//   }

//   Color _getActivityColor(String type) {
//     switch (type) {
//       case 'active':
//       case 'completed':
//         return Colors.green;
//       case 'pending_review':
//       case 'under_review':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getTimeAgo(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inSeconds < 60) return 'Just now';
//     if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
//     if (difference.inHours < 24) return '${difference.inHours}h ago';
//     if (difference.inDays < 7) return '${difference.inDays}d ago';
//     return '${difference.inDays ~/ 7}w ago';
//   }

//   void _handleQuickAction(String action) {
//     switch (action) {
//       case 'create_insurance':
//         _showMessage('Create New Insurance Request');
//         // Navigate to insurance request screen
//         break;
//       case 'track_request':
//         _showMessage('Track Insurance Request');
//         // Navigate to track request screen
//         break;
//       case 'document_upload':
//         _showMessage('Upload Documents');
//         break;
//       case 'export_report':
//         _showMessage('Exporting Report');
//         break;
//       case 'customer_chat':
//         _showMessage('Opening Support Chat');
//         break;
//       case 'policy_review':
//         _showMessage('Reviewing Policies');
//         break;
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }

//   void _navigateToNotifications() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       _showMessage('Please login to view notifications');
//       return;
//     }

//     _showMessage('Navigating to Notifications Page');
//   }

//   void _navigateToProfile() {
//     _showMessage('Navigating to Profile');
//   }

//   void _navigateToSettings() {
//     _showMessage('Navigating to Settings');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Insurance Dashboard'),
//         backgroundColor: const Color(0xFF7E57C2),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_outlined),
//                 onPressed: _navigateToNotifications,
//               ),
//               if (_notificationCount > 0)
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     constraints: const BoxConstraints(
//                       minWidth: 16,
//                       minHeight: 16,
//                     ),
//                     child: Text(
//                       _notificationCount > 9
//                           ? '9+'
//                           : _notificationCount.toString(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           IconButton(
//             icon: Icon(
//               _isAIEnabled ? Icons.auto_awesome : Icons.auto_awesome_outlined,
//             ),
//             onPressed: () => setState(() => _isAIEnabled = !_isAIEnabled),
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert),
//             onSelected: (value) {
//               switch (value) {
//                 case 'profile':
//                   _navigateToProfile();
//                   break;
//                 case 'settings':
//                   _navigateToSettings();
//                   break;
//                 case 'logout':
//                   _logout();
//                   break;
//               }
//             },
//             itemBuilder: (BuildContext context) => [
//               const PopupMenuItem<String>(
//                 value: 'profile',
//                 child: Row(
//                   children: [
//                     Icon(Icons.person, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text('Profile'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'settings',
//                 child: Row(
//                   children: [
//                     Icon(Icons.settings, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text('Settings'),
//                   ],
//                 ),
//               ),
//               const PopupMenuDivider(),
//               const PopupMenuItem<String>(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('Logout', style: TextStyle(color: Colors.red)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildLoadingIndicator()
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildWelcomeCard(),
//                   const SizedBox(height: 20),
//                   _buildQuickStats(),
//                   const SizedBox(height: 20),
//                   _buildQuickActionsGrid(),
//                   const SizedBox(height: 20),
//                   _buildAIInsights(),
//                   const SizedBox(height: 20),
//                   _buildRecentActivities(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7E57C2)),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Loading Dashboard...',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => InsuranceLoginPage()),
//                 (route) => false,
//               );
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard() {
//     final user = _auth.currentUser;
//     final userName = user?.displayName ?? 'User';
//     final userEmail = user?.email ?? '';

//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF7E57C2).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Welcome back, $userName!',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   userEmail,
//                   style: const TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'You have ${_analyticsData['pendingClaims']} pending requests that need your attention.',
//                   style: const TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _buildMetricChip('AI Active', Icons.auto_awesome),
//                     _buildMetricChip(
//                       '${_analyticsData['aiAccuracy']}% Accuracy',
//                       Icons.verified,
//                     ),
//                     _buildMetricChip(
//                       '${_analyticsData['activePolicies']} Policies',
//                       Icons.policy,
//                     ),
//                     _buildMetricChip(
//                       '\$${(_analyticsData['revenue'] / 1000).toStringAsFixed(0)}K Revenue',
//                       Icons.attach_money,
//                     ),
//                     if (_notificationCount > 0)
//                       _buildMetricChip(
//                         '$_notificationCount Notifications',
//                         Icons.notifications,
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.analytics, color: Colors.white, size: 40),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricChip(String text, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white, size: 14),
//           const SizedBox(width: 6),
//           Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 1.2,
//       children: [
//         _buildStatCard(
//           'Total Policies',
//           _analyticsData['totalClaims'].toString(),
//           Icons.policy,
//           const Color(0xFF7E57C2),
//         ),
//         _buildStatCard(
//           'Pending',
//           _analyticsData['pendingClaims'].toString(),
//           Icons.pending_actions,
//           const Color(0xFFFFA000),
//         ),
//         _buildStatCard(
//           'Active',
//           _analyticsData['approvedClaims'].toString(),
//           Icons.thumb_up,
//           const Color(0xFF4CAF50),
//         ),
//         _buildStatCard(
//           'Notifications',
//           _notificationCount.toString(),
//           Icons.notifications,
//           const Color(0xFF2196F3),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF333333),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 title,
//                 style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionsGrid() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Quick Actions',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF333333),
//               ),
//             ),
//             if (_notificationCount > 0)
//               TextButton(
//                 onPressed: _navigateToNotifications,
//                 child: const Text(
//                   'View Notifications',
//                   style: TextStyle(
//                     color: Color(0xFF7E57C2),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 3,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.2,
//           children: _quickActions
//               .map((action) => _buildQuickActionItem(action))
//               .toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionItem(Map<String, dynamic> action) {
//     return GestureDetector(
//       onTap: () => _handleQuickAction(action['action']),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: action['color'].withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(action['icon'], color: action['color'], size: 24),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               action['title'],
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF333333),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAIInsights() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.auto_awesome, color: Color(0xFF7E57C2)),
//               const SizedBox(width: 8),
//               const Text(
//                 'AI Insights & Predictions',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const Spacer(),
//               Switch(
//                 value: _isAIEnabled,
//                 onChanged: (value) => setState(() => _isAIEnabled = value),
//                 activeThumbColor: const Color(0xFF7E57C2),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildAIPredictionItem(
//             'Approval Rate',
//             '${_analyticsData['approvalRate'].toStringAsFixed(1)}% request approval rate',
//             Icons.trending_up,
//             Colors.green,
//           ),
//           _buildAIPredictionItem(
//             'Active Policies',
//             '${_analyticsData['activePolicies']} active insurance policies',
//             Icons.policy,
//             Colors.purple,
//           ),
//           _buildAIPredictionItem(
//             'Revenue',
//             '\$${_analyticsData['revenue'].toStringAsFixed(0)} total revenue',
//             Icons.attach_money,
//             Colors.blue,
//           ),
//           if (_notificationCount > 0)
//             _buildAIPredictionItem(
//               'Notifications',
//               '$_notificationCount unread notifications',
//               Icons.notifications,
//               Colors.orange,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAIPredictionItem(
//     String title,
//     String subtitle,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 16),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     color: Color(0xFF666666),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.chevron_right, color: Color(0xFF999999)),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivities() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Recent Activities',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//               TextButton(
//                 onPressed: _navigateToNotifications,
//                 child: const Text(
//                   'View All',
//                   style: TextStyle(
//                     color: Color(0xFF7E57C2),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ..._activities.map((activity) => _buildActivityItem(activity)),
//           if (_notificationCount > 0)
//             _buildActivityItem(
//               Activity(
//                 'New Notifications',
//                 'You have $_notificationCount unread notifications',
//                 'Just now',
//                 Icons.notifications,
//                 Colors.blue,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityItem(Activity activity) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F7),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: activity.color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(activity.icon, color: activity.color, size: 16),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   activity.title,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   activity.description,
//                   style: const TextStyle(
//                     color: Color(0xFF666666),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             activity.time,
//             style: const TextStyle(color: Color(0xFF999999), fontSize: 11),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Activity {
//   final String title;
//   final String description;
//   final String time;
//   final IconData icon;
//   final Color color;

//   Activity(this.title, this.description, this.time, this.icon, this.color);
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';
import 'package:smart_road_app/core/language/language_selector.dart';
import 'package:smart_road_app/Login/InsuranceLogin.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isAIEnabled = true;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  Map<String, dynamic> _analyticsData = {
    'totalClaims': 0,
    'pendingClaims': 0,
    'approvedClaims': 0,
    'rejectedClaims': 0,
    'totalPayouts': 0,
    'approvalRate': 0,
    'aiAccuracy': 98,
    'avgProcessingTime': 0.0,
    'customerSatisfaction': 0.0,
    'revenue': 0,
    'activePolicies': 0,
    'renewalRate': 0,
  };

  int _notificationCount = 0;
  List<Activity> _activities = [];
  bool _isLoading = true;
  String? _userEmail;

  final List<Map<String, dynamic>> _quickActions = [
    {'title': 'New Insurance', 'icon': Icons.add_circle, 'color': Color(0xFF7E57C2), 'action': 'create_insurance'},
    {'title': 'Track Request', 'icon': Icons.track_changes, 'color': Color(0xFF4CAF50), 'action': 'track_request'},
    {'title': 'Document Upload', 'icon': Icons.upload, 'color': Color(0xFFFFA000), 'action': 'document_upload'},
    {'title': 'Export Report', 'icon': Icons.download, 'color': Color(0xFF2196F3), 'action': 'export_report'},
    {'title': 'Support Chat', 'icon': Icons.chat, 'color': Color(0xFF9C27B0), 'action': 'customer_chat'},
    {'title': 'Policy Review', 'icon': Icons.policy, 'color': Color(0xFFF44336), 'action': 'policy_review'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _loadUserData();
    _loadAnalyticsData();
    _loadRecentActivities();
    _startNotificationListener();
  }

  void _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _loadAnalyticsData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final claimsSnapshot = await _firestore
          .collection('vehicle_owners')
          .doc(user.email)
          .collection('insurance_requests')
          .get();

      int totalClaims = claimsSnapshot.docs.length;
      int pendingClaims = 0;
      int approvedClaims = 0;
      int rejectedClaims = 0;
      double totalPayouts = 0;

      for (var doc in claimsSnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'pending';
        final amount = double.tryParse(data['quoteAmount']?.toString() ?? data['estimatedPremium']?.toString() ?? '0') ?? 0;

        if (status == 'pending_review' || status == 'under_review') pendingClaims++;
        if (status == 'active' || status == 'completed') {
          approvedClaims++;
          totalPayouts += amount;
        }
        if (status == 'rejected') rejectedClaims++;
      }

      double approvalRate = totalClaims > 0 ? (approvedClaims / totalClaims) * 100 : 0;
      double renewalRate = approvedClaims > 0 ? ((approvedClaims - 2) / approvedClaims) * 100 : 85.0;

      if (mounted) {
        setState(() {
          _analyticsData = {
            'totalClaims': totalClaims,
            'pendingClaims': pendingClaims,
            'approvedClaims': approvedClaims,
            'rejectedClaims': rejectedClaims,
            'totalPayouts': totalPayouts,
            'approvalRate': approvalRate,
            'aiAccuracy': 98,
            'avgProcessingTime': 2.4,
            'customerSatisfaction': 4.8,
            'revenue': totalPayouts * 1.2,
            'activePolicies': approvedClaims,
            'renewalRate': renewalRate,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading analytics data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadRecentActivities() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final activitiesSnapshot = await _firestore
          .collection('vehicle_owners')
          .doc(user.email)
          .collection('insurance_requests')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      List<Activity> activities = [];
      
      for (var doc in activitiesSnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'pending_review';
        activities.add(Activity(
          'Insurance Request ${data['requestId']?.toString().substring(0, 8) ?? ''}',
          'Status: ${_formatStatus(status)} - ${data['vehicleNumber'] ?? ''}',
          _getTimeAgo(data['createdAt']?.toDate() ?? DateTime.now()),
          _getActivityIcon(status),
          _getActivityColor(status),
        ));
      }

      if (activities.isEmpty) {
        activities = [
          Activity('Welcome to Insurance Dashboard', 'Get started by submitting your first insurance request', 'Just now', Icons.emoji_events, Colors.blue),
          Activity('System Ready', 'Your dashboard is fully operational', 'Today', Icons.check_circle, Colors.green),
        ];
      }

      if (mounted) {
        setState(() {
          _activities = activities;
        });
      }
    } catch (e) {
      print('Error loading activities: $e');
      if (mounted) {
        setState(() {
          _activities = [
            Activity('System Ready', 'Dashboard initialized successfully', 'Just now', Icons.check_circle, Colors.green),
          ];
        });
      }
    }
  }

  void _startNotificationListener() {
    final user = _auth.currentUser;
    if (user == null) return;

    _dbRef.child('notifications').child(user.uid).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      int count = 0;
      
      if (data != null) {
        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            count++;
          }
        });
      }
      
      if (mounted) {
        setState(() {
          _notificationCount = count;
        });
      }
    });
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'pending_review': return 'Pending Review';
      case 'under_review': return 'Under Review';
      case 'quotes_received': return 'Quotes Received';
      case 'policy_selected': return 'Policy Selected';
      case 'payment_pending': return 'Payment Pending';
      case 'active': return 'Policy Active';
      case 'completed': return 'Completed';
      default: return status;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'active': return Icons.check_circle;
      case 'completed': return Icons.verified;
      case 'pending_review': return Icons.pending;
      case 'under_review': return Icons.search;
      default: return Icons.notifications;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'active': case 'completed': return Colors.green;
      case 'pending_review': case 'under_review': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }

  void _handleQuickAction(String action) {
    final localizations = AppLocalizations.of(context);
    switch (action) {
      case 'create_insurance':
        _showMessage(localizations?.translate('create_insurance') ?? 'Create New Insurance Request');
        break;
      case 'track_request':
        _showMessage(localizations?.translate('track_request') ?? 'Track Insurance Request');
        break;
      case 'document_upload':
        _showMessage(localizations?.translate('document_upload') ?? 'Upload Documents');
        break;
      case 'export_report':
        _showMessage(localizations?.translate('export_report') ?? 'Exporting Report');
        break;
      case 'customer_chat':
        _showMessage(localizations?.translate('support_chat') ?? 'Opening Support Chat');
        break;
      case 'policy_review':
        _showMessage(localizations?.translate('policy_review') ?? 'Reviewing Policies');
        break;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToNotifications() {
    final user = _auth.currentUser;
    final localizations = AppLocalizations.of(context);
    if (user == null) {
      _showMessage(localizations?.translate('login_required') ?? 'Please login to view notifications');
      return;
    }
    
    _showMessage(localizations?.translate('navigating_notifications') ?? 'Navigating to Notifications Page');
  }

  void _navigateToProfile() {
    final localizations = AppLocalizations.of(context);
    _showMessage(localizations?.translate('navigating_profile') ?? 'Navigating to Profile');
  }

  void _navigateToSettings() {
    final localizations = AppLocalizations.of(context);
    _showMessage(localizations?.translate('navigating_settings') ?? 'Navigating to Settings');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('insurance_dashboard') ?? 'Insurance Dashboard'),
        backgroundColor: const Color(0xFF7E57C2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: _navigateToNotifications,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _notificationCount > 9 ? '9+' : _notificationCount.toString(),
                      style: const TextStyle(
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
            icon: Icon(_isAIEnabled ? Icons.auto_awesome : Icons.auto_awesome_outlined),
            onPressed: () => setState(() => _isAIEnabled = !_isAIEnabled),
          ),
          LanguageSelector(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _navigateToProfile();
                  break;
                case 'settings':
                  _navigateToSettings();
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading 
          ? _buildLoadingIndicator(localizations)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildWelcomeCard(localizations),
                  const SizedBox(height: 20),
                  _buildQuickStats(localizations),
                  const SizedBox(height: 20),
                  _buildQuickActionsGrid(localizations),
                  const SizedBox(height: 20),
                  _buildAIInsights(localizations),
                  const SizedBox(height: 20),
                  _buildRecentActivities(localizations),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingIndicator(AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7E57C2)),
          ),
          const SizedBox(height: 20),
          Text(
            localizations?.translate('loading') ?? 'Loading Dashboard...',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.logout ?? 'Logout'),
        content: Text(localizations?.translate('logout_confirm_message') ?? 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => InsuranceLoginPage()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(localizations?.logout ?? 'Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(AppLocalizations? localizations) {
    final user = _auth.currentUser;
    final userName = user?.displayName ?? 'User';
    final userEmail = user?.email ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF7E57C2).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${localizations?.welcomeBack ?? 'Welcome back'}, $userName!', 
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text('${localizations?.translate('you_have_pending_requests') ?? 'You have'} ${_analyticsData['pendingClaims']} ${localizations?.translate('pending_requests_attention') ?? 'pending requests that need your attention.'}', 
                     style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildMetricChip('AI Active', Icons.auto_awesome, localizations),
                    _buildMetricChip('${_analyticsData['aiAccuracy']}% ${localizations?.translate('accuracy') ?? 'Accuracy'}', Icons.verified, localizations),
                    _buildMetricChip('${_analyticsData['activePolicies']} ${localizations?.translate('policies') ?? 'Policies'}', Icons.policy, localizations),
                    _buildMetricChip('\$${(_analyticsData['revenue']/1000).toStringAsFixed(0)}K ${localizations?.translate('revenue') ?? 'Revenue'}', Icons.attach_money, localizations),
                    if (_notificationCount > 0)
                      _buildMetricChip('$_notificationCount ${localizations?.translate('notifications') ?? 'Notifications'}', Icons.notifications, localizations),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80, 
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), 
              shape: BoxShape.circle
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String text, IconData icon, AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), 
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]
      ),
    );
  }

  Widget _buildQuickStats(AppLocalizations? localizations) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(localizations?.translate('total_policies') ?? 'Total Policies', _analyticsData['totalClaims'].toString(), Icons.policy, const Color(0xFF7E57C2)),
        _buildStatCard(localizations?.translate('pending') ?? 'Pending', _analyticsData['pendingClaims'].toString(), Icons.pending_actions, const Color(0xFFFFA000)),
        _buildStatCard(localizations?.translate('active') ?? 'Active', _analyticsData['approvedClaims'].toString(), Icons.thumb_up, const Color(0xFF4CAF50)),
        _buildStatCard(localizations?.translate('notifications') ?? 'Notifications', _notificationCount.toString(), Icons.notifications, const Color(0xFF2196F3)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(localizations?.translate('quick_actions') ?? 'Quick Actions', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            if (_notificationCount > 0)
              TextButton(
                onPressed: _navigateToNotifications,
                child: Text(
                  localizations?.translate('view_notifications') ?? 'View Notifications',
                  style: const TextStyle(color: Color(0xFF7E57C2), fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: _quickActions.map((action) => _buildQuickActionItem(action, localizations)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(Map<String, dynamic> action, AppLocalizations? localizations) {
    return GestureDetector(
      onTap: () => _handleQuickAction(action['action']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action['icon'], color: action['color'], size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              _getTranslatedActionTitle(action['title'], localizations),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTranslatedActionTitle(String title, AppLocalizations? localizations) {
    switch (title) {
      case 'New Insurance':
        return localizations?.translate('create_insurance') ?? title;
      case 'Track Request':
        return localizations?.translate('track_request') ?? title;
      case 'Document Upload':
        return localizations?.translate('document_upload') ?? title;
      case 'Export Report':
        return localizations?.translate('export_report') ?? title;
      case 'Support Chat':
        return localizations?.translate('support_chat') ?? title;
      case 'Policy Review':
        return localizations?.translate('policy_review') ?? title;
      default:
        return title;
    }
  }

  Widget _buildAIInsights(AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF7E57C2)),
            const SizedBox(width: 8),
            Text(localizations?.translate('ai_insights') ?? 'AI Insights & Predictions', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Spacer(),
            Switch(
              value: _isAIEnabled, 
              onChanged: (value) => setState(() => _isAIEnabled = value), 
              activeThumbColor: const Color(0xFF7E57C2)
            ),
          ]),
          const SizedBox(height: 16),
          _buildAIPredictionItem(localizations?.translate('approval_rate') ?? 'Approval Rate', '${_analyticsData['approvalRate'].toStringAsFixed(1)}% ${localizations?.translate('request_approval_rate') ?? 'request approval rate'}', Icons.trending_up, Colors.green),
          _buildAIPredictionItem(localizations?.translate('active_policies') ?? 'Active Policies', '${_analyticsData['activePolicies']} ${localizations?.translate('active_policies') ?? 'active insurance policies'}', Icons.policy, Colors.purple),
          _buildAIPredictionItem(localizations?.translate('revenue') ?? 'Revenue', '\$${_analyticsData['revenue'].toStringAsFixed(0)} ${localizations?.translate('total_revenue') ?? 'total revenue'}', Icons.attach_money, Colors.blue),
          if (_notificationCount > 0)
            _buildAIPredictionItem(localizations?.translate('notifications') ?? 'Notifications', '$_notificationCount ${localizations?.translate('unread_notifications') ?? 'unread notifications'}', Icons.notifications, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAIPredictionItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
        ])),
        const Icon(Icons.chevron_right, color: Color(0xFF999999)),
      ]),
    );
  }

  Widget _buildRecentActivities(AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(localizations?.translate('recent_activities') ?? 'Recent Activities', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          TextButton(
            onPressed: _navigateToNotifications, 
            child: Text(localizations?.translate('view_all') ?? 'View All', style: const TextStyle(color: Color(0xFF7E57C2), fontWeight: FontWeight.w500))
          ),
        ]),
        const SizedBox(height: 16),
        ..._activities.map((activity) => _buildActivityItem(activity)),
        if (_notificationCount > 0)
          _buildActivityItem(
            Activity(
              localizations?.translate('new_notifications') ?? 'New Notifications', 
              '${localizations?.translate('you_have') ?? 'You have'} $_notificationCount ${localizations?.translate('unread_notifications') ?? 'unread notifications'}', 
              'Just now', 
              Icons.notifications, 
              Colors.blue
            ),
          ),
      ]),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F7), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: activity.color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(activity.icon, color: activity.color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(activity.description, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
        ])),
        Text(activity.time, style: const TextStyle(color: Color(0xFF999999), fontSize: 11)),
      ]),
    );
  }
}

class Activity {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  Activity(this.title, this.description, this.time, this.icon, this.color);
}