// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProviderProfileScreen extends StatefulWidget {
//   const ProviderProfileScreen({super.key});

//   @override
//   State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
// }

// class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Map<String, dynamic> _providerData = {};
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isEditing = false;

//   // Controllers for editing
//   final TextEditingController _driverNameController = TextEditingController();
//   final TextEditingController _truckNumberController = TextEditingController();
//   final TextEditingController _truckTypeController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _upiIdController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadProviderData();
//   }

//   Future<void> _loadProviderData() async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         throw Exception('User not logged in');
//       }

//       String userEmail = currentUser.email!;

//       // Try to load from tow_providers collection first (new structure)
//       DocumentSnapshot? profileSnapshot = await _firestore
//           .collection('tow_providers')
//           .doc(userEmail)
//           .get();

//       // If not found, try old structure
//       if (!profileSnapshot.exists) {
//         profileSnapshot = await _firestore
//             .collection('tow')
//             .doc(userEmail)
//             .collection('profile')
//             .doc('provider_details')
//             .get();
//       }

//       if (!profileSnapshot.exists) {
//         // If no profile data exists, create default data structure
//         setState(() {
//           _providerData = _getDefaultProviderData(currentUser);
//           _initializeControllers();
//           _isLoading = false;
//         });
//         return;
//       }

//       Map<String, dynamic> firestoreData =
//           profileSnapshot.data() as Map<String, dynamic>;

//       // Enhance with calculated fields
//       setState(() {
//         _providerData = _enhanceProviderData(firestoreData, currentUser);
//         _initializeControllers();
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading provider data: $e');
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//     }
//   }

//   Map<String, dynamic> _getDefaultProviderData(User user) {
//     return {
//       'driverName': user.displayName ?? 'Provider Name',
//       'email': user.email ?? 'No email',
//       'truckNumber': 'Not assigned',
//       'truckType': 'Not specified',
//       'location': 'Not specified',
//       'status': 'inactive',
//       'rating': 0.0,
//       'totalJobs': 0,
//       'isOnline': false,
//       'serviceArea': 'Not specified',
//       'phone': 'Not provided',
//       'earnings': 0.0,
//       'successRate': 0.0,
//     };
//   }

//   Map<String, dynamic> _enhanceProviderData(
//     Map<String, dynamic> data,
//     User user,
//   ) {
//     // Calculate additional fields for display
//     double rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
//     int totalJobs = (data['totalJobs'] as int?) ?? 0;
//     double earnings = (data['earnings'] as num?)?.toDouble() ?? 0.0;
//     double successRate =
//         (data['successRate'] as num?)?.toDouble() ??
//         (totalJobs > 0
//             ? ((totalJobs - (data['failedJobs'] as int? ?? 0)) /
//                   totalJobs *
//                   100)
//             : 0.0);

//     return {
//       'driverName': data['driverName'] ?? user.displayName ?? 'Provider Name',
//       'email': data['email'] ?? user.email ?? 'No email',
//       'truckNumber': data['truckNumber'] ?? 'Not assigned',
//       'truckType': data['truckType'] ?? 'Not specified',
//       'location': data['location'] ?? data['serviceArea'] ?? 'Not specified',
//       'status': data['status'] ?? 'inactive',
//       'rating': rating,
//       'totalJobs': totalJobs,
//       'isOnline': data['isOnline'] ?? false,
//       'serviceArea': data['serviceArea'] ?? 'Not specified',
//       'phone': data['phone'] ?? 'Not provided',
//       'earnings': earnings,
//       'successRate': successRate,
//       'userId': data['userId'] ?? user.uid,
//       'upiId': data['upiId'] ?? '',
//     };
//   }

//   void _initializeControllers() {
//     _driverNameController.text = _providerData['driverName']?.toString() ?? '';
//     _truckNumberController.text =
//         _providerData['truckNumber']?.toString() ?? '';
//     _truckTypeController.text = _providerData['truckType']?.toString() ?? '';
//     _locationController.text =
//         _providerData['location']?.toString() ??
//         _providerData['serviceArea']?.toString() ??
//         '';
//     _phoneController.text = _providerData['phone']?.toString() ?? '';
//     _upiIdController.text = _providerData['upiId']?.toString() ?? '';
//   }

//   void _handleLogout() async {
//     try {
//       await _auth.signOut();
//       // Navigate to login screen or handle logout
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Logged out successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       // You can add navigation logic here
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Logout failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _handleEditProfile() {
//     setState(() {
//       _isEditing = !_isEditing;
//       if (!_isEditing) {
//         // Reset controllers when canceling edit
//         _initializeControllers();
//       }
//     });
//   }

//   Future<void> _updateProfile() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         throw Exception('User not logged in');
//       }

//       String userEmail = currentUser.email!;

//       // Validate UPI ID format if provided
//       final upiId = _upiIdController.text.trim();
//       if (upiId.isNotEmpty) {
//         final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
//         if (!upiRegex.hasMatch(upiId)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'Please enter a valid UPI ID format (e.g., yourname@paytm)',
//               ),
//               backgroundColor: Colors.red,
//             ),
//           );
//           setState(() {
//             _isLoading = false;
//           });
//           return;
//         }
//       }

//       final updatedData = {
//         'driverName': _driverNameController.text.trim(),
//         'truckNumber': _truckNumberController.text.trim(),
//         'truckType': _truckTypeController.text.trim(),
//         'location': _locationController.text.trim(),
//         'serviceArea': _locationController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'upiId': upiId,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       // Update both collections for compatibility
//       final batch = _firestore.batch();

//       // Update tow_providers collection
//       final towProviderRef = _firestore
//           .collection('tow_providers')
//           .doc(userEmail);
//       batch.set(towProviderRef, updatedData, SetOptions(merge: true));

//       // Update old structure
//       final profileRef = _firestore
//           .collection('tow')
//           .doc(userEmail)
//           .collection('profile')
//           .doc('provider_details');
//       batch.set(profileRef, updatedData, SetOptions(merge: true));

//       await batch.commit();

//       // Reload profile data
//       await _loadProviderData();

//       setState(() {
//         _isEditing = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profile updated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update profile: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;

//     if (_isLoading) {
//       return _buildLoadingState(isTablet);
//     }

//     if (_hasError) {
//       return _buildErrorState(isTablet);
//     }

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Column(
//         children: [
//           _buildProfileHeader(isTablet),
//           SizedBox(height: isTablet ? 32 : 24),
//           if (_isEditing)
//             _buildEditProfileForm(isTablet)
//           else
//             _buildStatsSection(isTablet),
//           SizedBox(height: isTablet ? 32 : 24),
//           if (!_isEditing) _buildMenuItems(isTablet),
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
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading Profile...',
//             style: TextStyle(
//               fontSize: isTablet ? 18 : 16,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(bool isTablet) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(isTablet ? 32 : 24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: isTablet ? 64 : 48,
//               color: Colors.red,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Failed to load profile',
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Please check your internet connection and try again',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: isTablet ? 16 : 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _loadProviderData,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7E57C2),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isTablet ? 32 : 24,
//                   vertical: isTablet ? 16 : 12,
//                 ),
//               ),
//               child: Text(
//                 'Retry',
//                 style: TextStyle(fontSize: isTablet ? 16 : 14),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: isTablet ? 50 : 40,
//             backgroundColor: Color(0xFF7E57C2).withOpacity(0.1),
//             child: Icon(
//               Icons.person,
//               size: isTablet ? 40 : 32,
//               color: Color(0xFF7E57C2),
//             ),
//           ),
//           SizedBox(width: isTablet ? 20 : 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _providerData['driverName'] ?? 'Provider Name',
//                   style: TextStyle(
//                     fontSize: isTablet ? 24 : 20,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   _providerData['truckType'] ?? 'Tow Truck Operator',
//                   style: TextStyle(
//                     color: Color(0xFF666666),
//                     fontSize: isTablet ? 16 : 14,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.local_shipping,
//                       size: 16,
//                       color: Color(0xFF7E57C2),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       'Truck #${_providerData['truckNumber'] ?? 'Not assigned'}',
//                       style: TextStyle(
//                         color: Color(0xFF666666),
//                         fontSize: isTablet ? 14 : 12,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Icon(Icons.phone, size: 16, color: Color(0xFF7E57C2)),
//                     SizedBox(width: 4),
//                     Text(
//                       _providerData['phone'] ?? 'Not provided',
//                       style: TextStyle(
//                         color: Color(0xFF666666),
//                         fontSize: isTablet ? 14 : 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_providerData['upiId'] != null &&
//                     (_providerData['upiId'] as String).isNotEmpty) ...[
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.payment, size: 16, color: Colors.green[700]),
//                       SizedBox(width: 4),
//                       Text(
//                         'UPI: ${_providerData['upiId']}',
//                         style: TextStyle(
//                           color: Colors.green[700],
//                           fontSize: isTablet ? 14 : 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 SizedBox(height: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _providerData['status'] == 'active'
//                         ? Color(0xFF4CAF50).withOpacity(0.1)
//                         : Colors.orange.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         _providerData['status'] == 'active'
//                             ? Icons.verified
//                             : Icons.pending,
//                         color: _providerData['status'] == 'active'
//                             ? Color(0xFF4CAF50)
//                             : Colors.orange,
//                         size: 14,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         _providerData['status'] == 'active'
//                             ? 'Verified Provider'
//                             : 'Pending Verification',
//                         style: TextStyle(
//                           color: _providerData['status'] == 'active'
//                               ? Color(0xFF4CAF50)
//                               : Colors.orange,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               _isEditing ? Icons.close : Icons.edit,
//               color: Color(0xFF7E57C2),
//               size: isTablet ? 28 : 24,
//             ),
//             onPressed: _handleEditProfile,
//             tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsSection(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem(
//             _providerData['totalJobs']?.toString() ?? '0',
//             'Total Jobs',
//             Icons.work,
//             isTablet,
//           ),
//           _buildStatItem(
//             _providerData['rating']?.toStringAsFixed(1) ?? '0.0',
//             'Rating',
//             Icons.star,
//             isTablet,
//           ),
//           _buildStatItem(
//             '\$${_providerData['earnings']?.toStringAsFixed(0) ?? '0'}',
//             'Earnings',
//             Icons.attach_money,
//             isTablet,
//           ),
//           _buildStatItem(
//             '${_providerData['successRate']?.toStringAsFixed(0) ?? '0'}%',
//             'Success',
//             Icons.check_circle,
//             isTablet,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(
//     String value,
//     String label,
//     IconData icon,
//     bool isTablet,
//   ) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(isTablet ? 12 : 8),
//           decoration: BoxDecoration(
//             color: Color(0xFF7E57C2).withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: Color(0xFF7E57C2), size: isTablet ? 20 : 16),
//         ),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isTablet ? 20 : 18,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF333333),
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Color(0xFF666666),
//             fontSize: isTablet ? 14 : 12,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEditProfileForm(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Edit Profile',
//             style: TextStyle(
//               fontSize: isTablet ? 22 : 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF7E57C2),
//             ),
//           ),
//           SizedBox(height: isTablet ? 24 : 20),
//           TextField(
//             controller: _driverNameController,
//             decoration: InputDecoration(
//               labelText: 'Driver Name',
//               prefixIcon: Icon(Icons.person, color: Color(0xFF7E57C2)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _truckNumberController,
//             decoration: InputDecoration(
//               labelText: 'Truck Number',
//               prefixIcon: Icon(
//                 Icons.confirmation_number,
//                 color: Color(0xFF7E57C2),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _truckTypeController,
//             decoration: InputDecoration(
//               labelText: 'Truck Type',
//               prefixIcon: Icon(Icons.local_shipping, color: Color(0xFF7E57C2)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _locationController,
//             decoration: InputDecoration(
//               labelText: 'Service Area / Location',
//               prefixIcon: Icon(Icons.location_on, color: Color(0xFF7E57C2)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _phoneController,
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(
//               labelText: 'Phone Number',
//               prefixIcon: Icon(Icons.phone, color: Color(0xFF7E57C2)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _upiIdController,
//             decoration: InputDecoration(
//               labelText: 'UPI ID',
//               hintText: 'yourname@paytm',
//               prefixIcon: Icon(Icons.payment, color: Color(0xFF7E57C2)),
//               helperText: 'Used for receiving payments',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: _isLoading ? null : _updateProfile,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7E57C2),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: _isLoading
//                   ? SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : Text(
//                       'UPDATE PROFILE',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItems(bool isTablet) {
//     final menuItems = [
//       _MenuItem(Icons.work, 'Job History', Icons.chevron_right, onTap: () {}),
//       _MenuItem(
//         Icons.attach_money,
//         'Earnings & Reports',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(
//         Icons.business,
//         'Service Areas',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(
//         Icons.local_shipping,
//         'Vehicle Details',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(
//         Icons.notifications,
//         'Notifications',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(
//         Icons.help,
//         'Help & Support',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(
//         Icons.security,
//         'Privacy & Security',
//         Icons.chevron_right,
//         onTap: () {},
//       ),
//       _MenuItem(Icons.settings, 'Settings', Icons.chevron_right, onTap: () {}),
//       _MenuItem(
//         Icons.logout,
//         'Logout',
//         Icons.chevron_right,
//         isLogout: true,
//         onTap: _handleLogout,
//       ),
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: menuItems
//             .map((item) => _buildMenuTile(item, isTablet))
//             .toList(),
//       ),
//     );
//   }

//   Widget _buildMenuTile(_MenuItem item, bool isTablet) {
//     return ListTile(
//       leading: Container(
//         width: isTablet ? 48 : 40,
//         height: isTablet ? 48 : 40,
//         decoration: BoxDecoration(
//           color: item.isLogout
//               ? Color(0xFFF44336).withOpacity(0.1)
//               : Color(0xFF7E57C2).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
//         ),
//         child: Icon(
//           item.icon,
//           color: item.isLogout ? Color(0xFFF44336) : Color(0xFF7E57C2),
//           size: isTablet ? 20 : 18,
//         ),
//       ),
//       title: Text(
//         item.title,
//         style: TextStyle(
//           color: item.isLogout ? Color(0xFFF44336) : Color(0xFF333333),
//           fontWeight: FontWeight.w500,
//           fontSize: isTablet ? 18 : 16,
//         ),
//       ),
//       trailing: Icon(
//         item.trailingIcon,
//         color: item.isLogout ? Color(0xFFF44336) : Color(0xFF666666),
//         size: isTablet ? 24 : 20,
//       ),
//       onTap: item.onTap,
//     );
//   }

//   @override
//   void dispose() {
//     _driverNameController.dispose();
//     _truckNumberController.dispose();
//     _truckTypeController.dispose();
//     _locationController.dispose();
//     _phoneController.dispose();
//     _upiIdController.dispose();
//     super.dispose();
//   }
// }

// class _MenuItem {
//   final IconData icon;
//   final String title;
//   final IconData trailingIcon;
//   final bool isLogout;
//   final VoidCallback onTap;

//   _MenuItem(
//     this.icon,
//     this.title,
//     this.trailingIcon, {
//     this.isLogout = false,
//     required this.onTap,
//   });
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_road_app/Login/ToeProviderLogin.dart';
import 'package:smart_road_app/shared_prefrences.dart';
//import 'package:smart_road_app/services/auth_service.dart';
//import 'package:smart_road_app/Login/TowProviderLoginPage.dart';

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
  bool _isEditing = false;

  // Controllers for editing
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _truckNumberController = TextEditingController();
  final TextEditingController _truckTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

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

      // Try to load from tow_providers collection first (new structure)
      DocumentSnapshot? profileSnapshot = await _firestore
          .collection('tow_providers')
          .doc(userEmail)
          .get();

      // If not found, try old structure
      if (!profileSnapshot.exists) {
        profileSnapshot = await _firestore
            .collection('tow')
            .doc(userEmail)
            .collection('profile')
            .doc('provider_details')
            .get();
      }

      if (!profileSnapshot.exists) {
        // If no profile data exists, create default data structure
        setState(() {
          _providerData = _getDefaultProviderData(currentUser);
          _initializeControllers();
          _isLoading = false;
        });
        return;
      }

      Map<String, dynamic> firestoreData =
          profileSnapshot.data() as Map<String, dynamic>;

      // Enhance with calculated fields
      setState(() {
        _providerData = _enhanceProviderData(firestoreData, currentUser);
        _initializeControllers();
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

  Map<String, dynamic> _enhanceProviderData(
    Map<String, dynamic> data,
    User user,
  ) {
    // Calculate additional fields for display
    double rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
    int totalJobs = (data['totalJobs'] as int?) ?? 0;
    double earnings = (data['earnings'] as num?)?.toDouble() ?? 0.0;
    double successRate =
        (data['successRate'] as num?)?.toDouble() ??
        (totalJobs > 0
            ? ((totalJobs - (data['failedJobs'] as int? ?? 0)) /
                  totalJobs *
                  100)
            : 0.0);

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
      'upiId': data['upiId'] ?? '',
    };
  }

  void _initializeControllers() {
    _driverNameController.text = _providerData['driverName']?.toString() ?? '';
    _truckNumberController.text =
        _providerData['truckNumber']?.toString() ?? '';
    _truckTypeController.text = _providerData['truckType']?.toString() ?? '';
    _locationController.text =
        _providerData['location']?.toString() ??
        _providerData['serviceArea']?.toString() ??
        '';
    _phoneController.text = _providerData['phone']?.toString() ?? '';
    _upiIdController.text = _providerData['upiId']?.toString() ?? '';
  }

  // SIMPLE LOGOUT METHOD FOR PROFILE SCREEN
  Future<void> _handleLogout() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('🚪 Starting logout process from profile...');
      
      // Clear all data using AuthService
      await AuthService.logout();
      
      print('✅ Data cleared, navigating to login...');
      
      // Navigate to login page
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TowProviderLoginPage()),
          (route) => false,
        );
      }
      
    } catch (e) {
      print('❌ Logout error in profile: $e');
      
      // Even if there's error, try to navigate to login
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TowProviderLoginPage()),
          (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // LOGOUT CONFIRMATION DIALOG
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Logout Confirmation'),
          ],
        ),
        content: Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _handleLogout(); // Start logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleEditProfile() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers when canceling edit
        _initializeControllers();
      }
    });
  }

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      String userEmail = currentUser.email!;

      // Validate UPI ID format if provided
      final upiId = _upiIdController.text.trim();
      if (upiId.isNotEmpty) {
        final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
        if (!upiRegex.hasMatch(upiId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enter a valid UPI ID format (e.g., yourname@paytm)',
              ),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final updatedData = {
        'driverName': _driverNameController.text.trim(),
        'truckNumber': _truckNumberController.text.trim(),
        'truckType': _truckTypeController.text.trim(),
        'location': _locationController.text.trim(),
        'serviceArea': _locationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'upiId': upiId,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update both collections for compatibility
      final batch = _firestore.batch();

      // Update tow_providers collection
      final towProviderRef = _firestore
          .collection('tow_providers')
          .doc(userEmail);
      batch.set(towProviderRef, updatedData, SetOptions(merge: true));

      // Update old structure
      final profileRef = _firestore
          .collection('tow')
          .doc(userEmail)
          .collection('profile')
          .doc('provider_details');
      batch.set(profileRef, updatedData, SetOptions(merge: true));

      await batch.commit();

      // Reload profile data
      await _loadProviderData();

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          if (_isEditing)
            _buildEditProfileForm(isTablet)
          else
            _buildStatsSection(isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          if (!_isEditing) _buildMenuItems(isTablet),
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
            child: Icon(
              Icons.person,
              size: isTablet ? 40 : 32,
              color: Color(0xFF7E57C2),
            ),
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
                    Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: Color(0xFF7E57C2),
                    ),
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
                if (_providerData['upiId'] != null &&
                    (_providerData['upiId'] as String).isNotEmpty) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.payment, size: 16, color: Colors.green[700]),
                      SizedBox(width: 4),
                      Text(
                        'UPI: ${_providerData['upiId']}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
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
                        _providerData['status'] == 'active'
                            ? Icons.verified
                            : Icons.pending,
                        color: _providerData['status'] == 'active'
                            ? Color(0xFF4CAF50)
                            : Colors.orange,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _providerData['status'] == 'active'
                            ? 'Verified Provider'
                            : 'Pending Verification',
                        style: TextStyle(
                          color: _providerData['status'] == 'active'
                              ? Color(0xFF4CAF50)
                              : Colors.orange,
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
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Color(0xFF7E57C2),
              size: isTablet ? 28 : 24,
            ),
            onPressed: _handleEditProfile,
            tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
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
            isTablet,
          ),
          _buildStatItem(
            _providerData['rating']?.toStringAsFixed(1) ?? '0.0',
            'Rating',
            Icons.star,
            isTablet,
          ),
          _buildStatItem(
            '\$${_providerData['earnings']?.toStringAsFixed(0) ?? '0'}',
            'Earnings',
            Icons.attach_money,
            isTablet,
          ),
          _buildStatItem(
            '${_providerData['successRate']?.toStringAsFixed(0) ?? '0'}%',
            'Success',
            Icons.check_circle,
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isTablet,
  ) {
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

  Widget _buildEditProfileForm(bool isTablet) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7E57C2),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
          TextField(
            controller: _driverNameController,
            decoration: InputDecoration(
              labelText: 'Driver Name',
              prefixIcon: Icon(Icons.person, color: Color(0xFF7E57C2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _truckNumberController,
            decoration: InputDecoration(
              labelText: 'Truck Number',
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Color(0xFF7E57C2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _truckTypeController,
            decoration: InputDecoration(
              labelText: 'Truck Type',
              prefixIcon: Icon(Icons.local_shipping, color: Color(0xFF7E57C2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Service Area / Location',
              prefixIcon: Icon(Icons.location_on, color: Color(0xFF7E57C2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone, color: Color(0xFF7E57C2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _upiIdController,
            decoration: InputDecoration(
              labelText: 'UPI ID',
              hintText: 'yourname@paytm',
              prefixIcon: Icon(Icons.payment, color: Color(0xFF7E57C2)),
              helperText: 'Used for receiving payments',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7E57C2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'UPDATE PROFILE',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(bool isTablet) {
    final menuItems = [
      _MenuItem(Icons.work, 'Job History', Icons.chevron_right, onTap: () {
        _showComingSoon('Job History');
      }),
      _MenuItem(
        Icons.attach_money,
        'Earnings & Reports',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Earnings & Reports');
        },
      ),
      _MenuItem(
        Icons.business,
        'Service Areas',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Service Areas');
        },
      ),
      _MenuItem(
        Icons.local_shipping,
        'Vehicle Details',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Vehicle Details');
        },
      ),
      _MenuItem(
        Icons.notifications,
        'Notifications',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Notifications');
        },
      ),
      _MenuItem(
        Icons.help,
        'Help & Support',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Help & Support');
        },
      ),
      _MenuItem(
        Icons.security,
        'Privacy & Security',
        Icons.chevron_right,
        onTap: () {
          _showComingSoon('Privacy & Security');
        },
      ),
      _MenuItem(Icons.settings, 'Settings', Icons.chevron_right, onTap: () {
        _showComingSoon('Settings');
      }),
      _MenuItem(
        Icons.logout,
        'Logout',
        Icons.chevron_right,
        isLogout: true,
        onTap: _showLogoutConfirmation,
      ),
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
        children: menuItems
            .map((item) => _buildMenuTile(item, isTablet))
            .toList(),
      ),
    );
  }

  Widget _buildMenuTile(_MenuItem item, bool isTablet) {
    return ListTile(
      leading: Container(
        width: isTablet ? 48 : 40,
        height: isTablet ? 48 : 40,
        decoration: BoxDecoration(
          color: item.isLogout
              ? Color(0xFFF44336).withOpacity(0.1)
              : Color(0xFF7E57C2).withOpacity(0.1),
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

  // Helper method to show coming soon dialog
  void _showComingSoon(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.build, color: Color(0xFF7E57C2)),
            SizedBox(width: 8),
            Text('Coming Soon'),
          ],
        ),
        content: Text('$featureName feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _truckNumberController.dispose();
    _truckTypeController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final IconData trailingIcon;
  final bool isLogout;
  final VoidCallback onTap;

  _MenuItem(
    this.icon,
    this.title,
    this.trailingIcon, {
    this.isLogout = false,
    required this.onTap,
  });
}