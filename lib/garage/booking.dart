import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Mock AuthService since it wasn't provided
class AuthService {
  static Future<String?> getUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.email;
      }
      return null;
    } catch (e) {
      print('Error getting user email: $e');
      return null;
    }
  }
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with TickerProviderStateMixin {
  late TabController _mainTabController; // For Spare Parts vs Service Requests
  late TabController _partsTabController; // For spare parts status tabs
  late TabController _serviceTabController; // For service requests status tabs
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  String? _garageId;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Spare Parts Bookings
  List<Booking> sparePartsBookings = [];
  
  // Service Requests
  List<ServiceRequest> serviceRequests = [];
  List<ServiceRequest> _pendingServiceRequests = [];
  List<ServiceRequest> _confirmedServiceRequests = [];
  List<ServiceRequest> _completedServiceRequests = [];
  List<ServiceRequest> _cancelledServiceRequests = [];


  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _partsTabController = TabController(length: 4, vsync: this);
    _serviceTabController = TabController(length: 4, vsync: this);
    
    
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (_userEmail != null) {
      await _loadGarageProfile();
      await Future.wait([
        _loadBookings(),
        _loadServiceRequests(),
      ]);
    } else {
      _handleNoUser();
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('🔄 Loading user data...');
      
      // Try to get current user from Firebase Auth
      User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        setState(() {
          _userEmail = currentUser.email;
        });
        print('✅ User email from Firebase Auth: $_userEmail');
        return;
      }
      
      // If no current user, try AuthService
      String? userEmail = await AuthService.getUserEmail();
      if (userEmail != null) {
        setState(() {
          _userEmail = userEmail;
        });
        print('✅ User email from AuthService: $_userEmail');
        return;
      }
      
      // If still no user, set error state
      _handleNoUser();
      
    } catch (e) {
      print('❌ Error loading user data: $e');
      _handleNoUser();
    }
  }

  Future<void> _loadGarageProfile() async {
    try {
      if (_userEmail == null) return;
      
      final garageSnapshot = await _firestore
          .collection('garages')
          .where('email', isEqualTo: _userEmail)
          .limit(1)
          .get();

      if (garageSnapshot.docs.isNotEmpty) {
        setState(() {
          _garageId = garageSnapshot.docs.first.id;
        });
        print('✅ Found garage ID: $_garageId');
      } else {
        print('⚠️ No garage profile found for email: $_userEmail');
      }
    } catch (e) {
      print('❌ Error loading garage profile: $e');
    }
  }

  void _handleNoUser() {
    setState(() {
      _hasError = true;
      _errorMessage = 'Please login again to access bookings';
      _isLoading = false;
    });
  }

  // Load service requests
  Future<void> _loadServiceRequests() async {
    try {
      if (_garageId == null) {
        print('⚠️ No garage ID, skipping service requests');
        return;
      }

      print('📡 Fetching service requests for garage: $_garageId');

      final serviceRequestsSnapshot = await _firestore
          .collection('garages')
          .doc(_garageId!)
          .collection('service_requests')
          .orderBy('createdAt', descending: true)
          .get();

      print('📊 Documents found in service_requests: ${serviceRequestsSnapshot.docs.length}');

      List<ServiceRequest> requests = [];

      for (var doc in serviceRequestsSnapshot.docs) {
        try {
          final data = doc.data();
          ServiceRequest request = _parseServiceRequest(doc.id, data);
          requests.add(request);
        } catch (e) {
          print('❌ Error parsing service request ${doc.id}: $e');
        }
      }

      _categorizeServiceRequests(requests);
      
      setState(() {
        serviceRequests = requests;
      });

      print('🎉 Successfully loaded ${serviceRequests.length} service requests');
    } catch (e) {
      print('❌ Error loading service requests: $e');
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
      garageName: data['garageName']?.toString() ?? 'Our Garage',
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
      return DateTime.now();
    }
  }

  void _categorizeServiceRequests(List<ServiceRequest> requests) {
    setState(() {
      _pendingServiceRequests = requests.where((request) =>
        request.status.toLowerCase() == 'pending').toList();
      _confirmedServiceRequests = requests.where((request) =>
        request.status.toLowerCase() == 'confirmed' ||
        request.status.toLowerCase() == 'accepted').toList();
      _completedServiceRequests = requests.where((request) =>
        request.status.toLowerCase() == 'completed').toList();
      _cancelledServiceRequests = requests.where((request) =>
        request.status.toLowerCase() == 'cancelled' ||
        request.status.toLowerCase() == 'rejected').toList();
    });
  }

  // Firebase get call to fetch bookings with accurate data fetching
  Future<void> _loadBookings() async {
    try {
      if (_userEmail == null || _userEmail!.isEmpty) {
        _handleNoUser();
        return;
      }

      print('📡 Fetching bookings for: $_userEmail');

      final querySnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('shop')
          .get();

      print('✅ Found ${querySnapshot.docs.length} booking documents');

      if (querySnapshot.docs.isEmpty) {
        _showNoDataState();
        return;
      }

      List<Booking> loadedBookings = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          print('📄 Processing booking document: ${doc.id}');
          print('📊 Booking data: $data');
          
          // Extract cart items data safely
          List<Map<String, dynamic>> cartItems = [];
          if (data['cartItems'] is List) {
            for (var item in data['cartItems']) {
              if (item is Map<String, dynamic>) {
                cartItems.add(Map<String, dynamic>.from(item));
              }
            }
          }

          // Get order ID - try multiple possible fields
          String orderId = _getField(data, 'orderId', 
                        _getField(data, 'id', 
                          _getField(data, 'bookingId', 'ORD-${doc.id.substring(0, 8)}')));

          // Get the first item from cart for display or use individual fields
          String partName = 'Multiple Items';
          String partId = '';
          int quantity = 0;

          if (cartItems.isNotEmpty) {
            partName = _getField(cartItems.first, 'name', 
                        _getField(cartItems.first, 'partName', 'Unknown Part'));
            partId = _getField(cartItems.first, 'id', 
                      _getField(cartItems.first, 'partId', ''));
            quantity = _getQuantity(cartItems.first);
          } else {
            // Try to get from individual fields if cartItems is empty
            partName = _getField(data, 'partName', 'Unknown Part');
            partId = _getField(data, 'partId', '');
            quantity = _getQuantity(data);
          }

          // Calculate total price
          double totalPrice = _getTotalPrice(data, cartItems);

          Booking booking = Booking(
            id: orderId,
            userName: _getField(data, 'name', 'Unknown Customer'),
            userPhone: _getField(data, 'phone', 'Not provided'),
            partName: partName,
            partId: partId,
            quantity: quantity,
            totalPrice: totalPrice,
            address: _buildAddress(data),
            status: _getField(data, 'status', 'Pending'),
            timestamp: _formatTimestamp(data['timestamp'] ?? data['createdAt'] ?? data['date']),
            vehicleType: _getField(data, 'vehicleType', 'Not specified'),
            paymentMethod: _getField(data, 'paymentMethod', 'Unknown'),
            email: _getField(data, 'email', ''),
            cartItems: cartItems,
            docId: doc.id, // Store document ID for updates
          );
          
          loadedBookings.add(booking);
          print('✅ Processed booking: ${booking.id} - ${booking.status}');

        } catch (e) {
          print('❌ Error processing booking document ${doc.id}: $e');
        }
      }

      // Sort by timestamp descending
      loadedBookings.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        sparePartsBookings = loadedBookings;
        _isLoading = false;
        _hasError = false;
      });

      print('🎉 Successfully loaded ${sparePartsBookings.length} spare parts bookings');

    } catch (e) {
      print('❌ Error loading bookings: $e');
      _showErrorState('Failed to load bookings: ${e.toString()}');
    }
  }

  // Helper method to safely get string fields
  String _getField(Map<String, dynamic> data, String field, String defaultValue) {
    try {
      final value = data[field];
      if (value == null || value.toString().isEmpty) {
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  // Helper method to get quantity
  int _getQuantity(Map<String, dynamic> data) {
    try {
      final quantity = data['quantity'];
      if (quantity is int) return quantity;
      if (quantity is String) return int.tryParse(quantity) ?? 1;
      if (quantity is double) return quantity.toInt();
      return 1;
    } catch (e) {
      return 1;
    }
  }

  // Helper method to calculate total price
  double _getTotalPrice(Map<String, dynamic> data, List<Map<String, dynamic>> cartItems) {
    try {
      // First try to get total from data
      final total = data['total'];
      if (total != null) {
        if (total is double) return total;
        if (total is int) return total.toDouble();
        if (total is String) return double.tryParse(total) ?? 0.0;
      }

      // Calculate from cart items
      double calculatedTotal = 0.0;
      for (var item in cartItems) {
        double price = 0.0;
        int quantity = 1;

        final itemPrice = item['price'] ?? item['totalPrice'];
        final itemQuantity = item['quantity'];

        if (itemPrice is double) price = itemPrice;
        if (itemPrice is int) price = itemPrice.toDouble();
        if (itemPrice is String) price = double.tryParse(itemPrice) ?? 0.0;

        if (itemQuantity is int) quantity = itemQuantity;
        if (itemQuantity is String) quantity = int.tryParse(itemQuantity) ?? 1;

        calculatedTotal += price * quantity;
      }

      return calculatedTotal;
    } catch (e) {
      return 0.0;
    }
  }

  // Helper method to build address
  String _buildAddress(Map<String, dynamic> data) {
    List<String> addressParts = [];
    
    if (data['address'] != null && data['address'].toString().isNotEmpty) {
      addressParts.add(data['address'].toString());
    }
    if (data['city'] != null && data['city'].toString().isNotEmpty) {
      addressParts.add(data['city'].toString());
    }
    if (data['state'] != null && data['state'].toString().isNotEmpty) {
      addressParts.add(data['state'].toString());
    }
    if (data['zip'] != null && data['zip'].toString().isNotEmpty) {
      addressParts.add(data['zip'].toString());
    }
    if (data['pincode'] != null && data['pincode'].toString().isNotEmpty) {
      addressParts.add(data['pincode'].toString());
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'Address not provided';
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown Date';
    
    try {
      DateTime date;
      
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is String) {
        date = DateTime.parse(timestamp);
      } else {
        return 'Invalid Date';
      }
      
      return '${_formatTwoDigits(date.day)}/${_formatTwoDigits(date.month)}/${date.year} ${_formatTwoDigits(date.hour)}:${_formatTwoDigits(date.minute)}';
    } catch (e) {
      print('Error formatting timestamp: $e');
      return 'Unknown Date';
    }
  }

  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  // Update booking status in Firestore
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      if (_userEmail == null) {
        _showErrorSnackBar('Please login again');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      print('🔄 Updating booking $bookingId to $newStatus');

      // Find the document with matching orderId
      final querySnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('shop')
          .where('orderId', isEqualTo: bookingId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showErrorSnackBar('Booking not found');
        return;
      }

      final docId = querySnapshot.docs.first.id;

      await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('shop')
          .doc(docId)
          .update({
            'status': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update local state
      setState(() {
        int index = sparePartsBookings.indexWhere((booking) => booking.id == bookingId);
        if (index != -1) {
          sparePartsBookings[index] = sparePartsBookings[index].copyWith(status: newStatus);
        }
        _isLoading = false;
      });

      _showSuccessSnackBar('Booking status updated to $newStatus');

    } catch (e) {
      print('❌ Error updating booking status: $e');
      _showErrorSnackBar('Failed to update status: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorState(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _isLoading = false;
    });
  }

  void _showNoDataState() {
    setState(() {
      sparePartsBookings = [];
      serviceRequests = [];
      _isLoading = false;
      _hasError = false;
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleRetry() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _initializeData();
  }

  // Service Request Methods
  Widget _buildServiceRequestsList(List<ServiceRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'No Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadServiceRequests();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return _buildServiceRequestCard(requests[index]);
        },
      ),
    );
  }

  Widget _buildServiceRequestCard(ServiceRequest request) {
    Color statusColor = _getServiceRequestStatusColor(request.status);

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to detailed view or show bottom sheet
          _showServiceRequestDetails(request);
        },
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
              Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.name, style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text(request.phone, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _callCustomer(request.phone),
                    icon: Icon(Icons.phone, color: Colors.green),
                    tooltip: 'Call Customer',
                  ),
                  if (request.status.toLowerCase() == 'pending') ...[
                    IconButton(
                      onPressed: () => _updateServiceRequestStatus(request, 'Confirmed'),
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Confirm Request',
                    ),
                    IconButton(
                      onPressed: () => _updateServiceRequestStatus(request, 'Cancelled'),
                      icon: Icon(Icons.cancel, color: Colors.red),
                      tooltip: 'Cancel Request',
                    ),
                  ],
                  if (request.status.toLowerCase() == 'confirmed') ...[
                    IconButton(
                      onPressed: () => _showCompleteServiceDialog(request),
                      icon: Icon(Icons.done_all, color: Colors.blue),
                      tooltip: 'Mark as Completed',
                    ),
                  ],
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Requested: ${DateFormat('MMM dd, yyyy - hh:mm a').format(request.createdAt)}',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getServiceRequestStatusColor(String status) {
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

  Future<void> _updateServiceRequestStatus(ServiceRequest request, String newStatus) async {
    try {
      print('🔄 Updating service request ${request.requestId} to $newStatus');

      // Update in garage's service_requests collection
      if (_garageId != null) {
        await _firestore
            .collection('garages')
            .doc(_garageId!)
            .collection('service_requests')
            .doc(request.id)
            .update({
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
          await userRequestQuery.docs.first.reference.update({
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
      print('❌ Error updating service request status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showServiceRequestDetails(ServiceRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Service Request Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Request ID', request.requestId),
              _buildDetailRow('Status', request.status),
              _buildDetailRow('Vehicle Number', request.vehicleNumber),
              _buildDetailRow('Vehicle Model', request.vehicleModel),
              _buildDetailRow('Service Type', request.serviceType),
              _buildDetailRow('Preferred Date', request.preferredDate),
              _buildDetailRow('Preferred Time', request.preferredTime),
              _buildDetailRow('Customer Name', request.name),
              _buildDetailRow('Phone', request.phone),
              _buildDetailRow('Location', request.location),
              if (request.problemDescription.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Problem Description:', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text(request.problemDescription),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              if (request.status.toLowerCase() == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateServiceRequestStatus(request, 'Cancelled');
                        },
                        child: Text('Reject'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateServiceRequestStatus(request, 'Confirmed');
                        },
                        child: Text('Confirm'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                  ],
                ),
              if (request.status.toLowerCase() == 'confirmed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCompleteServiceDialog(request);
                    },
                    child: Text('Mark as Completed'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompleteServiceDialog(ServiceRequest request) async {
    final amountController = TextEditingController();
    final upiIdController = TextEditingController();
    final notesController = TextEditingController();

    // Try to load saved UPI ID
    bool hasSavedUpiId = false;
    if (_userEmail != null) {
      try {
        final profileDoc = await _firestore
            .collection('garages')
            .doc(_userEmail!)
            .get();
        
        if (profileDoc.exists && profileDoc.data()?['upiId'] != null) {
          final savedUpiId = profileDoc.data()!['upiId'].toString().trim();
          if (savedUpiId.isNotEmpty) {
            upiIdController.text = savedUpiId;
            hasSavedUpiId = true;
          }
        }
      } catch (e) {
        print('⚠️ Could not load saved UPI ID: $e');
      }
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Complete Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Service Amount *',
                  hintText: 'Enter amount in ₹',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              TextField(
                controller: upiIdController,
                decoration: InputDecoration(
                  labelText: 'Your UPI ID *',
                  hintText: hasSavedUpiId ? null : 'yourname@paytm',
                  prefixIcon: Icon(Icons.payment),
                  helperText: hasSavedUpiId
                      ? 'Pre-filled from your profile'
                      : 'This will be used to receive payment',
                ),
              ),
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
              if (amountController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter service amount')),
                );
                return;
              }
              if (double.tryParse(amountController.text.trim()) == null ||
                  double.parse(amountController.text.trim()) <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter valid amount')),
                );
                return;
              }
              if (upiIdController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter UPI ID')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: Text('Mark Complete'),
          ),
        ],
      ),
    );

    if (result == true) {
      final amount = double.parse(amountController.text.trim());
      final upiId = upiIdController.text.trim();
      final notes = notesController.text.trim();

      await _completeServiceWithPayment(request, amount, upiId, notes);
    }

    amountController.dispose();
    upiIdController.dispose();
    notesController.dispose();
  }

  Future<void> _completeServiceWithPayment(
    ServiceRequest request,
    double amount,
    String upiId,
    String notes,
  ) async {
    try {
      // Save UPI ID to profile
      if (_userEmail != null) {
        try {
          await _firestore.collection('garages').doc(_userEmail!).set({
            'upiId': upiId,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (e) {
          print('⚠️ Could not save UPI ID: $e');
        }
      }

      // Update request with completion and payment info
      if (_garageId != null) {
        await _firestore
            .collection('garages')
            .doc(_garageId!)
            .collection('service_requests')
            .doc(request.id)
            .update({
          'status': 'completed',
          'serviceAmount': amount,
          'providerUpiId': upiId,
          'paymentStatus': 'pending',
          'notes': notes,
          'completedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Also update in user's collection
      try {
        final userRequestQuery = await _firestore
            .collectionGroup('garagerequest')
            .where('requestId', isEqualTo: request.requestId)
            .limit(1)
            .get();

        if (userRequestQuery.docs.isNotEmpty) {
          await userRequestQuery.docs.first.reference.update({
            'status': 'completed',
            'serviceAmount': amount,
            'providerUpiId': upiId,
            'paymentStatus': 'pending',
            'notes': notes,
            'completedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        print('⚠️ Could not update user collection: $e');
      }

      // Reload requests
      await _loadServiceRequests();

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

  void _handleLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please login again'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  List<Booking> getBookingsByStatus(String status) {
    return sparePartsBookings.where((booking) => booking.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        bottom: !_hasError
            ? TabBar(
                controller: _mainTabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Spare Parts (${sparePartsBookings.length})'),
                  Tab(text: 'Service Requests (${serviceRequests.length})'),
                ],
              )
            : null,
      ),
      body: _buildBody(),
      floatingActionButton: !_hasError ? FloatingActionButton(
        onPressed: _handleRetry,
        backgroundColor: Color(0xFF2563EB),
        tooltip: 'Refresh',
        child: Icon(Icons.refresh, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    return TabBarView(
      controller: _mainTabController,
      children: [
        _buildSparePartsView(),
        _buildServiceRequestsView(),
      ],
    );
  }

  Widget _buildSparePartsView() {
    if (sparePartsBookings.isEmpty) {
      return _buildNoSparePartsState();
    }

    return Column(
      children: [
        TabBar(
          controller: _partsTabController,
          labelColor: Color(0xFF2563EB),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF2563EB),
          tabs: [
            Tab(text: 'Pending (${getBookingsByStatus("Pending").length})'),
            Tab(text: 'Confirmed (${getBookingsByStatus("Confirmed").length})'),
            Tab(text: 'Dispatched (${getBookingsByStatus("Dispatched").length})'),
            Tab(text: 'Completed (${getBookingsByStatus("Completed").length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _partsTabController,
            children: [
              _buildBookingsList('Pending'),
              _buildBookingsList('Confirmed'),
              _buildBookingsList('Dispatched'),
              _buildBookingsList('Completed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRequestsView() {
    if (serviceRequests.isEmpty) {
      return _buildNoServiceRequestsState();
    }

    return Column(
      children: [
        TabBar(
          controller: _serviceTabController,
          labelColor: Color(0xFF2563EB),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF2563EB),
          tabs: [
            Tab(text: 'Pending (${_pendingServiceRequests.length})'),
            Tab(text: 'Confirmed (${_confirmedServiceRequests.length})'),
            Tab(text: 'Completed (${_completedServiceRequests.length})'),
            Tab(text: 'Cancelled (${_cancelledServiceRequests.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _serviceTabController,
            children: [
              _buildServiceRequestsList(_pendingServiceRequests),
              _buildServiceRequestsList(_confirmedServiceRequests),
              _buildServiceRequestsList(_completedServiceRequests),
              _buildServiceRequestsList(_cancelledServiceRequests),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoSparePartsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No Spare Parts Bookings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Your spare parts bookings will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoServiceRequestsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No Service Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Service requests from customers will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
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
            'Loading bookings...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          if (_userEmail != null) ...[
            SizedBox(height: 8),
            Text(
              'User: $_userEmail',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
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
              'Authentication Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handleRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Try Again'),
                ),
                SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _handleLogout,
                  child: Text('Login Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBookingsList(String status) {
    List<Booking> statusBookings = getBookingsByStatus(status);
    
    if (statusBookings.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: statusBookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(statusBookings[index]);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor = _getStatusColor(booking.status);

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Customer Information
            _buildInfoRow(Icons.person, 'Customer', booking.userName),
            _buildInfoRow(Icons.phone, 'Phone', booking.userPhone),
            if (booking.email.isNotEmpty) 
              _buildInfoRow(Icons.email, 'Email', booking.email),
            
            SizedBox(height: 8),
            
            // Order Details
            _buildInfoRow(Icons.inventory_2, 'Item', booking.partName),
            _buildInfoRow(Icons.format_list_numbered, 'Quantity', booking.quantity.toString()),
            _buildInfoRow(Icons.directions_car, 'Vehicle', booking.vehicleType),
            _buildInfoRow(Icons.payment, 'Payment', booking.paymentMethod),
            
            SizedBox(height: 8),
            
            // Address
            _buildInfoRow(Icons.location_on, 'Address', booking.address),
            
            SizedBox(height: 12),
            
            // Footer with Total and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Text(
                  booking.timestamp,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            
            // Action Buttons
            SizedBox(height: 12),
            _buildActionButtons(booking),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Color(0xFF64748B)),
          SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Booking booking) {
    switch (booking.status) {
      case 'Pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRejectDialog(booking),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                ),
                child: Text('Reject'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => updateBookingStatus(booking.id, 'Confirmed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Confirm'),
              ),
            ),
          ],
        );
      
      case 'Confirmed':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => updateBookingStatus(booking.id, 'Dispatched'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                child: Text('Mark Dispatched'),
              ),
            ),
          ],
        );
      
      case 'Dispatched':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => updateBookingStatus(booking.id, 'Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: Text('Mark Completed'),
              ),
            ),
          ],
        );
      
      default:
        return SizedBox.shrink();
    }
  }

  void _showRejectDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Booking'),
        content: Text('Are you sure you want to reject this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              updateBookingStatus(booking.id, 'Cancelled');
              Navigator.pop(context);
            },
            child: Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Color(0xFFF59E0B);
      case 'confirmed': return Color(0xFF2563EB);
      case 'dispatched': return Color(0xFF8B5CF6);
      case 'completed': return Color(0xFF10B981);
      case 'cancelled': return Color(0xFFEF4444);
      default: return Color(0xFF64748B);
    }
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No $status Bookings',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'All $status bookings will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _partsTabController.dispose();
    _serviceTabController.dispose();
    super.dispose();
  }
}

class Booking {
  final String id;
  final String userName;
  final String userPhone;
  final String partName;
  final String partId;
  final int quantity;
  final double totalPrice;
  final String address;
  final String status;
  final String timestamp;
  final String vehicleType;
  final String paymentMethod;
  final String email;
  final List<Map<String, dynamic>> cartItems;
  final String? docId;

  Booking({
    required this.id,
    required this.userName,
    required this.userPhone,
    required this.partName,
    required this.partId,
    required this.quantity,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.timestamp,
    required this.vehicleType,
    required this.paymentMethod,
    required this.email,
    required this.cartItems,
    this.docId,
  });

  Booking copyWith({
    String? id,
    String? userName,
    String? userPhone,
    String? partName,
    String? partId,
    int? quantity,
    double? totalPrice,
    String? address,
    String? status,
    String? timestamp,
    String? vehicleType,
    String? paymentMethod,
    String? email,
    List<Map<String, dynamic>>? cartItems,
    String? docId,
  }) {
    return Booking(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      partName: partName ?? this.partName,
      partId: partId ?? this.partId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      vehicleType: vehicleType ?? this.vehicleType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      email: email ?? this.email,
      cartItems: cartItems ?? this.cartItems,
      docId: docId ?? this.docId,
    );
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