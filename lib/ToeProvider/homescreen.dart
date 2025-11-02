// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProviderHomeScreen extends StatefulWidget {
//   const ProviderHomeScreen({super.key});

//   @override
//   State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
// }

// class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
  
//   Map<String, dynamic> _providerData = {};
//   bool _isLoading = true;
//   bool _isOnline = true;
//   List<Map<String, dynamic>> _recentRequests = [];
//   List<Map<String, dynamic>> _activeJobs = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadProviderData();
//     _loadRecentRequests();
//     _loadActiveJobs();
//   }

//   Future<void> _loadProviderData() async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         throw Exception('User not logged in');
//       }

//       String userEmail = currentUser.email!;

//       // Load provider profile data
//       DocumentSnapshot profileSnapshot = await _firestore
//           .collection('tow')
//           .doc(userEmail)
//           .collection('profile')
//           .doc('provider_details')
//           .get();

//       Map<String, dynamic> providerData;
      
//       if (!profileSnapshot.exists) {
//         providerData = _getDefaultProviderData(currentUser);
//       } else {
//         Map<String, dynamic> firestoreData = profileSnapshot.data() as Map<String, dynamic>;
//         providerData = _enhanceProviderData(firestoreData, currentUser);
//       }

//       // Load dynamic stats
//       final stats = await _loadProviderStats(userEmail);
      
//       setState(() {
//         _providerData = {...providerData, ...stats};
//         _isOnline = providerData['isOnline'] ?? true;
//         _isLoading = false;
//       });

//     } catch (e) {
//       print('Error loading provider data: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<Map<String, dynamic>> _loadProviderStats(String userEmail) async {
//     try {
//       // Get today's earnings from completed jobs
//       final now = DateTime.now();
//       final startOfDay = DateTime(now.year, now.month, now.day);
      
//       final earningsSnapshot = await _firestore
//           .collection('tow_requests')
//           .where('assignedProvider', isEqualTo: userEmail)
//           .where('status', isEqualTo: 'completed')
//           .where('completedAt', isGreaterThanOrEqualTo: startOfDay)
//           .get();

//       double todayEarnings = 0;
//       for (var doc in earningsSnapshot.docs) {
//         final data = doc.data();
//         todayEarnings += (data['amount'] ?? 0).toDouble();
//       }

//       // Get active jobs count
//       final activeJobsSnapshot = await _firestore
//           .collection('tow_requests')
//           .where('assignedProvider', isEqualTo: userEmail)
//           .where('status', whereIn: ['accepted', 'in_progress'])
//           .get();

//       // Get total jobs count
//       final totalJobsSnapshot = await _firestore
//           .collection('tow_requests')
//           .where('assignedProvider', isEqualTo: userEmail)
//           .get();

//       // Get average rating
//       final ratingSnapshot = await _firestore
//           .collection('reviews')
//           .where('providerEmail', isEqualTo: userEmail)
//           .get();

//       double averageRating = 4.8; // default
//       if (ratingSnapshot.docs.isNotEmpty) {
//         double totalRating = 0;
//         for (var doc in ratingSnapshot.docs) {
//           totalRating += (doc.data()['rating'] ?? 5).toDouble();
//         }
//         averageRating = totalRating / ratingSnapshot.docs.length;
//       }

//       return {
//         'todayEarnings': todayEarnings,
//         'activeJobs': activeJobsSnapshot.docs.length,
//         'totalJobs': totalJobsSnapshot.docs.length,
//         'rating': double.parse(averageRating.toStringAsFixed(1)),
//       };

//     } catch (e) {
//       print('Error loading stats: $e');
//       return {
//         'todayEarnings': 0.0,
//         'activeJobs': 0,
//         'totalJobs': 0,
//         'rating': 4.8,
//       };
//     }
//   }

//   Future<void> _loadRecentRequests() async {
//     try {
//       // Get requests from last 5 minutes
//       final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      
//       final requestsSnapshot = await _firestore
//           .collection('tow_requests')
//           .where('status', isEqualTo: 'pending')
//           .where('createdAt', isGreaterThanOrEqualTo: fiveMinutesAgo)
//           .orderBy('createdAt', descending: true)
//           .limit(5)
//           .get();

//       setState(() {
//         _recentRequests = requestsSnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? 'Unknown',
//             'phone': data['phone'] ?? '',
//             'location': data['location'] ?? 'Location not specified',
//             'vehicleNumber': data['vehicleNumber'] ?? 'Unknown Vehicle',
//             'issueType': data['issueType'] ?? 'Unknown Issue',
//             'towType': data['towType'] ?? 'Standard',
//             'isUrgent': data['isUrgent'] ?? false,
//             'createdAt': data['createdAt'] ?? Timestamp.now(),
//             'latitude': data['latitude'],
//             'longitude': data['longitude'],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       print('Error loading recent requests: $e');
//     }
//   }

//   Future<void> _loadActiveJobs() async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) return;

//       final activeJobsSnapshot = await _firestore
//           .collection('tow_requests')
//           .where('assignedProvider', isEqualTo: currentUser.email)
//           .where('status', whereIn: ['accepted', 'in_progress'])
//           .orderBy('acceptedAt', descending: true)
//           .limit(3)
//           .get();

//       setState(() {
//         _activeJobs = activeJobsSnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? 'Unknown',
//             'phone': data['phone'] ?? '',
//             'location': data['location'] ?? 'Location not specified',
//             'vehicleNumber': data['vehicleNumber'] ?? 'Unknown Vehicle',
//             'issueType': data['issueType'] ?? 'Unknown Issue',
//             'status': data['status'] ?? 'accepted',
//             'amount': data['amount'] ?? 0.0,
//             'acceptedAt': data['acceptedAt'] ?? Timestamp.now(),
//             'latitude': data['latitude'],
//             'longitude': data['longitude'],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       print('Error loading active jobs: $e');
//     }
//   }

//   Map<String, dynamic> _getDefaultProviderData(User user) {
//     return {
//       'driverName': user.displayName ?? 'Provider',
//       'email': user.email ?? 'No email',
//       'truckNumber': 'Not assigned',
//       'truckType': 'Tow Truck Operator',
//       'status': 'active',
//       'isOnline': true,
//     };
//   }

//   Map<String, dynamic> _enhanceProviderData(Map<String, dynamic> data, User user) {
//     return {
//       'driverName': data['driverName'] ?? user.displayName ?? 'Provider',
//       'email': data['email'] ?? user.email ?? 'No email',
//       'truckNumber': data['truckNumber'] ?? 'Not assigned',
//       'truckType': data['truckType'] ?? 'Tow Truck Operator',
//       'status': data['status'] ?? 'active',
//       'isOnline': data['isOnline'] ?? true,
//     };
//   }

//   Future<void> _toggleOnlineStatus(bool value) async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser != null) {
//         String userEmail = currentUser.email!;
        
//         await _firestore
//             .collection('tow')
//             .doc(userEmail)
//             .collection('profile')
//             .doc('provider_details')
//             .update({
//               'isOnline': value,
//               'updatedAt': FieldValue.serverTimestamp(),
//             });

//         setState(() {
//           _isOnline = value;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(value ? 'You are now online' : 'You are now offline'),
//             backgroundColor: value ? Colors.green : Colors.orange,
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error updating online status: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to update status'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _acceptRequest(Map<String, dynamic> request) async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) return;

//       await _firestore
//           .collection('tow_requests')
//           .doc(request['id'])
//           .update({
//             'status': 'accepted',
//             'assignedProvider': currentUser.email,
//             'acceptedAt': FieldValue.serverTimestamp(),
//           });

//       // Reload data
//       _loadRecentRequests();
//       _loadActiveJobs();
//       _loadProviderData();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Request accepted successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print('Error accepting request: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to accept request'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;

//     if (_isLoading) {
//       return _buildLoadingState(isTablet);
//     }

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildWelcomeCard(isTablet),
//           SizedBox(height: isTablet ? 32 : 24),
//           _buildQuickStats(isTablet),
//           SizedBox(height: isTablet ? 32 : 24),
//           if (_activeJobs.isNotEmpty) ...[
//             _buildActiveJobsSection(isTablet),
//             SizedBox(height: isTablet ? 32 : 24),
//           ],
//           if (_recentRequests.isNotEmpty) ...[
//             _buildRecentRequestsSection(isTablet),
//             SizedBox(height: isTablet ? 32 : 24),
//           ],
//           _buildQuickActions(isTablet),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState(bool isTablet) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7E57C2)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading Dashboard...',
//             style: TextStyle(
//               fontSize: isTablet ? 18 : 16,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard(bool isTablet) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isTablet ? 28 : 20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
//         ),
//         borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF7E57C2).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isTablet ? 32 : 24,
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 child: Icon(Icons.person, color: Colors.white, 
//                     size: isTablet ? 28 : 24),
//               ),
//               SizedBox(width: isTablet ? 16 : 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Welcome back,',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: isTablet ? 16 : 14,
//                       ),
//                     ),
//                     Text(
//                       '${_providerData['driverName'] ?? 'Provider'}!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isTablet ? 22 : 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       _providerData['truckNumber'] ?? 'Truck not assigned',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: isTablet ? 14 : 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Switch(
//                 value: _isOnline,
//                 onChanged: _toggleOnlineStatus,
//                 activeThumbColor: Colors.white,
//                 activeTrackColor: Colors.white.withOpacity(0.5),
//               )
//             ],
//           ),
//           SizedBox(height: isTablet ? 20 : 16),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Status:',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.circle, 
//                         color: _isOnline ? Colors.green : Colors.red, 
//                         size: 12),
//                     SizedBox(width: 8),
//                     Text(
//                       _isOnline ? 'Online - Accepting Requests' : 'Offline - Not Available',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats(bool isTablet) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             title: 'Active Jobs',
//             value: '${_providerData['activeJobs'] ?? '0'}',
//             icon: Icons.work,
//             color: const Color(0xFF7E57C2),
//             isTablet: isTablet,
//           ),
//         ),
//         SizedBox(width: isTablet ? 16 : 12),
//         Expanded(
//           child: _buildStatCard(
//             title: 'Today\'s Earnings',
//             value: '\$${(_providerData['todayEarnings'] ?? 0).toStringAsFixed(0)}',
//             icon: Icons.attach_money,
//             color: const Color(0xFF4CAF50),
//             isTablet: isTablet,
//           ),
//         ),
//         SizedBox(width: isTablet ? 16 : 12),
//         Expanded(
//           child: _buildStatCard(
//             title: 'Total Jobs',
//             value: '${_providerData['totalJobs'] ?? '0'}',
//             icon: Icons.list_alt,
//             color: const Color(0xFF2196F3),
//             isTablet: isTablet,
//           ),
//         ),
//         SizedBox(width: isTablet ? 16 : 12),
//         Expanded(
//           child: _buildStatCard(
//             title: 'Rating',
//             value: '${_providerData['rating']?.toStringAsFixed(1) ?? '0.0'}',
//             icon: Icons.star,
//             color: const Color(0xFFFFA000),
//             isTablet: isTablet,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required bool isTablet,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(isTablet ? 12 : 8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: isTablet ? 24 : 20),
//           ),
//           SizedBox(height: isTablet ? 12 : 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isTablet ? 24 : 20,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF333333),
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               color: const Color(0xFF666666),
//               fontSize: isTablet ? 14 : 12,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActiveJobsSection(bool isTablet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Active Jobs',
//               style: TextStyle(
//                 fontSize: isTablet ? 22 : 18,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF333333),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to active jobs screen
//               },
//               child: Text(
//                 'View All',
//                 style: TextStyle(
//                   color: const Color(0xFF7E57C2),
//                   fontSize: isTablet ? 16 : 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: isTablet ? 16 : 12),
//         ..._activeJobs.map((job) => _buildActiveJobCard(job, isTablet)),
//       ],
//     );
//   }

//   Widget _buildActiveJobCard(Map<String, dynamic> job, bool isTablet) {
//     return Container(
//       margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: isTablet ? 50 : 40,
//             height: isTablet ? 50 : 40,
//             decoration: BoxDecoration(
//               color: const Color(0xFF7E57C2).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.directions_car, color: const Color(0xFF7E57C2)),
//           ),
//           SizedBox(width: isTablet ? 16 : 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   job['name'] ?? 'Unknown Customer',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF333333),
//                     fontSize: isTablet ? 16 : 14,
//                   ),
//                 ),
//                 Text(
//                   '${job['vehicleNumber']} • ${job['issueType']}',
//                   style: TextStyle(
//                     color: const Color(0xFF666666),
//                     fontSize: isTablet ? 14 : 12,
//                   ),
//                 ),
//                 Text(
//                   job['location'],
//                   style: TextStyle(
//                     color: const Color(0xFF7E57C2),
//                     fontSize: isTablet ? 14 : 12,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(job['status']).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   job['status'].toString().replaceAll('_', ' ').toUpperCase(),
//                   style: TextStyle(
//                     color: _getStatusColor(job['status']),
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 '\$${(job['amount'] ?? 0).toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF333333),
//                   fontSize: isTablet ? 16 : 14,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentRequestsSection(bool isTablet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'New Requests (Last 5 mins)',
//               style: TextStyle(
//                 fontSize: isTablet ? 22 : 18,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF333333),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFA000).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 '${_recentRequests.length} New',
//                 style: TextStyle(
//                   color: const Color(0xFFFFA000),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: isTablet ? 16 : 12),
//         ..._recentRequests.map((request) => _buildRequestCard(request, isTablet)),
//       ],
//     );
//   }

//   Widget _buildRequestCard(Map<String, dynamic> request, bool isTablet) {
//     return Container(
//       margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(
//           color: const Color(0xFFFFA000).withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: const Color(0xFFFFA000).withOpacity(0.1),
//                 child: Icon(Icons.person, color: const Color(0xFFFFA000)),
//               ),
//               SizedBox(width: isTablet ? 16 : 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       request['name'] ?? 'Unknown',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF333333),
//                         fontSize: isTablet ? 16 : 14,
//                       ),
//                     ),
//                     Text(
//                       request['phone'],
//                       style: TextStyle(
//                         color: const Color(0xFF666666),
//                         fontSize: isTablet ? 14 : 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (request['isUrgent'] == true)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.warning, color: Colors.red, size: 14),
//                       SizedBox(width: 4),
//                       Text(
//                         'URGENT',
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: isTablet ? 12 : 8),
//           Row(
//             children: [
//               _buildDetailChip(Icons.directions_car, request['vehicleNumber'], isTablet),
//               SizedBox(width: 8),
//               _buildDetailChip(Icons.build, request['issueType'], isTablet),
//               SizedBox(width: 8),
//               _buildDetailChip(Icons.local_shipping, request['towType'], isTablet),
//             ],
//           ),
//           SizedBox(height: isTablet ? 12 : 8),
//           Text(
//             request['location'],
//             style: TextStyle(
//               color: const Color(0xFF666666),
//               fontSize: isTablet ? 14 : 12,
//             ),
//           ),
//           SizedBox(height: isTablet ? 12 : 8),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isOnline ? () => _acceptRequest(request) : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF7E57C2),
//                 foregroundColor: Colors.white,
//               ),
//               child: Text('Accept Request'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailChip(IconData icon, String text, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F7),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: const Color(0xFF7E57C2), size: 14),
//           SizedBox(width: 4),
//           Text(
//             text.length > 15 ? '${text.substring(0, 15)}...' : text,
//             style: TextStyle(
//               fontSize: isTablet ? 12 : 10,
//               color: const Color(0xFF666666),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions(bool isTablet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: isTablet ? 22 : 18,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF333333),
//           ),
//         ),
//         SizedBox(height: isTablet ? 20 : 16),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: isTablet ? 4 : 2,
//           crossAxisSpacing: isTablet ? 16 : 12,
//           mainAxisSpacing: isTablet ? 16 : 12,
//           children: [
//             _buildActionButton(
//               icon: Icons.request_quote,
//               title: 'All Requests',
//               subtitle: 'View all requests',
//               color: const Color(0xFF7E57C2),
//               isTablet: isTablet,
//               onTap: () {
//                 // Navigate to all requests screen
//               },
//             ),
//             _buildActionButton(
//               icon: Icons.work,
//               title: 'My Jobs',
//               subtitle: 'Active & history',
//               color: const Color(0xFF5E35B1),
//               isTablet: isTablet,
//               onTap: () {
//                 // Navigate to my jobs screen
//               },
//             ),
//             _buildActionButton(
//               icon: Icons.attach_money,
//               title: 'Earnings',
//               subtitle: 'View reports',
//               color: const Color(0xFF4CAF50),
//               isTablet: isTablet,
//               onTap: () {
//                 // Navigate to earnings screen
//               },
//             ),
//             _buildActionButton(
//               icon: Icons.settings,
//               title: 'Profile',
//               subtitle: 'Update details',
//               color: const Color(0xFF2196F3),
//               isTablet: isTablet,
//               onTap: () {
//                 // Navigate to profile screen
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required bool isTablet,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(isTablet ? 20 : 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(isTablet ? 12 : 10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: color, size: isTablet ? 24 : 20),
//             ),
//             SizedBox(height: isTablet ? 12 : 8),
//             Text(
//               title,
//               style: TextStyle(
//                 color: const Color(0xFF333333),
//                 fontSize: isTablet ? 16 : 14,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: const Color(0xFF666666),
//                 fontSize: isTablet ? 12 : 10,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'accepted':
//         return const Color(0xFFFFA000);
//       case 'in_progress':
//         return const Color(0xFF2196F3);
//       case 'completed':
//         return const Color(0xFF4CAF50);
//       case 'cancelled':
//         return const Color(0xFFF44336);
//       default:
//         return const Color(0xFF666666);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';
import 'package:smart_road_app/core/language/language_selector.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Map<String, dynamic> _providerData = {};
  bool _isLoading = true;
  bool _isOnline = true;
  List<Map<String, dynamic>> _recentRequests = [];
  List<Map<String, dynamic>> _activeJobs = [];

  @override
  void initState() {
    super.initState();
    _loadProviderData();
    _loadRecentRequests();
    _loadActiveJobs();
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

      Map<String, dynamic> providerData;
      
      if (!profileSnapshot.exists) {
        providerData = _getDefaultProviderData(currentUser);
      } else {
        Map<String, dynamic> firestoreData = profileSnapshot.data() as Map<String, dynamic>;
        providerData = _enhanceProviderData(firestoreData, currentUser);
      }

      final stats = await _loadProviderStats(userEmail);
      
      setState(() {
        _providerData = {...providerData, ...stats};
        _isOnline = providerData['isOnline'] ?? true;
        _isLoading = false;
      });

    } catch (e) {
      print('Error loading provider data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _loadProviderStats(String userEmail) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      
      final earningsSnapshot = await _firestore
          .collection('tow_requests')
          .where('assignedProvider', isEqualTo: userEmail)
          .where('status', isEqualTo: 'completed')
          .where('completedAt', isGreaterThanOrEqualTo: startOfDay)
          .get();

      double todayEarnings = 0;
      for (var doc in earningsSnapshot.docs) {
        final data = doc.data();
        todayEarnings += (data['amount'] ?? 0).toDouble();
      }

      final activeJobsSnapshot = await _firestore
          .collection('tow_requests')
          .where('assignedProvider', isEqualTo: userEmail)
          .where('status', whereIn: ['accepted', 'in_progress'])
          .get();

      final totalJobsSnapshot = await _firestore
          .collection('tow_requests')
          .where('assignedProvider', isEqualTo: userEmail)
          .get();

      final ratingSnapshot = await _firestore
          .collection('reviews')
          .where('providerEmail', isEqualTo: userEmail)
          .get();

      double averageRating = 4.8;
      if (ratingSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in ratingSnapshot.docs) {
          totalRating += (doc.data()['rating'] ?? 5).toDouble();
        }
        averageRating = totalRating / ratingSnapshot.docs.length;
      }

      return {
        'todayEarnings': todayEarnings,
        'activeJobs': activeJobsSnapshot.docs.length,
        'totalJobs': totalJobsSnapshot.docs.length,
        'rating': double.parse(averageRating.toStringAsFixed(1)),
      };

    } catch (e) {
      print('Error loading stats: $e');
      return {
        'todayEarnings': 0.0,
        'activeJobs': 0,
        'totalJobs': 0,
        'rating': 4.8,
      };
    }
  }

  Future<void> _loadRecentRequests() async {
    try {
      final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      
      final requestsSnapshot = await _firestore
          .collection('tow_requests')
          .where('status', isEqualTo: 'pending')
          .where('createdAt', isGreaterThanOrEqualTo: fiveMinutesAgo)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      setState(() {
        _recentRequests = requestsSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
            'phone': data['phone'] ?? '',
            'location': data['location'] ?? 'Location not specified',
            'vehicleNumber': data['vehicleNumber'] ?? 'Unknown Vehicle',
            'issueType': data['issueType'] ?? 'Unknown Issue',
            'towType': data['towType'] ?? 'Standard',
            'isUrgent': data['isUrgent'] ?? false,
            'createdAt': data['createdAt'] ?? Timestamp.now(),
            'latitude': data['latitude'],
            'longitude': data['longitude'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading recent requests: $e');
    }
  }

  Future<void> _loadActiveJobs() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final activeJobsSnapshot = await _firestore
          .collection('tow_requests')
          .where('assignedProvider', isEqualTo: currentUser.email)
          .where('status', whereIn: ['accepted', 'in_progress'])
          .orderBy('acceptedAt', descending: true)
          .limit(3)
          .get();

      setState(() {
        _activeJobs = activeJobsSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
            'phone': data['phone'] ?? '',
            'location': data['location'] ?? 'Location not specified',
            'vehicleNumber': data['vehicleNumber'] ?? 'Unknown Vehicle',
            'issueType': data['issueType'] ?? 'Unknown Issue',
            'status': data['status'] ?? 'accepted',
            'amount': data['amount'] ?? 0.0,
            'acceptedAt': data['acceptedAt'] ?? Timestamp.now(),
            'latitude': data['latitude'],
            'longitude': data['longitude'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading active jobs: $e');
    }
  }

  Map<String, dynamic> _getDefaultProviderData(User user) {
    return {
      'driverName': user.displayName ?? 'Provider',
      'email': user.email ?? 'No email',
      'truckNumber': 'Not assigned',
      'truckType': 'Tow Truck Operator',
      'status': 'active',
      'isOnline': true,
    };
  }

  Map<String, dynamic> _enhanceProviderData(Map<String, dynamic> data, User user) {
    return {
      'driverName': data['driverName'] ?? user.displayName ?? 'Provider',
      'email': data['email'] ?? user.email ?? 'No email',
      'truckNumber': data['truckNumber'] ?? 'Not assigned',
      'truckType': data['truckType'] ?? 'Tow Truck Operator',
      'status': data['status'] ?? 'active',
      'isOnline': data['isOnline'] ?? true,
    };
  }

  Future<void> _toggleOnlineStatus(bool value) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userEmail = currentUser.email!;
        
        await _firestore
            .collection('tow')
            .doc(userEmail)
            .collection('profile')
            .doc('provider_details')
            .update({
              'isOnline': value,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        setState(() {
          _isOnline = value;
        });

        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value 
                ? localizations?.translate('online_accepting_requests') ?? 'You are now online'
                : localizations?.translate('offline_not_available') ?? 'You are now offline'),
            backgroundColor: value ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error updating online status: $e');
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.translate('status_update_failed') ?? 'Failed to update status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _acceptRequest(Map<String, dynamic> request) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      await _firestore
          .collection('tow_requests')
          .doc(request['id'])
          .update({
            'status': 'accepted',
            'assignedProvider': currentUser.email,
            'acceptedAt': FieldValue.serverTimestamp(),
          });

      _loadRecentRequests();
      _loadActiveJobs();
      _loadProviderData();

      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.translate('request_accepted') ?? 'Request accepted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error accepting request: $e');
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.translate('request_failed') ?? 'Failed to accept request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (_isLoading) {
      return _buildLoadingState(isTablet, localizations);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('tow_dashboard') ?? 'Tow Provider Dashboard'),
        actions: [
          LanguageSelector(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(isTablet, localizations),
            SizedBox(height: isTablet ? 32 : 24),
            _buildQuickStats(isTablet, localizations),
            SizedBox(height: isTablet ? 32 : 24),
            if (_activeJobs.isNotEmpty) ...[
              _buildActiveJobsSection(isTablet, localizations),
              SizedBox(height: isTablet ? 32 : 24),
            ],
            if (_recentRequests.isNotEmpty) ...[
              _buildRecentRequestsSection(isTablet, localizations),
              SizedBox(height: isTablet ? 32 : 24),
            ],
            _buildQuickActions(isTablet, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet, AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7E57C2)),
          ),
          SizedBox(height: 16),
          Text(
            localizations?.translate('loading') ?? 'Loading Dashboard...',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(bool isTablet, AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 28 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isTablet ? 32 : 24,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(Icons.person, color: Colors.white, 
                    size: isTablet ? 28 : 24),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.translate('welcome_back_provider') ?? 'Welcome back,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Text(
                      '${_providerData['driverName'] ?? 'Provider'}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _providerData['truckNumber'] ?? 'Truck not assigned',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isOnline,
                onChanged: _toggleOnlineStatus,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.5),
              )
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations?.translate('status') ?? 'Status:',
                  style: TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, 
                        color: _isOnline ? Colors.green : Colors.red, 
                        size: 12),
                    SizedBox(width: 8),
                    Text(
                      _isOnline 
                          ? localizations?.translate('online_accepting_requests') ?? 'Online - Accepting Requests'
                          : localizations?.translate('offline_not_available') ?? 'Offline - Not Available',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(bool isTablet, AppLocalizations? localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('active_jobs') ?? 'Active Jobs',
            value: '${_providerData['activeJobs'] ?? '0'}',
            icon: Icons.work,
            color: const Color(0xFF7E57C2),
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('today_earnings') ?? 'Today\'s Earnings',
            value: '\$${(_providerData['todayEarnings'] ?? 0).toStringAsFixed(0)}',
            icon: Icons.attach_money,
            color: const Color(0xFF4CAF50),
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('total_jobs') ?? 'Total Jobs',
            value: '${_providerData['totalJobs'] ?? '0'}',
            icon: Icons.list_alt,
            color: const Color(0xFF2196F3),
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            title: localizations?.translate('rating') ?? 'Rating',
            value: '${_providerData['rating']?.toStringAsFixed(1) ?? '0.0'}',
            icon: Icons.star,
            color: const Color(0xFFFFA000),
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: isTablet ? 24 : 20),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF333333),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: isTablet ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJobsSection(bool isTablet, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.translate('active_jobs') ?? 'Active Jobs',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to active jobs screen
              },
              child: Text(
                localizations?.translate('view_all') ?? 'View All',
                style: TextStyle(
                  color: const Color(0xFF7E57C2),
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 16 : 12),
        ..._activeJobs.map((job) => _buildActiveJobCard(job, isTablet)),
      ],
    );
  }

  Widget _buildActiveJobCard(Map<String, dynamic> job, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 50 : 40,
            height: isTablet ? 50 : 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7E57C2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_car, color: const Color(0xFF7E57C2)),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['name'] ?? 'Unknown Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                Text(
                  '${job['vehicleNumber']} • ${job['issueType']}',
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
                Text(
                  job['location'],
                  style: TextStyle(
                    color: const Color(0xFF7E57C2),
                    fontSize: isTablet ? 14 : 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(job['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job['status'].toString().replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(job['status']),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '\$${(job['amount'] ?? 0).toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF333333),
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsSection(bool isTablet, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${localizations?.translate('new_requests') ?? 'New Requests'} (Last 5 mins)',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_recentRequests.length} ${localizations?.translate('new') ?? 'New'}',
                style: TextStyle(
                  color: const Color(0xFFFFA000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 16 : 12),
        ..._recentRequests.map((request) => _buildRequestCard(request, isTablet, localizations)),
      ],
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, bool isTablet, AppLocalizations? localizations) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFA000).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFA000).withOpacity(0.1),
                child: Icon(Icons.person, color: const Color(0xFFFFA000)),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Text(
                      request['phone'],
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (request['isUrgent'] == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 14),
                      SizedBox(width: 4),
                      Text(
                        localizations?.translate('urgent') ?? 'URGENT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              _buildDetailChip(Icons.directions_car, request['vehicleNumber'], isTablet),
              SizedBox(width: 8),
              _buildDetailChip(Icons.build, request['issueType'], isTablet),
              SizedBox(width: 8),
              _buildDetailChip(Icons.local_shipping, request['towType'], isTablet),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            request['location'],
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: isTablet ? 14 : 12,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isOnline ? () => _acceptRequest(request) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2),
                foregroundColor: Colors.white,
              ),
              child: Text(localizations?.translate('accept_request') ?? 'Accept Request'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7E57C2), size: 14),
          SizedBox(width: 4),
          Text(
            text.length > 15 ? '${text.substring(0, 15)}...' : text,
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isTablet, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.translate('quick_actions') ?? 'Quick Actions',
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: isTablet ? 20 : 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isTablet ? 4 : 2,
          crossAxisSpacing: isTablet ? 16 : 12,
          mainAxisSpacing: isTablet ? 16 : 12,
          children: [
            _buildActionButton(
              icon: Icons.request_quote,
              title: localizations?.translate('all_requests') ?? 'All Requests',
              subtitle: localizations?.translate('view_all_requests') ?? 'View all requests',
              color: const Color(0xFF7E57C2),
              isTablet: isTablet,
              onTap: () {
                // Navigate to all requests screen
              },
            ),
            _buildActionButton(
              icon: Icons.work,
              title: localizations?.translate('my_jobs') ?? 'My Jobs',
              subtitle: localizations?.translate('active_history') ?? 'Active & history',
              color: const Color(0xFF5E35B1),
              isTablet: isTablet,
              onTap: () {
                // Navigate to my jobs screen
              },
            ),
            _buildActionButton(
              icon: Icons.attach_money,
              title: localizations?.translate('earnings') ?? 'Earnings',
              subtitle: localizations?.translate('view_reports') ?? 'View reports',
              color: const Color(0xFF4CAF50),
              isTablet: isTablet,
              onTap: () {
                // Navigate to earnings screen
              },
            ),
            _buildActionButton(
              icon: Icons.settings,
              title: localizations?.translate('profile') ?? 'Profile',
              subtitle: localizations?.translate('update_details') ?? 'Update details',
              color: const Color(0xFF2196F3),
              isTablet: isTablet,
              onTap: () {
                // Navigate to profile screen
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: isTablet ? 24 : 20),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: isTablet ? 12 : 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return const Color(0xFFFFA000);
      case 'in_progress':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF666666);
    }
  }
}