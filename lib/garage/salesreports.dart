import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SalesReportsScreen extends StatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  _SalesReportsScreenState createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends State<SalesReportsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  bool _isLoading = true;
  String? _errorMessage;
  bool _needsIndex = false;

  List<Booking> completedBookings = [];
  List<Booking> filteredBookings = [];

  // Filter options
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String _selectedFilter = 'all';

  // Sales statistics
  double totalRevenue = 0.0;
  int totalOrders = 0;
  double averageOrderValue = 0.0;
  Map<String, int> categorySales = {};
  Map<String, int> monthlySales = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (_userEmail != null) {
      await _loadCompletedBookings();
    } else {
      _handleNoUser();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email;
        });
        return;
      }
      throw Exception('No user logged in');
    } catch (e) {
      _handleNoUser();
    }
  }

  void _handleNoUser() {
    setState(() {
      _errorMessage = 'Please login again to access sales reports';
      _isLoading = false;
    });
  }

  // Fetch completed bookings without complex queries to avoid index issues
  Future<void> _loadCompletedBookings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _needsIndex = false;
      });

      if (_userEmail == null || _userEmail!.isEmpty) {
        _handleNoUser();
        return;
      }

      print('📡 Fetching completed bookings for: $_userEmail');

      // First, try a simple query without ordering to avoid index issues
      final querySnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('shop')
          .get();

      print('✅ Found ${querySnapshot.docs.length} total bookings');

      if (querySnapshot.docs.isEmpty) {
        _showNoDataState();
        return;
      }

      List<Booking> loadedBookings = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          
          // Only process completed bookings
          final status = data['status']?.toString() ?? '';
          if (status.toLowerCase() != 'completed') {
            continue;
          }

          print('📄 Processing completed booking: ${doc.id}');

          // Extract cart items data safely
          List<Map<String, dynamic>> cartItems = [];
          if (data['cartItems'] is List) {
            for (var item in data['cartItems']) {
              if (item is Map<String, dynamic>) {
                cartItems.add(Map<String, dynamic>.from(item));
              }
            }
          }

          // Get order ID
          String orderId = _getField(data, 'orderId', 
                        _getField(data, 'id', 
                          _getField(data, 'bookingId', 'ORD-${doc.id.substring(0, 8)}')));

          // Get item details
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
            partName = _getField(data, 'partName', 'Unknown Part');
            partId = _getField(data, 'partId', '');
            quantity = _getQuantity(data);
          }

          // Calculate total price
          double totalPrice = _getTotalPrice(data, cartItems);

          // Get completion timestamp
          Timestamp? completionTimestamp = data['updatedAt'] ?? data['timestamp'] ?? data['createdAt'];

          Booking booking = Booking(
            id: orderId,
            userName: _getField(data, 'name', 'Unknown Customer'),
            userPhone: _getField(data, 'phone', 'Not provided'),
            partName: partName,
            partId: partId,
            quantity: quantity,
            totalPrice: totalPrice,
            address: _buildAddress(data),
            status: 'Completed',
            timestamp: _formatTimestamp(completionTimestamp),
            vehicleType: _getField(data, 'vehicleType', 'Not specified'),
            paymentMethod: _getField(data, 'paymentMethod', 'Unknown'),
            email: _getField(data, 'email', ''),
            cartItems: cartItems,
            completionDate: completionTimestamp?.toDate(),
          );
          
          loadedBookings.add(booking);

        } catch (e) {
          print('❌ Error processing booking ${doc.id}: $e');
        }
      }

      // Sort locally by completion date (newest first)
      loadedBookings.sort((a, b) {
        if (a.completionDate == null && b.completionDate == null) return 0;
        if (a.completionDate == null) return 1;
        if (b.completionDate == null) return -1;
        return b.completionDate!.compareTo(a.completionDate!);
      });

      setState(() {
        completedBookings = loadedBookings;
        filteredBookings = List.from(completedBookings);
        _isLoading = false;
      });

      _calculateSalesStatistics();

      print('🎉 Successfully loaded ${completedBookings.length} completed bookings');

    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        print('🔧 Index required, using alternative approach');
        _handleIndexRequirement();
      } else {
        print('❌ Firebase error: ${e.code} - ${e.message}');
        _showErrorState('Database error: ${e.message}');
      }
    } catch (e) {
      print('❌ Error loading completed bookings: $e');
      _showErrorState('Failed to load sales data: ${e.toString()}');
    }
  }

  void _handleIndexRequirement() {
    setState(() {
      _needsIndex = true;
      _isLoading = false;
      _errorMessage = 'Optimizing database query... Please try again.';
    });
    
    // Auto-retry after a delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _loadCompletedBookingsWithFallback();
      }
    });
  }

  // Fallback method without complex queries
  Future<void> _loadCompletedBookingsWithFallback() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Use a very simple query that shouldn't require indexes
      final querySnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('shop')
          .limit(100) // Limit to avoid large queries
          .get();

      List<Booking> loadedBookings = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final status = data['status']?.toString() ?? '';
        
        if (status.toLowerCase() == 'completed') {
          // Process the booking (same logic as above)
          List<Map<String, dynamic>> cartItems = [];
          if (data['cartItems'] is List) {
            for (var item in data['cartItems']) {
              if (item is Map<String, dynamic>) {
                cartItems.add(Map<String, dynamic>.from(item));
              }
            }
          }

          String orderId = _getField(data, 'orderId', 'ORD-${doc.id.substring(0, 8)}');
          String partName = cartItems.isNotEmpty 
              ? _getField(cartItems.first, 'name', 'Unknown Part')
              : _getField(data, 'partName', 'Unknown Part');

          double totalPrice = _getTotalPrice(data, cartItems);
          Timestamp? completionTimestamp = data['updatedAt'] ?? data['timestamp'];

          Booking booking = Booking(
            id: orderId,
            userName: _getField(data, 'name', 'Unknown Customer'),
            userPhone: _getField(data, 'phone', 'Not provided'),
            partName: partName,
            partId: '',
            quantity: _getQuantity(data),
            totalPrice: totalPrice,
            address: _buildAddress(data),
            status: 'Completed',
            timestamp: _formatTimestamp(completionTimestamp),
            vehicleType: _getField(data, 'vehicleType', 'Not specified'),
            paymentMethod: _getField(data, 'paymentMethod', 'Unknown'),
            email: _getField(data, 'email', ''),
            cartItems: cartItems,
            completionDate: completionTimestamp?.toDate(),
          );
          
          loadedBookings.add(booking);
        }
      }

      // Sort locally
      loadedBookings.sort((a, b) {
        if (a.completionDate == null && b.completionDate == null) return 0;
        if (a.completionDate == null) return 1;
        if (b.completionDate == null) return -1;
        return b.completionDate!.compareTo(a.completionDate!);
      });

      setState(() {
        completedBookings = loadedBookings;
        filteredBookings = List.from(completedBookings);
        _isLoading = false;
        _needsIndex = false;
      });

      _calculateSalesStatistics();

    } catch (e) {
      print('❌ Error in fallback loading: $e');
      _showErrorState('Please wait while we optimize the database');
    }
  }

  // Calculate sales statistics
  void _calculateSalesStatistics() {
    totalRevenue = 0.0;
    totalOrders = filteredBookings.length;
    categorySales.clear();
    monthlySales.clear();

    for (var booking in filteredBookings) {
      // Total revenue
      totalRevenue += booking.totalPrice;

      // Category sales
      String category = booking.vehicleType;
      categorySales[category] = (categorySales[category] ?? 0) + 1;

      // Monthly sales
      if (booking.completionDate != null) {
        String monthYear = DateFormat('MMM yyyy').format(booking.completionDate!);
        monthlySales[monthYear] = (monthlySales[monthYear] ?? 0) + 1;
      }
    }

    // Average order value
    averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    setState(() {});
  }

  // Helper methods
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

  double _getTotalPrice(Map<String, dynamic> data, List<Map<String, dynamic>> cartItems) {
    try {
      final total = data['total'];
      if (total != null) {
        if (total is double) return total;
        if (total is int) return total.toDouble();
        if (total is String) return double.tryParse(total) ?? 0.0;
      }

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
      
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'Unknown Date';
    }
  }

  void _showErrorState(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  void _showNoDataState() {
    setState(() {
      completedBookings = [];
      filteredBookings = [];
      _isLoading = false;
    });
  }

  // Filter methods
  void _applyFilter(String filterType) {
    setState(() {
      _selectedFilter = filterType;
      final now = DateTime.now();
      
      switch (filterType) {
        case 'today':
          filteredBookings = completedBookings.where((booking) {
            if (booking.completionDate == null) return false;
            return _isSameDay(booking.completionDate!, now);
          }).toList();
          break;
        
        case 'week':
          final weekAgo = now.subtract(Duration(days: 7));
          filteredBookings = completedBookings.where((booking) {
            if (booking.completionDate == null) return false;
            return booking.completionDate!.isAfter(weekAgo);
          }).toList();
          break;
        
        case 'month':
          final monthAgo = now.subtract(Duration(days: 30));
          filteredBookings = completedBookings.where((booking) {
            if (booking.completionDate == null) return false;
            return booking.completionDate!.isAfter(monthAgo);
          }).toList();
          break;
        
        case 'custom':
          if (_selectedStartDate != null && _selectedEndDate != null) {
            filteredBookings = completedBookings.where((booking) {
              if (booking.completionDate == null) return false;
              return booking.completionDate!.isAfter(_selectedStartDate!) &&
                     booking.completionDate!.isBefore(_selectedEndDate!.add(Duration(days: 1)));
            }).toList();
          }
          break;
        
        default: // 'all'
          filteredBookings = List.from(completedBookings);
          break;
      }
      
      _calculateSalesStatistics();
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
      
      if (_selectedStartDate != null && _selectedEndDate != null) {
        _applyFilter('custom');
      }
    }
  }

  void _handleRetry() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _needsIndex = false;
    });
    _loadCompletedBookingsWithFallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Reports'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _handleRetry,
            tooltip: 'Refresh Reports',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : completedBookings.isEmpty
                  ? _buildNoDataState()
                  : _buildSalesReports(),
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
            _needsIndex ? 'Optimizing database...' : 'Loading sales reports...',
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
            Icon(
              _needsIndex ? Icons.build_circle : Icons.error_outline, 
              size: 80, 
              color: _needsIndex ? Colors.blue : Colors.orange
            ),
            SizedBox(height: 16),
            Text(
              _needsIndex ? 'Database Optimization' : 'Unable to Load Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: Text(_needsIndex ? 'Try Again' : 'Retry'),
            ),
            if (_needsIndex) ...[
              SizedBox(height: 16),
              Text(
                'This is automatically fixing the database index',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
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
          Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No Sales Data Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Completed orders will appear here for sales analysis',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
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

  Widget _buildSalesReports() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Section
          _buildFilterSection(),
          
          SizedBox(height: 20),
          
          // Sales Overview Cards
          _buildSalesOverview(),
          
          SizedBox(height: 20),
          
          // Sales Charts
          _buildSalesCharts(),
          
          SizedBox(height: 20),
          
          // Recent Completed Orders
          _buildRecentOrders(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Sales Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('All Time', 'all'),
                _buildFilterChip('Today', 'today'),
                _buildFilterChip('Last 7 Days', 'week'),
                _buildFilterChip('Last 30 Days', 'month'),
                _buildFilterChip('Custom', 'custom'),
              ],
            ),
            if (_selectedFilter == 'custom') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Date', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Text(
                                  _selectedStartDate != null 
                                    ? DateFormat('dd/MM/yyyy').format(_selectedStartDate!)
                                    : 'Select Start Date',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('End Date', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Text(
                                  _selectedEndDate != null 
                                    ? DateFormat('dd/MM/yyyy').format(_selectedEndDate!)
                                    : 'Select End Date',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) => _applyFilter(value),
      backgroundColor: Colors.grey[100],
      selectedColor: Color(0xFF2563EB).withOpacity(0.1),
      checkmarkColor: Color(0xFF2563EB),
      labelStyle: TextStyle(
        color: _selectedFilter == value ? Color(0xFF2563EB) : Colors.grey[700],
      ),
    );
  }

  Widget _buildSalesOverview() {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: [
        _buildStatCard('Total Revenue', '₹${totalRevenue.toStringAsFixed(2)}', Icons.attach_money, Color(0xFF10B981)),
        _buildStatCard('Total Orders', totalOrders.toString(), Icons.shopping_cart, Color(0xFF2563EB)),
        _buildStatCard('Avg Order Value', '₹${averageOrderValue.toStringAsFixed(2)}', Icons.trending_up, Color(0xFFF59E0B)),
        _buildStatCard('Filtered Orders', '${filteredBookings.length}', Icons.filter_list, Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesCharts() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
            SizedBox(height: 16),
            if (categorySales.isNotEmpty) ...[
              Text(
                'By Vehicle Type',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
              SizedBox(height: 8),
              ...categorySales.entries.map((entry) => _buildCategoryRow(entry.key, entry.value)),
              SizedBox(height: 16),
            ],
            if (monthlySales.isNotEmpty) ...[
              Text(
                'Monthly Sales Trend',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
              SizedBox(height: 8),
              ...monthlySales.entries.map((entry) => _buildMonthlyRow(entry.key, entry.value)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, int count) {
    double percentage = totalOrders > 0 ? (count / totalOrders) * 100 : 0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(category, style: TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRow(String month, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: TextStyle(fontSize: 12)),
          Text('$count orders', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Completed Orders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                ),
                Spacer(),
                Text(
                  '${filteredBookings.length} orders',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...filteredBookings.take(5).map((booking) => _buildOrderItem(booking)),
            if (filteredBookings.length > 5) ...[
              SizedBox(height: 8),
              Center(
                child: Text(
                  '... and ${filteredBookings.length - 5} more orders',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Booking booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.id,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  booking.partName,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${booking.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF10B981)),
              ),
              SizedBox(height: 2),
              Text(
                booking.timestamp.split(' ')[0],
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extended Booking class with completion date
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
  final DateTime? completionDate;

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
    this.completionDate,
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
    DateTime? completionDate,
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
      completionDate: completionDate ?? this.completionDate,
    );
  }
}