// // import 'dart:math';

// // import 'package:smart_road_app/VehicleOwner/TowRequest.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';

// // class NearbyTowScreen extends StatefulWidget {
// //   final Position userLocation;
// //   final String? userEmail;

// //   const NearbyTowScreen({
// //     super.key,
// //     required this.userLocation,
// //     required this.userEmail,
// //   });

// //   @override
// //   _NearbyTowScreenState createState() => _NearbyTowScreenState();
// // }

// // class _NearbyTowScreenState extends State<NearbyTowScreen> {
// //   List<TowProvider> _nearbyTowProviders = [];
// //   bool _isLoading = true;
// //   bool _hasError = false;
// //   String _errorMessage = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadNearbyTowProviders();
// //   }

// //   // Calculate distance between two coordinates in kilometers using Haversine formula
// //   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
// //     const double earthRadius = 6371; // Earth's radius in kilometers

// //     double dLat = _toRadians(lat2 - lat1);
// //     double dLon = _toRadians(lon2 - lon1);

// //     double a = sin(dLat / 2) * sin(dLat / 2) +
// //         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
// //         sin(dLon / 2) * sin(dLon / 2);

// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
// //     double distance = earthRadius * c;

// //     return distance;
// //   }

// //   double _toRadians(double degree) {
// //     return degree * pi / 180;
// //   }

// //   Future<void> _loadNearbyTowProviders() async {
// //     try {
// //       print('📍 User location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}');
// //       print('🔍 Loading registered tow providers from Firestore...');

// //       // Fetch all active tow providers from Firestore
// //       final towProvidersSnapshot = await FirebaseFirestore.instance
// //           .collection('tow_providers')
// //           .where('status', isEqualTo: 'active')
// //           .where('isAvailable', isEqualTo: true)
// //           .get();

// //       print('📊 Total tow providers found in system: ${towProvidersSnapshot.docs.length}');

// //       List<TowProvider> allTowProviders = [];

// //       for (var doc in towProvidersSnapshot.docs) {
// //         try {
// //           final data = doc.data();
// //           print('\n🔍 Processing tow provider: ${data['driverName']}');

// //           // Check if tow provider has location data
// //           if (data['latitude'] == null || data['longitude'] == null) {
// //             print('⚠️ Tow provider ${data['driverName']} has no location data - skipping');
// //             continue;
// //           }

// //           double providerLat = data['latitude'] is int
// //               ? (data['latitude'] as int).toDouble()
// //               : data['latitude'].toDouble();

// //           double providerLon = data['longitude'] is int
// //               ? (data['longitude'] as int).toDouble()
// //               : data['longitude'].toDouble();

// //           // Calculate distance from user
// //           double distance = _calculateDistance(
// //             widget.userLocation.latitude,
// //             widget.userLocation.longitude,
// //             providerLat,
// //             providerLon,
// //           );

// //           print('📏 Distance to ${data['driverName']}: ${distance.toStringAsFixed(1)} km');

// //           // Only include tow providers within 20 km radius (larger radius for tow services)
// //           if (distance <= 20) {
// //             TowProvider provider = TowProvider(
// //               id: doc.id,
// //               driverName: data['driverName'] ?? 'Unknown Driver',
// //               email: data['email'] ?? 'Not provided',
// //               truckNumber: data['truckNumber'] ?? 'Not provided',
// //               truckType: data['truckType'] ?? 'Standard Tow',
// //               serviceLocation: data['serviceLocation'] ?? 'Location not provided',
// //               distance: distance,
// //               rating: (data['rating'] ?? 4.0).toDouble(),
// //               totalJobs: (data['totalJobs'] ?? 0).toInt(),
// //               isAvailable: data['isAvailable'] ?? true,
// //               latitude: providerLat,
// //               longitude: providerLon,
// //               isOnline: data['isOnline'] ?? false,
// //             );

// //             allTowProviders.add(provider);
// //             print('✅ ADDED: ${provider.driverName} (${distance.toStringAsFixed(1)} km away)');
// //           } else {
// //             print('❌ TOO FAR: ${data['driverName']} - ${distance.toStringAsFixed(1)} km');
// //           }

// //         } catch (e) {
// //           print('❌ Error processing tow provider document: $e');
// //           print('📋 Problematic data: ${doc.data()}');
// //         }
// //       }

// //       // Sort by distance (nearest first)
// //       allTowProviders.sort((a, b) => a.distance.compareTo(b.distance));

// //       setState(() {
// //         _nearbyTowProviders = allTowProviders;
// //         _isLoading = false;
// //         _hasError = false;
// //       });

// //       print('\n🎉 FINAL RESULTS:');
// //       print('📍 User Location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}');
// //       print('📊 Nearby tow providers loaded: ${_nearbyTowProviders.length} within 20km');
// //       print('📈 Distance range: ${_nearbyTowProviders.isNotEmpty ? _nearbyTowProviders.first.distance.toStringAsFixed(1) : 0}km - ${_nearbyTowProviders.isNotEmpty ? _nearbyTowProviders.last.distance.toStringAsFixed(1) : 0}km');

// //     } catch (e) {
// //       print('❌ CRITICAL ERROR loading nearby tow providers: $e');
// //       setState(() {
// //         _hasError = true;
// //         _errorMessage = 'Failed to load tow providers: ${e.toString()}';
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   void _selectTowProvider(TowProvider provider) {
// //     print('🎯 Selected tow provider: ${provider.driverName} (${provider.distance.toStringAsFixed(1)} km)');

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => TowServiceRequestScreen(
// //           selectedTowProvider: provider,
// //           userLocation: widget.userLocation,
// //           userEmail: widget.userEmail,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Nearby Tow Services'),
// //         backgroundColor: Color(0xFF8B5CF6),
// //         foregroundColor: Colors.white,
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.refresh),
// //             onPressed: () {
// //               setState(() {
// //                 _isLoading = true;
// //                 _hasError = false;
// //               });
// //               _loadNearbyTowProviders();
// //             },
// //             tooltip: 'Refresh',
// //           ),
// //         ],
// //       ),
// //       body: _isLoading
// //           ? _buildLoadingState()
// //           : _hasError
// //             ? _buildErrorState()
// //             : _buildTowProvidersList(),
// //     );
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(color: Color(0xFF8B5CF6)),
// //           SizedBox(height: 16),
// //           Text(
// //             'Finding Nearby Tow Services...',
// //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             'Searching within 20km radius',
// //             style: TextStyle(fontSize: 12, color: Colors.grey[500]),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Padding(
// //         padding: EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.error_outline, size: 80, color: Colors.orange),
// //             SizedBox(height: 16),
// //             Text(
// //               'Unable to Load Tow Services',
// //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
// //             ),
// //             SizedBox(height: 12),
// //             Text(
// //               _errorMessage,
// //               textAlign: TextAlign.center,
// //               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //             ),
// //             SizedBox(height: 24),
// //             ElevatedButton(
// //               onPressed: _loadNearbyTowProviders,
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Color(0xFF8B5CF6),
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: Text('Try Again'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTowProvidersList() {
// //     return Column(
// //       children: [
// //         // Header with user location and results
// //         Container(
// //           padding: EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.grey[50],
// //             border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 234, 217, 217))),
// //           ),
// //           child: Row(
// //             children: [
// //               Icon(Icons.local_shipping, color: Color(0xFF8B5CF6), size: 20),
// //               SizedBox(width: 8),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Tow Services Near You',
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w500,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     SizedBox(height: 2),
// //                     Text(
// //                       '${_nearbyTowProviders.length} providers found within 20km • Sorted by distance',
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: _nearbyTowProviders.isNotEmpty ? Colors.green : Colors.orange,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),

// //         if (_nearbyTowProviders.isEmpty)
// //           _buildNoTowProvidersState()
// //         else
// //           Expanded(
// //             child: RefreshIndicator(
// //               onRefresh: _loadNearbyTowProviders,
// //               child: ListView.builder(
// //                 padding: EdgeInsets.all(16),
// //                 itemCount: _nearbyTowProviders.length,
// //                 itemBuilder: (context, index) {
// //                   final provider = _nearbyTowProviders[index];
// //                   return _buildTowProviderCard(provider, index);
// //                 },
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildNoTowProvidersState() {
// //     return Expanded(
// //       child: Center(
// //         child: Padding(
// //           padding: EdgeInsets.all(24),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey[300]),
// //               SizedBox(height: 16),
// //               Text(
// //                 'No Tow Services Found Nearby',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
// //                 textAlign: TextAlign.center,
// //               ),
// //               SizedBox(height: 8),
// //               Text(
// //                 'We couldn\'t find any registered tow services within 20km of your current location.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(color: Colors.grey[500]),
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _loadNearbyTowProviders,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xFF8B5CF6),
// //                   foregroundColor: Colors.white,
// //                 ),
// //                 child: Text('Search Again'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTowProviderCard(TowProvider provider, int index) {
// //     return Card(
// //       elevation: 3,
// //       margin: EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF8B5CF6).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Icon(
// //                     Icons.local_shipping_rounded,
// //                     color: Color(0xFF8B5CF6),
// //                     size: 30,
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         provider.driverName,
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       SizedBox(height: 4),
// //                       Text(
// //                         provider.serviceLocation,
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.grey[600],
// //                         ),
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       SizedBox(height: 4),
// //                       Row(
// //                         children: [
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                             decoration: BoxDecoration(
// //                               color: Colors.blueGrey[100],
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                             child: Text(
// //                               provider.truckType,
// //                               style: TextStyle(
// //                                 fontSize: 10,
// //                                 color: Colors.blueGrey[700],
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 6),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                             decoration: BoxDecoration(
// //                               color: provider.isOnline ? Colors.green[100] : Colors.grey[300],
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                             child: Text(
// //                               provider.isOnline ? 'Online' : 'Offline',
// //                               style: TextStyle(
// //                                 fontSize: 10,
// //                                 color: provider.isOnline ? Colors.green[700] : Colors.grey[600],
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 12),

// //             // Rating and Distance
// //             Row(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Icon(Icons.star, color: Colors.amber, size: 16),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       provider.rating.toStringAsFixed(1),
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       '(${provider.totalJobs} jobs)',
// //                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                     ),
// //                   ],
// //                 ),
// //                 Spacer(),
// //                 Row(
// //                   children: [
// //                     Icon(Icons.location_on, color: Colors.red, size: 16),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       '${provider.distance.toStringAsFixed(1)} km',
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 8),

// //             // Truck Details
// //             Container(
// //               padding: EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[50],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.confirmation_number, size: 14, color: Colors.grey[600]),
// //                   SizedBox(width: 4),
// //                   Text(
// //                     'Truck: ${provider.truckNumber}',
// //                     style: TextStyle(fontSize: 12, color: Colors.grey[700]),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 12),

// //             // Select Button
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () => _selectTowProvider(provider),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xFF8B5CF6),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //                 child: Text('Request Tow Service'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class TowProvider {
// //   final String id;
// //   final String driverName;
// //   final String email;
// //   final String truckNumber;
// //   final String truckType;
// //   final String serviceLocation;
// //   final double distance;
// //   final double rating;
// //   final int totalJobs;
// //   final bool isAvailable;
// //   final double latitude;
// //   final double longitude;
// //   final bool isOnline;

// //   TowProvider({
// //     required this.id,
// //     required this.driverName,
// //     required this.email,
// //     required this.truckNumber,
// //     required this.truckType,
// //     required this.serviceLocation,
// //     required this.distance,
// //     required this.rating,
// //     required this.totalJobs,
// //     required this.isAvailable,
// //     required this.latitude,
// //     required this.longitude,
// //     required this.isOnline,
// //   });
// // }

// // NearbyTowProvidersScreen.dart
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:smart_road_app/VehicleOwner/TowRequest.dart';

// class NearbyTowProvidersScreen extends StatefulWidget {
//   final Position userLocation;
//   final String? userEmail;

//   const NearbyTowProvidersScreen({
//     super.key,
//     required this.userLocation,
//     required this.userEmail,
//   });

//   @override
//   _NearbyTowProvidersScreenState createState() => _NearbyTowProvidersScreenState();
// }

// class _NearbyTowProvidersScreenState extends State<NearbyTowProvidersScreen> {
//   List<Map<String, dynamic>> _nearbyProviders = [];
//   bool _isLoading = true;
//   bool _isRefreshing = false;
//   final double _searchRadius = 20.0; // 20 km radius

//   @override
//   void initState() {
//     super.initState();
//     _fetchNearbyProviders();
//   }

//   Future<void> _fetchNearbyProviders() async {
//     try {
//       setState(() {
//         _isRefreshing = true;
//       });

//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('tow')
//           .get();

//       List<Map<String, dynamic>> allProviders = [];

//       for (var doc in snapshot.docs) {
//         final profileDoc = await doc.reference
//             .collection('profile')
//             .doc('provider_details')
//             .get();

//         if (profileDoc.exists) {
//           final providerData = profileDoc.data() as Map<String, dynamic>;

//           if (providerData['latitude'] != null && providerData['longitude'] != null) {
//             final double providerLat = providerData['latitude'];
//             final double providerLon = providerData['longitude'];

//             final double distance = _calculateDistance(
//               widget.userLocation.latitude,
//               widget.userLocation.longitude,
//               providerLat,
//               providerLon,
//             );

//             if (distance <= _searchRadius) {
//               allProviders.add({
//                 ...providerData,
//                 'distance': distance,
//                 'docId': doc.id,
//               });
//             }
//           }
//         }
//       }

//       allProviders.sort((a, b) => a['distance'].compareTo(b['distance']));

//       setState(() {
//         _nearbyProviders = allProviders;
//         _isLoading = false;
//         _isRefreshing = false;
//       });

//     } catch (e) {
//       print('Error fetching nearby providers: $e');
//       setState(() {
//         _isLoading = false;
//         _isRefreshing = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading providers: $e')),
//       );
//     }
//   }

//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double earthRadius = 6371;

//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);

//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return earthRadius * c;
//   }

//   double _toRadians(double degree) {
//     return degree * (3.14159265358979323846 / 180);
//   }

//   String _calculateETA(double distance) {
//     double timeInHours = distance / 40; // 40 km/h average speed
//     int minutes = (timeInHours * 60).ceil();
//     return '${minutes} min';
//   }

//   void _selectProvider(Map<String, dynamic> provider) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TowServiceRequestForm(
//           selectedProvider: provider,
//           userLocation: widget.userLocation,
//           userEmail: widget.userEmail,
//         ),
//       ),
//     );
//   }

//   Widget _buildProviderCard(Map<String, dynamic> provider, int index) {
//     final double distance = provider['distance'];
//     final String driverName = provider['driverName'] ?? 'Unknown Driver';
//     final String truckType = provider['truckType'] ?? 'Not Specified';
//     final String truckNumber = provider['truckNumber'] ?? 'Not Available';
//     final double rating = (provider['rating'] ?? 0.0).toDouble();
//     final int totalJobs = provider['totalJobs'] ?? 0;
//     final bool isOnline = provider['isOnline'] ?? false;
//     final String status = provider['status'] ?? 'active';

//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: index == 0 ? Colors.green : Colors.transparent,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           contentPadding: EdgeInsets.all(16),
//           leading: Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Color(0xFF6D28D9).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.local_shipping,
//               color: Color(0xFF6D28D9),
//               size: 30,
//             ),
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       driverName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   if (isOnline)
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.circle, color: Colors.white, size: 8),
//                           SizedBox(width: 4),
//                           Text(
//                             'Online',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               SizedBox(height: 4),
//               Text(
//                 truckType,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 8),
//               Text(
//                 'Truck: $truckNumber',
//                 style: TextStyle(fontSize: 12),
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amber, size: 16),
//                   SizedBox(width: 4),
//                   Text(
//                     rating.toStringAsFixed(1),
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   SizedBox(width: 12),
//                   Icon(Icons.work, color: Colors.grey, size: 16),
//                   SizedBox(width: 4),
//                   Text(
//                     '$totalJobs jobs',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//               if (status != 'active') ...[
//                 SizedBox(height: 4),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     status.toUpperCase(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '${distance.toStringAsFixed(1)} km',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Color(0xFF6D28D9),
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 _calculateETA(distance),
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//               if (index == 0) ...[
//                 SizedBox(height: 4),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'NEAREST',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//           onTap: () => _selectProvider(provider),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 16),
//           Text(
//             'Finding nearby tow providers...',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Searching within $_searchRadius km radius',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.local_shipping_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No tow providers found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'within $_searchRadius km radius',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[500],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Try again later or expand your search area',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[400],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _fetchNearbyProviders,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF6D28D9),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             icon: Icon(Icons.refresh),
//             label: Text('Search Again'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProvidersList() {
//     return Column(
//       children: [
//         // Header with stats
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Icon(Icons.info_outline, color: Colors.blue, size: 24),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${_nearbyProviders.length} providers found nearby',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue[800],
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Within $_searchRadius km of your location',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Providers list
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: _fetchNearbyProviders,
//             child: ListView.builder(
//               itemCount: _nearbyProviders.length,
//               itemBuilder: (context, index) {
//                 return _buildProviderCard(_nearbyProviders[index], index);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Tow Providers'),
//         backgroundColor: Color(0xFF6D28D9),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: _isRefreshing
//                 ? SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : Icon(Icons.refresh),
//             onPressed: _isRefreshing ? null : _fetchNearbyProviders,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildLoadingState()
//           : _nearbyProviders.isEmpty
//               ? _buildEmptyState()
//               : _buildProvidersList(),
//       floatingActionButton: _nearbyProviders.isNotEmpty
//           ? FloatingActionButton.extended(
//               onPressed: () {
//                 if (_nearbyProviders.isNotEmpty) {
//                   _selectProvider(_nearbyProviders[0]);
//                 }
//               },
//               icon: Icon(Icons.local_shipping),
//               label: Text('Book Nearest'),
//               backgroundColor: Color(0xFF6D28D9),
//             )
//           : null,
//     );
//   }
// }

import 'dart:math';

import 'package:smart_road_app/VehicleOwner/TowRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyTowProvidersScreen extends StatefulWidget {
  final Position userLocation;
  final String? userEmail;

  const NearbyTowProvidersScreen({
    super.key,
    required this.userLocation,
    required this.userEmail,
  });

  @override
  _NearbyTowProvidersScreenState createState() =>
      _NearbyTowProvidersScreenState();
}

class _NearbyTowProvidersScreenState extends State<NearbyTowProvidersScreen> {
  List<TowProvider> _nearbyTowProviders = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadNearbyTowProviders();
  }

  // Calculate distance between two coordinates in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Future<void> _loadNearbyTowProviders() async {
    try {
      print(
        '📍 User location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}',
      );
      print('🔍 Loading tow providers from Firestore...');

      // Fetch all active tow providers from Firestore
      final providersSnapshot = await FirebaseFirestore.instance
          .collection('tow_providers')
          .where('isActive', isEqualTo: true)
          .where('isAvailable', isEqualTo: true)
          .get();

      print('📊 Total tow providers found: ${providersSnapshot.docs.length}');

      List<TowProvider> allProviders = [];

      for (var doc in providersSnapshot.docs) {
        try {
          final data = doc.data();
          print('🔍 Processing tow provider: ${data['driverName']}');

          // Check if provider has location data
          if (data['latitude'] == null || data['longitude'] == null) {
            print('⚠️ Tow provider ${data['driverName']} has no location data');
            continue;
          }

          double providerLat = data['latitude'].toDouble();
          double providerLon = data['longitude'].toDouble();

          // Calculate distance from user
          double distance = _calculateDistance(
            widget.userLocation.latitude,
            widget.userLocation.longitude,
            providerLat,
            providerLon,
          );

          print(
            '📏 Distance to ${data['driverName']}: ${distance.toStringAsFixed(1)} km',
          );

          // Only include providers within 20 km radius
          if (distance <= 20) {
            TowProvider provider = TowProvider(
              id: doc.id,
              driverName: data['driverName'] ?? 'Unknown Driver',
              email: data['email'] ?? 'Not provided',
              phone: data['phone'] ?? 'Not provided',
              truckNumber: data['truckNumber'] ?? 'Not provided',
              truckType: data['truckType'] ?? 'Not specified',
              serviceArea: data['serviceArea'] ?? 'Not specified',
              distance: distance,
              rating: (data['rating'] ?? 4.0).toDouble(),
              reviews: (data['reviews'] ?? 0).toInt(),
              totalJobs: (data['totalJobs'] ?? 0).toInt(),
              isAvailable: data['isAvailable'] ?? true,
              latitude: providerLat,
              longitude: providerLon,
            );

            allProviders.add(provider);
            print(
              '✅ Added tow provider: ${provider.driverName} (${distance.toStringAsFixed(1)} km)',
            );
          } else {
            print(
              '❌ Tow provider ${data['driverName']} is too far: ${distance.toStringAsFixed(1)} km',
            );
          }
        } catch (e) {
          print('❌ Error processing tow provider document: $e');
        }
      }

      // Sort by distance (nearest first)
      allProviders.sort((a, b) => a.distance.compareTo(b.distance));

      setState(() {
        _nearbyTowProviders = allProviders;
        _isLoading = false;
        _hasError = false;
      });

      print(
        '🎉 Nearby tow providers loaded: ${_nearbyTowProviders.length} within 20km',
      );
    } catch (e) {
      print('❌ Error loading nearby tow providers: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load tow providers: $e';
        _isLoading = false;
      });
    }
  }

  void _selectTowProvider(TowProvider provider) {
    print(
      '🎯 Selected tow provider: ${provider.driverName} (${provider.distance.toStringAsFixed(1)} km)',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TowServiceRequestScreen(
          selectedProvider: provider,
          userLocation: widget.userLocation,
          userEmail: widget.userEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Tow Providers'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNearbyTowProviders,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _hasError
          ? _buildErrorState()
          : _buildProvidersList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Finding Nearby Tow Providers...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Searching within 20km radius',
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
              'Unable to Load Tow Providers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadNearbyTowProviders,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvidersList() {
    return Column(
      children: [
        // Header with user location
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tow Providers Near You',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Within 20km radius • ${_nearbyTowProviders.length} found',
                      style: TextStyle(
                        fontSize: 12,
                        color: _nearbyTowProviders.isNotEmpty
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (_nearbyTowProviders.isEmpty)
          _buildNoProvidersState()
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNearbyTowProviders,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _nearbyTowProviders.length,
                itemBuilder: (context, index) {
                  final provider = _nearbyTowProviders[index];
                  return _buildProviderCard(provider);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoProvidersState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 80, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'No Tow Providers Found Nearby',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'No registered tow providers found within 20km radius',
              style: TextStyle(color: Colors.grey[500]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadNearbyTowProviders,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(TowProvider provider) {
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
              children: [
                // Provider Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.driverName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider.truckType,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider.serviceArea,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Rating and Distance
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      provider.rating.toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${provider.reviews} reviews)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                // Distance
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${provider.distance.toStringAsFixed(1)} km',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),

            // Truck Info
            Row(
              children: [
                Icon(Icons.confirmation_number, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Truck: ${provider.truckNumber}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Spacer(),
                Icon(Icons.work, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Jobs: ${provider.totalJobs}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Select Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _selectTowProvider(provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Request Tow Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TowProvider {
  final String id;
  final String driverName;
  final String email;
  final String phone;
  final String truckNumber;
  final String truckType;
  final String serviceArea;
  final double distance;
  final double rating;
  final int reviews;
  final int totalJobs;
  final bool isAvailable;
  final double latitude;
  final double longitude;

  TowProvider({
    required this.id,
    required this.driverName,
    required this.email,
    required this.phone,
    required this.truckNumber,
    required this.truckType,
    required this.serviceArea,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.totalJobs,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
  });
}
