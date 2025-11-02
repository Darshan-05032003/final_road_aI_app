import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (_userEmail != null) {
      await _loadBookings();
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

  void _handleNoUser() {
    setState(() {
      _hasError = true;
      _errorMessage = 'Please login again to access bookings';
      _isLoading = false;
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
        bookings = loadedBookings;
        _isLoading = false;
        _hasError = false;
      });

      print('🎉 Successfully loaded ${bookings.length} bookings');

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
        int index = bookings.indexWhere((booking) => booking.id == bookingId);
        if (index != -1) {
          bookings[index] = bookings[index].copyWith(status: newStatus);
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
      bookings = [];
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

  void _handleRetry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _initializeData();
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
    return bookings.where((booking) => booking.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        bottom: !_hasError && bookings.isNotEmpty
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Pending (${getBookingsByStatus("Pending").length})'),
                  Tab(text: 'Confirmed (${getBookingsByStatus("Confirmed").length})'),
                  Tab(text: 'Dispatched (${getBookingsByStatus("Dispatched").length})'),
                  Tab(text: 'Completed (${getBookingsByStatus("Completed").length})'),
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

    if (bookings.isEmpty) {
      return _buildNoDataState();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookingsList('Pending'),
        _buildBookingsList('Confirmed'),
        _buildBookingsList('Dispatched'),
        _buildBookingsList('Completed'),
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

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No Bookings Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Your customer bookings will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: Text('Refresh'),
          ),
          if (_userEmail != null) ...[
            SizedBox(height: 16),
            Text(
              'Logged in as: $_userEmail',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ],
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
    _tabController.dispose();
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
    );
  }
}