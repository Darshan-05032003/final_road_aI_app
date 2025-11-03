// import 'package:smart_road_app/VehicleOwner/notification.dart';
// import 'package:smart_road_app/garage/calling.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class AuthService {
//   static Future<String?> getUserEmail() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         print('✅ AuthService: Found user email: ${user.email}');
//         return user.email;
//       }
//       print('❌ AuthService: No user found');
//       return null;
//     } catch (e) {
//       print('❌ AuthService Error: $e');
//       return null;
//     }
//   }
// }

// class ServiceRequestsScreen extends StatefulWidget {
//   const ServiceRequestsScreen({super.key});

//   @override
//   _ServiceRequestsScreenState createState() => _ServiceRequestsScreenState();
// }

// class _ServiceRequestsScreenState extends State<ServiceRequestsScreen>
//     with SingleTickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _userEmail;
//   String? _garageId;
//   String? _garageName;
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';
//   late TabController _tabController;

//   List<ServiceRequest> _allRequests = [];
//   List<ServiceRequest> _pendingRequests = [];
//   List<ServiceRequest> _confirmedRequests = [];
//   List<ServiceRequest> _completedRequests = [];
//   List<ServiceRequest> _cancelledRequests = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     print('🚀 ServiceRequestsScreen initialized');
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     print('🔄 Starting data initialization...');
//     await _loadUserData();
//     if (_userEmail != null) {
//       await _loadGarageProfile();
//       if (_garageId != null) {
//         await _loadServiceRequests();
//       } else {
//         _showErrorState('Garage profile not found for this email');
//       }
//     } else {
//       _handleNoUser();
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       print('👤 Loading user data...');

//       User? currentUser = _auth.currentUser;
//       print('🔍 Firebase Auth currentUser: $currentUser');

//       if (currentUser != null) {
//         print('✅ Using Firebase Auth user: ${currentUser.email}');
//         setState(() {
//           _userEmail = currentUser.email;
//         });
//         return;
//       }

//       print('❌ No user found');
//       _handleNoUser();

//     } catch (e) {
//       print('❌ Error loading user data: $e');
//       _handleNoUser();
//     }
//   }

//   Future<void> _loadGarageProfile() async {
//     try {
//       print('🔍 Loading garage profile for email: $_userEmail');

//       final garageSnapshot = await _firestore
//           .collection('garages')
//           .where('email', isEqualTo: _userEmail)
//           .limit(1)
//           .get();

//       if (garageSnapshot.docs.isNotEmpty) {
//         final garageDoc = garageSnapshot.docs.first;
//         final garageData = garageDoc.data();

//         setState(() {
//           _garageId = garageDoc.id;
//           _garageName = garageData['garageName'] ?? 'Our Garage';
//         });

//         print('✅ Found garage profile:');
//         print('   Garage ID: $_garageId');
//         print('   Garage Name: $_garageName');
//         print('   Email: $_userEmail');

//       } else {
//         print('❌ No garage profile found for email: $_userEmail');
//         _showErrorState('No garage profile found. Please complete garage registration first.');
//       }
//     } catch (e) {
//       print('❌ Error loading garage profile: $e');
//       _showErrorState('Error loading garage profile: ${e.toString()}');
//     }
//   }

//   Future<void> _loadServiceRequests() async {
//     try {
//       if (_garageId == null) {
//         print('❌ No garage ID available');
//         _showErrorState('Garage profile not loaded');
//         return;
//       }

//       print('📡 Fetching service requests for garage: "$_garageName" ($_garageId)');

//       // Method 1: Fetch from garage's service_requests collection (Primary method)
//       final serviceRequestsRef = _firestore
//           .collection('garages')
//           .doc(_garageId!)
//           .collection('service_requests')
//           .orderBy('createdAt', descending: true);

//       print('🔍 Querying path: garages/$_garageId/service_requests');

//       final serviceRequestsSnapshot = await serviceRequestsRef.get();

//       print('📊 Documents found in service_requests: ${serviceRequestsSnapshot.docs.length}');

//       List<ServiceRequest> requests = [];

//       // Process requests from garage's service_requests collection
//       if (serviceRequestsSnapshot.docs.isNotEmpty) {
//         print('🎯 Processing requests from garage collection...');
//         for (var doc in serviceRequestsSnapshot.docs) {
//           try {
//             final data = doc.data();
//             ServiceRequest request = _parseServiceRequest(doc.id, data);
//             requests.add(request);
//             print('✅ Added request: ${request.requestId}');
//           } catch (e) {
//             print('❌ Error parsing document ${doc.id}: $e');
//           }
//         }
//       } else {
//         // Method 2: Fallback - Search all service requests by garage email
//         print('🔄 No requests in garage collection, searching by garage email...');
//         requests = await _searchRequestsByGarageEmail();
//       }

//       if (requests.isEmpty) {
//         print('ℹ️ No service requests found');
//         _showNoDataState();
//         return;
//       }

//       _categorizeRequests(requests);
//       print('🎉 Successfully loaded ${requests.length} service requests');

//     } catch (e) {
//       print('❌ CRITICAL ERROR loading service requests: $e');
//       _showErrorState('Failed to load service requests: ${e.toString()}');
//     }
//   }

//   Future<List<ServiceRequest>> _searchRequestsByGarageEmail() async {
//     try {
//       print('🔍 Searching requests by garage email: $_userEmail');

//       // Search in all garage requests where garage email matches
//       final allRequestsSnapshot = await _firestore
//           .collectionGroup('garagerequest')
//           .where('garageEmail', isEqualTo: _userEmail)
//           .orderBy('createdAt', descending: true)
//           .get();

//       print('📊 Found ${allRequestsSnapshot.docs.length} requests by garage email');

//       List<ServiceRequest> requests = [];
//       for (var doc in allRequestsSnapshot.docs) {
//         try {
//           final data = doc.data();
//           ServiceRequest request = _parseServiceRequest(doc.id, data);
//           requests.add(request);
//           print('✅ Added request by email search: ${request.requestId}');
//         } catch (e) {
//           print('❌ Error parsing email-search document ${doc.id}: $e');
//         }
//       }

//       return requests;
//     } catch (e) {
//       print('❌ Error searching by garage email: $e');
//       return [];
//     }
//   }

//   ServiceRequest _parseServiceRequest(String docId, Map<String, dynamic> data) {
//     return ServiceRequest(
//       id: docId,
//       requestId: data['requestId']?.toString() ?? 'GRG-$docId',
//       vehicleNumber: data['vehicleNumber']?.toString() ?? 'Not specified',
//       serviceType: data['serviceType']?.toString() ?? 'General Service',
//       preferredDate: _parsePreferredDate(data),
//       preferredTime: data['preferredTime']?.toString() ?? 'Not specified',
//       name: data['name']?.toString() ?? 'Customer',
//       phone: data['phone']?.toString() ?? 'Not provided',
//       location: data['location']?.toString() ?? 'Not provided',
//       problemDescription: data['description']?.toString() ?? 'No description provided',
//       userEmail: data['userEmail']?.toString() ?? 'Unknown',
//       status: data['status']?.toString() ?? 'Pending',
//       createdAt: _parseTimestamp(data['createdAt']),
//       updatedAt: _parseTimestamp(data['updatedAt']),
//       vehicleModel: data['vehicleModel']?.toString() ?? 'Not specified',
//       vehicleType: data['vehicleType']?.toString() ?? 'Car',
//       fuelType: data['fuelType']?.toString() ?? 'Petrol',
//       selectedIssues: _parseIssues(data['selectedIssues']),
//       userLatitude: data['userLatitude']?.toDouble(),
//       userLongitude: data['userLongitude']?.toDouble(),
//       garageLatitude: data['garageLatitude']?.toDouble(),
//       garageLongitude: data['garageLongitude']?.toDouble(),
//       distance: data['distance']?.toDouble() ?? 0.0,
//       liveLocationEnabled: data['liveLocationEnabled'] ?? false,
//       garageName: data['garageName']?.toString() ?? _garageName ?? 'Our Garage',
//       garageAddress: data['garageAddress']?.toString() ?? '',
//       garageEmail: data['garageEmail']?.toString() ?? _userEmail,
//     );
//   }

//   String _parsePreferredDate(Map<String, dynamic> data) {
//     try {
//       if (data['preferredDate'] != null) {
//         if (data['preferredDate'] is Timestamp) {
//           final date = (data['preferredDate'] as Timestamp).toDate();
//           return DateFormat('MMM dd, yyyy').format(date);
//         } else if (data['preferredDate'] is String) {
//           return data['preferredDate'];
//         }
//       }

//       if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
//         final date = (data['createdAt'] as Timestamp).toDate();
//         return DateFormat('MMM dd, yyyy').format(date);
//       }

//       return 'Not specified';
//     } catch (e) {
//       print('❌ Error parsing preferred date: $e');
//       return 'Not specified';
//     }
//   }

//   List<String> _parseIssues(dynamic issuesField) {
//     try {
//       if (issuesField == null) return [];
//       if (issuesField is List) {
//         return issuesField.map((item) => item.toString()).toList();
//       }
//       return [];
//     } catch (e) {
//       print('❌ Error parsing issues: $e');
//       return [];
//     }
//   }

//   DateTime _parseTimestamp(dynamic timestamp) {
//     try {
//       if (timestamp is Timestamp) {
//         return timestamp.toDate();
//       } else if (timestamp is String) {
//         return DateTime.parse(timestamp);
//       } else {
//         return DateTime.now();
//       }
//     } catch (e) {
//       print('❌ Error parsing timestamp: $e');
//       return DateTime.now();
//     }
//   }

//   void _categorizeRequests(List<ServiceRequest> requests) {
//     print('📊 Categorizing ${requests.length} requests...');

//     setState(() {
//       _allRequests = requests;
//       _pendingRequests = requests.where((request) =>
//         request.status.toLowerCase() == 'pending').toList();
//       _confirmedRequests = requests.where((request) =>
//         request.status.toLowerCase() == 'confirmed' ||
//         request.status.toLowerCase() == 'accepted').toList();
//       _completedRequests = requests.where((request) =>
//         request.status.toLowerCase() == 'completed').toList();
//       _cancelledRequests = requests.where((request) =>
//         request.status.toLowerCase() == 'cancelled' ||
//         request.status.toLowerCase() == 'rejected').toList();
//       _isLoading = false;
//       _hasError = false;
//     });

//     print('📈 Categorization complete:');
//     print('   Total: ${_allRequests.length}');
//     print('   Pending: ${_pendingRequests.length}');
//     print('   Confirmed: ${_confirmedRequests.length}');
//     print('   Completed: ${_completedRequests.length}');
//     print('   Cancelled: ${_cancelledRequests.length}');
//   }

//   void _handleNoUser() {
//     print('❌ No user detected');
//     setState(() {
//       _hasError = true;
//       _errorMessage = 'Please login again to access service requests';
//       _isLoading = false;
//     });
//   }

//   void _showErrorState(String message) {
//     print('❌ Showing error state: $message');
//     setState(() {
//       _hasError = true;
//       _errorMessage = message;
//       _isLoading = false;
//     });
//   }

//   void _showNoDataState() {
//     print('ℹ️ Showing no data state');
//     setState(() {
//       _allRequests = [];
//       _pendingRequests = [];
//       _confirmedRequests = [];
//       _completedRequests = [];
//       _cancelledRequests = [];
//       _isLoading = false;
//       _hasError = false;
//     });
//   }

//   void _handleRetry() {
//     print('🔄 Retrying data load...');
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//     _initializeData();
//   }

//   Future<void> _debugFirestoreStructure() async {
//     print('🧪 DEBUGGING FIRESTORE STRUCTURE...');

//     try {
//       if (_userEmail == null) {
//         print('❌ No user email available');
//         return;
//       }

//       print('1. Checking garage profile for: $_userEmail');
//       final garageSnapshot = await _firestore
//           .collection('garages')
//           .where('email', isEqualTo: _userEmail)
//           .get();

//       print('   Garage documents found: ${garageSnapshot.docs.length}');
//       for (var doc in garageSnapshot.docs) {
//         print('   🏪 Garage: ${doc.id} - ${doc.data()['garageName']}');
//       }

//       if (_garageId != null) {
//         print('2. Checking service_requests for garage: $_garageId');
//         final serviceRequests = await _firestore
//             .collection('garages')
//             .doc(_garageId!)
//             .collection('service_requests')
//             .get();

//         print('   Service requests in garage collection: ${serviceRequests.docs.length}');

//         for (var doc in serviceRequests.docs) {
//           final data = doc.data();
//           print('   📋 Request: ${data['requestId']} - ${data['vehicleNumber']} - ${data['status']}');
//         }
//       }

//       print('3. Searching all requests by garage email...');
//       final emailRequests = await _firestore
//           .collectionGroup('garagerequest')
//           .where('garageEmail', isEqualTo: _userEmail)
//           .get();

//       print('   Requests by email search: ${emailRequests.docs.length}');

//     } catch (e) {
//       print('❌ Debug failed: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Service Requests'),
//         backgroundColor: Color(0xFF2563EB),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationsPage()),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _handleRetry,
//           ),
//           IconButton(
//             icon: Icon(Icons.bug_report),
//             onPressed: _debugFirestoreStructure,
//             tooltip: 'Debug Firestore',
//           ),
//         ],
//         bottom: _allRequests.isNotEmpty && !_hasError
//             ? TabBar(
//                 controller: _tabController,
//                 indicatorColor: Colors.white,
//                 labelStyle: TextStyle(fontWeight: FontWeight.w500),
//                 tabs: [
//                   Tab(text: 'Pending (${_pendingRequests.length})'),
//                   Tab(text: 'Confirmed (${_confirmedRequests.length})'),
//                   Tab(text: 'Completed (${_completedRequests.length})'),
//                   Tab(text: 'Cancelled (${_cancelledRequests.length})'),
//                 ],
//               )
//             : null,
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return _buildLoadingState();
//     }

//     if (_hasError) {
//       return _buildErrorState();
//     }

//     if (_allRequests.isEmpty) {
//       return _buildNoDataState();
//     }

//     return TabBarView(
//       controller: _tabController,
//       children: [
//         _buildRequestsList(_pendingRequests, 'Pending'),
//         _buildRequestsList(_confirmedRequests, 'Confirmed'),
//         _buildRequestsList(_completedRequests, 'Completed'),
//         _buildRequestsList(_cancelledRequests, 'Cancelled'),
//       ],
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF2563EB)),
//           SizedBox(height: 16),
//           Text(
//             'Loading service requests...',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           if (_garageName != null)
//             Text('Garage: $_garageName', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//           if (_userEmail != null)
//             Text('Email: $_userEmail', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 80, color: Colors.orange),
//             SizedBox(height: 16),
//             Text(
//               'Unable to Load Requests',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 12),
//             Text(
//               _errorMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             if (_userEmail != null)
//               Text('Logged in as: $_userEmail',
//                   style: TextStyle(color: Colors.grey, fontSize: 14)),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _handleRetry,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF2563EB),
//                 foregroundColor: Colors.white,
//               ),
//               child: Text('Try Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNoDataState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
//           SizedBox(height: 16),
//           Text(
//             'No Service Requests Yet',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'When customers send service requests, they will appear here',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//           SizedBox(height: 20),
//           if (_garageName != null)
//             Text('Garage: $_garageName',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _handleRetry,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF2563EB),
//               foregroundColor: Colors.white,
//             ),
//             child: Text('Refresh'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRequestsList(List<ServiceRequest> requests, String status) {
//     if (requests.isEmpty) {
//       return _buildEmptyState(status);
//     }

//     return RefreshIndicator(
//       onRefresh: _loadServiceRequests,
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: requests.length,
//         itemBuilder: (context, index) {
//           return _buildRequestCard(requests[index]);
//         },
//       ),
//     );
//   }

//   Widget _buildRequestCard(ServiceRequest request) {
//     Color statusColor = _getStatusColor(request.status);

//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         request.requestId,
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       SizedBox(height: 4),
//                       if (request.distance > 0)
//                         Text(
//                           '${request.distance.toStringAsFixed(1)} km away',
//                           style: TextStyle(fontSize: 12, color: Colors.blue[600]),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: statusColor.withOpacity(0.3)),
//                   ),
//                   child: Text(
//                     request.status.toUpperCase(),
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),

//             _buildInfoRow(Icons.directions_car, 'Vehicle', '${request.vehicleNumber} (${request.vehicleModel})'),
//             _buildInfoRow(Icons.build, 'Service', request.serviceType),
//             _buildInfoRow(Icons.calendar_today, 'Date', request.preferredDate),
//             _buildInfoRow(Icons.access_time, 'Time', request.preferredTime),

//             if (request.selectedIssues.isNotEmpty) ...[
//               Divider(height: 20),
//               Text('Reported Issues:', style: TextStyle(fontWeight: FontWeight.w600)),
//               SizedBox(height: 6),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 4,
//                 children: request.selectedIssues.map((issue) => Chip(
//                   label: Text(issue),
//                   backgroundColor: Colors.blue[50],
//                   labelStyle: TextStyle(fontSize: 12),
//                 )).toList(),
//               ),
//             ],

//             Divider(height: 20),

//             _buildInfoRow(Icons.person, 'Customer', request.name),
//             _buildInfoRow(Icons.phone, 'Phone', request.phone),
//             _buildInfoRow(Icons.location_on, 'Location', request.location),

//             if (request.liveLocationEnabled)
//               _buildInfoRow(Icons.location_searching, 'Live Location', 'Enabled'),

//             if (request.problemDescription.isNotEmpty &&
//                 request.problemDescription != 'No description provided') ...[
//               Divider(height: 20),
//               Text('Problem Description:', style: TextStyle(fontWeight: FontWeight.w600)),
//               SizedBox(height: 6),
//               Text(
//                 request.problemDescription,
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             ],

//             // Action buttons based on status
//             if (request.status.toLowerCase() == 'pending') ...[
//               Divider(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _callCustomer(request.phone),
//                       icon: Icon(Icons.phone, size: 16),
//                       label: Text('Call'),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _updateRequestStatus(request, 'confirmed'),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                       icon: Icon(Icons.check, size: 16),
//                       label: Text('Confirm'),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _updateRequestStatus(request, 'cancelled'),
//                       style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
//                       icon: Icon(Icons.close, size: 16),
//                       label: Text('Reject'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             if (request.status.toLowerCase() == 'confirmed') ...[
//               Divider(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _callCustomer(request.phone),
//                       icon: Icon(Icons.phone, size: 16),
//                       label: Text('Call'),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _updateRequestStatus(request, 'completed'),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                       icon: Icon(Icons.done_all, size: 16),
//                       label: Text('Complete'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           SizedBox(width: 8),
//           SizedBox(
//             width: 80,
//             child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.grey[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(String status) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
//           SizedBox(height: 16),
//           Text(
//             'No $status Requests',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'All $status requests will appear here',
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Colors.orange;
//       case 'confirmed': return Colors.blue;
//       case 'completed': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   void _callCustomer(String phone) {
//     print('📞 Calling customer: $phone');
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DynamicCallScreen(phoneNumber: phone),
//       ),
//     );
//   }

//   Future<void> _updateRequestStatus(ServiceRequest request, String newStatus) async {
//     try {
//       // Update in garage's service_requests collection
//       if (_garageId != null) {
//         await _firestore
//             .collection('garages')
//             .doc(_garageId!)
//             .collection('service_requests')
//             .doc(request.id)
//             .update({
//               'status': newStatus,
//               'updatedAt': FieldValue.serverTimestamp(),
//             });
//       }

//       // Also update in user's garagerequest collection
//       if (request.userEmail.isNotEmpty && request.userEmail != 'Unknown') {
//         try {
//           final userRequestSnapshot = await _firestore
//               .collection('owner')
//               .doc(request.userEmail)
//               .collection('garagerequest')
//               .where('requestId', isEqualTo: request.requestId)
//               .limit(1)
//               .get();

//           if (userRequestSnapshot.docs.isNotEmpty) {
//             await _firestore
//                 .collection('owner')
//                 .doc(request.userEmail)
//                 .collection('garagerequest')
//                 .doc(userRequestSnapshot.docs.first.id)
//                 .update({
//                   'status': newStatus,
//                   'updatedAt': FieldValue.serverTimestamp(),
//                 });
//           }
//         } catch (e) {
//           print('⚠️ Could not update user collection: $e');
//         }
//       }

//       // Refresh data
//       _loadServiceRequests();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Request status updated to $newStatus'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print('❌ Error updating status: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }

// class ServiceRequest {
//   final String id;
//   final String requestId;
//   final String vehicleNumber;
//   final String serviceType;
//   final String preferredDate;
//   final String preferredTime;
//   final String name;
//   final String phone;
//   final String location;
//   final String problemDescription;
//   final String userEmail;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String vehicleModel;
//   final String vehicleType;
//   final String fuelType;
//   final List<String> selectedIssues;
//   final double? userLatitude;
//   final double? userLongitude;
//   final double? garageLatitude;
//   final double? garageLongitude;
//   final double distance;
//   final bool liveLocationEnabled;
//   final String garageName;
//   final String garageAddress;
//   final String? garageEmail;

//   ServiceRequest({
//     required this.id,
//     required this.requestId,
//     required this.vehicleNumber,
//     required this.serviceType,
//     required this.preferredDate,
//     required this.preferredTime,
//     required this.name,
//     required this.phone,
//     required this.location,
//     required this.problemDescription,
//     required this.userEmail,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.vehicleModel,
//     required this.vehicleType,
//     required this.fuelType,
//     required this.selectedIssues,
//     this.userLatitude,
//     this.userLongitude,
//     this.garageLatitude,
//     this.garageLongitude,
//     required this.distance,
//     required this.liveLocationEnabled,
//     required this.garageName,
//     required this.garageAddress,
//     this.garageEmail,
//   });
// }import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static Future<String?> getUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('✅ AuthService: Found user email: ${user.email}');
        return user.email;
      }
      print('❌ AuthService: No user found');
      return null;
    } catch (e) {
      print('❌ AuthService Error: $e');
      return null;
    }
  }
}

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  _ServiceRequestsScreenState createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String? _userEmail;
  String? _garageId;
  String? _garageName;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late TabController _tabController;
  int _unreadNotifications = 0;
  StreamSubscription? _notificationSubscription;

  List<ServiceRequest> _allRequests = [];
  List<ServiceRequest> _pendingRequests = [];
  List<ServiceRequest> _confirmedRequests = [];
  List<ServiceRequest> _completedRequests = [];
  List<ServiceRequest> _cancelledRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    print('🚀 ServiceRequestsScreen initialized');
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  // NOTIFICATION METHODS
  void _startNotificationListener() {
    if (_garageId == null) return;
    
    final String sanitizedGarageId = _garageId!.replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
    
    _notificationSubscription = _dbRef
        .child('garage_notifications')
        .child(sanitizedGarageId)
        .orderByChild('read')
        .equalTo(false)
        .onValue
        .listen((event) {
      if (mounted) {
        setState(() {
          if (event.snapshot.value == null) {
            _unreadNotifications = 0;
          } else {
            final Map<dynamic, dynamic> notifications = event.snapshot.value as Map<dynamic, dynamic>;
            _unreadNotifications = notifications.length;
          }
        });
      }
    });
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GarageNotificationsScreen(garageId: _garageId!),
      ),
    );
  }

  // EXISTING METHODS
  Future<void> _initializeData() async {
    print('🔄 Starting data initialization...');
    await _loadUserData();
    if (_userEmail != null) {
      await _loadGarageProfile();
      if (_garageId != null) {
        await _loadServiceRequests();
      } else {
        _showErrorState('Garage profile not found for this email');
      }
    } else {
      _handleNoUser();
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('👤 Loading user data...');

      User? currentUser = _auth.currentUser;
      print('🔍 Firebase Auth currentUser: $currentUser');

      if (currentUser != null) {
        print('✅ Using Firebase Auth user: ${currentUser.email}');
        setState(() {
          _userEmail = currentUser.email;
        });
        return;
      }

      print('❌ No user found');
      _handleNoUser();
    } catch (e) {
      print('❌ Error loading user data: $e');
      _handleNoUser();
    }
  }

  Future<void> _loadGarageProfile() async {
    try {
      print('🔍 Loading garage profile for email: $_userEmail');

      final garageSnapshot = await _firestore
          .collection('garages')
          .where('email', isEqualTo: _userEmail)
          .limit(1)
          .get();

      if (garageSnapshot.docs.isNotEmpty) {
        final garageDoc = garageSnapshot.docs.first;
        final garageData = garageDoc.data();

        setState(() {
          _garageId = garageDoc.id;
          _garageName = garageData['garageName'] ?? 'Our Garage';
        });

        print('✅ Found garage profile:');
        print('   Garage ID: $_garageId');
        print('   Garage Name: $_garageName');
        print('   Email: $_userEmail');

        // Start notification listener after garage profile is loaded
        _startNotificationListener();

      } else {
        print('❌ No garage profile found for email: $_userEmail');
        _showErrorState('No garage profile found. Please complete garage registration first.');
      }
    } catch (e) {
      print('❌ Error loading garage profile: $e');
      _showErrorState('Error loading garage profile: ${e.toString()}');
    }
  }

  Future<void> _loadServiceRequests() async {
    try {
      if (_garageId == null) {
        print('❌ No garage ID available');
        _showErrorState('Garage profile not loaded');
        return;
      }

      print('📡 Fetching service requests for garage: "$_garageName" ($_garageId)');

      // Method 1: Fetch from garage's service_requests collection (Primary method)
      final serviceRequestsRef = _firestore
          .collection('garages')
          .doc(_garageId!)
          .collection('service_requests')
          .orderBy('createdAt', descending: true);

      print('🔍 Querying path: garages/$_garageId/service_requests');

      final serviceRequestsSnapshot = await serviceRequestsRef.get();

      print('📊 Documents found in service_requests: ${serviceRequestsSnapshot.docs.length}');

      List<ServiceRequest> requests = [];

      // Process requests from garage's service_requests collection
      if (serviceRequestsSnapshot.docs.isNotEmpty) {
        print('🎯 Processing requests from garage collection...');
        for (var doc in serviceRequestsSnapshot.docs) {
          try {
            final data = doc.data();
            ServiceRequest request = _parseServiceRequest(doc.id, data);
            requests.add(request);
            print('✅ Added request: ${request.requestId}');
          } catch (e) {
            print('❌ Error parsing document ${doc.id}: $e');
          }
        }
      } else {
        // Method 2: Fallback - Search all service requests by garage email
        print('🔄 No requests in garage collection, searching by garage email...');
        requests = await _searchRequestsByGarageEmail();
      }

      if (requests.isEmpty) {
        print('ℹ️ No service requests found');
        _showNoDataState();
        return;
      }

      _categorizeRequests(requests);
      print('🎉 Successfully loaded ${requests.length} service requests');
    } catch (e) {
      print('❌ CRITICAL ERROR loading service requests: $e');
      _showErrorState('Failed to load service requests: ${e.toString()}');
    }
  }

  Future<List<ServiceRequest>> _searchRequestsByGarageEmail() async {
    try {
      print('🔍 Searching requests by garage email: $_userEmail');

      // Search in all garage requests where garage email matches
      final allRequestsSnapshot = await _firestore
          .collectionGroup('garagerequest')
          .where('garageEmail', isEqualTo: _userEmail)
          .orderBy('createdAt', descending: true)
          .get();

      print('📊 Found ${allRequestsSnapshot.docs.length} requests by garage email');

      List<ServiceRequest> requests = [];
      for (var doc in allRequestsSnapshot.docs) {
        try {
          final data = doc.data();
          ServiceRequest request = _parseServiceRequest(doc.id, data);
          requests.add(request);
          print('✅ Added request by email search: ${request.requestId}');
        } catch (e) {
          print('❌ Error parsing email-search document ${doc.id}: $e');
        }
      }

      return requests;
    } catch (e) {
      print('❌ Error searching by garage email: $e');
      return [];
    }
  }

  ServiceRequest _parseServiceRequest(String docId, Map<String, dynamic> data) {
    return ServiceRequest(
      id: docId,
      requestId: data['requestId']?.toString() ?? 'GRG-$docId',
      vehicleNumber: data['vehicleNumber']?.toString() ?? 'Not specified',
      serviceType: data['serviceType']?.toString() ?? 'General Service',
      preferredDate: _parsePreferredDate(data),
      preferredTime: data['preferredTime']?.toString() ?? 'Not specified',
      name: data['name']?.toString() ?? 'Customer',
      phone: data['phone']?.toString() ?? 'Not provided',
      location: data['location']?.toString() ?? 'Not provided',
      problemDescription: data['description']?.toString() ?? 'No description provided',
      userEmail: data['userEmail']?.toString() ?? 'Unknown',
      status: data['status']?.toString() ?? 'Pending',
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
      vehicleModel: data['vehicleModel']?.toString() ?? 'Not specified',
      vehicleType: data['vehicleType']?.toString() ?? 'Car',
      fuelType: data['fuelType']?.toString() ?? 'Petrol',
      selectedIssues: _parseIssues(data['selectedIssues']),
      userLatitude: data['userLatitude']?.toDouble(),
      userLongitude: data['userLongitude']?.toDouble(),
      garageLatitude: data['garageLatitude']?.toDouble(),
      garageLongitude: data['garageLongitude']?.toDouble(),
      distance: data['distance']?.toDouble() ?? 0.0,
      liveLocationEnabled: data['liveLocationEnabled'] ?? false,
      garageName: data['garageName']?.toString() ?? _garageName ?? 'Our Garage',
      garageAddress: data['garageAddress']?.toString() ?? '',
      garageEmail: data['garageEmail']?.toString() ?? _userEmail ?? 'Unknown',
    );
  }

  String _parsePreferredDate(Map<String, dynamic> data) {
    try {
      if (data['preferredDate'] != null) {
        if (data['preferredDate'] is Timestamp) {
          final date = (data['preferredDate'] as Timestamp).toDate();
          return DateFormat('MMM dd, yyyy').format(date);
        } else if (data['preferredDate'] is String) {
          return data['preferredDate'];
        }
      }

      if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
        final date = (data['createdAt'] as Timestamp).toDate();
        return DateFormat('MMM dd, yyyy').format(date);
      }

      return 'Not specified';
    } catch (e) {
      print('❌ Error parsing preferred date: $e');
      return 'Not specified';
    }
  }

  List<String> _parseIssues(dynamic issuesField) {
    try {
      if (issuesField == null) return [];
      if (issuesField is List) {
        return issuesField.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error parsing issues: $e');
      return [];
    }
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is String) {
        return DateTime.parse(timestamp);
      } else {
        return DateTime.now();
      }
    } catch (e) {
      print('❌ Error parsing timestamp: $e');
      return DateTime.now();
    }
  }

  void _categorizeRequests(List<ServiceRequest> requests) {
    print('📊 Categorizing ${requests.length} requests...');

    setState(() {
      _allRequests = requests;
      _pendingRequests = requests.where((request) =>
        request.status.toLowerCase() == 'pending').toList();
      _confirmedRequests = requests.where((request) =>
        request.status.toLowerCase() == 'confirmed' ||
        request.status.toLowerCase() == 'accepted').toList();
      _completedRequests = requests.where((request) =>
        request.status.toLowerCase() == 'completed').toList();
      _cancelledRequests = requests.where((request) =>
        request.status.toLowerCase() == 'cancelled' ||
        request.status.toLowerCase() == 'rejected').toList();
      _isLoading = false;
      _hasError = false;
    });

    print('📈 Categorization complete:');
    print('   Total: ${_allRequests.length}');
    print('   Pending: ${_pendingRequests.length}');
    print('   Confirmed: ${_confirmedRequests.length}');
    print('   Completed: ${_completedRequests.length}');
    print('   Cancelled: ${_cancelledRequests.length}');
  }

  void _handleNoUser() {
    print('❌ No user detected');
    setState(() {
      _hasError = true;
      _errorMessage = 'Please login again to access service requests';
      _isLoading = false;
    });
  }

  void _showErrorState(String message) {
    print('❌ Showing error state: $message');
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _isLoading = false;
    });
  }

  void _showNoDataState() {
    print('ℹ️ Showing no data state');
    setState(() {
      _allRequests = [];
      _pendingRequests = [];
      _confirmedRequests = [];
      _completedRequests = [];
      _cancelledRequests = [];
      _isLoading = false;
      _hasError = false;
    });
  }

  void _handleRetry() {
    print('🔄 Retrying data load...');
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _initializeData();
  }

  Future<void> _debugFirestoreStructure() async {
    print('🧪 DEBUGGING FIRESTORE STRUCTURE...');

    try {
      if (_userEmail == null) {
        print('❌ No user email available');
        return;
      }

      print('1. Checking garage profile for: $_userEmail');
      final garageSnapshot = await _firestore
          .collection('garages')
          .where('email', isEqualTo: _userEmail)
          .get();

      print('   Garage documents found: ${garageSnapshot.docs.length}');
      for (var doc in garageSnapshot.docs) {
        print('   🏪 Garage: ${doc.id} - ${doc.data()['garageName']}');
      }

      if (_garageId != null) {
        print('2. Checking service_requests for garage: $_garageId');
        final serviceRequests = await _firestore
            .collection('garages')
            .doc(_garageId!)
            .collection('service_requests')
            .get();

        print('   Service requests in garage collection: ${serviceRequests.docs.length}');

        for (var doc in serviceRequests.docs) {
          final data = doc.data();
          print('   📋 Request: ${data['requestId']} - ${data['vehicleNumber']} - ${data['status']}');
        }
      }

      print('3. Searching all requests by garage email...');
      final emailRequests = await _firestore
          .collectionGroup('garagerequest')
          .where('garageEmail', isEqualTo: _userEmail)
          .get();

      print('   Requests by email search: ${emailRequests.docs.length}');
    } catch (e) {
      print('❌ Debug failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Requests'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          // NOTIFICATION ICON WITH BADGE
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: _navigateToNotifications,
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
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
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
            icon: Icon(Icons.refresh),
            onPressed: _handleRetry,
          ),
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: _debugFirestoreStructure,
            tooltip: 'Debug Firestore',
          ),
        ],
        bottom: _allRequests.isNotEmpty && !_hasError
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text: 'Pending (${_pendingRequests.length})'),
                  Tab(text: 'Confirmed (${_confirmedRequests.length})'),
                  Tab(text: 'Completed (${_completedRequests.length})'),
                  Tab(text: 'Cancelled (${_cancelledRequests.length})'),
                ],
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_allRequests.isEmpty) {
      return _buildNoDataState();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRequestsList(_pendingRequests, 'Pending'),
        _buildRequestsList(_confirmedRequests, 'Confirmed'),
        _buildRequestsList(_completedRequests, 'Completed'),
        _buildRequestsList(_cancelledRequests, 'Cancelled'),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Loading service requests...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          if (_garageName != null)
            Text('Garage: $_garageName', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          if (_userEmail != null)
            Text('Email: $_userEmail', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Unable to Load Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            if (_userEmail != null)
              Text('Logged in as: $_userEmail',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No Service Requests Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'When customers send service requests, they will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          if (_garageName != null)
            Text('Garage: $_garageName',
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<ServiceRequest> requests, String status) {
    if (requests.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: _loadServiceRequests,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return _buildRequestCard(requests[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No $status Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'All $status requests will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(ServiceRequest request) {
    Color statusColor = _getStatusColor(request.status);

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requestId,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      if (request.distance > 0)
                        Text(
                          '${request.distance.toStringAsFixed(1)} km away',
                          style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    request.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            _buildInfoRow(Icons.directions_car, 'Vehicle', '${request.vehicleNumber} (${request.vehicleModel})'),
            _buildInfoRow(Icons.build, 'Service', request.serviceType),
            _buildInfoRow(Icons.calendar_today, 'Date', request.preferredDate),
            _buildInfoRow(Icons.access_time, 'Time', request.preferredTime),

            // LOCATION SECTION WITH TRACKING BUTTON
            if (request.userLatitude != null && request.userLongitude != null) ...[
              Divider(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Location Available',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lat: ${request.userLatitude!.toStringAsFixed(4)}, Lng: ${request.userLongitude!.toStringAsFixed(4)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openCustomerLocation(request),
                      icon: Icon(Icons.directions, size: 16),
                      label: Text('Track'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // PROBLEM DESCRIPTION
            if (request.problemDescription.isNotEmpty && request.problemDescription != 'No description provided') ...[
              Divider(height: 20),
              Text(
                'Problem Description:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                request.problemDescription,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],

            // SELECTED ISSUES
            if (request.selectedIssues.isNotEmpty) ...[
              Divider(height: 20),
              Text(
                'Reported Issues:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: request.selectedIssues.map((issue) {
                  return Chip(
                    label: Text(issue),
                    backgroundColor: Colors.orange[50],
                    labelStyle: TextStyle(fontSize: 12, color: Colors.orange[800]),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            // CUSTOMER CONTACT & ACTIONS
            Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        request.phone,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // CALL BUTTON
                    IconButton(
                      onPressed: () => _callCustomer(request.phone),
                      icon: Icon(Icons.phone, color: Colors.green),
                      tooltip: 'Call Customer',
                    ),
                    
                    // STATUS ACTIONS
                    if (request.status == 'Pending') ...[
                      IconButton(
                        onPressed: () => _updateRequestStatus(request, 'Confirmed'),
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        tooltip: 'Confirm Request',
                      ),
                      IconButton(
                        onPressed: () => _updateRequestStatus(request, 'Cancelled'),
                        icon: Icon(Icons.cancel, color: Colors.red),
                        tooltip: 'Cancel Request',
                      ),
                    ],
                    
                    if (request.status == 'Confirmed') ...[
                      IconButton(
                        onPressed: () => _updateRequestStatus(request, 'Completed'),
                        icon: Icon(Icons.done_all, color: Colors.blue),
                        tooltip: 'Mark as Completed',
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // TIMESTAMP
            SizedBox(height: 8),
            Text(
              'Requested: ${DateFormat('MMM dd, yyyy - hh:mm a').format(request.createdAt)}',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _callCustomer(String phone) async {
    try {
      final url = 'tel:$phone';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone app')),
        );
      }
    } catch (e) {
      print('❌ Error making call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  }

  Future<void> _openCustomerLocation(ServiceRequest request) async {
    try {
      if (request.userLatitude == null || request.userLongitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer location not available')),
        );
        return;
      }

      final url = 'https://www.google.com/maps/search/?api=1&query=${request.userLatitude},${request.userLongitude}';
      
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open maps')),
        );
      }
    } catch (e) {
      print('❌ Error opening location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening location: $e')),
      );
    }
  }

  Future<void> _updateRequestStatus(ServiceRequest request, String newStatus) async {
    try {
      print('🔄 Updating request ${request.requestId} to $newStatus');

      // Update in garage's service_requests collection
      if (_garageId != null) {
        final garageRequestRef = _firestore
            .collection('garages')
            .doc(_garageId!)
            .collection('service_requests')
            .doc(request.id);

        await garageRequestRef.update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ Updated in garage collection');
      }

      // Also update in user's garagerequest collection if possible
      try {
        final userRequestQuery = await _firestore
            .collectionGroup('garagerequest')
            .where('requestId', isEqualTo: request.requestId)
            .limit(1)
            .get();

        if (userRequestQuery.docs.isNotEmpty) {
          final userRequestDoc = userRequestQuery.docs.first;
          await userRequestDoc.reference.update({
            'status': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          print('✅ Updated in user collection');
        }
      } catch (e) {
        print('⚠️ Could not update user collection: $e');
      }

      // Reload requests to reflect changes
      await _loadServiceRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${newStatus.toLowerCase()} successfully'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('❌ Error updating request status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ServiceRequest {
  final String id;
  final String requestId;
  final String vehicleNumber;
  final String serviceType;
  final String preferredDate;
  final String preferredTime;
  final String name;
  final String phone;
  final String location;
  final String problemDescription;
  final String userEmail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String vehicleModel;
  final String vehicleType;
  final String fuelType;
  final List<String> selectedIssues;
  final double? userLatitude;
  final double? userLongitude;
  final double? garageLatitude;
  final double? garageLongitude;
  final double distance;
  final bool liveLocationEnabled;
  final String garageName;
  final String garageAddress;
  final String garageEmail;

  ServiceRequest({
    required this.id,
    required this.requestId,
    required this.vehicleNumber,
    required this.serviceType,
    required this.preferredDate,
    required this.preferredTime,
    required this.name,
    required this.phone,
    required this.location,
    required this.problemDescription,
    required this.userEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicleModel,
    required this.vehicleType,
    required this.fuelType,
    required this.selectedIssues,
    this.userLatitude,
    this.userLongitude,
    this.garageLatitude,
    this.garageLongitude,
    required this.distance,
    required this.liveLocationEnabled,
    required this.garageName,
    required this.garageAddress,
    required this.garageEmail,
  });
}

// Garage Notifications Screen (placeholder - you'll need to implement this)
class GarageNotificationsScreen extends StatelessWidget {
  final String garageId;

  const GarageNotificationsScreen({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage Notifications'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Notifications for Garage: $garageId'),
      ),
    );
  }
}