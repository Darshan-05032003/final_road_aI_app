import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EnhancedHistoryScreen extends StatefulWidget {
  final String userEmail;

  const EnhancedHistoryScreen({super.key, required this.userEmail, required List<Map<String, dynamic>> serviceHistory, required garageName});

  @override
  State<EnhancedHistoryScreen> createState() => _EnhancedHistoryScreenState();
}

class _EnhancedHistoryScreenState extends State<EnhancedHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ServiceHistory> _serviceHistory = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadServiceHistory();
  }

  Future<void> _loadServiceHistory() async {
    try {
      if (widget.userEmail.isEmpty) {
        throw Exception('User email is empty');
      }

      print('🔄 Loading service history for: ${widget.userEmail}');

      // First, check if the user document exists
      final userDoc = await _firestore
          .collection('owner')
          .doc(widget.userEmail)
          .get();

      if (!userDoc.exists) {
        print('❌ User document does not exist');
        if (mounted) {
          setState(() {
            _serviceHistory = [];
            _isLoading = false;
            _hasError = false;
          });
        }
        return;
      }

      List<ServiceHistory> history = [];
      
      // Load Garage Requests
      try {
        final garageRequestsSnapshot = await _firestore
            .collection('owner')
            .doc(widget.userEmail)
            .collection('garagerequest')
            .orderBy('createdAt', descending: true)
            .get();

        print('📥 Found ${garageRequestsSnapshot.docs.length} garage requests');

        for (var doc in garageRequestsSnapshot.docs) {
          try {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            
            // Get status and only include completed/rejected requests
            String status = _getField(data, 'status', 'pending').toLowerCase();
            String normalizedStatus = _normalizeStatus(status);
            
            if (normalizedStatus != 'completed' && normalizedStatus != 'rejected') {
              continue; // Skip non-completed/rejected requests
            }
            
            // Parse dates safely
            DateTime createdAt = _parseTimestamp(data['createdAt']);
            DateTime updatedAt = _parseTimestamp(data['updatedAt']);
            DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;
            DateTime? paidAt = data['paidAt'] != null ? _parseTimestamp(data['paidAt']) : null;
            
            // Extract all possible fields with proper fallbacks
            String requestId = _getField(data, 'requestId', 'GRG-${DateTime.now().millisecondsSinceEpoch}');
            String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
            String serviceType = 'Garage Service';
            String garageName = _getField(data, 'assignedGarage', 
                              _getField(data, 'garageName', 'AutoCare Garage'));
            
            // Get pricing information
            double? serviceAmount = _parseDouble(data['serviceAmount']);
            double? taxAmount = _parseDouble(data['taxAmount']);
            double? totalAmount = _parseDouble(data['totalAmount']);
            String cost = totalAmount != null && totalAmount! > 0 
                ? '₹${totalAmount!.toStringAsFixed(2)}' 
                : (serviceAmount != null && serviceAmount! > 0 
                    ? '₹${serviceAmount!.toStringAsFixed(2)}' 
                    : _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00'))));
            
            String rating = _getField(data, 'rating', 'N/A');
            
            // Get date and time - prefer preferredDate/preferredTime, fallback to createdAt
            String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
            String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));
            
            // Handle problem description from multiple possible fields
            String problemDescription = _getField(data, 'problemDescription', 
                                    _getField(data, 'description', 
                                    _getField(data, 'additionalDetails', 
                                    _getField(data, 'issueDescription', 'No description provided'))));

            ServiceHistory service = ServiceHistory(
              id: doc.id,
              requestId: requestId,
              vehicleNumber: vehicleNumber,
              serviceType: serviceType,
              preferredDate: preferredDate,
              preferredTime: preferredTime,
              name: _getField(data, 'name', 'Customer'),
              phone: _getField(data, 'phone', 'Not Provided'),
              location: _getField(data, 'location', 'Not Provided'),
              problemDescription: problemDescription,
              userEmail: widget.userEmail,
              status: normalizedStatus,
              createdAt: createdAt,
              updatedAt: updatedAt,
              cost: cost,
              garageName: garageName,
              rating: rating,
              vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
              fuelType: _getField(data, 'fuelType', 'Not Specified'),
              vehicleType: _getField(data, 'vehicleType', 'Car'),
              additionalData: {
                'serviceAmount': serviceAmount,
                'taxAmount': taxAmount,
                'totalAmount': totalAmount,
                'paymentStatus': data['paymentStatus'] ?? 'pending',
                'paymentMethod': data['paymentMethod'],
                'transactionId': data['paymentTransactionId'] ?? data['transactionId'],
                'upiTransactionId': data['upiTransactionId'],
                'completedAt': completedAt,
                'paidAt': paidAt,
                'providerUpiId': data['providerUpiId'],
              },
            );
            
            history.add(service);
            print('✅ Added to history: ${service.requestId} - ${service.serviceType} - ${service.status}');
            
          } catch (e) {
            print('⚠️ Skipping garage document ${doc.id} due to error: $e');
          }
        }
      } catch (e) {
        print('❌ Error loading garage requests: $e');
      }

      // Load Tow Requests
      try {
        final towRequestsSnapshot = await _firestore
            .collection('owner')
            .doc(widget.userEmail)
            .collection('towrequest')
            .orderBy('createdAt', descending: true)
            .get();

        print('📥 Found ${towRequestsSnapshot.docs.length} tow requests');

        for (var doc in towRequestsSnapshot.docs) {
          try {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            
            // Get status and only include completed/rejected requests
            String status = _getField(data, 'status', 'pending').toLowerCase();
            String normalizedStatus = _normalizeStatus(status);
            
            if (normalizedStatus != 'completed' && normalizedStatus != 'rejected') {
              continue; // Skip non-completed/rejected requests
            }
            
            // Parse dates safely
            DateTime createdAt = _parseTimestamp(data['createdAt']);
            DateTime updatedAt = _parseTimestamp(data['updatedAt']);
            DateTime? completedAt = data['completedAt'] != null ? _parseTimestamp(data['completedAt']) : null;
            DateTime? paidAt = data['paidAt'] != null ? _parseTimestamp(data['paidAt']) : null;
            
            // Extract all possible fields with proper fallbacks
            String requestId = _getField(data, 'requestId', 'TOW-${DateTime.now().millisecondsSinceEpoch}');
            String vehicleNumber = _getField(data, 'vehicleNumber', 'Not Specified');
            String serviceType = 'Tow Service';
            String providerName = _getField(data, 'providerName', 
                            _getField(data, 'towProviderName', 'Tow Provider'));
            
            // Get pricing information
            double? serviceAmount = _parseDouble(data['serviceAmount']);
            double? taxAmount = _parseDouble(data['taxAmount']);
            double? totalAmount = _parseDouble(data['totalAmount']);
            String cost = totalAmount != null && totalAmount! > 0 
                ? '₹${totalAmount!.toStringAsFixed(2)}' 
                : (serviceAmount != null && serviceAmount! > 0 
                    ? '₹${serviceAmount!.toStringAsFixed(2)}' 
                    : _getField(data, 'cost', _getField(data, 'amount', _getField(data, 'price', '₹0.00'))));
            
            String rating = _getField(data, 'rating', 'N/A');
            
            // Get date and time
            String preferredDate = _getField(data, 'preferredDate', _formatDate(createdAt));
            String preferredTime = _getField(data, 'preferredTime', _formatTime(createdAt));
            
            // Handle description
            String problemDescription = _getField(data, 'description', 
                                    _getField(data, 'issue', 
                                    _getField(data, 'problemDescription', 'No description provided')));

            ServiceHistory service = ServiceHistory(
              id: doc.id,
              requestId: requestId,
              vehicleNumber: vehicleNumber,
              serviceType: serviceType,
              preferredDate: preferredDate,
              preferredTime: preferredTime,
              name: _getField(data, 'name', 'Customer'),
              phone: _getField(data, 'phone', 'Not Provided'),
              location: _getField(data, 'location', 'Not Provided'),
              problemDescription: problemDescription,
              userEmail: widget.userEmail,
              status: normalizedStatus,
              createdAt: createdAt,
              updatedAt: updatedAt,
              cost: cost,
              garageName: providerName, // Reusing garageName field for provider name
              rating: rating,
              vehicleModel: _getField(data, 'vehicleModel', 'Not Specified'),
              fuelType: _getField(data, 'fuelType', 'Not Specified'),
              vehicleType: _getField(data, 'vehicleType', 'Car'),
              additionalData: {
                'serviceAmount': serviceAmount,
                'taxAmount': taxAmount,
                'totalAmount': totalAmount,
                'paymentStatus': data['paymentStatus'] ?? 'pending',
                'paymentMethod': data['paymentMethod'],
                'transactionId': data['paymentTransactionId'] ?? data['transactionId'],
                'upiTransactionId': data['upiTransactionId'],
                'completedAt': completedAt,
                'paidAt': paidAt,
                'providerUpiId': data['providerUpiId'],
              },
            );
            
            history.add(service);
            print('✅ Added to history: ${service.requestId} - ${service.serviceType} - ${service.status}');
            
          } catch (e) {
            print('⚠️ Skipping tow document ${doc.id} due to error: $e');
          }
        }
      } catch (e) {
        print('❌ Error loading tow requests: $e');
      }

      // Sort by creation date (newest first)
      history.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (mounted) {
        setState(() {
          _serviceHistory = history;
          _isLoading = false;
          _hasError = false;
        });
      }

      print('🎉 Service History loaded successfully: ${_serviceHistory.length} completed/rejected requests');

    } catch (e, stackTrace) {
      print('❌ Error loading service history: $e');
      print('📝 Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load service history: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  String _getField(Map<String, dynamic> data, String field, String defaultValue) {
    try {
      if (!data.containsKey(field)) {
        return defaultValue;
      }
      
      final value = data[field];
      if (value == null) {
        return defaultValue;
      }
      
      // Handle different data types
      if (value is String) {
        return value.trim().isEmpty ? defaultValue : value.trim();
      } else if (value is num) {
        return value.toString();
      } else if (value is bool) {
        return value.toString();
      } else if (value is Timestamp) {
        return _formatDate(value.toDate());
      } else {
        final stringValue = value.toString().trim();
        return stringValue.isEmpty ? defaultValue : stringValue;
      }
    } catch (e) {
      print('⚠️ Error getting field "$field": $e');
      return defaultValue;
    }
  }

  String _normalizeStatus(String status) {
    final normalized = status.toLowerCase().trim();
    if (normalized.contains('pending') || normalized == 'pending') {
      return 'pending';
    } else if (normalized.contains('process') || normalized == 'in process' || normalized == 'accepted' || normalized == 'confirmed') {
      return 'in process';
    } else if (normalized.contains('complete') || normalized == 'completed') {
      return 'completed';
    } else if (normalized.contains('reject') || normalized == 'rejected' || normalized == 'cancelled') {
      return 'rejected';
    }
    return normalized;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) {
        return DateTime.now();
      }
      
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } 
      
      if (timestamp is String) {
        // Try to parse various date formats
        try {
          return DateTime.parse(timestamp);
        } catch (e) {
          // If parsing fails, try common formats
          try {
            return DateFormat('yyyy-MM-dd').parse(timestamp);
          } catch (e) {
            return DateTime.now();
          }
        }
      }
      
      return DateTime.now();
    } catch (e) {
      print('⚠️ Error parsing timestamp: $e');
      return DateTime.now();
    }
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatTime(DateTime date) {
    try {
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return 'Invalid Time';
    }
  }

  IconData _getServiceIcon(String serviceType) {
    final type = serviceType.toLowerCase();
    
    if (type.contains('engine')) {
      return Icons.engineering;
    } else if (type.contains('brake')) {
      return Icons.fact_check;
    } else if (type.contains('ac') || type.contains('air conditioning')) {
      return Icons.ac_unit;
    } else if (type.contains('electrical')) {
      return Icons.electrical_services;
    } else if (type.contains('dent') || type.contains('paint')) {
      return Icons.format_paint;
    } else if (type.contains('maintenance') || type.contains('periodic')) {
      return Icons.build_circle;
    } else if (type.contains('oil')) {
      return Icons.opacity;
    } else if (type.contains('tire') || type.contains('tyre')) {
      return Icons.donut_large;
    } else if (type.contains('battery')) {
      return Icons.battery_charging_full;
    } else {
      return Icons.handyman;
    }
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed') {
      return Colors.green;
    } else if (statusLower == 'cancelled') {
      return Colors.red;
    } else if (statusLower.contains('progress')) {
      return Colors.orange;
    } else if (statusLower.contains('confirm')) {
      return Colors.blue;
    } else if (statusLower == 'pending') {
      return Colors.amber;
    } else {
      return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed') {
      return 'Completed';
    } else if (statusLower == 'cancelled') {
      return 'Cancelled';
    } else if (statusLower.contains('progress')) {
      return 'In Progress';
    } else if (statusLower.contains('confirm')) {
      return 'Confirmed';
    } else if (statusLower == 'pending') {
      return 'Pending';
    } else {
      return status;
    }
  }

  void _handleRetry() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    _loadServiceHistory();
  }

  void _showServiceDetails(ServiceHistory service, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsBottomSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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

    if (_serviceHistory.isEmpty) {
      return _buildNoDataState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadServiceHistory();
      },
      backgroundColor: const Color(0xFF6D28D9),
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _serviceHistory.length,
        itemBuilder: (context, index) {
          final service = _serviceHistory[index];
          return _buildHistoryCard(service, context);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading Service History...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fetching data for: ${widget.userEmail}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Load History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            const Text(
              'No Service History Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You don\'t have any completed or cancelled service requests yet.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Completed and cancelled requests will appear here automatically.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D28D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ServiceHistory service, BuildContext context) {
    final statusColor = _getStatusColor(service.status);
    final statusText = _getStatusText(service.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showServiceDetails(service, context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getServiceIcon(service.serviceType),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serviceType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.vehicleNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Details Row
                Row(
                  children: [
                    _buildDetailItem(Icons.calendar_today, service.preferredDate),
                    _buildDetailItem(Icons.access_time, service.preferredTime),
                    _buildDetailItem(Icons.business, service.garageName),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          service.rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      service.cost,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDetailsBottomSheet extends StatelessWidget {
  final ServiceHistory service;

  const ServiceDetailsBottomSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Service Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Service Information', [
                      _buildDetailRow('Request ID', service.requestId),
                      _buildDetailRow('Service Type', service.serviceType),
                      _buildDetailRow('Status', _getStatusText(service.status)),
                      _buildDetailRow('Provider', service.garageName),
                      _buildDetailRow('Rating', service.rating != 'N/A' ? '${service.rating} ⭐' : 'Not Rated'),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Timeline', [
                      _buildDetailRow('Requested On', DateFormat('MMM dd, yyyy • hh:mm a').format(service.createdAt)),
                      if (service.additionalData['completedAt'] != null)
                        _buildDetailRow('Completed On', DateFormat('MMM dd, yyyy • hh:mm a').format(service.additionalData['completedAt'] as DateTime)),
                      if (service.additionalData['paidAt'] != null)
                        _buildDetailRow('Paid On', DateFormat('MMM dd, yyyy • hh:mm a').format(service.additionalData['paidAt'] as DateTime)),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Payment & Pricing', [
                      if (service.additionalData['serviceAmount'] != null && service.additionalData['serviceAmount'] > 0)
                        _buildDetailRow('Service Amount', '₹${(service.additionalData['serviceAmount'] as double).toStringAsFixed(2)}'),
                      if (service.additionalData['taxAmount'] != null && service.additionalData['taxAmount'] > 0)
                        _buildDetailRow('GST (18%)', '₹${(service.additionalData['taxAmount'] as double).toStringAsFixed(2)}'),
                      if (service.additionalData['totalAmount'] != null && service.additionalData['totalAmount'] > 0)
                        _buildDetailRow('Total Amount', '₹${(service.additionalData['totalAmount'] as double).toStringAsFixed(2)}', isHighlight: true)
                      else
                        _buildDetailRow('Total Amount', service.cost, isHighlight: true),
                      if (service.additionalData['paymentStatus'] != null)
                        _buildDetailRow('Payment Status', _capitalizeFirst(service.additionalData['paymentStatus'].toString())),
                      if (service.additionalData['paymentMethod'] != null)
                        _buildDetailRow('Payment Method', service.additionalData['paymentMethod'].toString()),
                      if (service.additionalData['transactionId'] != null)
                        _buildDetailRow('Transaction ID', service.additionalData['transactionId'].toString()),
                      if (service.additionalData['upiTransactionId'] != null)
                        _buildDetailRow('UPI Transaction ID', service.additionalData['upiTransactionId'].toString()),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Schedule & Location', [
                      _buildDetailRow('Preferred Date', service.preferredDate),
                      _buildDetailRow('Preferred Time', service.preferredTime),
                      _buildDetailRow('Location', service.location),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Vehicle Information', [
                      _buildDetailRow('Vehicle Number', service.vehicleNumber),
                      _buildDetailRow('Vehicle Model', service.vehicleModel),
                      _buildDetailRow('Vehicle Type', service.vehicleType),
                      _buildDetailRow('Fuel Type', service.fuelType),
                    ]),
                    
                    const SizedBox(height: 20),
                    _buildDetailSection('Customer Details', [
                      _buildDetailRow('Customer Name', service.name),
                      _buildDetailRow('Phone', service.phone),
                      _buildDetailRow('Email', service.userEmail),
                    ]),
                    
                    if (service.problemDescription.isNotEmpty && 
                        service.problemDescription != 'No description provided') ...[
                      const SizedBox(height: 20),
                      _buildDetailSection('Problem Description', [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            service.problemDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ]),
                    ],
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invoice download started...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Download Invoice',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D28D9),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower == 'completed') {
      return 'Completed';
    } else if (statusLower == 'cancelled' || statusLower == 'rejected') {
      return 'Rejected';
    } else if (statusLower.contains('progress') || statusLower == 'in process') {
      return 'In Process';
    } else if (statusLower.contains('confirm')) {
      return 'Confirmed';
    } else if (statusLower == 'pending') {
      return 'Pending';
    } else {
      return status;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class ServiceHistory {
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
  final String cost;
  final String garageName;
  final String rating;
  final String vehicleModel;
  final String fuelType;
  final String vehicleType;
  Map<String, dynamic> additionalData;

  ServiceHistory({
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
    required this.cost,
    required this.garageName,
    required this.rating,
    required this.vehicleModel,
    required this.fuelType,
    required this.vehicleType,
    Map<String, dynamic>? additionalData,
  }) : additionalData = additionalData ?? {};
}