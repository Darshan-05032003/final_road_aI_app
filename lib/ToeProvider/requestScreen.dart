import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:url_launcher/url_launcher.dart';
import '../screens/chat/chat_screen.dart';

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

class TowServiceRequestsScreen extends StatefulWidget {
  const TowServiceRequestsScreen({super.key});

  @override
  _TowServiceRequestsScreenState createState() => _TowServiceRequestsScreenState();
}

class _TowServiceRequestsScreenState extends State<TowServiceRequestsScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String? _userEmail;
  String? _towProviderId;
  String? _providerName;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late TabController _tabController;
  int _unreadNotifications = 0;
  StreamSubscription? _notificationSubscription;

  List<TowServiceRequest> _allRequests = [];
  List<TowServiceRequest> _pendingRequests = [];
  List<TowServiceRequest> _acceptedRequests = [];
  List<TowServiceRequest> _completedRequests = [];
  List<TowServiceRequest> _rejectedRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    print('🚀 TowServiceRequestsScreen initialized');
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  // NOTIFICATION METHODS - ADDED FROM GARAGE FILE
  void _startNotificationListener() {
    if (_towProviderId == null) return;
    
    final String sanitizedProviderId = _towProviderId!.replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
    
    _notificationSubscription = _dbRef
        .child('tow_provider_notifications')
        .child(sanitizedProviderId)
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
        builder: (context) => TowProviderNotificationsScreen(providerId: _towProviderId!),
      ),
    );
  }

  // TRACK LOCATION FUNCTIONALITY
  void _trackLocation(TowServiceRequest request) async {
    print('📍 Tracking location for request: ${request.requestId}');

    if (request.userLatitude != null && request.userLongitude != null) {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=${request.userLatitude},${request.userLongitude}';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        _showError('Could not launch maps');
      }
    } else {
      _showError('Location coordinates not available');
    }
  }

  void _openLocationInMap(TowServiceRequest request) async {
    print('🗺️ Opening location in map for request: ${request.requestId}');

    if (request.userLatitude != null && request.userLongitude != null) {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=${request.userLatitude},${request.userLongitude}';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        _showError('Could not launch maps');
      }
    } else {
      _showError('Location coordinates not available');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // EXISTING METHODS ADAPTED FOR TOW PROVIDERS
  Future<void> _initializeData() async {
    print('🔄 Starting data initialization...');
    await _loadUserData();
    if (_userEmail != null) {
      await _loadTowProviderProfile();
      if (_towProviderId != null) {
        await _loadServiceRequests();
      } else {
        _showErrorState('Tow provider profile not found for this email');
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

  Future<void> _loadTowProviderProfile() async {
    try {
      print('🔍 Loading tow provider profile for email: $_userEmail');

      final providerSnapshot = await _firestore
          .collection('tow_providers')
          .where('email', isEqualTo: _userEmail)
          .limit(1)
          .get();

      if (providerSnapshot.docs.isNotEmpty) {
        final providerDoc = providerSnapshot.docs.first;
        final providerData = providerDoc.data();

        setState(() {
          _towProviderId = providerDoc.id;
          _providerName = providerData['driverName'] ?? 'Our Tow Service';
        });

        print('✅ Found tow provider profile:');
        print('   Provider ID: $_towProviderId');
        print('   Provider Name: $_providerName');
        print('   Email: $_userEmail');

        // Start notification listener after provider profile is loaded - ADDED
        _startNotificationListener();

      } else {
        print('❌ No tow provider profile found for email: $_userEmail');
        _showErrorState(
          'No tow provider profile found. Please complete provider registration first.',
        );
      }
    } catch (e) {
      print('❌ Error loading tow provider profile: $e');
      _showErrorState('Error loading provider profile: ${e.toString()}');
    }
  }

  Future<void> _loadServiceRequests() async {
    try {
      if (_towProviderId == null) {
        print('❌ No tow provider ID available');
        _showErrorState('Tow provider profile not loaded');
        return;
      }

      print(
        '📡 Fetching service requests for provider: "$_providerName" ($_towProviderId)',
      );

      // Method 1: Fetch from provider's service_requests collection (Primary method)
      final serviceRequestsRef = _firestore
          .collection('tow_providers')
          .doc(_towProviderId!)
          .collection('service_requests')
          .orderBy('timestamp', descending: true);

      print('🔍 Querying path: tow_providers/$_towProviderId/service_requests');

      final serviceRequestsSnapshot = await serviceRequestsRef.get();

      print(
        '📊 Documents found in service_requests: ${serviceRequestsSnapshot.docs.length}',
      );

      List<TowServiceRequest> requests = [];

      // Process requests from provider's service_requests collection
      if (serviceRequestsSnapshot.docs.isNotEmpty) {
        print('🎯 Processing requests from provider collection...');
        for (var doc in serviceRequestsSnapshot.docs) {
          try {
            final data = doc.data();
            TowServiceRequest request = _parseServiceRequest(doc.id, data);
            requests.add(request);
            print('✅ Added request: ${request.requestId}');
          } catch (e) {
            print('❌ Error parsing document ${doc.id}: $e');
          }
        }
      } else {
        // Method 2: Fallback - Search all service requests by provider email
        print(
          '🔄 No requests in provider collection, searching by provider email...',
        );
        requests = await _searchRequestsByProviderEmail();
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

  Future<List<TowServiceRequest>> _searchRequestsByProviderEmail() async {
    try {
      print('🔍 Searching requests by provider email: $_userEmail');

      // Search in all tow requests where provider email matches
      final allRequestsSnapshot = await _firestore
          .collectionGroup('tow_requests')
          .where('providerEmail', isEqualTo: _userEmail)
          .orderBy('timestamp', descending: true)
          .get();

      print(
        '📊 Found ${allRequestsSnapshot.docs.length} requests by provider email',
      );

      List<TowServiceRequest> requests = [];
      for (var doc in allRequestsSnapshot.docs) {
        try {
          final data = doc.data();
          TowServiceRequest request = _parseServiceRequest(doc.id, data);
          requests.add(request);
          print('✅ Added request by email search: ${request.requestId}');
        } catch (e) {
          print('❌ Error parsing email-search document ${doc.id}: $e');
        }
      }

      return requests;
    } catch (e) {
      print('❌ Error searching by provider email: $e');
      return [];
    }
  }

  TowServiceRequest _parseServiceRequest(String docId, Map<String, dynamic> data) {
    return TowServiceRequest(
      id: docId,
      requestId: data['requestId']?.toString() ?? 'TOW-$docId',
      name: data['name']?.toString() ?? 'Customer',
      phone: data['phone']?.toString() ?? 'Not provided',
      vehicleNumber: data['vehicleNumber']?.toString() ?? 'Not specified',
      vehicleType: data['vehicleType']?.toString() ?? 'Car',
      issueType: data['issueType']?.toString() ?? 'Breakdown',
      location: data['location']?.toString() ?? 'Not provided',
      description: data['description']?.toString() ?? 'No description provided',
      isUrgent: data['isUrgent'] ?? false,
      status: data['status']?.toString() ?? 'pending',
      timestamp: _parseTimestamp(data['timestamp']),
      userEmail: data['userEmail']?.toString() ?? 'Unknown',
      userId: data['userId']?.toString(),
      userLatitude: data['userLatitude']?.toDouble(),
      userLongitude: data['userLongitude']?.toDouble(),
      providerLatitude: data['providerLatitude']?.toDouble(),
      providerLongitude: data['providerLongitude']?.toDouble(),
      distance: data['distance']?.toDouble() ?? 0.0,
      providerName: data['providerName']?.toString() ?? _providerName ?? 'Our Tow Service',
      providerPhone: data['providerPhone']?.toString() ?? '',
      truckNumber: data['truckNumber']?.toString() ?? '',
      truckType: data['truckType']?.toString() ?? '',
      providerEmail: data['providerEmail']?.toString() ?? _userEmail,
    );
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
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

  void _categorizeRequests(List<TowServiceRequest> requests) {
    print('📊 Categorizing ${requests.length} requests...');

    setState(() {
      _allRequests = requests;
      _pendingRequests = requests
          .where((request) => request.status.toLowerCase() == 'pending')
          .toList();
      _acceptedRequests = requests
          .where((request) => request.status.toLowerCase() == 'accepted')
          .toList();
      _completedRequests = requests
          .where((request) => request.status.toLowerCase() == 'completed')
          .toList();
      _rejectedRequests = requests
          .where((request) => request.status.toLowerCase() == 'rejected')
          .toList();
      _isLoading = false;
      _hasError = false;
    });

    print('📈 Categorization complete:');
    print('   Total: ${_allRequests.length}');
    print('   Pending: ${_pendingRequests.length}');
    print('   Accepted: ${_acceptedRequests.length}');
    print('   Completed: ${_completedRequests.length}');
    print('   Rejected: ${_rejectedRequests.length}');
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
      _acceptedRequests = [];
      _completedRequests = [];
      _rejectedRequests = [];
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

      print('1. Checking tow provider profile for: $_userEmail');
      final providerSnapshot = await _firestore
          .collection('tow_providers')
          .where('email', isEqualTo: _userEmail)
          .get();

      print('   Provider documents found: ${providerSnapshot.docs.length}');
      for (var doc in providerSnapshot.docs) {
        print('   🚛 Provider: ${doc.id} - ${doc.data()['driverName']}');
      }

      if (_towProviderId != null) {
        print('2. Checking service_requests for provider: $_towProviderId');
        final serviceRequests = await _firestore
            .collection('tow_providers')
            .doc(_towProviderId!)
            .collection('service_requests')
            .get();

        print(
          '   Service requests in provider collection: ${serviceRequests.docs.length}',
        );

        for (var doc in serviceRequests.docs) {
          final data = doc.data();
          print('   📋 Request: ${data['requestId']} - ${data['vehicleNumber']} - ${data['status']}');
        }
      }

      print('3. Searching all requests by provider email...');
      final emailRequests = await _firestore
          .collectionGroup('tow_requests')
          .where('providerEmail', isEqualTo: _userEmail)
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
        title: Text('Tow Service Requests'),
        backgroundColor: Color(0xFFFF9800),
        foregroundColor: Colors.white,
        actions: [
          // NOTIFICATION ICON WITH BADGE - UPDATED
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
          IconButton(icon: Icon(Icons.refresh), onPressed: _handleRetry),
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
                  Tab(text: 'Accepted (${_acceptedRequests.length})'),
                  Tab(text: 'Completed (${_completedRequests.length})'),
                  Tab(text: 'Rejected (${_rejectedRequests.length})'),
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
        _buildRequestsList(_acceptedRequests, 'Accepted'),
        _buildRequestsList(_completedRequests, 'Completed'),
        _buildRequestsList(_rejectedRequests, 'Rejected'),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFF9800)),
          SizedBox(height: 16),
          Text(
            'Loading service requests...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          if (_providerName != null)
            Text(
              'Provider: $_providerName',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          if (_userEmail != null)
            Text(
              'Email: $_userEmail',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
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
              Text(
                'Logged in as: $_userEmail',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF9800),
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
            'When customers send tow service requests, they will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          if (_providerName != null)
            Text(
              'Provider: $_providerName',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF9800),
              foregroundColor: Colors.white,
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<TowServiceRequest> requests, String status) {
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

  Widget _buildRequestCard(TowServiceRequest request) {
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (request.distance > 0)
                        Text(
                          '${request.distance.toStringAsFixed(1)} km away',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[600],
                          ),
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

            _buildInfoRow(
              Icons.directions_car,
              'Vehicle',
              '${request.vehicleNumber} (${request.vehicleType})',
            ),
            _buildInfoRow(Icons.warning, 'Issue', request.issueType),
            _buildInfoRow(Icons.person, 'Customer', request.name),
            _buildInfoRow(Icons.phone, 'Phone', request.phone),

            if (request.isUrgent)
              _buildInfoRow(
                Icons.emergency,
                'Priority',
                'URGENT',
              ),

            // LOCATION SECTION WITH TRACKING BUTTON
            if (request.userLatitude != null &&
                request.userLongitude != null) ...[
              Divider(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.orange[800],
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Location',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[800],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            request.location,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.map, color: Colors.white, size: 18),
                        onPressed: () => _openLocationInMap(request),
                        padding: EdgeInsets.all(6),
                        tooltip: 'Open in Maps',
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (request.description.isNotEmpty &&
                request.description != 'No description provided') ...[
              Divider(height: 20),
              Text(
                'Problem Description:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                request.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],

            // Action buttons based on status
            if (request.status.toLowerCase() == 'pending') ...[
              Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callCustomer(request.phone),
                      icon: Icon(Icons.phone, size: 16),
                      label: Text('Call'),
                    ),
                  ),
                  SizedBox(width: 8),
                  // TRACK LOCATION BUTTON FOR PENDING REQUESTS WITH COORDINATES
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _trackLocation(request),
                        icon: Icon(Icons.map, size: 16),
                        label: Text('Track'),
                      ),
                    ),
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _updateRequestStatus(request, 'accepted'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: Icon(Icons.check, size: 16),
                      label: Text('Accept'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateRequestStatus(request, 'rejected'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      icon: Icon(Icons.close, size: 16),
                      label: Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],

            if (request.status.toLowerCase() == 'accepted') ...[
              Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callCustomer(request.phone),
                      icon: Icon(Icons.phone, size: 16),
                      label: Text('Call'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openChat(request),
                      icon: Icon(Icons.chat, size: 16),
                      label: Text('Chat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6D28D9),
                        side: BorderSide(color: Color(0xFF6D28D9)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // TRACK LOCATION BUTTON FOR ACCEPTED REQUESTS WITH COORDINATES
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _trackLocation(request),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        icon: Icon(Icons.location_searching, size: 16),
                        label: Text('Track'),
                      ),
                    ),
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showCompleteServiceDialog(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      icon: Icon(Icons.done_all, size: 16),
                      label: Text('Complete'),
                    ),
                  ),
                ],
              ),
            ],

            // For completed requests, show track and call buttons
            if (request.status.toLowerCase() == 'completed') ...[
              Divider(height: 20),
              Row(
                children: [
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _trackLocation(request),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF9800),
                        ),
                        icon: Icon(Icons.map, size: 16),
                        label: Text('View Location'),
                      ),
                    ),
                  if (request.userLatitude != null &&
                      request.userLongitude != null)
                    SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callCustomer(request.phone),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: Icon(Icons.phone, size: 16),
                      label: Text('Call Again'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No $status Requests',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _callCustomer(String phone) {
    print('📞 Calling customer: $phone');
    final Uri telLaunchUri = Uri(scheme: 'tel', path: phone);
    launchUrl(telLaunchUri);
  }

  Future<void> _updateRequestStatus(
    TowServiceRequest request,
    String newStatus,
  ) async {
    try {
      // Update in provider's service_requests collection
      if (_towProviderId != null) {
        await _firestore
            .collection('tow_providers')
            .doc(_towProviderId!)
            .collection('service_requests')
            .doc(request.id)
            .update({
              'status': newStatus,
              '${newStatus}At': FieldValue.serverTimestamp(),
            });
      }

      // Also update in user's tow_requests collection
      if (request.userEmail.isNotEmpty && request.userEmail != 'Unknown') {
        try {
          final userRequestSnapshot = await _firestore
              .collection('owner')
              .doc(request.userEmail)
              .collection('tow_requests')
              .where('requestId', isEqualTo: request.requestId)
              .limit(1)
              .get();

          if (userRequestSnapshot.docs.isNotEmpty) {
            await _firestore
                .collection('owner')
                .doc(request.userEmail)
                .collection('tow_requests')
                .doc(userRequestSnapshot.docs.first.id)
                .update({
                  'status': newStatus,
                  '${newStatus}At': FieldValue.serverTimestamp(),
                });
          }
        } catch (e) {
          print('⚠️ Could not update user collection: $e');
        }
      }

      // Refresh data
      _loadServiceRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request status updated to $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showCompleteServiceDialog(TowServiceRequest request) async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Complete Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to mark this service as completed?'),
              SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: 'Service Notes (Optional)',
                  hintText: 'Any additional notes...',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Mark Complete'),
          ),
        ],
      ),
    );

    if (result == true) {
      final notes = notesController.text.trim();
      await _completeService(request, notes);
    }

    notesController.dispose();
  }

  Future<void> _completeService(
    TowServiceRequest request,
    String notes,
  ) async {
    try {
      // Update request with completion info in provider's collection
      if (_towProviderId != null) {
        await _firestore
            .collection('tow_providers')
            .doc(_towProviderId!)
            .collection('service_requests')
            .doc(request.id)
            .update({
              'status': 'completed',
              'completedAt': FieldValue.serverTimestamp(),
              'serviceNotes': notes,
              'updatedAt': FieldValue.serverTimestamp(),
            });
      }

      // Also update in user's tow_requests collection
      if (request.userEmail.isNotEmpty && request.userEmail != 'Unknown') {
        try {
          final userRequestSnapshot = await _firestore
              .collection('owner')
              .doc(request.userEmail)
              .collection('tow_requests')
              .where('requestId', isEqualTo: request.requestId)
              .limit(1)
              .get();

          if (userRequestSnapshot.docs.isNotEmpty) {
            await _firestore
                .collection('owner')
                .doc(request.userEmail)
                .collection('tow_requests')
                .doc(userRequestSnapshot.docs.first.id)
                .update({
                  'status': 'completed',
                  'completedAt': FieldValue.serverTimestamp(),
                  'serviceNotes': notes,
                  'updatedAt': FieldValue.serverTimestamp(),
                });
          }
        } catch (e) {
          print('⚠️ Could not update user collection: $e');
        }
      }

      // Also update in towrequest collection (if exists)
      try {
        final towRequestSnapshot = await _firestore
            .collectionGroup('towrequest')
            .where('requestId', isEqualTo: request.requestId)
            .limit(1)
            .get();

        if (towRequestSnapshot.docs.isNotEmpty) {
          await towRequestSnapshot.docs.first.reference.update({
            'status': 'completed',
            'completedAt': FieldValue.serverTimestamp(),
            'serviceNotes': notes,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        print('⚠️ Could not update towrequest collection: $e');
      }

      // Update Realtime Database
      try {
        await _dbRef.child('tow_requests').child(request.requestId).update({
          'status': 'completed',
          'completedAt': DateTime.now().millisecondsSinceEpoch,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      } catch (e) {
        print('⚠️ Could not update Realtime Database: $e');
      }

      // Send notification to user
      if (request.userEmail.isNotEmpty && request.userEmail != 'Unknown') {
        try {
          final userId = request.userId?.toString() ?? 
              request.userEmail.replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
          
          final userNotificationRef = _dbRef
              .child('notifications')
              .child(userId)
              .push();

          await userNotificationRef.set({
            'id': userNotificationRef.key,
            'requestId': request.requestId,
            'title': 'Service Completed ✅',
            'message': 'Your service has been completed successfully.',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'read': false,
            'type': 'service_completed',
            'vehicleNumber': request.vehicleNumber,
            'providerName': request.providerName,
            'status': 'completed',
          });

          print('✅ Notification sent to user');
        } catch (e) {
          print('⚠️ Could not send notification: $e');
        }
      }

      // Refresh data
      _loadServiceRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service marked as completed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error completing service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openChat(TowServiceRequest request) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please login to chat')),
        );
        return;
      }

      final requestId = request.requestId;
      final userEmail = request.userEmail;
      final userName = request.name;
      final providerEmail = request.providerEmail ?? _userEmail ?? '';
      final providerName = request.providerName;

      if (requestId.isEmpty || providerEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid request information')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            requestId: requestId,
            userEmail: providerEmail,
            userName: providerName,
            otherPartyEmail: userEmail,
            otherPartyName: userName,
            serviceType: 'Tow Service',
          ),
        ),
      );
    } catch (e) {
      print('Error opening chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open chat: $e')),
      );
    }
  }
}

class TowServiceRequest {

  TowServiceRequest({
    required this.id,
    required this.requestId,
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.issueType,
    required this.location,
    required this.description,
    required this.isUrgent,
    required this.status,
    required this.timestamp,
    required this.userEmail,
    this.userId,
    this.userLatitude,
    this.userLongitude,
    this.providerLatitude,
    this.providerLongitude,
    required this.distance,
    required this.providerName,
    required this.providerPhone,
    required this.truckNumber,
    required this.truckType,
    this.providerEmail,
  });
  final String id;
  final String requestId;
  final String name;
  final String phone;
  final String vehicleNumber;
  final String vehicleType;
  final String issueType;
  final String location;
  final String description;
  final bool isUrgent;
  final String status;
  final DateTime timestamp;
  final String userEmail;
  final String? userId;
  final double? userLatitude;
  final double? userLongitude;
  final double? providerLatitude;
  final double? providerLongitude;
  final double distance;
  final String providerName;
  final String providerPhone;
  final String truckNumber;
  final String truckType;
  final String? providerEmail;
}

// Tow Provider Notifications Screen (placeholder)
class TowProviderNotificationsScreen extends StatelessWidget {

  const TowProviderNotificationsScreen({super.key, required this.providerId});
  final String providerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tow Provider Notifications'),
        backgroundColor: Color(0xFFFF9800),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Notifications for Tow Provider: $providerId'),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';


// class InsuranceDocumentsViewer extends StatefulWidget {
//   const InsuranceDocumentsViewer({super.key});

//   @override
//   State<InsuranceDocumentsViewer> createState() => _InsuranceDocumentsViewerState();
// }

// class _InsuranceDocumentsViewerState extends State<InsuranceDocumentsViewer> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> _allRequests = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAllInsuranceRequests();
//   }

//   Future<void> _fetchAllInsuranceRequests() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       // Replace with your actual user email
//       String userEmail = "avi@gmail.com";
      
//       print("🔄 Fetching all insurance requests...");

//       // Get all insurance requests
//       QuerySnapshot snapshot = await _firestore
//           .collection('vehicle_owners')
//           .doc(userEmail)
//           .collection('insurance_requests')
//           .orderBy('createdAt', descending: true)
//           .get();

//       List<Map<String, dynamic>> allRequests = [];

//       for (var doc in snapshot.docs) {
//         Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        
//         // Add document ID
//         requestData['firestoreId'] = doc.id;
        
//         allRequests.add(requestData);
//         print("✅ Added request: ${requestData['requestId']}");
//       }

//       setState(() {
//         _allRequests = allRequests;
//         _isLoading = false;
//       });

//       print("🎉 Successfully loaded ${allRequests.length} insurance requests");

//     } catch (e) {
//       print("❌ Error fetching data: $e");
//       setState(() {
//         _isLoading = false;
//       });
      
//       _showMessage("Error loading data: $e", isError: true);
//     }
//   }

//   // Function to view ALL documents for a specific request
//   void _viewAllDocuments(Map<String, dynamic> insuranceRequest) {
//     List<dynamic> uploadedDocuments = insuranceRequest['uploadedDocuments'] ?? [];
    
//     if (uploadedDocuments.isEmpty) {
//       _showMessage("No documents uploaded for this request");
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DocumentsScreen(
//           request: insuranceRequest,
//           documents: uploadedDocuments,
//         ),
//       ),
//     );
//   }

//   void _showMessage(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Insurance Documents"),
//         backgroundColor: Colors.purple,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchAllInsuranceRequests,
//             tooltip: "Refresh",
//           ),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Loading insurance requests...",
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_allRequests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.folder_off, size: 80, color: Colors.grey),
//             const SizedBox(height: 16),
//             const Text(
//               "No Insurance Requests",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "You don't have any insurance requests yet",
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _fetchAllInsuranceRequests,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: const Text("Refresh"),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _allRequests.length,
//       itemBuilder: (context, index) {
//         return _buildInsuranceRequestCard(_allRequests[index]);
//       },
//     );
//   }

//   Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
//     String requestId = request['requestId']?.toString() ?? "Unknown ID";
//     String vehicleNumber = request['vehicleNumber']?.toString() ?? "N/A";
//     String status = request['status']?.toString() ?? "pending";
//     List<dynamic> documents = request['uploadedDocuments'] ?? [];
//     int documentCount = documents.length;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with Request ID and Status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         requestId,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.purple,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Vehicle: $vehicleNumber",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: _getStatusColor(status)),
//                   ),
//                   child: Text(
//                     status.toUpperCase(),
//                     style: TextStyle(
//                       color: _getStatusColor(status),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 16),

//             // Request Details
//             _buildDetailRow("Insurance Type", request['insuranceType']?.toString() ?? "N/A"),
//             _buildDetailRow("Vehicle Model", request['vehicleModel']?.toString() ?? "N/A"),
//             _buildDetailRow("Preferred Provider", request['preferredProvider']?.toString() ?? "Any Provider"),

//             // Documents Count
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue[100]!),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.attachment, color: Colors.blue, size: 24),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Uploaded Documents",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                         Text(
//                           "$documentCount document(s) available",
//                           style: const TextStyle(
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // VIEW ALL DOCUMENTS BUTTON
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: () => _viewAllDocuments(request),
//                 icon: const Icon(Icons.folder_open, size: 20),
//                 label: const Text(
//                   "VIEW ALL DOCUMENTS",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'accepted':
//       case 'confirmed':
//       case 'completed':
//         return Colors.green;
//       case 'pending':
//       case 'pending_review':
//         return Colors.orange;
//       case 'rejected':
//       case 'cancelled':
//         return Colors.red;
//       case 'in_progress':
//       case 'under_review':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// // Documents Screen to view ALL documents
// class DocumentsScreen extends StatelessWidget {
//   final Map<String, dynamic> request;
//   final List<dynamic> documents;

//   const DocumentsScreen({
//     super.key,
//     required this.request,
//     required this.documents,
//   });

//   Future<void> _downloadDocument(Map<String, dynamic> document, BuildContext context) async {
//     String documentUrl = document['url']?.toString() ?? '';
//     String documentName = document['name']?.toString() ?? 'Document';

//     if (documentUrl.isEmpty) {
//       _showMessage(context, "Download URL not available for $documentName");
//       return;
//     }

//     try {
//       Uri url = Uri.parse(documentUrl);
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url);
//         _showMessage(context, "Downloading $documentName...");
//       } else {
//         _showMessage(context, "Cannot download $documentName");
//       }
//     } catch (e) {
//       _showMessage(context, "Error downloading document: $e");
//     }
//   }

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: message.contains("Error") ? Colors.red : Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Documents - ${request['requestId']}"),
//         backgroundColor: Colors.purple,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Request Info
//             Card(
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Request: ${request['requestId']}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("Vehicle: ${request['vehicleNumber'] ?? 'N/A'}"),
//                     Text("Total Documents: ${documents.length}"),
//                   ],
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 16),
            
//             // Documents List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: documents.length,
//                 itemBuilder: (context, index) {
//                   var document = documents[index];
//                   return _buildDocumentCard(document, index + 1, context);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentCard(Map<String, dynamic> document, int number, BuildContext context) {
//     String documentName = document['name']?.toString() ?? "Document $number";
//     String documentType = document['type']?.toString() ?? "Document";
    
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.purple[100],
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               "$number",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.purple,
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           documentName,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Type: $documentType"),
//             if (document['uploadedAt'] != null)
//               Text(
//                 "Uploaded: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(document['uploadedAt'].toString()))}",
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.download, color: Colors.green, size: 28),
//           onPressed: () => _downloadDocument(document, context),
//           tooltip: "Download Document",
//         ),
//       ),
//     );
//   }
// }