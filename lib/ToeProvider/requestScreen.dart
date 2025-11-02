import 'dart:developer';

import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
import 'package:smart_road_app/ToeProvider/notification.dart';
import 'package:smart_road_app/VehicleOwner/notification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class IncomingRequestsScreen extends StatefulWidget {
  const IncomingRequestsScreen({super.key});

  @override
  _IncomingRequestsScreenState createState() => _IncomingRequestsScreenState();
}

class _IncomingRequestsScreenState extends State<IncomingRequestsScreen>
    with SingleTickerProviderStateMixin {
  final String _userEmail = "avi@gmail.com";
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isFcmInitialized = false;

  final List<String> _categories = [
    'All',
    'Pending',
    'Accepted',
    'Rejected',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Initialize FCM without waiting for it
    _initializeFCMAsync();
  }

  void _initializeFCMAsync() async {
    try {
      await FirebaseMessagingHandler.initialize();
      if (mounted) {
        setState(() {
          _isFcmInitialized = true;
        });
      }
    } catch (e) {
      print('FCM init error: $e');
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging && mounted) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Incoming Requests',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Color(0xFF7E57C2),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.purple.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.notifications_outlined, size: 22),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: _buildNotificationBadge(),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          ),
        ],
        bottom: _buildCategoryTabs(),
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildNotificationBadge() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('owners')
          .doc(_userEmail)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox();
        }
        final unreadCount = snapshot.data!.docs.length;
        return Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          constraints: BoxConstraints(minWidth: 18, minHeight: 18),
          child: Text(
            unreadCount > 9 ? '9+' : '$unreadCount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildCategoryTabs() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Color(0xFF7E57C2),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Color(0xFF7E57C2),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: -0.2,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          tabs: _categories.map((category) {
            return Tab(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.grey[100]!],
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildRequestsByCategory(category);
        }).toList(),
      ),
    );
  }

  Widget _buildRequestsByCategory(String category) {
    Query query = FirebaseFirestore.instance
        .collection('owner')
        .doc(_userEmail)
        .collection("towrequest");

    if (category != 'All') {
      query = query.where('status', isEqualTo: category.toLowerCase());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(category);
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final requestData = requests[index].data() as Map<String, dynamic>;
            final request = TowRequest.fromFirestore(
              requestData,
              requests[index].id,
            );
            return _buildRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildRequestCard(TowRequest request) {
    Color statusColor = _getStatusColor(request.status);
    IconData statusIcon = _getStatusIcon(request.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.purple.withOpacity(0.1),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: statusColor.withOpacity(0.3), width: 4),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with status and urgent badge
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 14),
                            SizedBox(width: 6),
                            Text(
                              request.status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      if (request.isUrgent)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.flash_on,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'URGENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Customer Info
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              request.phone,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request.timestamp,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Vehicle Details Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDetailChip(
                        Icons.directions_car,
                        request.vehicleNumber,
                      ),
                      _buildDetailChip(Icons.build, request.issueType),
                      _buildDetailChip(Icons.local_shipping, request.towType),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Location Section
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue[800],
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup Location',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[800],
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
                        if (request.latitude != null &&
                            request.longitude != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[500],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.map,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () => _openLocationInMap(request),
                              padding: EdgeInsets.all(6),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Description
                  if (request.description.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.description,
                              color: Colors.grey[700],
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Additional Notes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  request.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Action Buttons
                  SizedBox(height: 16),
                  _buildActionButtons(request),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(TowRequest request) {
    switch (request.status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => _rejectRequest(request),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.05),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Reject',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _acceptRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E57C2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.purple.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case 'accepted':
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => _trackLocation(request),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF7E57C2),
                    side: BorderSide(color: Color(0xFF7E57C2), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_searching, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Track',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _completeRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.green.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done_all, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case 'completed':
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => _viewDetails(request),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF7E57C2),
                    side: BorderSide(color: Color(0xFF7E57C2), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _contactCustomer(request.phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      default:
        return SizedBox.shrink();
    }
  }

  // FAST NOTIFICATION METHODS
  void _acceptRequest(TowRequest request) async {
    _showLoadingDialog('Accepting request...');

    try {
      // Update request status
      await _updateRequestStatus(request.id, 'accepted');

      // Create notification immediately
      await FirebaseMessagingHandler.createLocalNotification(
        userEmail: _userEmail,
        title: 'Request Accepted ✅',
        body: 'You accepted request from ${request.name}',
        type: 'request_accepted',
        requestId: request.id,
      );

      Navigator.pop(context); // Close loading dialog
      _showSuccess('Request accepted!');
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showError('Failed: $e');
    }
  }

  void _rejectRequest(TowRequest request) async {
    _showLoadingDialog('Rejecting request...');

    try {
      await _updateRequestStatus(request.id, 'rejected');

      await FirebaseMessagingHandler.createLocalNotification(
        userEmail: _userEmail,
        title: 'Request Rejected ❌',
        body: 'You rejected request from ${request.name}',
        type: 'request_rejected',
        requestId: request.id,
      );

      Navigator.pop(context);
      _showSuccess('Request rejected');
    } catch (e) {
      Navigator.pop(context);
      _showError('Failed: $e');
    }
  }

  void _completeRequest(TowRequest request) async {
    _showLoadingDialog('Completing request...');

    try {
      await _updateRequestStatus(request.id, 'completed');

      await FirebaseMessagingHandler.createLocalNotification(
        userEmail: _userEmail,
        title: 'Request Completed 🎉',
        body: 'You completed request from ${request.name}',
        type: 'request_completed',
        requestId: request.id,
      );

      Navigator.pop(context);
      _showSuccess('Request completed!');
    } catch (e) {
      Navigator.pop(context);
      _showError('Failed: $e');
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF7E57C2).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  color: Color(0xFF7E57C2),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('owner')
        .doc(_userEmail)
        .collection("towrequest")
        .doc(requestId)
        .update({
          'status': status,
          '${status}At': FieldValue.serverTimestamp(),
        });
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFF7E57C2), size: 14),
          SizedBox(width: 6),
          Text(
            text.length > 12 ? '${text.substring(0, 12)}...' : text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Color(0xFFFFA000);
      case 'accepted':
        return Color(0xFF2196F3);
      case 'rejected':
        return Color(0xFFF44336);
      case 'completed':
        return Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  void _trackLocation(TowRequest request) async {
    log(request.latitude.toString());
    log(request.longitude.toString());
    if (request.latitude != null && request.longitude != null) {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=${request.latitude},${request.longitude}';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        _showError('Could not launch maps');
      }
    } else {
      _showError('Location not available');
    }
  }

  void _openLocationInMap(TowRequest request) => _trackLocation(request);

  void _contactCustomer(String phone) async {
    final Uri telLaunchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telLaunchUri)) {
      await launchUrl(telLaunchUri);
    } else {
      _showError('Could not make call');
    }
  }

  void _viewDetails(TowRequest request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.request_page,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Request Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ID: ${request.requestId}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailItem(
                      'Customer Name',
                      request.name,
                      Icons.person,
                    ),
                    _buildDetailItem(
                      'Phone Number',
                      request.phone,
                      Icons.phone,
                    ),
                    _buildDetailItem(
                      'Vehicle Number',
                      request.vehicleNumber,
                      Icons.directions_car,
                    ),
                    _buildDetailItem(
                      'Issue Type',
                      request.issueType,
                      Icons.build,
                    ),
                    _buildDetailItem(
                      'Service Type',
                      request.towType,
                      Icons.local_shipping,
                    ),
                    _buildDetailItem(
                      'Location',
                      request.location,
                      Icons.location_on,
                    ),
                    if (request.description.isNotEmpty)
                      _buildDetailItem(
                        'Description',
                        request.description,
                        Icons.description,
                      ),
                    _buildDetailItem(
                      'Status',
                      request.status.toUpperCase(),
                      Icons.circle,
                      color: _getStatusColor(request.status),
                    ),
                    _buildDetailItem(
                      'Request Time',
                      request.timestamp,
                      Icons.access_time,
                    ),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF7E57C2),
                          side: BorderSide(color: Color(0xFF7E57C2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _contactCustomer(request.phone);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7E57C2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 6),
                            Text('Call'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color ?? Color(0xFF7E57C2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color ?? Color(0xFF7E57C2), size: 14),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI Helper Methods
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              color: Color(0xFF7E57C2),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading requests...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, color: Colors.red, size: 48),
            ),
            SizedBox(height: 24),
            Text(
              'Unable to Load',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'There was an error loading your requests',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error,
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7E57C2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.request_quote_outlined,
                color: Colors.grey[400],
                size: 48,
              ),
            ),
            SizedBox(height: 24),
            Text(
              category == 'All' ? 'No Requests' : 'No $category Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Text(
              category == 'All'
                  ? 'New tow requests will appear here'
                  : 'You don\'t have any $category requests at the moment',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            if (category != 'All')
              TextButton(
                onPressed: () {
                  _tabController.animateTo(0); // Switch to All tab
                },
                child: Text(
                  'View All Requests',
                  style: TextStyle(
                    color: Color(0xFF7E57C2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
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
}

class TowRequest {
  final String id;
  final String name;
  final String phone;
  final String location;
  final String description;
  final String requestId;
  final String vehicleNumber;
  final String issueType;
  final String towType;
  final bool isUrgent;
  final String status;
  final String timestamp;
  final double? latitude;
  final double? longitude;

  TowRequest({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.description,
    required this.requestId,
    required this.vehicleNumber,
    required this.issueType,
    required this.towType,
    required this.isUrgent,
    required this.status,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  factory TowRequest.fromFirestore(Map<String, dynamic> data, String docId) {
    return TowRequest(
      id: docId,
      name: data['name'] ?? 'Unknown',
      phone: data['phone'] ?? '',
      location: data['location'] ?? 'Location not specified',
      description: data['description'] ?? '',
      requestId: data['requestId'] ?? docId,
      vehicleNumber: data['vehicleNumber'] ?? 'Unknown Vehicle',
      issueType: data['issueType'] ?? 'Unknown Issue',
      towType: data['towType'] ?? 'Standard',
      isUrgent: data['isUrgent'] ?? false,
      status: data['status'] ?? 'pending',
      timestamp: _formatTimestamp(data['timestamp']),
      latitude: data['latitude'] != null
          ? double.tryParse(data['latitude'].toString())
          : null,
      longitude: data['longitude'] != null
          ? double.tryParse(data['longitude'].toString())
          : null,
    );
  }
}

String _formatTimestamp(dynamic timestamp) {
  if (timestamp == null) return 'Recently';
  try {
    if (timestamp is Timestamp) {
      final now = DateTime.now();
      final time = timestamp.toDate();
      final difference = now.difference(time);

      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${time.day}/${time.month}/${time.year}';
    }
    return 'Recently';
  } catch (e) {
    return 'Recently';
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