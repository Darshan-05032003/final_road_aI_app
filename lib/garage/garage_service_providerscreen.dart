import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GarageServiceProviderScreen extends StatefulWidget {
  final String garageEmail;

  const GarageServiceProviderScreen({super.key, required this.garageEmail});

  @override
  _GarageServiceProviderScreenState createState() => _GarageServiceProviderScreenState();
}

class _GarageServiceProviderScreenState extends State<GarageServiceProviderScreen> {
  List<Map<String, dynamic>> _serviceRequests = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadServiceRequests();
  }

  Future<void> _loadServiceRequests() async {
    try {
      // Sanitize garage email for Firebase
      final sanitizedGarageEmail = _sanitizeEmail(widget.garageEmail);
      
      print('🔍 Loading service requests for garage: ${widget.garageEmail}');
      print('🔧 Sanitized email: $sanitizedGarageEmail');
      
      final serviceRequestsSnapshot = await FirebaseFirestore.instance
          .collection('garage_requests')
          .doc(sanitizedGarageEmail)
          .collection('service_requests')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> requests = [];
      
      for (var doc in serviceRequestsSnapshot.docs) {
        final data = doc.data();
        requests.add({
          'id': doc.id,
          ...data,
          // Convert Firestore timestamp to DateTime
          'createdAt': data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
          'preferredDate': data['preferredDate'] != null ? (data['preferredDate'] as Timestamp).toDate() : null,
        });
      }

      setState(() {
        _serviceRequests = requests;
        _isLoading = false;
      });

      print('✅ Loaded ${_serviceRequests.length} service requests for garage ${widget.garageEmail}');

    } catch (e) {
      print('❌ Error loading service requests: $e');
      setState(() {
        _errorMessage = 'Failed to load service requests: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _sanitizeEmail(String email) {
    return email.replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    try {
      final sanitizedGarageEmail = _sanitizeEmail(widget.garageEmail);
      
      // Update in garage's collection
      await FirebaseFirestore.instance
          .collection('garage_requests')
          .doc(sanitizedGarageEmail)
          .collection('service_requests')
          .doc(requestId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Also update in user's collection
      final request = _serviceRequests.firstWhere((req) => req['id'] == requestId);
      final userEmail = request['userEmail'];
      
      if (userEmail != null) {
        final userRequestsSnapshot = await FirebaseFirestore.instance
            .collection('owner')
            .doc(userEmail)
            .collection('garagerequest')
            .where('requestId', isEqualTo: requestId)
            .get();

        if (userRequestsSnapshot.docs.isNotEmpty) {
          await userRequestsSnapshot.docs.first.reference.update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Update Realtime Database
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('garage_requests').child(requestId).update({
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Send notification to user
      final userNotificationRef = dbRef
          .child('notifications')
          .child(request['userId']?.replaceAll(RegExp(r'[\.#\$\[\]]'), '_') ?? 'unknown')
          .push();
      
      await userNotificationRef.set({
        'id': userNotificationRef.key,
        'requestId': requestId,
        'title': 'Service Request $status',
        'message': 'Your service request for ${request['vehicleNumber']} has been $status by ${widget.garageEmail}',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'read': false,
        'type': 'garage_request_updated',
        'vehicleNumber': request['vehicleNumber'],
        'garageName': request['garageName'],
        'status': status.toLowerCase(),
      });

      // Refresh the list
      _loadServiceRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request status updated to $status')),
      );

    } catch (e) {
      print('❌ Error updating request status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${e.toString()}')),
      );
    }
  }

  void _viewLocationOnMap(double? latitude, double? longitude, String address) {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location coordinates not available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Customer Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: $address'),
            Text('Latitude: ${latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${longitude.toStringAsFixed(6)}'),
            SizedBox(height: 16),
            Text(
              'You can use this location to navigate to the customer.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you can integrate with maps app
              final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
              // You can use url_launcher to open the URL
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Open in maps: $mapsUrl')),
              );
              Navigator.pop(context);
            },
            child: Text('Open in Maps'),
          ),
        ],
      ),
    );
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Service Request Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Request ID', request['requestId']),
              _buildDetailItem('Vehicle Number', request['vehicleNumber']),
              _buildDetailItem('Vehicle Model', request['vehicleModel']),
              _buildDetailItem('Vehicle Type', request['vehicleType']),
              _buildDetailItem('Fuel Type', request['fuelType']),
              _buildDetailItem('Service Type', request['serviceType']),
              _buildDetailItem('Customer Name', request['name']),
              _buildDetailItem('Customer Phone', request['phone']),
              _buildDetailItem('Customer Email', request['userEmail']),
              _buildDetailItem('Location', request['address'] ?? request['location']),
              if (request['latitude'] != null && request['longitude'] != null)
                _buildDetailItem('Coordinates', '${request['latitude']}, ${request['longitude']}'),
              _buildDetailItem('Live Location', request['liveLocationEnabled'] == true ? 'Enabled' : 'Disabled'),
              _buildDetailItem('Preferred Date', request['preferredDate'] != null 
                  ? DateFormat('MMM dd, yyyy').format(request['preferredDate'])
                  : 'Not specified'),
              _buildDetailItem('Preferred Time', request['preferredTime'] ?? 'Not specified'),
              _buildDetailItem('Selected Issues', request['selectedIssues']?.join(', ') ?? 'None'),
              _buildDetailItem('Additional Details', request['description'] ?? 'None'),
              _buildDetailItem('Status', request['status'] ?? 'Pending'),
              _buildDetailItem('Distance', request['distance'] != null 
                  ? '${request['distance'].toStringAsFixed(1)} km away' 
                  : 'Not available'),
              _buildDetailItem('Request Date', DateFormat('MMM dd, yyyy HH:mm').format(request['createdAt'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (request['latitude'] != null && request['longitude'] != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _viewLocationOnMap(
                  request['latitude'],
                  request['longitude'],
                  request['address'] ?? request['location'] ?? 'Unknown location',
                );
              },
              child: Text('View Location'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Requests - ${widget.garageEmail}'),
        backgroundColor: Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadServiceRequests,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF6D28D9)),
                  SizedBox(height: 16),
                  Text('Loading service requests...'),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.orange),
                      SizedBox(height: 16),
                      Text(
                        'Error Loading Requests',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadServiceRequests,
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _serviceRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'No Service Requests',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You don\'t have any service requests yet.',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loadServiceRequests,
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
                            child: Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadServiceRequests,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _serviceRequests.length,
                        itemBuilder: (context, index) {
                          final request = _serviceRequests[index];
                          return _buildRequestCard(request);
                        },
                      ),
                    ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with vehicle info and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['vehicleNumber'] ?? 'No Vehicle Number',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${request['vehicleModel'] ?? 'Unknown Model'} • ${request['serviceType'] ?? 'General Repair'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request['status'] ?? 'Pending'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request['status'] ?? 'Pending',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Customer information
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${request['name'] ?? 'Unknown Customer'} • ${request['phone'] ?? 'No Phone'}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Location information
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['address'] ?? request['location'] ?? 'Location not provided',
                        style: TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (request['distance'] != null)
                        Text(
                          '${request['distance'].toStringAsFixed(1)} km away',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Live location indicator
            if (request['liveLocationEnabled'] == true)
              Row(
                children: [
                  Icon(Icons.location_searching, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Live Location Sharing Active',
                    style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            
            SizedBox(height: 12),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewRequestDetails(request),
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: 8),
                if (request['status'] == 'Pending') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateRequestStatus(request['id'], 'Accepted'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Accept'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateRequestStatus(request['id'], 'Rejected'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Reject'),
                    ),
                  ),
                ] else if (request['status'] == 'Accepted') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateRequestStatus(request['id'], 'Completed'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text('Complete'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}