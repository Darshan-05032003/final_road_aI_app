// // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:intl/intl.dart';

// // // class InsuranceRequestsListScreen extends StatefulWidget {
// // //   const InsuranceRequestsListScreen({super.key});

// // //   @override
// // //   State<InsuranceRequestsListScreen> createState() => _InsuranceRequestsListScreenState();
// // // }

// // // class _InsuranceRequestsListScreenState extends State<InsuranceRequestsListScreen> {
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // //   String? _userEmail;
// // //   List<Map<String, dynamic>> _insuranceRequests = [];
// // //   bool _isLoading = true;
// // //   bool _isUpdating = false;
// // //   String _errorMessage = '';
// // //   int _selectedTab = 0;

// // //   // Statistics
// // //   int _pendingCount = 0;
// // //   int _approvedCount = 0;
// // //   int _completedCount = 0;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadUserDataAndRequests();
// // //   }

// // //   Future<void> _loadUserDataAndRequests() async {
// // //     try {
// // //       String? userEmail = await AuthService.getUserEmail();
// // //       if (userEmail == null) {
// // //         setState(() {
// // //           _isLoading = false;
// // //           _errorMessage = 'Please login to view insurance requests';
// // //         });
// // //         return;
// // //       }

// // //       setState(() {
// // //         _userEmail = userEmail;
// // //       });

// // //       await _fetchInsuranceRequests();
// // //     } catch (e) {
// // //       setState(() {
// // //         _isLoading = false;
// // //         _errorMessage = 'Error loading user data: $e';
// // //       });
// // //     }
// // //   }

// // //   Future<void> _fetchInsuranceRequests() async {
// // //     try {
// // //       if (_userEmail == null) return;

// // //       final querySnapshot = await _firestore
// // //           .collection('owner')
// // //           .doc(_userEmail!)
// // //           .collection('insurance_requests')
// // //           .orderBy('createdAt', descending: true)
// // //           .get();

// // //       final List<Map<String, dynamic>> requests = [];
// // //       int pending = 0;
// // //       int approved = 0;
// // //       int completed = 0;

// // //       for (var doc in querySnapshot.docs) {
// // //         final data = doc.data();
// // //         final requestData = {
// // //           'id': doc.id,
// // //           ...data,
// // //           // Ensure all required fields have default values
// // //           'requestId': data['requestId'] ?? doc.id,
// // //           'vehicleNumber': data['vehicleNumber']?.toString() ?? 'N/A',
// // //           'vehicleModel': data['vehicleModel']?.toString() ?? 'N/A',
// // //           'insuranceType': data['insuranceType']?.toString() ?? 'N/A',
// // //           'status': data['status']?.toString() ?? 'pending_review',
// // //           'submittedDate': data['submittedDate']?.toString() ?? DateTime.now().toString(),
// // //           'preferredProvider': data['preferredProvider']?.toString() ?? 'Any Provider',
// // //           'ownerName': data['ownerName']?.toString() ?? 'N/A',
// // //           'ownerPhone': data['ownerPhone']?.toString() ?? 'N/A',
// // //           'vehicleType': data['vehicleType']?.toString() ?? 'N/A',
// // //           'vehicleYear': data['vehicleYear']?.toString() ?? 'N/A',
// // //           'vehicleColor': data['vehicleColor']?.toString() ?? 'N/A',
// // //           'fuelType': data['fuelType']?.toString() ?? 'N/A',
// // //           'chassisNumber': data['chassisNumber']?.toString() ?? 'N/A',
// // //           'engineNumber': data['engineNumber']?.toString() ?? 'N/A',
// // //           'purpose': data['purpose']?.toString() ?? 'N/A',
// // //           'quoteAmount': data['quoteAmount']?.toString() ?? '',
// // //           'uploadedDocuments': data['uploadedDocuments'] ?? [],
// // //           'quotes': data['quotes'] ?? [],
// // //           'providerNotes': data['providerNotes'] ?? [],
// // //         };

// // //         // Count statuses
// // //         final status = requestData['status'];
// // //         if (status == 'pending_review' || status == 'under_review') {
// // //           pending++;
// // //         } else if (status == 'quotes_received' || status == 'policy_selected' || status == 'payment_pending') {
// // //           approved++;
// // //         } else if (status == 'active' || status == 'completed') {
// // //           completed++;
// // //         }

// // //         requests.add(requestData);
// // //       }

// // //       setState(() {
// // //         _insuranceRequests = requests;
// // //         _pendingCount = pending;
// // //         _approvedCount = approved;
// // //         _completedCount = completed;
// // //         _isLoading = false;
// // //         _errorMessage = '';
// // //       });
// // //     } catch (e) {
// // //       setState(() {
// // //         _isLoading = false;
// // //         _errorMessage = 'Error fetching insurance requests: $e';
// // //       });
// // //     }
// // //   }

// // //   List<Map<String, dynamic>> _getFilteredRequests() {
// // //     switch (_selectedTab) {
// // //       case 0: // Pending
// // //         return _insuranceRequests.where((request) {
// // //           final status = request['status'];
// // //           return status == 'pending_review' || status == 'under_review';
// // //         }).toList();
// // //       case 1: // Approved
// // //         return _insuranceRequests.where((request) {
// // //           final status = request['status'];
// // //           return status == 'quotes_received' || status == 'policy_selected' || status == 'payment_pending';
// // //         }).toList();
// // //       case 2: // Completed
// // //         return _insuranceRequests.where((request) {
// // //           final status = request['status'];
// // //           return status == 'active' || status == 'completed';
// // //         }).toList();
// // //       default:
// // //         return _insuranceRequests;
// // //     }
// // //   }

// // //   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
// // //     if (_isUpdating) return; // Prevent multiple simultaneous updates

// // //     setState(() {
// // //       _isUpdating = true;
// // //     });

// // //     try {
// // //       if (_userEmail == null) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text('User not authenticated'),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //         return;
// // //       }

// // //       await _firestore
// // //           .collection('owner')
// // //           .doc(_userEmail!)
// // //           .collection('insurance_requests')
// // //           .doc(requestId)
// // //           .update({
// // //         'status': newStatus,
// // //         'updatedAt': FieldValue.serverTimestamp(),
// // //         if (newStatus == 'completed') 'completedAt': DateTime.now().toString(),
// // //         if (newStatus == 'active') 'activatedAt': DateTime.now().toString(),
// // //       });

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text('Request status updated to ${_formatStatus(newStatus)}'),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       }

// // //       await _fetchInsuranceRequests(); // Refresh data
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text('Error updating request: $e'),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() {
// // //           _isUpdating = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   void _showStatusUpdateDialog(Map<String, dynamic> request) {
// // //     final currentStatus = request['status']?.toString() ?? 'pending_review';

// // //     showDialog(
// // //       context: context,
// // //       builder: (context) {
// // //         return AlertDialog(
// // //           title: const Text('Update Request Status'),
// // //           content: SizedBox(
// // //             width: double.maxFinite,
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text('Request: ${request['requestId']?.toString() ?? 'N/A'}'),
// // //                 Text('Vehicle: ${request['vehicleNumber']?.toString() ?? 'N/A'}'),
// // //                 const SizedBox(height: 16),
// // //                 const Text(
// // //                   'Select new status:',
// // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 ..._getStatusOptions(currentStatus, request),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: const Text('Cancel'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }

// // //   List<Widget> _getStatusOptions(String currentStatus, Map<String, dynamic> request) {
// // //     final options = <Widget>[];

// // //     switch (currentStatus) {
// // //       case 'pending_review':
// // //       case 'under_review':
// // //         options.add(_buildStatusOption('Approve Quotes', 'quotes_received', request));
// // //         options.add(_buildStatusOption('Reject Request', 'rejected', request));
// // //         break;
// // //       case 'quotes_received':
// // //         options.add(_buildStatusOption('Select Policy', 'policy_selected', request));
// // //         options.add(_buildStatusOption('Mark as Under Review', 'under_review', request));
// // //         break;
// // //       case 'policy_selected':
// // //         options.add(_buildStatusOption('Mark Payment Pending', 'payment_pending', request));
// // //         options.add(_buildStatusOption('Back to Quotes', 'quotes_received', request));
// // //         break;
// // //       case 'payment_pending':
// // //         options.add(_buildStatusOption('Activate Policy', 'active', request));
// // //         options.add(_buildStatusOption('Mark Payment Failed', 'policy_selected', request));
// // //         break;
// // //       case 'active':
// // //         options.add(_buildStatusOption('Mark Completed', 'completed', request));
// // //         options.add(_buildStatusOption('Suspend Policy', 'under_review', request));
// // //         break;
// // //       case 'completed':
// // //         options.add(_buildStatusOption('Re-open Request', 'under_review', request));
// // //         break;
// // //       case 'rejected':
// // //         options.add(_buildStatusOption('Re-open Request', 'under_review', request));
// // //         break;
// // //       default:
// // //         options.add(_buildStatusOption('Mark as Under Review', 'under_review', request));
// // //     }

// // //     return options;
// // //   }

// // //   Widget _buildStatusOption(String label, String status, Map<String, dynamic> request) {
// // //     return Card(
// // //       margin: const EdgeInsets.symmetric(vertical: 4),
// // //       child: ListTile(
// // //         leading: Icon(
// // //           Icons.arrow_forward_rounded,
// // //           color: _getStatusColor(status),
// // //         ),
// // //         title: Text(
// // //           label,
// // //           style: TextStyle(
// // //             fontWeight: FontWeight.w500,
// // //             color: _getStatusColor(status),
// // //           ),
// // //         ),
// // //         subtitle: Text(
// // //           _formatStatus(status),
// // //           style: const TextStyle(fontSize: 12),
// // //         ),
// // //         onTap: () {
// // //           Navigator.pop(context);
// // //           _updateRequestStatus(request['id'], status);
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   void _refreshData() {
// // //     setState(() {
// // //       _isLoading = true;
// // //     });
// // //     _fetchInsuranceRequests();
// // //   }

// // //   String _formatStatus(String status) {
// // //     switch (status) {
// // //       case 'pending_review':
// // //         return 'Pending Review';
// // //       case 'under_review':
// // //         return 'Under Review';
// // //       case 'quotes_received':
// // //         return 'Quotes Received';
// // //       case 'policy_selected':
// // //         return 'Policy Selected';
// // //       case 'payment_pending':
// // //         return 'Payment Pending';
// // //       case 'active':
// // //         return 'Policy Active';
// // //       case 'completed':
// // //         return 'Completed';
// // //       case 'rejected':
// // //         return 'Rejected';
// // //       case 'cancelled':
// // //         return 'Cancelled';
// // //       default:
// // //         return status;
// // //     }
// // //   }

// // //   Color _getStatusColor(String status) {
// // //     switch (status) {
// // //       case 'active':
// // //       case 'completed':
// // //         return Colors.green;
// // //       case 'pending_review':
// // //       case 'under_review':
// // //         return Colors.orange;
// // //       case 'quotes_received':
// // //       case 'policy_selected':
// // //         return Colors.blue;
// // //       case 'payment_pending':
// // //         return Colors.purple;
// // //       case 'rejected':
// // //       case 'cancelled':
// // //         return Colors.red;
// // //       default:
// // //         return Colors.grey;
// // //     }
// // //   }

// // //   IconData _getStatusIcon(String status) {
// // //     switch (status) {
// // //       case 'active':
// // //       case 'completed':
// // //         return Icons.check_circle_rounded;
// // //       case 'pending_review':
// // //         return Icons.pending_rounded;
// // //       case 'under_review':
// // //         return Icons.search_rounded;
// // //       case 'quotes_received':
// // //         return Icons.request_quote_rounded;
// // //       case 'policy_selected':
// // //         return Icons.thumb_up_rounded;
// // //       case 'payment_pending':
// // //         return Icons.payment_rounded;
// // //       case 'rejected':
// // //         return Icons.cancel_rounded;
// // //       case 'cancelled':
// // //         return Icons.block_rounded;
// // //       default:
// // //         return Icons.help_rounded;
// // //     }
// // //   }

// // //   String _formatDate(String? dateString) {
// // //     if (dateString == null || dateString.isEmpty) return 'N/A';
// // //     try {
// // //       final date = DateTime.parse(dateString);
// // //       return DateFormat('dd MMM yyyy, hh:mm a').format(date);
// // //     } catch (e) {
// // //       return 'Invalid Date';
// // //     }
// // //   }

// // //   Widget _buildStatisticsCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             const Text(
// // //               'Insurance Requests Summary',
// // //               style: TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Color(0xFF6D28D9),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //               children: [
// // //                 _buildStatItem('Pending', _pendingCount.toString(), Colors.orange),
// // //                 _buildStatItem('Approved', _approvedCount.toString(), Colors.blue),
// // //                 _buildStatItem('Completed', _completedCount.toString(), Colors.green),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildStatItem(String label, String value, Color color) {
// // //     return Column(
// // //       children: [
// // //         Container(
// // //           width: 50,
// // //           height: 50,
// // //           decoration: BoxDecoration(
// // //             color: color.withOpacity(0.1),
// // //             shape: BoxShape.circle,
// // //             border: Border.all(color: color.withOpacity(0.3)),
// // //           ),
// // //           child: Center(
// // //             child: Text(
// // //               value,
// // //               style: TextStyle(
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: color,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 4),
// // //         Text(
// // //           label,
// // //           style: TextStyle(
// // //             fontSize: 12,
// // //             color: Colors.grey[600],
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
// // //     final status = request['status']?.toString() ?? 'pending_review';
// // //     final statusColor = _getStatusColor(status);
// // //     final statusIcon = _getStatusIcon(status);

// // //     return Card(
// // //       elevation: 4,
// // //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // Header with Request ID and Status
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Expanded(
// // //                   child: Text(
// // //                     'Request ID: ${request['requestId']?.toString() ?? 'N/A'}',
// // //                     style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Color(0xFF6D28D9),
// // //                     ),
// // //                     overflow: TextOverflow.ellipsis,
// // //                   ),
// // //                 ),
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                   decoration: BoxDecoration(
// // //                     color: statusColor.withOpacity(0.1),
// // //                     borderRadius: BorderRadius.circular(20),
// // //                     border: Border.all(color: statusColor.withOpacity(0.3)),
// // //                   ),
// // //                   child: Row(
// // //                     mainAxisSize: MainAxisSize.min,
// // //                     children: [
// // //                       Icon(statusIcon, size: 16, color: statusColor),
// // //                       const SizedBox(width: 4),
// // //                       Text(
// // //                         _formatStatus(status),
// // //                         style: TextStyle(
// // //                           fontSize: 12,
// // //                           fontWeight: FontWeight.w600,
// // //                           color: statusColor,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 12),

// // //             // Vehicle Information
// // //             _buildInfoRow('Vehicle Number', request['vehicleNumber']?.toString() ?? 'N/A'),
// // //             _buildInfoRow('Vehicle Model', request['vehicleModel']?.toString() ?? 'N/A'),
// // //             _buildInfoRow('Insurance Type', request['insuranceType']?.toString() ?? 'N/A'),
// // //             _buildInfoRow('Preferred Provider', request['preferredProvider']?.toString() ?? 'Any Provider'),

// // //             // Quote Information
// // //             if (request['quoteAmount'] != null && request['quoteAmount'].toString().isNotEmpty)
// // //               _buildInfoRow('Quote Amount', '₹${request['quoteAmount']}'),

// // //             const SizedBox(height: 8),
// // //             const Divider(),
// // //             const SizedBox(height: 8),

// // //             // Owner Information
// // //             _buildInfoRow('Owner Name', request['ownerName']?.toString() ?? 'N/A'),
// // //             _buildInfoRow('Owner Phone', request['ownerPhone']?.toString() ?? 'N/A'),

// // //             const SizedBox(height: 8),
// // //             const Divider(),
// // //             const SizedBox(height: 8),

// // //             // Dates
// // //             _buildInfoRow('Submitted Date', _formatDate(request['submittedDate']?.toString())),
// // //             if (request['estimatedCompletion'] != null)
// // //               _buildInfoRow('Estimated Completion', _formatDate(request['estimatedCompletion']?.toString())),

// // //             // Quotes from providers
// // //             if (request['quotes'] != null && (request['quotes'] as List).isNotEmpty)
// // //               Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   const SizedBox(height: 8),
// // //                   const Divider(),
// // //                   const Text(
// // //                     'Quotes Received:',
// // //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
// // //                   ),
// // //                   const SizedBox(height: 4),
// // //                   ...(request['quotes'] as List).map((quote) {
// // //                     final quoteData = quote as Map<String, dynamic>;
// // //                     return Padding(
// // //                       padding: const EdgeInsets.only(top: 4),
// // //                       child: Text(
// // //                         '• ${quoteData['provider']}: ₹${quoteData['amount']}',
// // //                         style: const TextStyle(fontSize: 12),
// // //                       ),
// // //                     );
// // //                   }),
// // //                 ],
// // //               ),

// // //             const SizedBox(height: 16),

// // //             // Action Buttons
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: OutlinedButton.icon(
// // //                     onPressed: _isUpdating ? null : () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (context) => TrackInsuranceRequest(
// // //                             requestId: request['requestId']?.toString() ?? '',
// // //                             userEmail: _userEmail!,
// // //                           ),
// // //                         ),
// // //                       );
// // //                     },
// // //                     icon: const Icon(Icons.track_changes_rounded, size: 16),
// // //                     label: const Text('Track'),
// // //                     style: OutlinedButton.styleFrom(
// // //                       padding: const EdgeInsets.symmetric(vertical: 8),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 8),
// // //                 Expanded(
// // //                   child: ElevatedButton.icon(
// // //                     onPressed: _isUpdating ? null : () {
// // //                       _showRequestDetails(request);
// // //                     },
// // //                     icon: const Icon(Icons.visibility_rounded, size: 16),
// // //                     label: const Text('Details'),
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: const Color(0xFF6D28D9),
// // //                       padding: const EdgeInsets.symmetric(vertical: 8),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 8),
// // //                 if (_selectedTab != 2) // Don't show update button for completed requests
// // //                   Expanded(
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: _isUpdating ? null : () {
// // //                         _showStatusUpdateDialog(request);
// // //                       },
// // //                       icon: _isUpdating
// // //                           ? const SizedBox(
// // //                               width: 16,
// // //                               height: 16,
// // //                               child: CircularProgressIndicator(
// // //                                 strokeWidth: 2,
// // //                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                               ),
// // //                             )
// // //                           : const Icon(Icons.update_rounded, size: 16),
// // //                       label: _isUpdating ? const Text('Updating...') : const Text('Update'),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: Colors.green,
// // //                         padding: const EdgeInsets.symmetric(vertical: 8),
// // //                       ),
// // //                     ),
// // //                   ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInfoRow(String label, String value) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 4),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Expanded(
// // //             flex: 2,
// // //             child: Text(
// // //               '$label:',
// // //               style: const TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: Colors.grey,
// // //               ),
// // //             ),
// // //           ),
// // //           Expanded(
// // //             flex: 3,
// // //             child: Text(
// // //               value,
// // //               style: const TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w500,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _showRequestDetails(Map<String, dynamic> request) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('Insurance Request Details'),
// // //         content: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               _buildDetailItem('Request ID', request['requestId']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Vehicle Number', request['vehicleNumber']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Vehicle Model', request['vehicleModel']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Vehicle Type', request['vehicleType']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Vehicle Year', request['vehicleYear']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Vehicle Color', request['vehicleColor']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Fuel Type', request['fuelType']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Chassis Number', request['chassisNumber']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Engine Number', request['engineNumber']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Insurance Type', request['insuranceType']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Purpose', request['purpose']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Preferred Provider', request['preferredProvider']?.toString() ?? 'N/A'),
// // //               _buildDetailItem('Status', _formatStatus(request['status']?.toString() ?? 'pending_review')),
// // //               _buildDetailItem('Submitted Date', _formatDate(request['submittedDate']?.toString())),
// // //               if (request['estimatedCompletion'] != null)
// // //                 _buildDetailItem('Estimated Completion', _formatDate(request['estimatedCompletion']?.toString())),
// // //               if (request['quoteAmount'] != null && request['quoteAmount'].toString().isNotEmpty)
// // //                 _buildDetailItem('Quote Amount', '₹${request['quoteAmount']}'),

// // //               // Quotes Section
// // //               if (request['quotes'] != null && (request['quotes'] as List).isNotEmpty)
// // //                 Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     const SizedBox(height: 8),
// // //                     const Text(
// // //                       'Quotes from Providers:',
// // //                       style: TextStyle(fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 4),
// // //                     ...(request['quotes'] as List).map((quote) {
// // //                       final quoteData = quote as Map<String, dynamic>;
// // //                       return Container(
// // //                         margin: const EdgeInsets.only(top: 4),
// // //                         padding: const EdgeInsets.all(8),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.grey[100],
// // //                           borderRadius: BorderRadius.circular(8),
// // //                         ),
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Text('Provider: ${quoteData['provider']}'),
// // //                             Text('Amount: ₹${quoteData['amount']}'),
// // //                             if (quoteData['notes'] != null && quoteData['notes'].toString().isNotEmpty)
// // //                               Text('Notes: ${quoteData['notes']}'),
// // //                             Text('Submitted: ${_formatDate(quoteData['submittedAt']?.toString())}'),
// // //                           ],
// // //                         ),
// // //                       );
// // //                     }),
// // //                   ],
// // //                 ),

// // //               if (request['uploadedDocuments'] != null && (request['uploadedDocuments'] as List).isNotEmpty)
// // //                 Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     const SizedBox(height: 8),
// // //                     const Text(
// // //                       'Uploaded Documents:',
// // //                       style: TextStyle(fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 4),
// // //                     ...(request['uploadedDocuments'] as List).map((doc) => Text('• $doc')),
// // //                   ],
// // //                 ),
// // //             ],
// // //           ),
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text('Close'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDetailItem(String label, String value) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 4),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Expanded(
// // //             flex: 2,
// // //             child: Text(
// // //               '$label:',
// // //               style: const TextStyle(fontWeight: FontWeight.w600),
// // //             ),
// // //           ),
// // //           Expanded(
// // //             flex: 3,
// // //             child: Text(value),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final filteredRequests = _getFilteredRequests();

// // //     return Stack(
// // //       children: [
// // //         DefaultTabController(
// // //           length: 3,
// // //           child: Scaffold(
// // //             appBar: AppBar(
// // //               title: const Text('My Insurance Requests'),
// // //               backgroundColor: const Color(0xFF6D28D9),
// // //               foregroundColor: Colors.white,
// // //               elevation: 0,
// // //               bottom: TabBar(
// // //                 onTap: (index) {
// // //                   setState(() {
// // //                     _selectedTab = index;
// // //                   });
// // //                 },
// // //                 tabs: const [
// // //                   Tab(text: 'Pending', icon: Icon(Icons.pending_rounded)),
// // //                   Tab(text: 'Approved', icon: Icon(Icons.check_circle_rounded)),
// // //                   Tab(text: 'Completed', icon: Icon(Icons.done_all_rounded)),
// // //                 ],
// // //               ),
// // //               actions: [
// // //                 IconButton(
// // //                   icon: const Icon(Icons.refresh_rounded),
// // //                   onPressed: _isLoading ? null : _refreshData,
// // //                   tooltip: 'Refresh',
// // //                 ),
// // //               ],
// // //             ),
// // //             body: _isLoading
// // //                 ? const Center(child: CircularProgressIndicator())
// // //                 : _errorMessage.isNotEmpty
// // //                     ? Center(
// // //                         child: Column(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
// // //                             const SizedBox(height: 16),
// // //                             Text(
// // //                               _errorMessage,
// // //                               textAlign: TextAlign.center,
// // //                               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// // //                             ),
// // //                             const SizedBox(height: 20),
// // //                             ElevatedButton(
// // //                               onPressed: _refreshData,
// // //                               style: ElevatedButton.styleFrom(
// // //                                 backgroundColor: const Color(0xFF6D28D9),
// // //                               ),
// // //                               child: const Text('Try Again'),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       )
// // //                     : Column(
// // //                         children: [
// // //                           _buildStatisticsCard(),
// // //                           const SizedBox(height: 8),
// // //                           Expanded(
// // //                             child: RefreshIndicator(
// // //                               onRefresh: () async {
// // //                                 _refreshData();
// // //                               },
// // //                               child: filteredRequests.isEmpty
// // //                                   ? Center(
// // //                                       child: Column(
// // //                                         mainAxisAlignment: MainAxisAlignment.center,
// // //                                         children: [
// // //                                           Icon(Icons.request_quote_rounded, size: 64, color: Colors.grey[400]),
// // //                                           const SizedBox(height: 16),
// // //                                           Text(
// // //                                             _selectedTab == 0
// // //                                                 ? 'No Pending Requests'
// // //                                                 : _selectedTab == 1
// // //                                                     ? 'No Approved Requests'
// // //                                                     : 'No Completed Requests',
// // //                                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
// // //                                           ),
// // //                                           const SizedBox(height: 8),
// // //                                           const Text(
// // //                                             'New requests will appear here',
// // //                                             textAlign: TextAlign.center,
// // //                                             style: TextStyle(fontSize: 14, color: Colors.grey),
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     )
// // //                                   : ListView.builder(
// // //                                       itemCount: filteredRequests.length,
// // //                                       itemBuilder: (context, index) {
// // //                                         final request = filteredRequests[index];
// // //                                         return _buildInsuranceRequestCard(request);
// // //                                       },
// // //                                     ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //             floatingActionButton: FloatingActionButton(
// // //               onPressed: _isLoading ? null : () {
// // //                 Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => const RequestInsuranceScreen(),
// // //                   ),
// // //                 );
// // //               },
// // //               backgroundColor: const Color(0xFF6D28D9),
// // //               foregroundColor: Colors.white,
// // //               tooltip: 'Submit New Insurance Request',
// // //               child: _isLoading
// // //                   ? const SizedBox(
// // //                       width: 20,
// // //                       height: 20,
// // //                       child: CircularProgressIndicator(
// // //                         strokeWidth: 2,
// // //                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                       ),
// // //                     )
// // //                   : const Icon(Icons.add_rounded),
// // //             ),
// // //           ),
// // //         ),

// // //         // Global Loader Overlay
// // //         if (_isUpdating)
// // //           Container(
// // //             color: Colors.black54,
// // //             child: const Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   CircularProgressIndicator(
// // //                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                   ),
// // //                   SizedBox(height: 16),
// // //                   Text(
// // //                     'Updating Request...',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // Simplified versions of other classes to make the code complete
// // // class RequestInsuranceScreen extends StatefulWidget {
// // //   const RequestInsuranceScreen({super.key});

// // //   @override
// // //   State<RequestInsuranceScreen> createState() => _RequestInsuranceScreenState();
// // // }

// // // class _RequestInsuranceScreenState extends State<RequestInsuranceScreen> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Request Insurance'),
// // //         backgroundColor: const Color(0xFF6D28D9),
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: const Center(
// // //         child: Text('Insurance Request Form'),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class TrackInsuranceRequest extends StatefulWidget {
// // //   final String requestId;
// // //   final String userEmail;

// // //   const TrackInsuranceRequest({
// // //     super.key,
// // //     required this.requestId,
// // //     required this.userEmail,
// // //   });

// // //   @override
// // //   State<TrackInsuranceRequest> createState() => _TrackInsuranceRequestState();
// // // }

// // // class _TrackInsuranceRequestState extends State<TrackInsuranceRequest> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Track Insurance Request'),
// // //         backgroundColor: const Color(0xFF6D28D9),
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: Center(
// // //         child: Text('Tracking request: ${widget.requestId}'),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class InsuranceRequestConfirmation extends StatelessWidget {
// // //   final String requestId;
// // //   final String vehicleNumber;
// // //   final String insuranceType;
// // //   final String provider;
// // //   final String userEmail;

// // //   const InsuranceRequestConfirmation({
// // //     super.key,
// // //     required this.requestId,
// // //     required this.vehicleNumber,
// // //     required this.insuranceType,
// // //     required this.provider,
// // //     required this.userEmail,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Dialog(
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             const Text('Insurance Request Submitted'),
// // //             Text('Request ID: $requestId'),
// // //             Text('Vehicle: $vehicleNumber'),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';

// // class InsuranceRequestsListScreen extends StatefulWidget {
// //   const InsuranceRequestsListScreen({super.key});

// //   @override
// //   State<InsuranceRequestsListScreen> createState() => _InsuranceRequestsListScreenState();
// // }

// // class _InsuranceRequestsListScreenState extends State<InsuranceRequestsListScreen> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   String? _userEmail;
// //   List<Map<String, dynamic>> _insuranceRequests = [];
// //   bool _isLoading = true;
// //   bool _isUpdating = false;
// //   String _errorMessage = '';
// //   final int _selectedTab = 0;

// //   // Statistics
// //   int _pendingCount = 0;
// //   int _approvedCount = 0;
// //   int _completedCount = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserDataAndRequests();
// //   }

// //   Future<void> _loadUserDataAndRequests() async {
// //     try {
// //       String? userEmail = await AuthService.getUserEmail();
// //       if (userEmail == null) {
// //         setState(() {
// //           _isLoading = false;
// //           _errorMessage = 'Please login to view insurance requests';
// //         });
// //         return;
// //       }

// //       setState(() {
// //         _userEmail = userEmail;
// //       });

// //       await _fetchInsuranceRequests();
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //         _errorMessage = 'Error loading user data: $e';
// //       });
// //     }
// //   }

// //   Future<void> _fetchInsuranceRequests() async {
// //     try {
// //       if (_userEmail == null) return;

// //       final querySnapshot = await _firestore
// //           .collection('vehicle_owners')
// //           .doc(_userEmail!)
// //           .collection('insurance_requests')
// //           .orderBy('createdAt', descending: true)
// //           .get();

// //       final List<Map<String, dynamic>> requests = [];
// //       int pending = 0;
// //       int approved = 0;
// //       int completed = 0;

// //       for (var doc in querySnapshot.docs) {
// //         final data = doc.data();
// //         final requestData = {
// //           'id': doc.id,
// //           ...data,
// //           'requestId': data['requestId'] ?? doc.id,
// //           'vehicleNumber': data['vehicleNumber']?.toString() ?? 'N/A',
// //           'vehicleModel': data['vehicleModel']?.toString() ?? 'N/A',
// //           'insuranceType': data['insuranceType']?.toString() ?? 'N/A',
// //           'status': data['status']?.toString() ?? 'pending_review',
// //           'submittedDate': data['submittedDate']?.toString() ?? DateTime.now().toString(),
// //           'preferredProvider': data['preferredProvider']?.toString() ?? 'Any Provider',
// //           'ownerName': data['ownerName']?.toString() ?? 'N/A',
// //           'ownerPhone': data['ownerPhone']?.toString() ?? 'N/A',
// //           'vehicleType': data['vehicleType']?.toString() ?? 'N/A',
// //           'vehicleYear': data['vehicleYear']?.toString() ?? 'N/A',
// //           'vehicleColor': data['vehicleColor']?.toString() ?? 'N/A',
// //           'fuelType': data['fuelType']?.toString() ?? 'N/A',
// //           'chassisNumber': data['chassisNumber']?.toString() ?? 'N/A',
// //           'engineNumber': data['engineNumber']?.toString() ?? 'N/A',
// //           'purpose': data['purpose']?.toString() ?? 'N/A',
// //           'quoteAmount': data['quoteAmount']?.toString() ?? '',
// //           'uploadedDocuments': data['uploadedDocuments'] ?? [],
// //           'quotes': data['quotes'] ?? [],
// //           'providerNotes': data['providerNotes'] ?? [],
// //         };

// //         final status = requestData['status'];
// //         if (status == 'pending_review' || status == 'under_review') {
// //           pending++;
// //         } else if (status == 'quotes_received' || status == 'policy_selected' || status == 'payment_pending') {
// //           approved++;
// //         } else if (status == 'active' || status == 'completed') {
// //           completed++;
// //         }

// //         requests.add(requestData);
// //       }

// //       setState(() {
// //         _insuranceRequests = requests;
// //         _pendingCount = pending;
// //         _approvedCount = approved;
// //         _completedCount = completed;
// //         _isLoading = false;
// //         _errorMessage = '';
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //         _errorMessage = 'Error fetching insurance requests: $e';
// //       });
// //     }
// //   }

// //   List<Map<String, dynamic>> _getFilteredRequests() {
// //     switch (_selectedTab) {
// //       case 0: return _insuranceRequests.where((request) {
// //         final status = request['status'];
// //         return status == 'pending_review' || status == 'under_review';
// //       }).toList();
// //       case 1: return _insuranceRequests.where((request) {
// //         final status = request['status'];
// //         return status == 'quotes_received' || status == 'policy_selected' || status == 'payment_pending';
// //       }).toList();
// //       case 2: return _insuranceRequests.where((request) {
// //         final status = request['status'];
// //         return status == 'active' || status == 'completed';
// //       }).toList();
// //       default: return _insuranceRequests;
// //     }
// //   }

// //   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
// //     if (_isUpdating) return;

// //     setState(() { _isUpdating = true; });

// //     try {
// //       if (_userEmail == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated'), backgroundColor: Colors.red));
// //         return;
// //       }

// //       await _firestore.collection('vehicle_owners').doc(_userEmail!).collection('insurance_requests').doc(requestId).update({
// //         'status': newStatus,
// //         'updatedAt': FieldValue.serverTimestamp(),
// //         if (newStatus == 'completed') 'completedAt': DateTime.now().toString(),
// //         if (newStatus == 'active') 'activatedAt': DateTime.now().toString(),
// //       });

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request status updated to ${_formatStatus(newStatus)}'), backgroundColor: Colors.green));
// //       }

// //       await _fetchInsuranceRequests();
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating request: $e'), backgroundColor: Colors.red));
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() { _isUpdating = false; });
// //       }
// //     }
// //   }

// //   void _showStatusUpdateDialog(Map<String, dynamic> request) {
// //     final currentStatus = request['status']?.toString() ?? 'pending_review';

// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Update Request Status'),
// //         content: SizedBox(
// //           width: double.maxFinite,
// //           child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             Text('Request: ${request['requestId']?.toString() ?? 'N/A'}'),
// //             Text('Vehicle: ${request['vehicleNumber']?.toString() ?? 'N/A'}'),
// //             const SizedBox(height: 16),
// //             const Text('Select new status:', style: TextStyle(fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 8),
// //             ..._getStatusOptions(currentStatus, request),
// //           ]),
// //         ),
// //         actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
// //       ),
// //     );
// //   }

// //   List<Widget> _getStatusOptions(String currentStatus, Map<String, dynamic> request) {
// //     final options = <Widget>[];
// //     switch (currentStatus) {
// //       case 'pending_review':
// //       case 'under_review':
// //         options.add(_buildStatusOption('Approve Quotes', 'quotes_received', request));
// //         options.add(_buildStatusOption('Reject Request', 'rejected', request));
// //         break;
// //       case 'quotes_received':
// //         options.add(_buildStatusOption('Select Policy', 'policy_selected', request));
// //         break;
// //       case 'policy_selected':
// //         options.add(_buildStatusOption('Mark Payment Pending', 'payment_pending', request));
// //         break;
// //       case 'payment_pending':
// //         options.add(_buildStatusOption('Activate Policy', 'active', request));
// //         break;
// //       case 'active':
// //         options.add(_buildStatusOption('Mark Completed', 'completed', request));
// //         break;
// //     }
// //     return options;
// //   }

// //   Widget _buildStatusOption(String label, String status, Map<String, dynamic> request) {
// //     return Card(margin: const EdgeInsets.symmetric(vertical: 4), child: ListTile(
// //       leading: Icon(Icons.arrow_forward_rounded, color: _getStatusColor(status)),
// //       title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: _getStatusColor(status))),
// //       subtitle: Text(_formatStatus(status), style: const TextStyle(fontSize: 12)),
// //       onTap: () { Navigator.pop(context); _updateRequestStatus(request['id'], status); },
// //     ));
// //   }

// //   void _refreshData() {
// //     setState(() { _isLoading = true; });
// //     _fetchInsuranceRequests();
// //   }

// //   String _formatStatus(String status) {
// //     switch (status) {
// //       case 'pending_review': return 'Pending Review';
// //       case 'under_review': return 'Under Review';
// //       case 'quotes_received': return 'Quotes Received';
// //       case 'policy_selected': return 'Policy Selected';
// //       case 'payment_pending': return 'Payment Pending';
// //       case 'active': return 'Policy Active';
// //       case 'completed': return 'Completed';
// //       case 'rejected': return 'Rejected';
// //       default: return status;
// //     }
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'active': case 'completed': return Colors.green;
// //       case 'pending_review': case 'under_review': return Colors.orange;
// //       case 'quotes_received': case 'policy_selected': return Colors.blue;
// //       case 'payment_pending': return Colors.purple;
// //       case 'rejected': return Colors.red;
// //       default: return Colors.grey;
// //     }
// //   }

// //   IconData _getStatusIcon(String status) {
// //     switch (status) {
// //       case 'active': case 'completed': return Icons.check_circle_rounded;
// //       case 'pending_review': return Icons.pending_rounded;
// //       case 'under_review': return Icons.search_rounded;
// //       case 'quotes_received': return Icons.request_quote_rounded;
// //       case 'policy_selected': return Icons.thumb_up_rounded;
// //       case 'payment_pending': return Icons.payment_rounded;
// //       case 'rejected': return Icons.cancel_rounded;
// //       default: return Icons.help_rounded;
// //     }
// //   }

// //   String _formatDate(String? dateString) {
// //     if (dateString == null || dateString.isEmpty) return 'N/A';
// //     try {
// //       final date = DateTime.parse(dateString);
// //       return DateFormat('dd MMM yyyy, hh:mm a').format(date);
// //     } catch (e) {
// //       return 'Invalid Date';
// //     }
// //   }

// //   Widget _buildStatisticsCard() {
// //     return Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
// //       const Text('Insurance Requests Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
// //       const SizedBox(height: 16),
// //       Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
// //         _buildStatItem('Pending', _pendingCount.toString(), Colors.orange),
// //         _buildStatItem('Approved', _approvedCount.toString(), Colors.blue),
// //         _buildStatItem('Completed', _completedCount.toString(), Colors.green),
// //       ]),
// //     ])));
// //   }

// //   Widget _buildStatItem(String label, String value, Color color) {
// //     return Column(children: [
// //       Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.3))), child: Center(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)))),
// //       const SizedBox(height: 4),
// //       Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //     ]);
// //   }

// //   Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
// //     final status = request['status']?.toString() ?? 'pending_review';
// //     final statusColor = _getStatusColor(status);
// //     final statusIcon = _getStatusIcon(status);

// //     return Card(elevation: 4, margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //         Expanded(child: Text('Request ID: ${request['requestId']?.toString() ?? 'N/A'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)), overflow: TextOverflow.ellipsis)),
// //         Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(statusIcon, size: 16, color: statusColor), const SizedBox(width: 4), Text(_formatStatus(status), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor))])),
// //       ]),
// //       const SizedBox(height: 12),
// //       _buildInfoRow('Vehicle Number', request['vehicleNumber']?.toString() ?? 'N/A'),
// //       _buildInfoRow('Vehicle Model', request['vehicleModel']?.toString() ?? 'N/A'),
// //       _buildInfoRow('Insurance Type', request['insuranceType']?.toString() ?? 'N/A'),
// //       _buildInfoRow('Preferred Provider', request['preferredProvider']?.toString() ?? 'Any Provider'),
// //       if (request['quoteAmount'] != null && request['quoteAmount'].toString().isNotEmpty) _buildInfoRow('Quote Amount', '₹${request['quoteAmount']}'),
// //       const SizedBox(height: 8), const Divider(), const SizedBox(height: 8),
// //       _buildInfoRow('Owner Name', request['ownerName']?.toString() ?? 'N/A'),
// //       _buildInfoRow('Owner Phone', request['ownerPhone']?.toString() ?? 'N/A'),
// //       const SizedBox(height: 8), const Divider(), const SizedBox(height: 8),
// //       _buildInfoRow('Submitted Date', _formatDate(request['submittedDate']?.toString())),
// //       if (request['estimatedCompletion'] != null) _buildInfoRow('Estimated Completion', _formatDate(request['estimatedCompletion']?.toString())),
// //       const SizedBox(height: 16),
// //       Row(children: [
// //         Expanded(child: OutlinedButton.icon(onPressed: _isUpdating ? null : () { Navigator.push(context, MaterialPageRoute(builder: (context) => TrackInsuranceRequest(requestId: request['requestId']?.toString() ?? '', userEmail: _userEmail!))); }, icon: const Icon(Icons.track_changes_rounded, size: 16), label: const Text('Track'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)))),
// //         const SizedBox(width: 8),
// //         Expanded(child: ElevatedButton.icon(onPressed: _isUpdating ? null : () { _showRequestDetails(request); }, icon: const Icon(Icons.visibility_rounded, size: 16), label: const Text('Details'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), padding: const EdgeInsets.symmetric(vertical: 8)))),
// //         const SizedBox(width: 8),
// //         if (_selectedTab != 2) Expanded(child: ElevatedButton.icon(onPressed: _isUpdating ? null : () { _showStatusUpdateDialog(request); }, icon: _isUpdating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Icon(Icons.update_rounded, size: 16), label: _isUpdating ? const Text('Updating...') : const Text('Update'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 8)))),
// //       ]),
// //     ])));
// //   }

// //   Widget _buildInfoRow(String label, String value) {
// //     return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
// //       Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
// //     ]));
// //   }

// //   void _showRequestDetails(Map<String, dynamic> request) {
// //     showDialog(context: context, builder: (context) => AlertDialog(
// //       title: const Text('Insurance Request Details'),
// //       content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
// //         _buildDetailItem('Request ID', request['requestId']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Vehicle Number', request['vehicleNumber']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Vehicle Model', request['vehicleModel']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Vehicle Type', request['vehicleType']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Vehicle Year', request['vehicleYear']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Vehicle Color', request['vehicleColor']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Fuel Type', request['fuelType']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Chassis Number', request['chassisNumber']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Engine Number', request['engineNumber']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Insurance Type', request['insuranceType']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Purpose', request['purpose']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Preferred Provider', request['preferredProvider']?.toString() ?? 'N/A'),
// //         _buildDetailItem('Status', _formatStatus(request['status']?.toString() ?? 'pending_review')),
// //         _buildDetailItem('Submitted Date', _formatDate(request['submittedDate']?.toString())),
// //         if (request['estimatedCompletion'] != null) _buildDetailItem('Estimated Completion', _formatDate(request['estimatedCompletion']?.toString())),
// //         if (request['quoteAmount'] != null && request['quoteAmount'].toString().isNotEmpty) _buildDetailItem('Quote Amount', '₹${request['quoteAmount']}'),
// //       ])),
// //       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
// //     ));
// //   }

// //   Widget _buildDetailItem(String label, String value) {
// //     return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
// //       Expanded(flex: 3, child: Text(value)),
// //     ]));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final filteredRequests = _getFilteredRequests();
// //     return Stack(children: [
// //       DefaultTabController(length: 3, child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('My Insurance Requests'),
// //           backgroundColor: const Color(0xFF6D28D9),
// //           foregroundColor: Colors.white,
// //           bottom: const TabBar(tabs: [
// //             Tab(text: 'Pending', icon: Icon(Icons.pending_rounded)),
// //             Tab(text: 'Approved', icon: Icon(Icons.check_circle_rounded)),
// //             Tab(text: 'Completed', icon: Icon(Icons.done_all_rounded)),
// //           ]),
// //           actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _isLoading ? null : _refreshData, tooltip: 'Refresh')],
// //         ),
// //         body: _isLoading ? const Center(child: CircularProgressIndicator()) : _errorMessage.isNotEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
// //           const SizedBox(height: 16),
// //           Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
// //           const SizedBox(height: 20),
// //           ElevatedButton(onPressed: _refreshData, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9)), child: const Text('Try Again')),
// //         ])) : Column(children: [
// //           _buildStatisticsCard(),
// //           const SizedBox(height: 8),
// //           Expanded(child: RefreshIndicator(onRefresh: () async { _refreshData(); }, child: filteredRequests.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             Icon(Icons.request_quote_rounded, size: 64, color: Colors.grey[400]),
// //             const SizedBox(height: 16),
// //             Text(_selectedTab == 0 ? 'No Pending Requests' : _selectedTab == 1 ? 'No Approved Requests' : 'No Completed Requests', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
// //             const SizedBox(height: 8),
// //             const Text('New requests will appear here', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
// //           ])) : ListView.builder(itemCount: filteredRequests.length, itemBuilder: (context, index) => _buildInsuranceRequestCard(filteredRequests[index])))),
// //         ]),
// //         floatingActionButton: FloatingActionButton(onPressed: _isLoading ? null : () { Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestInsuranceScreen())); }, backgroundColor: const Color(0xFF6D28D9), foregroundColor: Colors.white, tooltip: 'Submit New Insurance Request', child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Icon(Icons.add_rounded)),
// //       )),
// //       if (_isUpdating) Container(color: Colors.black54, child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
// //         SizedBox(height: 16),
// //         Text('Updating Request...', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //       ]))),
// //     ]);
// //   }
// // }

// // Include the same RequestInsuranceScreen, TrackInsuranceRequest, and InsuranceRequestConfirmation classes from the previous file

// import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// import 'package:smart_road_app/garage/garageDashboardd.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_filex/open_filex.dart';

// class InsuranceRequestsListScreen extends StatefulWidget {
//   const InsuranceRequestsListScreen({super.key});

//   @override
//   State<InsuranceRequestsListScreen> createState() =>
//       _InsuranceRequestsListScreenState();
// }

// class _InsuranceRequestsListScreenState
//     extends State<InsuranceRequestsListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String? _userEmail;
//   List<Map<String, dynamic>> _insuranceRequests = [];
//   bool _isLoading = true;
//   bool _isUpdating = false;
//   String _errorMessage = '';
//   final int _selectedTab = 0;

//   // Statistics
//   int _pendingCount = 0;
//   int _approvedCount = 0;
//   int _completedCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserDataAndRequests();
//   }

//   Future<void> _loadUserDataAndRequests() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       if (userEmail == null) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Please login to view insurance requests';
//         });
//         return;
//       }

//       setState(() {
//         _userEmail = userEmail;
//       });

//       await _fetchInsuranceRequests();
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error loading user data: $e';
//       });
//     }
//   }

//   Future<void> _fetchInsuranceRequests() async {
//     try {
//       if (_userEmail == null) return;

//       final querySnapshot = await _firestore
//           .collection('vehicle_owners')
//           .doc(_userEmail!)
//           .collection('insurance_requests')
//           .orderBy('createdAt', descending: true)
//           .get();

//       final List<Map<String, dynamic>> requests = [];
//       int pending = 0;
//       int approved = 0;
//       int completed = 0;

//       for (var doc in querySnapshot.docs) {
//         final data = doc.data();
//         final requestData = {
//           'id': doc.id,
//           ...data,
//           'requestId': data['requestId'] ?? doc.id,
//           'vehicleNumber': data['vehicleNumber']?.toString() ?? 'N/A',
//           'vehicleModel': data['vehicleModel']?.toString() ?? 'N/A',
//           'insuranceType': data['insuranceType']?.toString() ?? 'N/A',
//           'status': data['status']?.toString() ?? 'pending_review',
//           'submittedDate':
//               data['submittedDate']?.toString() ?? DateTime.now().toString(),
//           'preferredProvider':
//               data['preferredProvider']?.toString() ?? 'Any Provider',
//           'ownerName': data['ownerName']?.toString() ?? 'N/A',
//           'ownerPhone': data['ownerPhone']?.toString() ?? 'N/A',
//           'vehicleType': data['vehicleType']?.toString() ?? 'N/A',
//           'vehicleYear': data['vehicleYear']?.toString() ?? 'N/A',
//           'vehicleColor': data['vehicleColor']?.toString() ?? 'N/A',
//           'fuelType': data['fuelType']?.toString() ?? 'N/A',
//           'chassisNumber': data['chassisNumber']?.toString() ?? 'N/A',
//           'engineNumber': data['engineNumber']?.toString() ?? 'N/A',
//           'purpose': data['purpose']?.toString() ?? 'N/A',
//           'quoteAmount': data['quoteAmount']?.toString() ?? '',
//           'uploadedDocuments': data['uploadedDocuments'] ?? [],
//           'quotes': data['quotes'] ?? [],
//           'providerNotes': data['providerNotes'] ?? [],
//         };

//         final status = requestData['status'];
//         if (status == 'pending_review' || status == 'under_review') {
//           pending++;
//         } else if (status == 'quotes_received' ||
//             status == 'policy_selected' ||
//             status == 'payment_pending') {
//           approved++;
//         } else if (status == 'active' || status == 'completed') {
//           completed++;
//         }

//         requests.add(requestData);
//       }

//       setState(() {
//         _insuranceRequests = requests;
//         _pendingCount = pending;
//         _approvedCount = approved;
//         _completedCount = completed;
//         _isLoading = false;
//         _errorMessage = '';
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error fetching insurance requests: $e';
//       });
//     }
//   }

//   List<Map<String, dynamic>> _getFilteredRequests() {
//     switch (_selectedTab) {
//       case 0:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'pending_review' || status == 'under_review';
//         }).toList();
//       case 1:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'quotes_received' ||
//               status == 'policy_selected' ||
//               status == 'payment_pending';
//         }).toList();
//       case 2:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'active' || status == 'completed';
//         }).toList();
//       default:
//         return _insuranceRequests;
//     }
//   }

//   // ENHANCED DOCUMENT VIEWING AND DOWNLOAD FUNCTIONALITY
//   void _showAllDocuments(Map<String, dynamic> request) {
//     final List<dynamic> documents = request['uploadedDocuments'] ?? [];

//     if (documents.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No documents available for this request'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Uploaded Documents'),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Request: ${request['requestId'] ?? 'N/A'}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: documents.length,
//                   itemBuilder: (context, index) {
//                     final doc = documents[index];
//                     return _buildDocumentListItem(doc, index);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentListItem(Map<String, dynamic> doc, int index) {
//     final fileName = doc['fileName']?.toString() ?? 'Unknown';
//     final docName = doc['name']?.toString() ?? 'Document';
//     final uploadDate = doc['uploadedAt']?.toString() ?? '';
//     final fileSize = doc['fileSize'] != null
//         ? _formatFileSize(doc['fileSize'])
//         : 'Unknown size';
//     final fileUrl = doc['url']?.toString() ?? '';

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: const Icon(
//           Icons.description_rounded,
//           color: Color(0xFF6D28D9),
//         ),
//         title: Text(
//           docName,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('File: $fileName'),
//             if (uploadDate.isNotEmpty)
//               Text('Uploaded: ${_formatDate(uploadDate)}'),
//             Text('Size: $fileSize'),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.visibility_rounded, color: Colors.blue),
//               onPressed: () => _viewDocument(fileUrl, docName),
//               tooltip: 'View Document',
//             ),
//             IconButton(
//               icon: const Icon(Icons.download_rounded, color: Colors.green),
//               onPressed: () => _downloadDocument(fileUrl, fileName, docName),
//               tooltip: 'Download Document',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _viewDocument(String fileUrl, String docName) async {
//     try {
//       if (fileUrl.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Document URL is not available'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // For images, we can show in a dialog
//       if (fileUrl.toLowerCase().contains('.jpg') ||
//           fileUrl.toLowerCase().contains('.jpeg') ||
//           fileUrl.toLowerCase().contains('.png')) {
//         _showImageDialog(fileUrl, docName);
//       } else {
//         // For other file types, try to open with system viewer
//         await _downloadAndOpenFile(fileUrl, docName, true);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error viewing document: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showImageDialog(String imageUrl, String docName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(docName),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 imageUrl,
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Column(
//                     children: [
//                       Icon(
//                         Icons.error_outline_rounded,
//                         color: Colors.red,
//                         size: 48,
//                       ),
//                       SizedBox(height: 8),
//                       Text('Failed to load image'),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//           ElevatedButton(
//             onPressed: () =>
//                 _downloadDocument(imageUrl, '$docName.jpg', docName),
//             child: const Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }

//   // FIXED DOWNLOAD FUNCTIONALITY
//   Future<void> _downloadDocument(
//     String fileUrl,
//     String fileName,
//     String docName,
//   ) async {
//     try {
//       if (fileUrl.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Document URL is not available'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Check if URL is valid
//       if (!fileUrl.startsWith('http')) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid document URL'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Request storage permissions
//       final permissions = await _requestStoragePermissions();
//       if (!permissions) {
//         return;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Downloading $docName...'),
//           backgroundColor: Colors.blue,
//           duration: const Duration(seconds: 2),
//         ),
//       );

//       await _downloadAndOpenFile(fileUrl, fileName, false);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error downloading document: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // IMPROVED PERMISSION HANDLING
//   Future<bool> _requestStoragePermissions() async {
//     try {
//       // For Android 13+ (API 33+)
//       if (await Permission.manageExternalStorage.isRestricted) {
//         final status = await Permission.manageExternalStorage.request();
//         if (status.isGranted) {
//           return true;
//         }
//       }

//       // For older versions, request storage permission
//       final status = await Permission.storage.request();
//       if (status.isGranted) {
//         return true;
//       }

//       if (status.isPermanentlyDenied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Storage permission is permanently denied. Please enable it in app settings.',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//         // Open app settings
//         await openAppSettings();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Storage permission is required to download files'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       return false;
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }
//   }

//   // FIXED DOWNLOAD AND OPEN FILE FUNCTION
//   Future<void> _downloadAndOpenFile(
//     String fileUrl,
//     String fileName,
//     bool isViewOnly,
//   ) async {
//     String? downloadingFileName;

//     try {
//       // Show downloading progress
//       final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: Text('Downloading $fileName...')),
//             ],
//           ),
//           backgroundColor: Colors.blue,
//           duration: const Duration(minutes: 5), // Long duration for download
//         ),
//       );

//       downloadingFileName = fileName;

//       // Get the downloads directory with multiple fallbacks
//       Directory? targetDir;

//       // Try external storage first
//       try {
//         targetDir = await getExternalStorageDirectory();
//       } catch (e) {
//         print('External storage not available: $e');
//       }

//       // Fallback to application documents directory
//       targetDir ??= await getApplicationDocumentsDirectory();

//       // Create downloads folder
//       final String downloadsPath = '${targetDir.path}/Downloads';
//       final Directory dir = Directory(downloadsPath);
//       if (!await dir.exists()) {
//         await dir.create(recursive: true);
//       }

//       // Clean filename
//       String cleanFileName = _cleanFileName(fileName);
//       final File file = File('$downloadsPath/$cleanFileName');

//       // Download file with proper error handling
//       final http.Client client = http.Client();
//       final http.Response response = await client.get(Uri.parse(fileUrl));

//       if (response.statusCode == 200) {
//         await file.writeAsBytes(response.bodyBytes);

//         // Hide downloading snackbar
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();

//         if (!isViewOnly) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('$cleanFileName downloaded successfully!'),
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 3),
//             ),
//           );
//         }

//         // Open the file
//         final OpenResult result = await OpenFilex.open(file.path);

//         if (result.type != ResultType.done &&
//             result.type != ResultType.noAppToOpen) {
//           if (!isViewOnly) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Downloaded but could not open: ${result.message}',
//                 ),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: Failed to download file');
//       }

//       client.close();
//     } catch (e) {
//       // Hide any existing snackbars
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Download failed: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 4),
//         ),
//       );
//       rethrow;
//     }
//   }

//   String _cleanFileName(String fileName) {
//     // Remove invalid characters for file names
//     return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
//   }

//   String _formatFileSize(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
//   }

//   // ... (rest of your existing methods remain the same - _updateRequestStatus, _showStatusUpdateDialog, etc.)

//   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
//     if (_isUpdating) return;

//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       if (_userEmail == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User not authenticated'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       await _firestore
//           .collection('vehicle_owners')
//           .doc(_userEmail!)
//           .collection('insurance_requests')
//           .doc(requestId)
//           .update({
//             'status': newStatus,
//             'updatedAt': FieldValue.serverTimestamp(),
//             if (newStatus == 'completed')
//               'completedAt': DateTime.now().toString(),
//             if (newStatus == 'active') 'activatedAt': DateTime.now().toString(),
//           });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Request status updated to ${_formatStatus(newStatus)}',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }

//       await _fetchInsuranceRequests();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating request: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUpdating = false;
//         });
//       }
//     }
//   }

//   void _showStatusUpdateDialog(Map<String, dynamic> request) {
//     final currentStatus = request['status']?.toString() ?? 'pending_review';

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Request Status'),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Request: ${request['requestId']?.toString() ?? 'N/A'}'),
//               Text('Vehicle: ${request['vehicleNumber']?.toString() ?? 'N/A'}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'Select new status:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               ..._getStatusOptions(currentStatus, request),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _getStatusOptions(
//     String currentStatus,
//     Map<String, dynamic> request,
//   ) {
//     final options = <Widget>[];
//     switch (currentStatus) {
//       case 'pending_review':
//       case 'under_review':
//         options.add(
//           _buildStatusOption('Approve Quotes', 'quotes_received', request),
//         );
//         options.add(_buildStatusOption('Reject Request', 'rejected', request));
//         break;
//       case 'quotes_received':
//         options.add(
//           _buildStatusOption('Select Policy', 'policy_selected', request),
//         );
//         break;
//       case 'policy_selected':
//         options.add(
//           _buildStatusOption(
//             'Mark Payment Pending',
//             'payment_pending',
//             request,
//           ),
//         );
//         break;
//       case 'payment_pending':
//         options.add(_buildStatusOption('Activate Policy', 'active', request));
//         break;
//       case 'active':
//         options.add(_buildStatusOption('Mark Completed', 'completed', request));
//         break;
//     }
//     return options;
//   }

//   Widget _buildStatusOption(
//     String label,
//     String status,
//     Map<String, dynamic> request,
//   ) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: Icon(
//           Icons.arrow_forward_rounded,
//           color: _getStatusColor(status),
//         ),
//         title: Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: _getStatusColor(status),
//           ),
//         ),
//         subtitle: Text(
//           _formatStatus(status),
//           style: const TextStyle(fontSize: 12),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//           _updateRequestStatus(request['id'], status);
//         },
//       ),
//     );
//   }

//   void _refreshData() {
//     setState(() {
//       _isLoading = true;
//     });
//     _fetchInsuranceRequests();
//   }

//   String _formatStatus(String status) {
//     switch (status) {
//       case 'pending_review':
//         return 'Pending Review';
//       case 'under_review':
//         return 'Under Review';
//       case 'quotes_received':
//         return 'Quotes Received';
//       case 'policy_selected':
//         return 'Policy Selected';
//       case 'payment_pending':
//         return 'Payment Pending';
//       case 'active':
//         return 'Policy Active';
//       case 'completed':
//         return 'Completed';
//       case 'rejected':
//         return 'Rejected';
//       default:
//         return status;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'active':
//       case 'completed':
//         return Colors.green;
//       case 'pending_review':
//       case 'under_review':
//         return Colors.orange;
//       case 'quotes_received':
//       case 'policy_selected':
//         return Colors.blue;
//       case 'payment_pending':
//         return Colors.purple;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'active':
//       case 'completed':
//         return Icons.check_circle_rounded;
//       case 'pending_review':
//         return Icons.pending_rounded;
//       case 'under_review':
//         return Icons.search_rounded;
//       case 'quotes_received':
//         return Icons.request_quote_rounded;
//       case 'policy_selected':
//         return Icons.thumb_up_rounded;
//       case 'payment_pending':
//         return Icons.payment_rounded;
//       case 'rejected':
//         return Icons.cancel_rounded;
//       default:
//         return Icons.help_rounded;
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(date);
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }

//   Widget _buildStatisticsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Insurance Requests Summary',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF6D28D9),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   'Pending',
//                   _pendingCount.toString(),
//                   Colors.orange,
//                 ),
//                 _buildStatItem(
//                   'Approved',
//                   _approvedCount.toString(),
//                   Colors.blue,
//                 ),
//                 _buildStatItem(
//                   'Completed',
//                   _completedCount.toString(),
//                   Colors.green,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
//     final status = request['status']?.toString() ?? 'pending_review';
//     final statusColor = _getStatusColor(status);
//     final statusIcon = _getStatusIcon(status);
//     final hasDocuments = (request['uploadedDocuments'] ?? []).isNotEmpty;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Request ID: ${request['requestId']?.toString() ?? 'N/A'}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF6D28D9),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: statusColor.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(statusIcon, size: 16, color: statusColor),
//                       const SizedBox(width: 4),
//                       Text(
//                         _formatStatus(status),
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: statusColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               'Vehicle Number',
//               request['vehicleNumber']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Vehicle Model',
//               request['vehicleModel']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Insurance Type',
//               request['insuranceType']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Preferred Provider',
//               request['preferredProvider']?.toString() ?? 'Any Provider',
//             ),
//             if (request['quoteAmount'] != null &&
//                 request['quoteAmount'].toString().isNotEmpty)
//               _buildInfoRow('Quote Amount', '₹${request['quoteAmount']}'),
//             const SizedBox(height: 8),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               'Owner Name',
//               request['ownerName']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Owner Phone',
//               request['ownerPhone']?.toString() ?? 'N/A',
//             ),
//             const SizedBox(height: 8),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               'Submitted Date',
//               _formatDate(request['submittedDate']?.toString()),
//             ),
//             if (request['estimatedCompletion'] != null)
//               _buildInfoRow(
//                 'Estimated Completion',
//                 _formatDate(request['estimatedCompletion']?.toString()),
//               ),

//             // Documents section
//             if (hasDocuments) ...[
//               const SizedBox(height: 8),
//               const Divider(),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.folder_rounded,
//                     color: Color(0xFF6D28D9),
//                     size: 16,
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Documents:',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const Spacer(),
//                   Text(
//                     '${(request['uploadedDocuments'] ?? []).length} files',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ],

//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 // Documents Button
//                 if (hasDocuments)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isUpdating
//                           ? null
//                           : () => _showAllDocuments(request),
//                       icon: const Icon(Icons.folder_open_rounded, size: 16),
//                       label: const Text('Documents'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
//                   ),
//                 if (hasDocuments) const SizedBox(width: 8),

//                 // Track Button
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _isUpdating
//                         ? null
//                         : () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => TrackInsuranceRequest(
//                                   requestId:
//                                       request['requestId']?.toString() ?? '',
//                                   userEmail: _userEmail!,
//                                 ),
//                               ),
//                             );
//                           },
//                     icon: const Icon(Icons.track_changes_rounded, size: 16),
//                     label: const Text('Track'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Details Button
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isUpdating
//                         ? null
//                         : () {
//                             _showRequestDetails(request);
//                           },
//                     icon: const Icon(Icons.visibility_rounded, size: 16),
//                     label: const Text('Details'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6D28D9),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Update Button (only for non-completed requests)
//                 if (_selectedTab != 2)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isUpdating
//                           ? null
//                           : () {
//                               _showStatusUpdateDialog(request);
//                             },
//                       icon: _isUpdating
//                           ? const SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.white,
//                                 ),
//                               ),
//                             )
//                           : const Icon(Icons.update_rounded, size: 16),
//                       label: _isUpdating
//                           ? const Text('Updating...')
//                           : const Text('Update'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRequestDetails(Map<String, dynamic> request) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Insurance Request Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildDetailItem(
//                 'Request ID',
//                 request['requestId']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Number',
//                 request['vehicleNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Model',
//                 request['vehicleModel']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Type',
//                 request['vehicleType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Year',
//                 request['vehicleYear']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Color',
//                 request['vehicleColor']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Fuel Type',
//                 request['fuelType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Chassis Number',
//                 request['chassisNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Engine Number',
//                 request['engineNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Insurance Type',
//                 request['insuranceType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Purpose',
//                 request['purpose']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Preferred Provider',
//                 request['preferredProvider']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Status',
//                 _formatStatus(
//                   request['status']?.toString() ?? 'pending_review',
//                 ),
//               ),
//               _buildDetailItem(
//                 'Submitted Date',
//                 _formatDate(request['submittedDate']?.toString()),
//               ),
//               if (request['estimatedCompletion'] != null)
//                 _buildDetailItem(
//                   'Estimated Completion',
//                   _formatDate(request['estimatedCompletion']?.toString()),
//                 ),
//               if (request['quoteAmount'] != null &&
//                   request['quoteAmount'].toString().isNotEmpty)
//                 _buildDetailItem('Quote Amount', '₹${request['quoteAmount']}'),

//               // Documents count
//               _buildDetailItem(
//                 'Uploaded Documents',
//                 '${(request['uploadedDocuments'] ?? []).length} files',
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//           if ((request['uploadedDocuments'] ?? []).isNotEmpty)
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showAllDocuments(request);
//               },
//               child: const Text('View Documents'),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(flex: 3, child: Text(value)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredRequests = _getFilteredRequests();
//     return Stack(
//       children: [
//         DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('My Insurance Requests'),
//               backgroundColor: const Color(0xFF6D28D9),
//               foregroundColor: Colors.white,
//               bottom: const TabBar(
//                 tabs: [
//                   Tab(text: 'Pending', icon: Icon(Icons.pending_rounded)),
//                   Tab(text: 'Approved', icon: Icon(Icons.check_circle_rounded)),
//                   Tab(text: 'Completed', icon: Icon(Icons.done_all_rounded)),
//                 ],
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh_rounded),
//                   onPressed: _isLoading ? null : _refreshData,
//                   tooltip: 'Refresh',
//                 ),
//               ],
//             ),
//             body: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _errorMessage.isNotEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.error_outline_rounded,
//                           size: 64,
//                           color: Colors.red[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           _errorMessage,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _refreshData,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6D28D9),
//                           ),
//                           child: const Text('Try Again'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       _buildStatisticsCard(),
//                       const SizedBox(height: 8),
//                       Expanded(
//                         child: RefreshIndicator(
//                           onRefresh: () async {
//                             _refreshData();
//                           },
//                           child: filteredRequests.isEmpty
//                               ? Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.request_quote_rounded,
//                                         size: 64,
//                                         color: Colors.grey[400],
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Text(
//                                         _selectedTab == 0
//                                             ? 'No Pending Requests'
//                                             : _selectedTab == 1
//                                             ? 'No Approved Requests'
//                                             : 'No Completed Requests',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       const Text(
//                                         'New requests will appear here',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   itemCount: filteredRequests.length,
//                                   itemBuilder: (context, index) =>
//                                       _buildInsuranceRequestCard(
//                                         filteredRequests[index],
//                                       ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: _isLoading
//                   ? null
//                   : () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RequestInsuranceScreen(),
//                         ),
//                       );
//                     },
//               backgroundColor: const Color(0xFF6D28D9),
//               foregroundColor: Colors.white,
//               tooltip: 'Submit New Insurance Request',
//               child: _isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Icon(Icons.add_rounded),
//             ),
//           ),
//         ),
//         if (_isUpdating)
//           Container(
//             color: Colors.black54,
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Updating Request...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }


// import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
// import 'package:smart_road_app/garage/garageDashboardd.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_filex/open_filex.dart';

// class InsuranceRequestsListScreen extends StatefulWidget {
//   const InsuranceRequestsListScreen({super.key});

//   @override
//   State<InsuranceRequestsListScreen> createState() =>
//       _InsuranceRequestsListScreenState();
// }

// class _InsuranceRequestsListScreenState
//     extends State<InsuranceRequestsListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String? _userEmail;
//   List<Map<String, dynamic>> _insuranceRequests = [];
//   bool _isLoading = true;
//   bool _isUpdating = false;
//   String _errorMessage = '';
//   final int _selectedTab = 0;

//   // Statistics
//   int _pendingCount = 0;
//   int _approvedCount = 0;
//   int _completedCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserDataAndRequests();
//   }

//   Future<void> _loadUserDataAndRequests() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       if (userEmail == null) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Please login to view insurance requests';
//         });
//         return;
//       }

//       setState(() {
//         _userEmail = userEmail;
//       });

//       await _fetchInsuranceRequests();
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error loading user data: $e';
//       });
//     }
//   }

//   Future<void> _fetchInsuranceRequests() async {
//     try {
//       if (_userEmail == null) return;

//       final querySnapshot = await _firestore
//           .collection('vehicle_owners')
//           .doc(_userEmail!)
//           .collection('insurance_requests')
//           .orderBy('createdAt', descending: true)
//           .get();

//       final List<Map<String, dynamic>> requests = [];
//       int pending = 0;
//       int approved = 0;
//       int completed = 0;

//       for (var doc in querySnapshot.docs) {
//         final data = doc.data();
//         final requestData = {
//           'id': doc.id,
//           ...data,
//           'requestId': data['requestId'] ?? doc.id,
//           'vehicleNumber': data['vehicleNumber']?.toString() ?? 'N/A',
//           'vehicleModel': data['vehicleModel']?.toString() ?? 'N/A',
//           'insuranceType': data['insuranceType']?.toString() ?? 'N/A',
//           'status': data['status']?.toString() ?? 'pending_review',
//           'submittedDate':
//               data['submittedDate']?.toString() ?? DateTime.now().toString(),
//           'preferredProvider':
//               data['preferredProvider']?.toString() ?? 'Any Provider',
//           'ownerName': data['ownerName']?.toString() ?? 'N/A',
//           'ownerPhone': data['ownerPhone']?.toString() ?? 'N/A',
//           'vehicleType': data['vehicleType']?.toString() ?? 'N/A',
//           'vehicleYear': data['vehicleYear']?.toString() ?? 'N/A',
//           'vehicleColor': data['vehicleColor']?.toString() ?? 'N/A',
//           'fuelType': data['fuelType']?.toString() ?? 'N/A',
//           'chassisNumber': data['chassisNumber']?.toString() ?? 'N/A',
//           'engineNumber': data['engineNumber']?.toString() ?? 'N/A',
//           'purpose': data['purpose']?.toString() ?? 'N/A',
//           'quoteAmount': data['quoteAmount']?.toString() ?? '',
//           'uploadedDocuments': data['uploadedDocuments'] ?? [],
//           'quotes': data['quotes'] ?? [],
//           'providerNotes': data['providerNotes'] ?? [],
//         };

//         final status = requestData['status'];
//         if (status == 'pending_review' || status == 'under_review') {
//           pending++;
//         } else if (status == 'quotes_received' ||
//             status == 'policy_selected' ||
//             status == 'payment_pending') {
//           approved++;
//         } else if (status == 'active' || status == 'completed') {
//           completed++;
//         }

//         requests.add(requestData);
//       }

//       setState(() {
//         _insuranceRequests = requests;
//         _pendingCount = pending;
//         _approvedCount = approved;
//         _completedCount = completed;
//         _isLoading = false;
//         _errorMessage = '';
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error fetching insurance requests: $e';
//       });
//     }
//   }

//   List<Map<String, dynamic>> _getFilteredRequests() {
//     switch (_selectedTab) {
//       case 0:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'pending_review' || status == 'under_review';
//         }).toList();
//       case 1:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'quotes_received' ||
//               status == 'policy_selected' ||
//               status == 'payment_pending';
//         }).toList();
//       case 2:
//         return _insuranceRequests.where((request) {
//           final status = request['status'];
//           return status == 'active' || status == 'completed';
//         }).toList();
//       default:
//         return _insuranceRequests;
//     }
//   }

//   // ENHANCED DOCUMENT VIEWING AND DOWNLOAD FUNCTIONALITY
//   void _showAllDocuments(Map<String, dynamic> request) {
//     final List<dynamic> documents = request['uploadedDocuments'] ?? [];

//     if (documents.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No documents available for this request'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Uploaded Documents'),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Request: ${request['requestId'] ?? 'N/A'}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: documents.length,
//                   itemBuilder: (context, index) {
//                     final doc = documents[index];
//                     return _buildDocumentListItem(doc, index);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentListItem(Map<String, dynamic> doc, int index) {
//     final fileName = doc['fileName']?.toString() ?? 'Unknown';
//     final docName = doc['name']?.toString() ?? 'Document';
//     final uploadDate = doc['uploadedAt']?.toString() ?? '';
//     final fileSize = doc['fileSize'] != null
//         ? _formatFileSize(doc['fileSize'])
//         : 'Unknown size';
//     final fileUrl = doc['url']?.toString() ?? '';

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: const Icon(
//           Icons.description_rounded,
//           color: Color(0xFF6D28D9),
//         ),
//         title: Text(
//           docName,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('File: $fileName'),
//             if (uploadDate.isNotEmpty)
//               Text('Uploaded: ${_formatDate(uploadDate)}'),
//             Text('Size: $fileSize'),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.visibility_rounded, color: Colors.blue),
//               onPressed: () => _viewDocument(fileUrl, docName),
//               tooltip: 'View Document',
//             ),
//             IconButton(
//               icon: const Icon(Icons.download_rounded, color: Colors.green),
//               onPressed: () => _downloadDocument(fileUrl, fileName, docName),
//               tooltip: 'Download Document',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _viewDocument(String fileUrl, String docName) async {
//     try {
//       if (fileUrl.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Document URL is not available'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // For images, we can show in a dialog
//       if (fileUrl.toLowerCase().contains('.jpg') ||
//           fileUrl.toLowerCase().contains('.jpeg') ||
//           fileUrl.toLowerCase().contains('.png')) {
//         _showImageDialog(fileUrl, docName);
//       } else {
//         // For other file types, try to open with system viewer
//         await _downloadAndOpenFile(fileUrl, docName, true);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error viewing document: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showImageDialog(String imageUrl, String docName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(docName),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 imageUrl,
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Column(
//                     children: [
//                       Icon(
//                         Icons.error_outline_rounded,
//                         color: Colors.red,
//                         size: 48,
//                       ),
//                       SizedBox(height: 8),
//                       Text('Failed to load image'),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//           ElevatedButton(
//             onPressed: () =>
//                 _downloadDocument(imageUrl, '$docName.jpg', docName),
//             child: const Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ENHANCED DOWNLOAD FUNCTIONALITY WITH BETTER PERMISSION HANDLING
//   Future<void> _downloadDocument(
//     String fileUrl,
//     String fileName,
//     String docName,
//   ) async {
//     try {
//       if (fileUrl.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Document URL is not available'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Check if URL is valid
//       if (!fileUrl.startsWith('http')) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid document URL'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Request storage permissions
//       final permissions = await _requestStoragePermissions();
//       if (!permissions) {
//         return;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Downloading $docName...'),
//           backgroundColor: Colors.blue,
//           duration: const Duration(seconds: 2),
//         ),
//       );

//       await _downloadAndOpenFile(fileUrl, fileName, false);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error downloading document: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // IMPROVED PERMISSION HANDLING FOR ALL ANDROID VERSIONS
//   Future<bool> _requestStoragePermissions() async {
//     try {
//       // For Android 13+ (API 33+) - Use photos and videos permission
//       if (await Permission.manageExternalStorage.isRestricted) {
//         // Request storage permission for older versions
//         final storageStatus = await Permission.storage.request();
//         if (storageStatus.isGranted) {
//           return true;
//         }
//       }

//       // For Android 10+ (API 29+)
//       final storageStatus = await Permission.storage.status;
//       if (!storageStatus.isGranted) {
//         final result = await Permission.storage.request();
//         if (result.isGranted) {
//           return true;
//         }
//       } else {
//         return true;
//       }

//       // For Android 13+ specific permissions
//       if (await Permission.manageExternalStorage.isGranted) {
//         return true;
//       }

//       // If permissions are permanently denied
//       if (await Permission.storage.isPermanentlyDenied ||
//           await Permission.manageExternalStorage.isPermanentlyDenied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Storage permission is permanently denied. Please enable it in app settings.',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//         await openAppSettings();
//       }

//       return false;
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }
//   }

//   // ENHANCED DOWNLOAD AND OPEN FILE FUNCTION
//   Future<void> _downloadAndOpenFile(
//     String fileUrl,
//     String fileName,
//     bool isViewOnly,
//   ) async {
//     String? downloadingFileName;

//     try {
//       // Show downloading progress
//       final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: Text('Downloading $fileName...')),
//             ],
//           ),
//           backgroundColor: Colors.blue,
//           duration: const Duration(minutes: 5),
//         ),
//       );

//       downloadingFileName = fileName;

//       // Get the appropriate directory for downloads
//       Directory? targetDir;

//       // Try external storage first (Downloads folder)
//       try {
//         if (Platform.isAndroid) {
//           targetDir = Directory('/storage/emulated/0/Download');
//           if (!await targetDir.exists()) {
//             targetDir = await getExternalStorageDirectory();
//           }
//         } else {
//           targetDir = await getDownloadsDirectory();
//         }
//       } catch (e) {
//         print('External storage not available: $e');
//       }

//       // Fallback to application documents directory
//       targetDir ??= await getApplicationDocumentsDirectory();

//       // Create the directory if it doesn't exist
//       if (!await targetDir.exists()) {
//         await targetDir.create(recursive: true);
//       }

//       // Clean filename
//       String cleanFileName = _cleanFileName(fileName);
//       String filePath = '${targetDir.path}/$cleanFileName';

//       // Handle duplicate file names
//       File file = File(filePath);
//       int counter = 1;
//       while (await file.exists()) {
//         String nameWithoutExtension = cleanFileName.substring(0, cleanFileName.lastIndexOf('.'));
//         String extension = cleanFileName.substring(cleanFileName.lastIndexOf('.'));
//         filePath = '${targetDir.path}/${nameWithoutExtension}_$counter$extension';
//         file = File(filePath);
//         counter++;
//       }

//       // Download file with proper error handling
//       final http.Client client = http.Client();
//       final http.Response response = await client.get(Uri.parse(fileUrl));

//       if (response.statusCode == 200) {
//         await file.writeAsBytes(response.bodyBytes);

//         // Hide downloading snackbar
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();

//         if (!isViewOnly) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('$cleanFileName downloaded successfully!'),
//                   Text(
//                     'Location: ${file.path}',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 4),
//             ),
//           );
//         }

//         // Open the file
//         final OpenResult result = await OpenFilex.open(file.path);

//         if (result.type != ResultType.done) {
//           if (!isViewOnly) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Downloaded but could not open: ${result.message}',
//                 ),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: Failed to download file');
//       }

//       client.close();
//     } catch (e) {
//       // Hide any existing snackbars
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Download failed: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 4),
//         ),
//       );
//       print('Download error: $e');
//     }
//   }

//   String _cleanFileName(String fileName) {
//     // Remove invalid characters for file names
//     return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
//   }

//   String _formatFileSize(dynamic size) {
//     try {
//       int bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
//       if (bytes < 1024) return '$bytes B';
//       if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//       return '${(bytes / 1048576).toStringAsFixed(1)} MB';
//     } catch (e) {
//       return 'Unknown size';
//     }
//   }

//   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
//     if (_isUpdating) return;

//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       if (_userEmail == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User not authenticated'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       await _firestore
//           .collection('vehicle_owners')
//           .doc(_userEmail!)
//           .collection('insurance_requests')
//           .doc(requestId)
//           .update({
//             'status': newStatus,
//             'updatedAt': FieldValue.serverTimestamp(),
//             if (newStatus == 'completed')
//               'completedAt': DateTime.now().toString(),
//             if (newStatus == 'active') 'activatedAt': DateTime.now().toString(),
//           });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Request status updated to ${_formatStatus(newStatus)}',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }

//       await _fetchInsuranceRequests();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating request: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUpdating = false;
//         });
//       }
//     }
//   }

//   void _showStatusUpdateDialog(Map<String, dynamic> request) {
//     final currentStatus = request['status']?.toString() ?? 'pending_review';

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Request Status'),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Request: ${request['requestId']?.toString() ?? 'N/A'}'),
//               Text('Vehicle: ${request['vehicleNumber']?.toString() ?? 'N/A'}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'Select new status:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               ..._getStatusOptions(currentStatus, request),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _getStatusOptions(
//     String currentStatus,
//     Map<String, dynamic> request,
//   ) {
//     final options = <Widget>[];
//     switch (currentStatus) {
//       case 'pending_review':
//       case 'under_review':
//         options.add(
//           _buildStatusOption('Approve Quotes', 'quotes_received', request),
//         );
//         options.add(_buildStatusOption('Reject Request', 'rejected', request));
//         break;
//       case 'quotes_received':
//         options.add(
//           _buildStatusOption('Select Policy', 'policy_selected', request),
//         );
//         break;
//       case 'policy_selected':
//         options.add(
//           _buildStatusOption(
//             'Mark Payment Pending',
//             'payment_pending',
//             request,
//           ),
//         );
//         break;
//       case 'payment_pending':
//         options.add(_buildStatusOption('Activate Policy', 'active', request));
//         break;
//       case 'active':
//         options.add(_buildStatusOption('Mark Completed', 'completed', request));
//         break;
//     }
//     return options;
//   }

//   Widget _buildStatusOption(
//     String label,
//     String status,
//     Map<String, dynamic> request,
//   ) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: Icon(
//           Icons.arrow_forward_rounded,
//           color: _getStatusColor(status),
//         ),
//         title: Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: _getStatusColor(status),
//           ),
//         ),
//         subtitle: Text(
//           _formatStatus(status),
//           style: const TextStyle(fontSize: 12),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//           _updateRequestStatus(request['id'], status);
//         },
//       ),
//     );
//   }

//   void _refreshData() {
//     setState(() {
//       _isLoading = true;
//     });
//     _fetchInsuranceRequests();
//   }

//   String _formatStatus(String status) {
//     switch (status) {
//       case 'pending_review':
//         return 'Pending Review';
//       case 'under_review':
//         return 'Under Review';
//       case 'quotes_received':
//         return 'Quotes Received';
//       case 'policy_selected':
//         return 'Policy Selected';
//       case 'payment_pending':
//         return 'Payment Pending';
//       case 'active':
//         return 'Policy Active';
//       case 'completed':
//         return 'Completed';
//       case 'rejected':
//         return 'Rejected';
//       default:
//         return status;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'active':
//       case 'completed':
//         return Colors.green;
//       case 'pending_review':
//       case 'under_review':
//         return Colors.orange;
//       case 'quotes_received':
//       case 'policy_selected':
//         return Colors.blue;
//       case 'payment_pending':
//         return Colors.purple;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'active':
//       case 'completed':
//         return Icons.check_circle_rounded;
//       case 'pending_review':
//         return Icons.pending_rounded;
//       case 'under_review':
//         return Icons.search_rounded;
//       case 'quotes_received':
//         return Icons.request_quote_rounded;
//       case 'policy_selected':
//         return Icons.thumb_up_rounded;
//       case 'payment_pending':
//         return Icons.payment_rounded;
//       case 'rejected':
//         return Icons.cancel_rounded;
//       default:
//         return Icons.help_rounded;
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(date);
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }

//   Widget _buildStatisticsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Insurance Requests Summary',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF6D28D9),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   'Pending',
//                   _pendingCount.toString(),
//                   Colors.orange,
//                 ),
//                 _buildStatItem(
//                   'Approved',
//                   _approvedCount.toString(),
//                   Colors.blue,
//                 ),
//                 _buildStatItem(
//                   'Completed',
//                   _completedCount.toString(),
//                   Colors.green,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
//     final status = request['status']?.toString() ?? 'pending_review';
//     final statusColor = _getStatusColor(status);
//     final statusIcon = _getStatusIcon(status);
//     final hasDocuments = (request['uploadedDocuments'] ?? []).isNotEmpty;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Request ID: ${request['requestId']?.toString() ?? 'N/A'}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF6D28D9),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: statusColor.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(statusIcon, size: 16, color: statusColor),
//                       const SizedBox(width: 4),
//                       Text(
//                         _formatStatus(status),
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: statusColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               'Vehicle Number',
//               request['vehicleNumber']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Vehicle Model',
//               request['vehicleModel']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Insurance Type',
//               request['insuranceType']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Preferred Provider',
//               request['preferredProvider']?.toString() ?? 'Any Provider',
//             ),
//             if (request['quoteAmount'] != null &&
//                 request['quoteAmount'].toString().isNotEmpty)
//               _buildInfoRow('Quote Amount', '₹${request['quoteAmount']}'),
//             const SizedBox(height: 8),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               'Owner Name',
//               request['ownerName']?.toString() ?? 'N/A',
//             ),
//             _buildInfoRow(
//               'Owner Phone',
//               request['ownerPhone']?.toString() ?? 'N/A',
//             ),
//             const SizedBox(height: 8),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               'Submitted Date',
//               _formatDate(request['submittedDate']?.toString()),
//             ),
//             if (request['estimatedCompletion'] != null)
//               _buildInfoRow(
//                 'Estimated Completion',
//                 _formatDate(request['estimatedCompletion']?.toString()),
//               ),

//             // Documents section
//             if (hasDocuments) ...[
//               const SizedBox(height: 8),
//               const Divider(),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.folder_rounded,
//                     color: Color(0xFF6D28D9),
//                     size: 16,
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Documents:',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const Spacer(),
//                   Text(
//                     '${(request['uploadedDocuments'] ?? []).length} files',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ],

//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 // Documents Button
//                 if (hasDocuments)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isUpdating
//                           ? null
//                           : () => _showAllDocuments(request),
//                       icon: const Icon(Icons.folder_open_rounded, size: 16),
//                       label: const Text('Documents'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
//                   ),
//                 if (hasDocuments) const SizedBox(width: 8),

//                 // Track Button
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _isUpdating
//                         ? null
//                         : () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => TrackInsuranceRequest(
//                                   requestId:
//                                       request['requestId']?.toString() ?? '',
//                                   userEmail: _userEmail!,
//                                 ),
//                               ),
//                             );
//                           },
//                     icon: const Icon(Icons.track_changes_rounded, size: 16),
//                     label: const Text('Track'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Details Button
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isUpdating
//                         ? null
//                         : () {
//                             _showRequestDetails(request);
//                           },
//                     icon: const Icon(Icons.visibility_rounded, size: 16),
//                     label: const Text('Details'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6D28D9),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Update Button (only for non-completed requests)
//                 if (_selectedTab != 2)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isUpdating
//                           ? null
//                           : () {
//                               _showStatusUpdateDialog(request);
//                             },
//                       icon: _isUpdating
//                           ? const SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.white,
//                                 ),
//                               ),
//                             )
//                           : const Icon(Icons.update_rounded, size: 16),
//                       label: _isUpdating
//                           ? const Text('Updating...')
//                           : const Text('Update'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRequestDetails(Map<String, dynamic> request) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Insurance Request Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildDetailItem(
//                 'Request ID',
//                 request['requestId']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Number',
//                 request['vehicleNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Model',
//                 request['vehicleModel']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Type',
//                 request['vehicleType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Year',
//                 request['vehicleYear']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Vehicle Color',
//                 request['vehicleColor']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Fuel Type',
//                 request['fuelType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Chassis Number',
//                 request['chassisNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Engine Number',
//                 request['engineNumber']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Insurance Type',
//                 request['insuranceType']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Purpose',
//                 request['purpose']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Preferred Provider',
//                 request['preferredProvider']?.toString() ?? 'N/A',
//               ),
//               _buildDetailItem(
//                 'Status',
//                 _formatStatus(
//                   request['status']?.toString() ?? 'pending_review',
//                 ),
//               ),
//               _buildDetailItem(
//                 'Submitted Date',
//                 _formatDate(request['submittedDate']?.toString()),
//               ),
//               if (request['estimatedCompletion'] != null)
//                 _buildDetailItem(
//                   'Estimated Completion',
//                   _formatDate(request['estimatedCompletion']?.toString()),
//                 ),
//               if (request['quoteAmount'] != null &&
//                   request['quoteAmount'].toString().isNotEmpty)
//                 _buildDetailItem('Quote Amount', '₹${request['quoteAmount']}'),

//               // Documents count
//               _buildDetailItem(
//                 'Uploaded Documents',
//                 '${(request['uploadedDocuments'] ?? []).length} files',
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//           if ((request['uploadedDocuments'] ?? []).isNotEmpty)
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showAllDocuments(request);
//               },
//               child: const Text('View Documents'),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(flex: 3, child: Text(value)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredRequests = _getFilteredRequests();
//     return Stack(
//       children: [
//         DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('My Insurance Requests'),
//               backgroundColor: const Color(0xFF6D28D9),
//               foregroundColor: Colors.white,
//               bottom: const TabBar(
//                 tabs: [
//                   Tab(text: 'Pending', icon: Icon(Icons.pending_rounded)),
//                   Tab(text: 'Approved', icon: Icon(Icons.check_circle_rounded)),
//                   Tab(text: 'Completed', icon: Icon(Icons.done_all_rounded)),
//                 ],
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh_rounded),
//                   onPressed: _isLoading ? null : _refreshData,
//                   tooltip: 'Refresh',
//                 ),
//               ],
//             ),
//             body: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _errorMessage.isNotEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.error_outline_rounded,
//                           size: 64,
//                           color: Colors.red[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           _errorMessage,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _refreshData,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6D28D9),
//                           ),
//                           child: const Text('Try Again'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       _buildStatisticsCard(),
//                       const SizedBox(height: 8),
//                       Expanded(
//                         child: RefreshIndicator(
//                           onRefresh: () async {
//                             _refreshData();
//                           },
//                           child: filteredRequests.isEmpty
//                               ? Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.request_quote_rounded,
//                                         size: 64,
//                                         color: Colors.grey[400],
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Text(
//                                         _selectedTab == 0
//                                             ? 'No Pending Requests'
//                                             : _selectedTab == 1
//                                             ? 'No Approved Requests'
//                                             : 'No Completed Requests',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       const Text(
//                                         'New requests will appear here',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   itemCount: filteredRequests.length,
//                                   itemBuilder: (context, index) =>
//                                       _buildInsuranceRequestCard(
//                                         filteredRequests[index],
//                                       ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: _isLoading
//                   ? null
//                   : () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RequestInsuranceScreen(),
//                         ),
//                       );
//                     },
//               backgroundColor: const Color(0xFF6D28D9),
//               foregroundColor: Colors.white,
//               tooltip: 'Submit New Insurance Request',
//               child: _isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Icon(Icons.add_rounded),
//             ),
//           ),
//         ),
//         if (_isUpdating)
//           Container(
//             color: Colors.black54,
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Updating Request...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }




import 'package:smart_road_app/VehicleOwner/InsuranceRequest.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_road_app/utils/file_download_util.dart';
import 'package:smart_road_app/services/google_auth_service.dart';

class InsuranceRequestsListScreen extends StatefulWidget {
  const InsuranceRequestsListScreen({super.key});

  @override
  State<InsuranceRequestsListScreen> createState() =>
      _InsuranceRequestsListScreenState();
}

class _InsuranceRequestsListScreenState
    extends State<InsuranceRequestsListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _userEmail;
  List<Map<String, dynamic>> _insuranceRequests = [];
  bool _isLoading = true;
  bool _isUpdating = false;
  String _errorMessage = '';
  int _selectedTab = 0;

  // Statistics
  int _pendingCount = 0;
  int _approvedCount = 0;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndRequests();
  }

  Future<void> _loadUserDataAndRequests() async {
    try {
      String? userEmail = await GoogleAuthService.getUserEmail();
      if (userEmail == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to view insurance requests';
        });
        return;
      }

      setState(() {
        _userEmail = userEmail;
      });

      await _fetchInsuranceRequests();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading user data: $e';
      });
    }
  }

  Future<void> _fetchInsuranceRequests() async {
    try {
      if (_userEmail == null) return;

      final querySnapshot = await _firestore
          .collection('vehicle_owners')
          .doc(_userEmail!)
          .collection('insurance_requests')
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> requests = [];
      int pending = 0;
      int approved = 0;
      int completed = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final requestData = {
          'id': doc.id,
          ...data,
          'requestId': data['requestId'] ?? doc.id,
          'vehicleNumber': data['vehicleNumber']?.toString() ?? 'N/A',
          'vehicleModel': data['vehicleModel']?.toString() ?? 'N/A',
          'insuranceType': data['insuranceType']?.toString() ?? 'N/A',
          'status': data['status']?.toString() ?? 'pending_review',
          'submittedDate':
              data['submittedDate']?.toString() ?? DateTime.now().toString(),
          'preferredProvider':
              data['preferredProvider']?.toString() ?? 'Any Provider',
          'ownerName': data['ownerName']?.toString() ?? 'N/A',
          'ownerPhone': data['ownerPhone']?.toString() ?? 'N/A',
          'vehicleType': data['vehicleType']?.toString() ?? 'N/A',
          'vehicleYear': data['vehicleYear']?.toString() ?? 'N/A',
          'vehicleColor': data['vehicleColor']?.toString() ?? 'N/A',
          'fuelType': data['fuelType']?.toString() ?? 'N/A',
          'chassisNumber': data['chassisNumber']?.toString() ?? 'N/A',
          'engineNumber': data['engineNumber']?.toString() ?? 'N/A',
          'purpose': data['purpose']?.toString() ?? 'N/A',
          'quoteAmount': data['quoteAmount']?.toString() ?? '',
          'uploadedDocuments': data['uploadedDocuments'] ?? [],
          'quotes': data['quotes'] ?? [],
          'providerNotes': data['providerNotes'] ?? [],
        };

        final status = requestData['status'];
        if (status == 'pending_review' || status == 'under_review') {
          pending++;
        } else if (status == 'quotes_received' ||
            status == 'policy_selected' ||
            status == 'payment_pending') {
          approved++;
        } else if (status == 'active' || status == 'completed') {
          completed++;
        }

        requests.add(requestData);
      }

      setState(() {
        _insuranceRequests = requests;
        _pendingCount = pending;
        _approvedCount = approved;
        _completedCount = completed;
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching insurance requests: $e';
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredRequests() {
    switch (_selectedTab) {
      case 0:
        return _insuranceRequests.where((request) {
          final status = request['status'];
          return status == 'pending_review' || status == 'under_review';
        }).toList();
      case 1:
        return _insuranceRequests.where((request) {
          final status = request['status'];
          return status == 'quotes_received' ||
              status == 'policy_selected' ||
              status == 'payment_pending';
        }).toList();
      case 2:
        return _insuranceRequests.where((request) {
          final status = request['status'];
          return status == 'active' || status == 'completed';
        }).toList();
      default:
        return _insuranceRequests;
    }
  }

  void _showAllDocuments(Map<String, dynamic> request) {
    final List<dynamic> documents = request['uploadedDocuments'] ?? [];

    if (documents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No documents available for this request'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uploaded Documents'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Request: ${request['requestId'] ?? 'N/A'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return _buildDocumentListItem(doc, index);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentListItem(Map<String, dynamic> doc, int index) {
    final fileName = doc['fileName']?.toString() ?? 'Unknown';
    final docName = doc['name']?.toString() ?? 'Document';
    final uploadDate = doc['uploadedAt']?.toString() ?? '';
    final fileSize = doc['fileSize'] != null
        ? _formatFileSize(doc['fileSize'])
        : 'Unknown size';
    final fileUrl = doc['url']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(
          Icons.description_rounded,
          color: Color(0xFF6D28D9),
        ),
        title: Text(
          docName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File: $fileName'),
            if (uploadDate.isNotEmpty)
              Text('Uploaded: ${_formatDate(uploadDate)}'),
            Text('Size: $fileSize'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_rounded, color: Colors.blue),
              onPressed: () => _viewDocument(fileUrl, docName),
              tooltip: 'View Document',
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded, color: Colors.green),
              onPressed: () => FileDownloadUtil.downloadFile(
                fileUrl: fileUrl,
                fileName: fileName,
                docName: docName,
                context: context,
                openAfterDownload: true,
              ),
              tooltip: 'Download Document',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewDocument(String fileUrl, String docName) async {
    try {
      if (fileUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document URL is not available'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // For images, we can show in a dialog
      if (fileUrl.toLowerCase().contains('.jpg') ||
          fileUrl.toLowerCase().contains('.jpeg') ||
          fileUrl.toLowerCase().contains('.png')) {
        _showImageDialog(fileUrl, docName);
      } else {
        // For other file types, download and open the file
        String fileExtension = FileDownloadUtil.getFileExtension(fileUrl);
        await FileDownloadUtil.downloadFile(
          fileUrl: fileUrl,
          fileName: '$docName$fileExtension',
          docName: docName,
          context: context,
          openAfterDownload: true,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error viewing document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageDialog(String imageUrl, String docName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docName),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text('Failed to load image'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => FileDownloadUtil.downloadFile(
              fileUrl: imageUrl,
              fileName: '$docName.jpg',
              docName: docName,
              context: context,
              openAfterDownload: true,
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(dynamic size) {
    try {
      int bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Unknown size';
    }
  }

  Future<void> _updateRequestStatus(String requestId, String newStatus) async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      if (_userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _firestore
          .collection('vehicle_owners')
          .doc(_userEmail!)
          .collection('insurance_requests')
          .doc(requestId)
          .update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
        if (newStatus == 'completed')
          'completedAt': DateTime.now().toString(),
        if (newStatus == 'active') 'activatedAt': DateTime.now().toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Request status updated to ${_formatStatus(newStatus)}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _fetchInsuranceRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  void _showStatusUpdateDialog(Map<String, dynamic> request) {
    final currentStatus = request['status']?.toString() ?? 'pending_review';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Request Status'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request: ${request['requestId']?.toString() ?? 'N/A'}'),
              Text('Vehicle: ${request['vehicleNumber']?.toString() ?? 'N/A'}'),
              const SizedBox(height: 16),
              const Text(
                'Select new status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._getStatusOptions(currentStatus, request),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  List<Widget> _getStatusOptions(
    String currentStatus,
    Map<String, dynamic> request,
  ) {
    final options = <Widget>[];
    switch (currentStatus) {
      case 'pending_review':
      case 'under_review':
        options.add(
          _buildStatusOption('Approve Quotes', 'quotes_received', request),
        );
        options.add(_buildStatusOption('Reject Request', 'rejected', request));
        break;
      case 'quotes_received':
        options.add(
          _buildStatusOption('Select Policy', 'policy_selected', request),
        );
        break;
      case 'policy_selected':
        options.add(
          _buildStatusOption(
            'Mark Payment Pending',
            'payment_pending',
            request,
          ),
        );
        break;
      case 'payment_pending':
        options.add(_buildStatusOption('Activate Policy', 'active', request));
        break;
      case 'active':
        options.add(_buildStatusOption('Mark Completed', 'completed', request));
        break;
    }
    return options;
  }

  Widget _buildStatusOption(
    String label,
    String status,
    Map<String, dynamic> request,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.arrow_forward_rounded,
          color: _getStatusColor(status),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: _getStatusColor(status),
          ),
        ),
        subtitle: Text(
          _formatStatus(status),
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () {
          Navigator.pop(context);
          _updateRequestStatus(request['id'], status);
        },
      ),
    );
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
    });
    _fetchInsuranceRequests();
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'pending_review':
        return 'Pending Review';
      case 'under_review':
        return 'Under Review';
      case 'quotes_received':
        return 'Quotes Received';
      case 'policy_selected':
        return 'Policy Selected';
      case 'payment_pending':
        return 'Payment Pending';
      case 'active':
        return 'Policy Active';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
      case 'completed':
        return Colors.green;
      case 'pending_review':
      case 'under_review':
        return Colors.orange;
      case 'quotes_received':
      case 'policy_selected':
        return Colors.blue;
      case 'payment_pending':
        return Colors.purple;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
      case 'completed':
        return Icons.check_circle_rounded;
      case 'pending_review':
        return Icons.pending_rounded;
      case 'under_review':
        return Icons.search_rounded;
      case 'quotes_received':
        return Icons.request_quote_rounded;
      case 'policy_selected':
        return Icons.thumb_up_rounded;
      case 'payment_pending':
        return Icons.payment_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Insurance Requests Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Pending',
                  _pendingCount.toString(),
                  Colors.orange,
                ),
                _buildStatItem(
                  'Approved',
                  _approvedCount.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  'Completed',
                  _completedCount.toString(),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInsuranceRequestCard(Map<String, dynamic> request) {
    final status = request['status']?.toString() ?? 'pending_review';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final hasDocuments = (request['uploadedDocuments'] ?? []).isNotEmpty;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Request ID: ${request['requestId']?.toString() ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        _formatStatus(status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Vehicle Number',
              request['vehicleNumber']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Vehicle Model',
              request['vehicleModel']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Insurance Type',
              request['insuranceType']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Preferred Provider',
              request['preferredProvider']?.toString() ?? 'Any Provider',
            ),
            if (request['quoteAmount'] != null &&
                request['quoteAmount'].toString().isNotEmpty)
              _buildInfoRow('Quote Amount', '₹${request['quoteAmount']}'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Owner Name',
              request['ownerName']?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              'Owner Phone',
              request['ownerPhone']?.toString() ?? 'N/A',
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Submitted Date',
              _formatDate(request['submittedDate']?.toString()),
            ),
            if (request['estimatedCompletion'] != null)
              _buildInfoRow(
                'Estimated Completion',
                _formatDate(request['estimatedCompletion']?.toString()),
              ),

            // Documents section
            if (hasDocuments) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    color: Color(0xFF6D28D9),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Documents:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '${(request['uploadedDocuments'] ?? []).length} files',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                // Documents Button
                if (hasDocuments)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isUpdating
                          ? null
                          : () => _showAllDocuments(request),
                      icon: const Icon(Icons.folder_open_rounded, size: 16),
                      label: const Text('Documents'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                if (hasDocuments) const SizedBox(width: 8),

                // Details Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUpdating
                        ? null
                        : () {
                      _showRequestDetails(request);
                    },
                    icon: const Icon(Icons.visibility_rounded, size: 16),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Update Button (only for non-completed requests)
                if (_selectedTab != 2)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isUpdating
                          ? null
                          : () {
                        _showStatusUpdateDialog(request);
                      },
                      icon: _isUpdating
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : const Icon(Icons.update_rounded, size: 16),
                      label: _isUpdating
                          ? const Text('Updating...')
                          : const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insurance Request Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem(
                'Request ID',
                request['requestId']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Vehicle Number',
                request['vehicleNumber']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Vehicle Model',
                request['vehicleModel']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Vehicle Type',
                request['vehicleType']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Vehicle Year',
                request['vehicleYear']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Vehicle Color',
                request['vehicleColor']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Fuel Type',
                request['fuelType']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Chassis Number',
                request['chassisNumber']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Engine Number',
                request['engineNumber']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Insurance Type',
                request['insuranceType']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Purpose',
                request['purpose']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Preferred Provider',
                request['preferredProvider']?.toString() ?? 'N/A',
              ),
              _buildDetailItem(
                'Status',
                _formatStatus(
                  request['status']?.toString() ?? 'pending_review',
                ),
              ),
              _buildDetailItem(
                'Submitted Date',
                _formatDate(request['submittedDate']?.toString()),
              ),
              if (request['estimatedCompletion'] != null)
                _buildDetailItem(
                  'Estimated Completion',
                  _formatDate(request['estimatedCompletion']?.toString()),
                ),
              if (request['quoteAmount'] != null &&
                  request['quoteAmount'].toString().isNotEmpty)
                _buildDetailItem('Quote Amount', '₹${request['quoteAmount']}'),

              // Documents count
              _buildDetailItem(
                'Uploaded Documents',
                '${(request['uploadedDocuments'] ?? []).length} files',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if ((request['uploadedDocuments'] ?? []).isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAllDocuments(request);
              },
              child: const Text('View Documents'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRequests = _getFilteredRequests();
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('My Insurance Requests'),
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
              bottom: TabBar(
                tabs: const [
                  Tab(text: 'Pending', icon: Icon(Icons.pending_rounded)),
                  Tab(text: 'Approved', icon: Icon(Icons.check_circle_rounded)),
                  Tab(text: 'Completed', icon: Icon(Icons.done_all_rounded)),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _isLoading ? null : _refreshData,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _refreshData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6D28D9),
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      _buildStatisticsCard(),
                      const SizedBox(height: 8),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _refreshData();
                          },
                          child: filteredRequests.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.request_quote_rounded,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _selectedTab == 0
                                            ? 'No Pending Requests'
                                            : _selectedTab == 1
                                            ? 'No Approved Requests'
                                            : 'No Completed Requests',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'New requests will appear here',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredRequests.length,
                                  itemBuilder: (context, index) =>
                                      _buildInsuranceRequestCard(
                                        filteredRequests[index],
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RequestInsuranceScreen(),
                        ),
                      );
                    },
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
              tooltip: 'Submit New Insurance Request',
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.add_rounded),
            ),
          ),
        ),
        if (_isUpdating)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Updating Request...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}