// // // Tow Service Request Form with Live Location
// // import 'dart:async';

// // import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// // import 'package:smart_road_app/VehicleOwner/notification.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart' as geo;
// // import 'package:geolocator/geolocator.dart';

// // class TowServiceRequestScreen extends StatefulWidget {
// //   const TowServiceRequestScreen({super.key});

// //   @override
// //   _TowServiceRequestScreenState createState() => _TowServiceRequestScreenState();
// // }

// // class _TowServiceRequestScreenState extends State<TowServiceRequestScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _vehicleNumberController = TextEditingController();
// //   final TextEditingController _locationController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();

// //   String? _userEmail;
// //   String? _userId;

// //   // Location variables
// //   Position? _currentPosition;
// //   bool _isGettingLocation = false;
// //   bool _isLocationEnabled = false;
// //   String _locationAddress = '';
// //   StreamSubscription<Position>? _positionStreamSubscription;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserData();
// //     _checkLocationPermission();
// //   }

// //   @override
// //   void dispose() {
// //     _stopLocationUpdates();
// //     super.dispose();
// //   }

// //   Future<void> _loadUserData() async {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     setState(() {
// //       _userEmail = user?.email;
// //       _userId = user?.uid;
// //     });
// //   }

// //   String _selectedVehicleType = 'Car';
// //   String _selectedIssueType = 'Breakdown';
// //   String _selectedTowType = 'Standard Tow';
// //   bool _isUrgent = false;

// //   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
// //   final List<String> _issueTypes = ['Breakdown', 'Accident', 'Flat Tire', 'Out of Fuel', 'Battery Issue', 'Lockout', 'Other'];
// //   final List<String> _towTypes = ['Standard Tow', 'Flatbed Tow', 'Wheel-Lift Tow', 'Heavy Duty Tow'];

// //   // Location Methods
// //   Future<bool> _checkLocationPermission() async {
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Location services are disabled. Please enable them.')),
// //       );
// //       return false;
// //     }

// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Location permissions are denied')),
// //         );
// //         return false;
// //       }
// //     }

// //     if (permission == LocationPermission.deniedForever) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
// //       );
// //       return false;
// //     }

// //     return true;
// //   }

// //   Future<void> _getCurrentLocation() async {
// //     bool hasPermission = await _checkLocationPermission();
// //     if (!hasPermission) return;

// //     setState(() {
// //       _isGettingLocation = true;
// //     });

// //     try {
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );

// //       setState(() {
// //         _currentPosition = position;
// //         _isGettingLocation = false;
// //         _locationController.text = '${position.latitude}, ${position.longitude}';
// //       });

// //       // Get address from coordinates
// //       await _getAddressFromLatLng(position);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Location captured: ${_locationAddress.isNotEmpty ? _locationAddress : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'}')),
// //       );

// //     } catch (e) {
// //       setState(() {
// //         _isGettingLocation = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error getting location: $e')),
// //       );
// //     }
// //   }

// // Future<void> _getAddressFromLatLng(Position position) async {
// //   try {
// //     // Using geocoding package instead
// //     final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
// //       position.latitude,
// //       position.longitude,
// //     );

// //     if (placemarks.isNotEmpty) {
// //       final geo.Placemark place = placemarks.first;

// //       final List<String> addressParts = [];

// //       if (place.street != null && place.street!.isNotEmpty) {
// //         addressParts.add(place.street!);
// //       }
// //       if (place.locality != null && place.locality!.isNotEmpty) {
// //         addressParts.add(place.locality!);
// //       }
// //       if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
// //         addressParts.add(place.administrativeArea!);
// //       }
// //       if (place.country != null && place.country!.isNotEmpty) {
// //         addressParts.add(place.country!);
// //       }

// //       setState(() {
// //         _locationAddress = addressParts.isNotEmpty
// //             ? addressParts.join(', ')
// //             : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// //       });
// //     } else {
// //       setState(() {
// //         _locationAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// //       });
// //     }
// //   } catch (e) {
// //     print('Error getting address: $e');
// //     setState(() {
// //       _locationAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// //     });
// //   }
// // }

// //   Future<void> _startLiveLocationSharing() async {
// //     bool hasPermission = await _checkLocationPermission();
// //     if (!hasPermission) return;

// //     setState(() {
// //       _isLocationEnabled = true;
// //       _isGettingLocation = true;
// //     });

// //     // First get current location
// //     await _getCurrentLocation();

// //     // Then start live updates
// //     _positionStreamSubscription = Geolocator.getPositionStream(
// //       locationSettings: const LocationSettings(
// //         accuracy: LocationAccuracy.high,
// //         distanceFilter: 10, // Update every 10 meters
// //       ),
// //     ).listen((Position position) {
// //       setState(() {
// //         _currentPosition = position;
// //         _isGettingLocation = false;
// //       });

// //       // Update location in controller
// //       _locationController.text = '${position.latitude}, ${position.longitude}';

// //       // Get address for the new position
// //       _getAddressFromLatLng(position);

// //       // Update location in Firebase if request is already submitted
// //       _updateLiveLocationInFirebase(position);
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Live location sharing started')),
// //     );
// //   }

// //   void _stopLocationUpdates() {
// //     _positionStreamSubscription?.cancel();
// //     setState(() {
// //       _isLocationEnabled = false;
// //       _isGettingLocation = false;
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Live location sharing stopped')),
// //     );
// //   }

// //   Future<void> _updateLiveLocationInFirebase(Position position) async {
// //     if (_userId == null) return;

// //     try {
// //       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
// //       await dbRef.child('live_locations').child(_userId!).set({
// //         'latitude': position.latitude,
// //         'longitude': position.longitude,
// //         'timestamp': DateTime.now().millisecondsSinceEpoch,
// //         'userEmail': _userEmail,
// //         'vehicleNumber': _vehicleNumberController.text.isNotEmpty ? _vehicleNumberController.text : 'Unknown',
// //         'address': _locationAddress,
// //         'isUrgent': _isUrgent,
// //         'lastUpdated': DateTime.now().toIso8601String(),
// //       });
// //     } catch (e) {
// //       print('Error updating live location: $e');
// //     }
// //   }

// //   void _submitRequest() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     // Ensure we have location
// //     if (_currentPosition == null && _locationController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enable location or enter your location manually')),
// //       );
// //       return;
// //     }

// //     final requestId = 'TOW${DateTime.now().millisecondsSinceEpoch}';
// //     final timestamp = DateTime.now().millisecondsSinceEpoch;

// //     // Prepare request data with location
// //     final requestData = {
// //       "name": _nameController.text,
// //       "phone": _phoneController.text,
// //       "location": _locationController.text,
// //       "description": _descriptionController.text,
// //       "requestId": requestId,
// //       "vehicleNumber": _vehicleNumberController.text,
// //       "vehicleType": _selectedVehicleType,
// //       "issueType": _selectedIssueType,
// //       "towType": _selectedTowType,
// //       "isUrgent": _isUrgent,
// //       "status": "pending",
// //       "timestamp": timestamp,
// //       "userEmail": _userEmail,
// //       "userId": _userId,
// //       "latitude": _currentPosition?.latitude,
// //       "longitude": _currentPosition?.longitude,
// //       "address": _locationAddress,
// //       "liveLocationEnabled": _isLocationEnabled,
// //     };

// //     try {
// //       // 1. Save to Cloud Firestore
// //       await FirebaseFirestore.instance
// //           .collection('owner')
// //           .doc(_userEmail)
// //           .collection("towrequest")
// //           .doc(requestId)
// //           .set(requestData);

// //       // 2. Save to Realtime Database for notifications
// //       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
// //       await dbRef.child('tow_requests').child(requestId).set({
// //         ...requestData,
// //         'notificationRead': false,
// //         'adminRead': false,
// //       });

// //       // 3. Save initial live location if enabled
// //       if (_isLocationEnabled && _currentPosition != null) {
// //         await dbRef.child('live_locations').child(_userId!).set({
// //           'latitude': _currentPosition!.latitude,
// //           'longitude': _currentPosition!.longitude,
// //           'timestamp': timestamp,
// //           'userEmail': _userEmail,
// //           'vehicleNumber': _vehicleNumberController.text,
// //           'address': _locationAddress,
// //           'isUrgent': _isUrgent,
// //           'requestId': requestId,
// //           'lastUpdated': DateTime.now().toIso8601String(),
// //         });
// //       }

// //       // 4. Create user notification
// //       final userNotificationRef = dbRef
// //           .child('notifications')
// //           .child(_userId ?? 'unknown')
// //           .push();

// //       await userNotificationRef.set({
// //         'id': userNotificationRef.key,
// //         'requestId': requestId,
// //         'title': 'Tow Service Request Submitted',
// //         'message': 'Your tow service request for ${_vehicleNumberController.text} has been submitted successfully. We will assign a driver soon.',
// //         'timestamp': timestamp,
// //         'read': false,
// //         'type': 'tow_request_submitted',
// //         'vehicleNumber': _vehicleNumberController.text,
// //         'status': 'pending',
// //         'liveLocationEnabled': _isLocationEnabled,
// //       });

// //       // 5. Create admin notification
// //       final adminNotificationRef = dbRef.child('admin_notifications').push();
// //       await adminNotificationRef.set({
// //         'id': adminNotificationRef.key,
// //         'requestId': requestId,
// //         'title': 'New Tow Service Request',
// //         'message': 'New tow request from ${_nameController.text} for ${_vehicleNumberController.text}',
// //         'timestamp': timestamp,
// //         'read': false,
// //         'type': 'new_tow_request',
// //         'userEmail': _userEmail,
// //         'vehicleNumber': _vehicleNumberController.text,
// //         'location': _locationController.text,
// //         'isUrgent': _isUrgent,
// //         'userId': _userId,
// //         'latitude': _currentPosition?.latitude,
// //         'longitude': _currentPosition?.longitude,
// //         'liveLocationEnabled': _isLocationEnabled,
// //       });

// //       showDialog(
// //         context: context,
// //         builder: (context) => TowRequestConfirmation(
// //           requestId: requestId,
// //           vehicleNumber: _vehicleNumberController.text,
// //           issueType: _selectedIssueType,
// //           towType: _selectedTowType,
// //           isUrgent: _isUrgent,
// //           isLiveLocationEnabled: _isLocationEnabled,
// //         ),
// //       );
// //     //  Navigator.of(context).pop();

// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
// //       );
// //     }
// //   }

// //   Widget _buildServiceTypeCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Service Details',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             DropdownButtonFormField<String>(
// //               initialValue: _selectedTowType,
// //               decoration: InputDecoration(
// //                 labelText: 'Tow Service Type',
// //                 prefixIcon: Icon(Icons.local_shipping_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               items: _towTypes.map((type) {
// //                 return DropdownMenuItem(
// //                   value: type,
// //                   child: Text(type),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedTowType = value!;
// //                 });
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             DropdownButtonFormField<String>(
// //               initialValue: _selectedIssueType,
// //               decoration: InputDecoration(
// //                 labelText: 'Issue Type',
// //                 prefixIcon: Icon(Icons.warning_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               items: _issueTypes.map((type) {
// //                 return DropdownMenuItem(
// //                   value: type,
// //                   child: Text(type),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedIssueType = value!;
// //                 });
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPersonalDetailsCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Personal Details',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _nameController,
// //               decoration: InputDecoration(
// //                 labelText: 'Full Name',
// //                 prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter your name';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _phoneController,
// //               decoration: InputDecoration(
// //                 labelText: 'Phone Number',
// //                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               keyboardType: TextInputType.phone,
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter your phone number';
// //                 }
// //                 return null;
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildVehicleDetailsCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Vehicle Details',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _vehicleNumberController,
// //               decoration: InputDecoration(
// //                 labelText: 'Vehicle Number',
// //                 hintText: 'e.g., MH12AB1234',
// //                 prefixIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter vehicle number';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             DropdownButtonFormField<String>(
// //               initialValue: _selectedVehicleType,
// //               decoration: InputDecoration(
// //                 labelText: 'Vehicle Type',
// //                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               items: _vehicleTypes.map((type) {
// //                 return DropdownMenuItem(
// //                   value: type,
// //                   child: Text(type),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedVehicleType = value!;
// //                 });
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _descriptionController,
// //               decoration: InputDecoration(
// //                 labelText: 'Additional Details',
// //                 hintText: 'Describe your issue in detail...',
// //                 prefixIcon: Icon(Icons.description_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               maxLines: 3,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildLocationCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Location Details',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),

// //             // Current Location Display
// //             if (_currentPosition != null) ...[
// //               Container(
// //                 padding: EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.green[50],
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(color: Colors.green),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.location_on_rounded, color: Colors.green),
// //                     SizedBox(width: 8),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Current Location:',
// //                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
// //                           ),
// //                           Text(
// //                             _locationAddress.isNotEmpty
// //                                 ? _locationAddress
// //                                 : '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
// //                             style: TextStyle(fontSize: 11),
// //                             maxLines: 2,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 12),
// //             ],

// //             TextFormField(
// //               controller: _locationController,
// //               decoration: InputDecoration(
// //                 labelText: 'Location',
// //                 hintText: 'Enter your location or use buttons below',
// //                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter your location';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             SizedBox(height: 12),

// //             // Location Buttons
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: OutlinedButton.icon(
// //                     onPressed: _isGettingLocation ? null : _getCurrentLocation,
// //                     icon: _isGettingLocation
// //                         ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
// //                         : Icon(Icons.gps_fixed_rounded),
// //                     label: Text(_isGettingLocation ? 'Getting Location...' : 'Get Current Location'),
// //                   ),
// //                 ),
// //                 SizedBox(width: 8),
// //                 Expanded(
// //                   child: _isLocationEnabled
// //                       ? ElevatedButton.icon(
// //                           onPressed: _stopLocationUpdates,
// //                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //                           icon: Icon(Icons.location_off_rounded),
// //                           label: Text('Stop Sharing'),
// //                         )
// //                       : ElevatedButton.icon(
// //                           onPressed: _startLiveLocationSharing,
// //                           icon: Icon(Icons.location_searching_rounded),
// //                           label: Text('Share Live'),
// //                         ),
// //                 ),
// //               ],
// //             ),

// //             SizedBox(height: 8),
// //             if (_isLocationEnabled) ...[
// //               Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[50],
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.info_rounded, color: Colors.blue, size: 16),
// //                     SizedBox(width: 8),
// //                     Expanded(
// //                       child: Text(
// //                         'Live location sharing is active. Your location will update automatically.',
// //                         style: TextStyle(fontSize: 12, color: Colors.blue[700]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildUrgentServiceCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Service Priority',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Icon(Icons.emergency_rounded, color: _isUrgent ? Colors.red : Colors.grey),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'Urgent Service',
// //                         style: TextStyle(fontWeight: FontWeight.w600),
// //                       ),
// //                       Text(
// //                         'Get priority response (Additional charges may apply)',
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Switch(
// //                   value: _isUrgent,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _isUrgent = value;
// //                     });
// //                   },
// //                   activeThumbColor: Colors.red,
// //                 ),
// //               ],
// //             ),
// //             if (_isUrgent) ...[
// //               SizedBox(height: 12),
// //               Container(
// //                 padding: EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.red.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.info_rounded, color: Colors.red, size: 20),
// //                     SizedBox(width: 8),
// //                     Expanded(
// //                       child: Text(
// //                         'Urgent service ensures faster response time. Additional charges: \$25',
// //                         style: TextStyle(fontSize: 12, color: Colors.red[700]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSubmitButton() {
// //     return SizedBox(
// //       width: double.infinity,
// //       child: ElevatedButton(
// //         onPressed: _submitRequest,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Color(0xFF6D28D9),
// //           foregroundColor: Colors.white,
// //           padding: EdgeInsets.symmetric(vertical: 16),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         ),
// //         child: Text(
// //           'Request Tow Service',
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Tow Service Request'),
// //         backgroundColor: Color(0xFF6D28D9),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               _buildServiceTypeCard(),
// //               SizedBox(height: 12),
// //               _buildPersonalDetailsCard(),
// //               SizedBox(height: 12),
// //               _buildVehicleDetailsCard(),
// //               SizedBox(height: 12),
// //               _buildLocationCard(),
// //               SizedBox(height: 12),
// //               _buildUrgentServiceCard(),
// //               SizedBox(height: 16),
// //               _buildSubmitButton(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class TowRequestConfirmation extends StatelessWidget {
// //   final String requestId;
// //   final String vehicleNumber;
// //   final String issueType;
// //   final String towType;
// //   final bool isUrgent;
// //   final bool isLiveLocationEnabled;

// //   const TowRequestConfirmation({
// //     super.key,
// //     required this.requestId,
// //     required this.vehicleNumber,
// //     required this.issueType,
// //     required this.towType,
// //     required this.isUrgent,
// //     required this.isLiveLocationEnabled,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       child: Padding(
// //         padding: EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
// //             SizedBox(height: 16),
// //             Text(
// //               'Tow Request Sent!',
// //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 16),
// //             Text(
// //               'Your tow service request has been submitted successfully.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: Colors.grey[600]),
// //             ),
// //             SizedBox(height: 20),
// //             _buildDetailRow('Request ID', requestId),
// //             _buildDetailRow('Vehicle', vehicleNumber),
// //             _buildDetailRow('Issue Type', issueType),
// //             _buildDetailRow('Service Type', towType),
// //             _buildDetailRow('Priority', isUrgent ? 'Urgent' : 'Standard'),
// //             _buildDetailRow('Live Location', isLiveLocationEnabled ? 'Enabled' : 'Disabled'),
// //             SizedBox(height: 24),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: OutlinedButton(
// //                     onPressed: () =>Navigator.of(context).pushAndRemoveUntil(
// //   MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// //   (route) => false, ),
// //                     child: Text('Back to Home'),
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => NotificationsPage(),
// //                         ),
// //                       );
// //                     },
// //                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
// //                     child: Text('View Notifications'),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDetailRow(String label, String value) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
// //           SizedBox(width: 8),
// //           Text(value),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'dart:async';

// // // import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// // // import 'package:smart_road_app/VehicleOwner/notification.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:firebase_database/firebase_database.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:geocoding/geocoding.dart' as geo;
// // // import 'package:geolocator/geolocator.dart';

// // // class TowServiceRequestScreen extends StatefulWidget {
// // //   final TowProvider? selectedTowProvider;
// // //   final Position userLocation;
// // //   final String? userEmail;

// // //   const TowServiceRequestScreen({
// // //     super.key,
// // //     this.selectedTowProvider,
// // //     required this.userLocation,
// // //     required this.userEmail,
// // //   });

// // //   @override
// // //   _TowServiceRequestScreenState createState() => _TowServiceRequestScreenState();
// // // }

// // // class _TowServiceRequestScreenState extends State<TowServiceRequestScreen> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final TextEditingController _nameController = TextEditingController();
// // //   final TextEditingController _phoneController = TextEditingController();
// // //   final TextEditingController _vehicleNumberController = TextEditingController();
// // //   final TextEditingController _locationController = TextEditingController();
// // //   final TextEditingController _descriptionController = TextEditingController();

// // //   String? _userEmail;
// // //   String? _userId;

// // //   // Location variables
// // //   Position? _currentPosition;
// // //   bool _isGettingLocation = false;
// // //   bool _isLocationEnabled = false;
// // //   String _locationAddress = '';
// // //   StreamSubscription<Position>? _positionStreamSubscription;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadUserData();
// // //     _checkLocationPermission();
// // //     _prefillUserData();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _stopLocationUpdates();
// // //     super.dispose();
// // //   }

// // //   Future<void> _loadUserData() async {
// // //     User? user = FirebaseAuth.instance.currentUser;
// // //     setState(() {
// // //       _userEmail = user?.email;
// // //       _userId = user?.uid;
// // //     });
// // //   }

// // //   void _prefillUserData() {
// // //     _nameController.text = 'Vehicle Owner';
// // //     _phoneController.text = '+91XXXXXXXXXX';
// // //     _locationController.text = 'Current Location';
// // //   }

// // //   String _selectedVehicleType = 'Car';
// // //   String _selectedIssueType = 'Breakdown';
// // //   String _selectedTowType = 'Standard Tow';
// // //   bool _isUrgent = false;

// // //   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
// // //   final List<String> _issueTypes = ['Breakdown', 'Accident', 'Flat Tire', 'Out of Fuel', 'Battery Issue', 'Lockout', 'Other'];
// // //   final List<String> _towTypes = ['Standard Tow', 'Flatbed Tow', 'Wheel-Lift Tow', 'Heavy Duty Tow'];

// // //   // Location Methods
// // //   Future<bool> _checkLocationPermission() async {
// // //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //     if (!serviceEnabled) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Location services are disabled. Please enable them.')),
// // //       );
// // //       return false;
// // //     }

// // //     LocationPermission permission = await Geolocator.checkPermission();
// // //     if (permission == LocationPermission.denied) {
// // //       permission = await Geolocator.requestPermission();
// // //       if (permission == LocationPermission.denied) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Location permissions are denied')),
// // //         );
// // //         return false;
// // //       }
// // //     }

// // //     if (permission == LocationPermission.deniedForever) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
// // //       );
// // //       return false;
// // //     }

// // //     return true;
// // //   }

// // //   Future<void> _getCurrentLocation() async {
// // //     bool hasPermission = await _checkLocationPermission();
// // //     if (!hasPermission) return;

// // //     setState(() {
// // //       _isGettingLocation = true;
// // //     });

// // //     try {
// // //       Position position = await Geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.high,
// // //       );

// // //       setState(() {
// // //         _currentPosition = position;
// // //         _isGettingLocation = false;
// // //         _locationController.text = '${position.latitude}, ${position.longitude}';
// // //       });

// // //       // Get address from coordinates
// // //       await _getAddressFromLatLng(position);

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Location captured: ${_locationAddress.isNotEmpty ? _locationAddress : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'}')),
// // //       );

// // //     } catch (e) {
// // //       setState(() {
// // //         _isGettingLocation = false;
// // //       });
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Error getting location: $e')),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _getAddressFromLatLng(Position position) async {
// // //     try {
// // //       final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
// // //         position.latitude,
// // //         position.longitude,
// // //       );

// // //       if (placemarks.isNotEmpty) {
// // //         final geo.Placemark place = placemarks.first;

// // //         final List<String> addressParts = [];

// // //         if (place.street != null && place.street!.isNotEmpty) {
// // //           addressParts.add(place.street!);
// // //         }
// // //         if (place.locality != null && place.locality!.isNotEmpty) {
// // //           addressParts.add(place.locality!);
// // //         }
// // //         if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
// // //           addressParts.add(place.administrativeArea!);
// // //         }
// // //         if (place.country != null && place.country!.isNotEmpty) {
// // //           addressParts.add(place.country!);
// // //         }

// // //         setState(() {
// // //           _locationAddress = addressParts.isNotEmpty
// // //               ? addressParts.join(', ')
// // //               : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// // //         });
// // //       } else {
// // //         setState(() {
// // //           _locationAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// // //         });
// // //       }
// // //     } catch (e) {
// // //       print('Error getting address: $e');
// // //       setState(() {
// // //         _locationAddress = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
// // //       });
// // //     }
// // //   }

// // //   Future<void> _startLiveLocationSharing() async {
// // //     bool hasPermission = await _checkLocationPermission();
// // //     if (!hasPermission) return;

// // //     setState(() {
// // //       _isLocationEnabled = true;
// // //       _isGettingLocation = true;
// // //     });

// // //     // First get current location
// // //     await _getCurrentLocation();

// // //     // Then start live updates
// // //     _positionStreamSubscription = Geolocator.getPositionStream(
// // //       locationSettings: const LocationSettings(
// // //         accuracy: LocationAccuracy.high,
// // //         distanceFilter: 10, // Update every 10 meters
// // //       ),
// // //     ).listen((Position position) {
// // //       setState(() {
// // //         _currentPosition = position;
// // //         _isGettingLocation = false;
// // //       });

// // //       // Update location in controller
// // //       _locationController.text = '${position.latitude}, ${position.longitude}';

// // //       // Get address for the new position
// // //       _getAddressFromLatLng(position);

// // //       // Update location in Firebase if request is already submitted
// // //       _updateLiveLocationInFirebase(position);
// // //     });

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text('Live location sharing started')),
// // //     );
// // //   }

// // //   void _stopLocationUpdates() {
// // //     _positionStreamSubscription?.cancel();
// // //     setState(() {
// // //       _isLocationEnabled = false;
// // //       _isGettingLocation = false;
// // //     });

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text('Live location sharing stopped')),
// // //     );
// // //   }

// // //   Future<void> _updateLiveLocationInFirebase(Position position) async {
// // //     if (_userId == null) return;

// // //     try {
// // //       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
// // //       await dbRef.child('tow_live_locations').child(_userId!).set({
// // //         'latitude': position.latitude,
// // //         'longitude': position.longitude,
// // //         'timestamp': DateTime.now().millisecondsSinceEpoch,
// // //         'userEmail': _userEmail,
// // //         'vehicleNumber': _vehicleNumberController.text.isNotEmpty ? _vehicleNumberController.text : 'Unknown',
// // //         'address': _locationAddress,
// // //         'isUrgent': _isUrgent,
// // //         'lastUpdated': DateTime.now().toIso8601String(),
// // //       });
// // //     } catch (e) {
// // //       print('Error updating live location: $e');
// // //     }
// // //   }

// // //   void _submitRequest() async {
// // //     if (!_formKey.currentState!.validate()) {
// // //       _showErrorSnackBar('Please fill all required fields correctly.');
// // //       return;
// // //     }

// // //     // Ensure we have location
// // //     if (_currentPosition == null && _locationController.text.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Please enable location or enter your location manually')),
// // //       );
// // //       return;
// // //     }

// // //     final requestId = 'TOW${DateTime.now().millisecondsSinceEpoch}';
// // //     final timestamp = DateTime.now().millisecondsSinceEpoch;

// // //     // Prepare request data with location and provider info
// // //     final requestData = {
// // //       "name": _nameController.text.trim(),
// // //       "phone": _phoneController.text.trim(),
// // //       "location": _locationController.text.trim(),
// // //       "description": _descriptionController.text.trim(),
// // //       "requestId": requestId,
// // //       "vehicleNumber": _vehicleNumberController.text.trim(),
// // //       "vehicleType": _selectedVehicleType,
// // //       "issueType": _selectedIssueType,
// // //       "towType": _selectedTowType,
// // //       "isUrgent": _isUrgent,
// // //       "status": "pending",
// // //       "timestamp": timestamp,
// // //       "userEmail": _userEmail,
// // //       "userId": _userId,
// // //       "latitude": _currentPosition?.latitude,
// // //       "longitude": _currentPosition?.longitude,
// // //       "address": _locationAddress,
// // //       "liveLocationEnabled": _isLocationEnabled,
// // //       "createdAt": FieldValue.serverTimestamp(),
// // //       "updatedAt": FieldValue.serverTimestamp(),
// // //       // Tow provider information if selected
// // //       if (widget.selectedTowProvider != null) ...{
// // //         "towProviderId": widget.selectedTowProvider!.id,
// // //         "towProviderName": widget.selectedTowProvider!.driverName,
// // //         "towProviderEmail": widget.selectedTowProvider!.email,
// // //         "towProviderTruck": widget.selectedTowProvider!.truckNumber,
// // //         "towProviderType": widget.selectedTowProvider!.truckType,
// // //         "towProviderRating": widget.selectedTowProvider!.rating,
// // //         "towProviderJobs": widget.selectedTowProvider!.totalJobs,
// // //         "towProviderLatitude": widget.selectedTowProvider!.latitude,
// // //         "towProviderLongitude": widget.selectedTowProvider!.longitude,
// // //         "distanceToProvider": widget.selectedTowProvider!.distance,
// // //       },
// // //       // User location for distance calculation
// // //       "userLatitude": widget.userLocation.latitude,
// // //       "userLongitude": widget.userLocation.longitude,
// // //     };

// // //     try {
// // //       // 1. Save to Cloud Firestore - user's collection
// // //       await FirebaseFirestore.instance
// // //           .collection('owner')
// // //           .doc(_userEmail)
// // //           .collection("towrequest")
// // //           .doc(requestId)
// // //           .set(requestData);

// // //       // 2. If specific tow provider is selected, save to their collection too
// // //       if (widget.selectedTowProvider != null) {
// // //         await FirebaseFirestore.instance
// // //             .collection('tow_providers')
// // //             .doc(widget.selectedTowProvider!.id)
// // //             .collection('service_requests')
// // //             .add(requestData);
// // //       }

// // //       // 3. Save to Realtime Database for notifications
// // //       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
// // //       await dbRef.child('tow_requests').child(requestId).set({
// // //         ...requestData,
// // //         'notificationRead': false,
// // //         'adminRead': false,
// // //         'providerRead': widget.selectedTowProvider != null ? false : null,
// // //       });

// // //       // 4. Save initial live location if enabled
// // //       if (_isLocationEnabled && _currentPosition != null) {
// // //         await dbRef.child('tow_live_locations').child(_userId!).set({
// // //           'latitude': _currentPosition!.latitude,
// // //           'longitude': _currentPosition!.longitude,
// // //           'timestamp': timestamp,
// // //           'userEmail': _userEmail,
// // //           'vehicleNumber': _vehicleNumberController.text,
// // //           'address': _locationAddress,
// // //           'isUrgent': _isUrgent,
// // //           'requestId': requestId,
// // //           'lastUpdated': DateTime.now().toIso8601String(),
// // //         });
// // //       }

// // //       // 5. Create user notification
// // //       final userNotificationRef = dbRef
// // //           .child('notifications')
// // //           .child(_userId ?? 'unknown')
// // //           .push();

// // //       await userNotificationRef.set({
// // //         'id': userNotificationRef.key,
// // //         'requestId': requestId,
// // //         'title': 'Tow Service Request Submitted',
// // //         'message': widget.selectedTowProvider != null
// // //             ? 'Your tow service request has been sent to ${widget.selectedTowProvider!.driverName}.'
// // //             : 'Your tow service request has been submitted successfully. We will assign a driver soon.',
// // //         'timestamp': timestamp,
// // //         'read': false,
// // //         'type': 'tow_request_submitted',
// // //         'vehicleNumber': _vehicleNumberController.text,
// // //         'status': 'pending',
// // //         'liveLocationEnabled': _isLocationEnabled,
// // //       });

// // //       // 6. Create admin notification
// // //       final adminNotificationRef = dbRef.child('admin_notifications').push();
// // //       await adminNotificationRef.set({
// // //         'id': adminNotificationRef.key,
// // //         'requestId': requestId,
// // //         'title': 'New Tow Service Request',
// // //         'message': 'New tow request from ${_nameController.text} for ${_vehicleNumberController.text}',
// // //         'timestamp': timestamp,
// // //         'read': false,
// // //         'type': 'new_tow_request',
// // //         'userEmail': _userEmail,
// // //         'vehicleNumber': _vehicleNumberController.text,
// // //         'location': _locationController.text,
// // //         'isUrgent': _isUrgent,
// // //         'userId': _userId,
// // //         'latitude': _currentPosition?.latitude,
// // //         'longitude': _currentPosition?.longitude,
// // //         'liveLocationEnabled': _isLocationEnabled,
// // //       });

// // //       // 7. Create provider notification if specific provider selected
// // //       if (widget.selectedTowProvider != null) {
// // //         final providerNotificationRef = dbRef
// // //             .child('tow_provider_notifications')
// // //             .child(widget.selectedTowProvider!.id)
// // //             .push();

// // //         await providerNotificationRef.set({
// // //           'id': providerNotificationRef.key,
// // //           'requestId': requestId,
// // //           'title': 'New Tow Service Request',
// // //           'message': 'New service request from ${_nameController.text} for ${_vehicleNumberController.text}',
// // //           'timestamp': timestamp,
// // //           'read': false,
// // //           'type': 'new_tow_request',
// // //           'userEmail': _userEmail,
// // //           'vehicleNumber': _vehicleNumberController.text,
// // //           'location': _locationController.text,
// // //           'isUrgent': _isUrgent,
// // //           'userId': _userId,
// // //           'latitude': _currentPosition?.latitude,
// // //           'longitude': _currentPosition?.longitude,
// // //           'liveLocationEnabled': _isLocationEnabled,
// // //         });
// // //       }

// // //       showDialog(
// // //         context: context,
// // //         barrierDismissible: false,
// // //         builder: (context) => TowRequestConfirmation(
// // //           requestId: requestId,
// // //           vehicleNumber: _vehicleNumberController.text,
// // //           issueType: _selectedIssueType,
// // //           towType: _selectedTowType,
// // //           isUrgent: _isUrgent,
// // //           isLiveLocationEnabled: _isLocationEnabled,
// // //           towProviderName: widget.selectedTowProvider?.driverName,
// // //           distance: widget.selectedTowProvider?.distance,
// // //         ),
// // //       );

// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
// // //       );
// // //     }
// // //   }

// // //   void _showErrorSnackBar(String message) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text(message),
// // //         backgroundColor: Colors.red,
// // //         duration: Duration(seconds: 3),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSelectedProviderCard() {
// // //     if (widget.selectedTowProvider == null) {
// // //       return Container(); // Return empty container if no provider selected
// // //     }

// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               width: 50,
// // //               height: 50,
// // //               decoration: BoxDecoration(
// // //                 color: Color(0xFF8B5CF6).withOpacity(0.1),
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(
// // //                 Icons.local_shipping_rounded,
// // //                 color: Color(0xFF8B5CF6),
// // //                 size: 30,
// // //               ),
// // //             ),
// // //             SizedBox(width: 12),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     widget.selectedTowProvider!.driverName,
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                       fontSize: 16,
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 4),
// // //                   Text(
// // //                     widget.selectedTowProvider!.serviceLocation,
// // //                     style: TextStyle(
// // //                       fontSize: 12,
// // //                       color: Colors.grey[600],
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 4),
// // //                   Row(
// // //                     children: [
// // //                       Icon(Icons.star, color: Colors.amber, size: 14),
// // //                       SizedBox(width: 4),
// // //                       Text(
// // //                         '${widget.selectedTowProvider!.rating} (${widget.selectedTowProvider!.totalJobs} jobs)',
// // //                         style: TextStyle(fontSize: 12),
// // //                       ),
// // //                       SizedBox(width: 12),
// // //                       Container(
// // //                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.blue,
// // //                           borderRadius: BorderRadius.circular(8),
// // //                         ),
// // //                         child: Text(
// // //                           '${widget.selectedTowProvider!.distance.toStringAsFixed(1)} km away',
// // //                           style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 10,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildServiceTypeCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Service Details',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             DropdownButtonFormField<String>(
// // //               value: _selectedTowType,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Tow Service Type *',
// // //                 prefixIcon: Icon(Icons.local_shipping_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               items: _towTypes.map((type) {
// // //                 return DropdownMenuItem(
// // //                   value: type,
// // //                   child: Text(type),
// // //                 );
// // //               }).toList(),
// // //               onChanged: (value) {
// // //                 setState(() {
// // //                   _selectedTowType = value!;
// // //                 });
// // //               },
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please select service type';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             DropdownButtonFormField<String>(
// // //               value: _selectedIssueType,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Issue Type *',
// // //                 prefixIcon: Icon(Icons.warning_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               items: _issueTypes.map((type) {
// // //                 return DropdownMenuItem(
// // //                   value: type,
// // //                   child: Text(type),
// // //                 );
// // //               }).toList(),
// // //               onChanged: (value) {
// // //                 setState(() {
// // //                   _selectedIssueType = value!;
// // //                 });
// // //               },
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please select issue type';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildPersonalDetailsCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Personal Details',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _nameController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Full Name *',
// // //                 prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter your name';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _phoneController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Phone Number *',
// // //                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               keyboardType: TextInputType.phone,
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter your phone number';
// // //                 }
// // //                 if (value.length < 10) {
// // //                   return 'Please enter a valid phone number';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildVehicleDetailsCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Vehicle Details',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _vehicleNumberController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Vehicle Number *',
// // //                 hintText: 'e.g., MH12AB1234',
// // //                 prefixIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter vehicle number';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             DropdownButtonFormField<String>(
// // //               value: _selectedVehicleType,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Vehicle Type *',
// // //                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               items: _vehicleTypes.map((type) {
// // //                 return DropdownMenuItem(
// // //                   value: type,
// // //                   child: Text(type),
// // //                 );
// // //               }).toList(),
// // //               onChanged: (value) {
// // //                 setState(() {
// // //                   _selectedVehicleType = value!;
// // //                 });
// // //               },
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please select vehicle type';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _descriptionController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Additional Details',
// // //                 hintText: 'Describe your issue in detail...',
// // //                 prefixIcon: Icon(Icons.description_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               maxLines: 3,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildLocationCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Location Details',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
// // //             ),
// // //             SizedBox(height: 12),

// // //             if (_currentPosition != null) ...[
// // //               Container(
// // //                 padding: EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.green[50],
// // //                   borderRadius: BorderRadius.circular(10),
// // //                   border: Border.all(color: Colors.green),
// // //                 ),
// // //                 child: Row(
// // //                   children: [
// // //                     Icon(Icons.location_on_rounded, color: Colors.green),
// // //                     SizedBox(width: 8),
// // //                     Expanded(
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(
// // //                             'Current Location:',
// // //                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
// // //                           ),
// // //                           Text(
// // //                             _locationAddress.isNotEmpty
// // //                                 ? _locationAddress
// // //                                 : '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
// // //                             style: TextStyle(fontSize: 11),
// // //                             maxLines: 2,
// // //                             overflow: TextOverflow.ellipsis,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               SizedBox(height: 12),
// // //             ],

// // //             TextFormField(
// // //               controller: _locationController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Service Location *',
// // //                 hintText: 'Enter your location or use buttons below',
// // //                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF8B5CF6)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter your location';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),

// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: OutlinedButton.icon(
// // //                     onPressed: _isGettingLocation ? null : _getCurrentLocation,
// // //                     icon: _isGettingLocation
// // //                         ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
// // //                         : Icon(Icons.gps_fixed_rounded),
// // //                     label: Text(_isGettingLocation ? 'Getting Location...' : 'Get Current Location'),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 8),
// // //                 Expanded(
// // //                   child: _isLocationEnabled
// // //                       ? ElevatedButton.icon(
// // //                           onPressed: _stopLocationUpdates,
// // //                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // //                           icon: Icon(Icons.location_off_rounded),
// // //                           label: Text('Stop Sharing'),
// // //                         )
// // //                       : ElevatedButton.icon(
// // //                           onPressed: _startLiveLocationSharing,
// // //                           icon: Icon(Icons.location_searching_rounded),
// // //                           label: Text('Share Live'),
// // //                         ),
// // //                 ),
// // //               ],
// // //             ),

// // //             SizedBox(height: 8),
// // //             if (_isLocationEnabled) ...[
// // //               Container(
// // //                 padding: EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.blue[50],
// // //                   borderRadius: BorderRadius.circular(8),
// // //                 ),
// // //                 child: Row(
// // //                   children: [
// // //                     Icon(Icons.info_rounded, color: Colors.blue, size: 16),
// // //                     SizedBox(width: 8),
// // //                     Expanded(
// // //                       child: Text(
// // //                         'Live location sharing is active. ${widget.selectedTowProvider != null ? widget.selectedTowProvider!.driverName : 'Tow providers'} can track your location.',
// // //                         style: TextStyle(fontSize: 12, color: Colors.blue[700]),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildUrgentServiceCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Service Priority',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Icon(Icons.emergency_rounded, color: _isUrgent ? Colors.red : Colors.grey),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         'Urgent Service',
// // //                         style: TextStyle(fontWeight: FontWeight.w600),
// // //                       ),
// // //                       Text(
// // //                         'Get priority response (Additional charges may apply)',
// // //                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Switch(
// // //                   value: _isUrgent,
// // //                   onChanged: (value) {
// // //                     setState(() {
// // //                       _isUrgent = value;
// // //                     });
// // //                   },
// // //                   activeThumbColor: Colors.red,
// // //                 ),
// // //               ],
// // //             ),
// // //             if (_isUrgent) ...[
// // //               SizedBox(height: 12),
// // //               Container(
// // //                 padding: EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.red.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //                 child: Row(
// // //                   children: [
// // //                     Icon(Icons.info_rounded, color: Colors.red, size: 20),
// // //                     SizedBox(width: 8),
// // //                     Expanded(
// // //                       child: Text(
// // //                         'Urgent service ensures faster response time. Additional charges: ₹500',
// // //                         style: TextStyle(fontSize: 12, color: Colors.red[700]),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSubmitButton() {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       child: ElevatedButton(
// // //         onPressed: _submitRequest,
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: Color(0xFF8B5CF6),
// // //           foregroundColor: Colors.white,
// // //           padding: EdgeInsets.symmetric(vertical: 16),
// // //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //         ),
// // //         child: Text(
// // //           widget.selectedTowProvider != null
// // //               ? 'Request Service from ${widget.selectedTowProvider!.driverName}'
// // //               : 'Request Tow Service',
// // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //           textAlign: TextAlign.center,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(widget.selectedTowProvider != null
// // //             ? 'Request - ${widget.selectedTowProvider!.driverName}'
// // //             : 'Tow Service Request'),
// // //         backgroundColor: Color(0xFF8B5CF6),
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: EdgeInsets.all(16),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             children: [
// // //               if (widget.selectedTowProvider != null) ...[
// // //                 _buildSelectedProviderCard(),
// // //                 SizedBox(height: 20),
// // //               ],

// // //               if (_userEmail != null) ...[
// // //                 Container(
// // //                   padding: EdgeInsets.all(12),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.green[50],
// // //                     borderRadius: BorderRadius.circular(10),
// // //                     border: Border.all(color: Colors.green),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       Icon(Icons.check_circle, color: Colors.green, size: 16),
// // //                       SizedBox(width: 8),
// // //                       Expanded(
// // //                         child: Text(
// // //                           'Logged in as: $_userEmail',
// // //                           style: TextStyle(fontSize: 12, color: Colors.green[800]),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 12),
// // //               ],

// // //               _buildServiceTypeCard(),
// // //               SizedBox(height: 12),
// // //               _buildPersonalDetailsCard(),
// // //               SizedBox(height: 12),
// // //               _buildVehicleDetailsCard(),
// // //               SizedBox(height: 12),
// // //               _buildLocationCard(),
// // //               SizedBox(height: 12),
// // //               _buildUrgentServiceCard(),
// // //               SizedBox(height: 16),
// // //               _buildSubmitButton(),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class TowRequestConfirmation extends StatelessWidget {
// // //   final String requestId;
// // //   final String vehicleNumber;
// // //   final String issueType;
// // //   final String towType;
// // //   final bool isUrgent;
// // //   final bool isLiveLocationEnabled;
// // //   final String? towProviderName;
// // //   final double? distance;

// // //   const TowRequestConfirmation({
// // //     super.key,
// // //     required this.requestId,
// // //     required this.vehicleNumber,
// // //     required this.issueType,
// // //     required this.towType,
// // //     required this.isUrgent,
// // //     required this.isLiveLocationEnabled,
// // //     this.towProviderName,
// // //     this.distance,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Dialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(24),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
// // //             SizedBox(height: 16),
// // //             Text(
// // //               'Tow Request Sent!',
// // //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //             ),
// // //             SizedBox(height: 16),
// // //             Text(
// // //               towProviderName != null
// // //                   ? 'Your tow request has been sent to $towProviderName'
// // //                   : 'Your tow service request has been submitted successfully.',
// // //               textAlign: TextAlign.center,
// // //               style: TextStyle(color: Colors.grey[600]),
// // //             ),
// // //             SizedBox(height: 8),
// // //             if (towProviderName != null && distance != null)
// // //               Container(
// // //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.blue[50],
// // //                   borderRadius: BorderRadius.circular(8),
// // //                 ),
// // //                 child: Text(
// // //                   '${distance!.toStringAsFixed(1)} km away • ${isLiveLocationEnabled ? 'Live Location On' : 'Standard Service'}',
// // //                   style: TextStyle(
// // //                     color: Colors.blue[700],
// // //                     fontWeight: FontWeight.w600,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ),
// // //             SizedBox(height: 20),
// // //             _buildDetailRow('Request ID', requestId),
// // //             _buildDetailRow('Vehicle', vehicleNumber),
// // //             _buildDetailRow('Issue Type', issueType),
// // //             _buildDetailRow('Service Type', towType),
// // //             if (towProviderName != null) _buildDetailRow('Tow Provider', towProviderName!),
// // //             _buildDetailRow('Priority', isUrgent ? 'Urgent' : 'Standard'),
// // //             _buildDetailRow('Live Location', isLiveLocationEnabled ? 'Enabled' : 'Disabled'),
// // //             SizedBox(height: 24),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: OutlinedButton(
// // //                     onPressed: () => Navigator.of(context).pushAndRemoveUntil(
// // //                       MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// // //                       (route) => false,
// // //                     ),
// // //                     child: Text('Back to Home'),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: ElevatedButton(
// // //                     onPressed: () {
// // //                       Navigator.pop(context);
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (context) => NotificationsPage(),
// // //                         ),
// // //                       );
// // //                     },
// // //                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8B5CF6)),
// // //                     child: Text('View Notifications'),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDetailRow(String label, String value) {
// // //     return Padding(
// // //       padding: EdgeInsets.symmetric(vertical: 4),
// // //       child: Row(
// // //         children: [
// // //           Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
// // //           SizedBox(width: 8),
// // //           Expanded(
// // //             child: Text(
// // //               value,
// // //               style: TextStyle(color: Colors.grey[700]),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class TowProvider {
// // //   final String id;
// // //   final String driverName;
// // //   final String email;
// // //   final String truckNumber;
// // //   final String truckType;
// // //   final String serviceLocation;
// // //   final double distance;
// // //   final double rating;
// // //   final int totalJobs;
// // //   final bool isAvailable;
// // //   final double latitude;
// // //   final double longitude;
// // //   final bool isOnline;

// // //   TowProvider({
// // //     required this.id,
// // //     required this.driverName,
// // //     required this.email,
// // //     required this.truckNumber,
// // //     required this.truckType,
// // //     required this.serviceLocation,
// // //     required this.distance,
// // //     required this.rating,
// // //     required this.totalJobs,
// // //     required this.isAvailable,
// // //     required this.latitude,
// // //     required this.longitude,
// // //     required this.isOnline,
// // //   });
// // // }

// // TowRequest.dart
// import 'dart:async';
// import 'dart:math';
// import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// import 'package:smart_road_app/VehicleOwner/notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:geolocator/geolocator.dart';

// class TowServiceRequestScreen extends StatefulWidget {
//   const TowServiceRequestScreen({super.key});

//   @override
//   _TowServiceRequestScreenState createState() => _TowServiceRequestScreenState();
// }

// class _TowServiceRequestScreenState extends State<TowServiceRequestScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _vehicleNumberController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   String? _userEmail;
//   String? _userId;
//   Position? _currentPosition;
//   bool _isGettingLocation = false;

//   String _selectedVehicleType = 'Car';
//   String _selectedIssueType = 'Breakdown';
//   String _selectedTowType = 'Standard Tow';
//   bool _isUrgent = false;

//   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
//   final List<String> _issueTypes = ['Breakdown', 'Accident', 'Flat Tire', 'Out of Fuel', 'Battery Issue', 'Lockout', 'Other'];
//   final List<String> _towTypes = ['Standard Tow', 'Flatbed Tow', 'Wheel-Lift Tow', 'Heavy Duty Tow'];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _getCurrentLocation();
//   }

//   Future<void> _loadUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     setState(() {
//       _userEmail = user?.email;
//       _userId = user?.uid;
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isGettingLocation = true;
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location services are disabled. Please enable them.')),
//         );
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')),
//           );
//           return;
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentPosition = position;
//         _isGettingLocation = false;
//         _locationController.text = '${position.latitude}, ${position.longitude}';
//       });

//       // Get nearby providers and show selection
//       _showNearbyProviders(position);

//     } catch (e) {
//       setState(() {
//         _isGettingLocation = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//     }
//   }

//   Future<void> _showNearbyProviders(Position userLocation) async {
//     try {
//       // Show loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Finding nearby tow providers...'),
//             ],
//           ),
//         ),
//       );

//       // Get nearby providers
//       List<Map<String, dynamic>> nearbyProviders = await _fetchNearbyProviders(userLocation);

//       // Close loading dialog
//       Navigator.of(context).pop();

//       if (nearbyProviders.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No tow providers found nearby. Using general request system.')),
//         );
//         return;
//       }

//       // Show provider selection
//       await showDialog(
//         context: context,
//         builder: (context) => NearbyProvidersDialog(
//           providers: nearbyProviders,
//           userLocation: userLocation,
//           userEmail: _userEmail,
//           onProviderSelected: (provider) {
//             _submitRequestToProvider(provider, userLocation);
//           },
//         ),
//       );

//     } catch (e) {
//       Navigator.of(context).pop();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error finding providers: $e')),
//       );
//     }
//   }

//   Future<List<Map<String, dynamic>>> _fetchNearbyProviders(Position userLocation) async {
//     List<Map<String, dynamic>> nearbyProviders = [];

//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('tow')
//           .get();

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
//               userLocation.latitude,
//               userLocation.longitude,
//               providerLat,
//               providerLon,
//             );

//             if (distance <= 20.0) { // 20 km radius
//               nearbyProviders.add({
//                 ...providerData,
//                 'distance': distance,
//                 'docId': doc.id,
//               });
//             }
//           }
//         }
//       }

//       // Sort by distance
//       nearbyProviders.sort((a, b) => a['distance'].compareTo(b['distance']));

//     } catch (e) {
//       print('Error fetching providers: $e');
//     }

//     return nearbyProviders;
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

//   void _submitRequestToProvider(Map<String, dynamic> provider, Position userLocation) {
//     // Navigate to request form with selected provider
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TowServiceRequestForm(
//           selectedProvider: provider,
//           userLocation: userLocation,
//           userEmail: _userEmail,
//         ),
//       ),
//     );
//   }

//   void _submitGeneralRequest() {
//     if (!_formKey.currentState!.validate()) return;

//     if (_currentPosition == null && _locationController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enable location or enter your location manually')),
//       );
//       return;
//     }

//     _submitRequest();
//   }

//   void _submitRequest() async {
//     final requestId = 'TOW${DateTime.now().millisecondsSinceEpoch}';
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     final requestData = {
//       "name": _nameController.text,
//       "phone": _phoneController.text,
//       "location": _locationController.text,
//       "description": _descriptionController.text,
//       "requestId": requestId,
//       "vehicleNumber": _vehicleNumberController.text,
//       "vehicleType": _selectedVehicleType,
//       "issueType": _selectedIssueType,
//       "towType": _selectedTowType,
//       "isUrgent": _isUrgent,
//       "status": "pending",
//       "timestamp": timestamp,
//       "userEmail": _userEmail,
//       "userId": _userId,
//       "latitude": _currentPosition?.latitude,
//       "longitude": _currentPosition?.longitude,
//     };

//     try {
//       await FirebaseFirestore.instance
//           .collection('owner')
//           .doc(_userEmail)
//           .collection("towrequest")
//           .doc(requestId)
//           .set(requestData);

//       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
//       await dbRef.child('tow_requests').child(requestId).set({
//         ...requestData,
//         'notificationRead': false,
//         'adminRead': false,
//       });

//       showDialog(
//         context: context,
//         builder: (context) => TowRequestConfirmation(
//           requestId: requestId,
//           vehicleNumber: _vehicleNumberController.text,
//           issueType: _selectedIssueType,
//           towType: _selectedTowType,
//           isUrgent: _isUrgent,
//           isLiveLocationEnabled: false,
//         ),
//       );

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tow Service Request'),
//         backgroundColor: Color(0xFF6D28D9),
//       ),
//       body: _isGettingLocation
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildLocationCard(),
//                     SizedBox(height: 12),
//                     _buildPersonalDetailsCard(),
//                     SizedBox(height: 12),
//                     _buildVehicleDetailsCard(),
//                     SizedBox(height: 12),
//                     _buildServiceTypeCard(),
//                     SizedBox(height: 12),
//                     _buildUrgentServiceCard(),
//                     SizedBox(height: 16),
//                     _buildSubmitButton(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildLocationCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Location Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             if (_currentPosition != null) ...[
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.green),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.location_on_rounded, color: Colors.green),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Location captured: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12),
//             ],
//             TextFormField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: 'Location',
//                 hintText: 'Enter your location',
//                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your location';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: _isGettingLocation ? null : _getCurrentLocation,
//                 icon: _isGettingLocation
//                     ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
//                     : Icon(Icons.gps_fixed_rounded),
//                 label: Text(_isGettingLocation ? 'Getting Location...' : 'Refresh Location'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPersonalDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Personal Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVehicleDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Vehicle Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _vehicleNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Vehicle Number',
//                 hintText: 'e.g., MH12AB1234',
//                 prefixIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter vehicle number';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedVehicleType,
//               decoration: InputDecoration(
//                 labelText: 'Vehicle Type',
//                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _vehicleTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedVehicleType = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Additional Details',
//                 hintText: 'Describe your issue in detail...',
//                 prefixIcon: Icon(Icons.description_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               maxLines: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceTypeCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Service Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedTowType,
//               decoration: InputDecoration(
//                 labelText: 'Tow Service Type',
//                 prefixIcon: Icon(Icons.local_shipping_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _towTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedTowType = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedIssueType,
//               decoration: InputDecoration(
//                 labelText: 'Issue Type',
//                 prefixIcon: Icon(Icons.warning_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _issueTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedIssueType = value!;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUrgentServiceCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Service Priority',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(Icons.emergency_rounded, color: _isUrgent ? Colors.red : Colors.grey),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Urgent Service',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       Text(
//                         'Get priority response (Additional charges may apply)',
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Switch(
//                   value: _isUrgent,
//                   onChanged: (value) {
//                     setState(() {
//                       _isUrgent = value;
//                     });
//                   },
//                   activeThumbColor: Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _submitGeneralRequest,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF6D28D9),
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: Text(
//           'Request Tow Service',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class NearbyProvidersDialog extends StatelessWidget {
//   final List<Map<String, dynamic>> providers;
//   final Position userLocation;
//   final String? userEmail;
//   final Function(Map<String, dynamic>) onProviderSelected;

//   const NearbyProvidersDialog({
//     super.key,
//     required this.providers,
//     required this.userLocation,
//     required this.userEmail,
//     required this.onProviderSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         width: double.maxFinite,
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Nearby Tow Providers',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Select a provider for your tow service:',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             Container(
//               height: 300,
//               child: ListView.builder(
//                 itemCount: providers.length,
//                 itemBuilder: (context, index) {
//                   return _buildProviderCard(providers[index], context);
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Continue without selecting'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProviderCard(Map<String, dynamic> provider, BuildContext context) {
//     final double distance = provider['distance'];
//     final String driverName = provider['driverName'] ?? 'Unknown Driver';
//     final String truckType = provider['truckType'] ?? 'Not Specified';
//     final String truckNumber = provider['truckNumber'] ?? 'Not Available';
//     final double rating = (provider['rating'] ?? 0.0).toDouble();
//     final int totalJobs = provider['totalJobs'] ?? 0;
//     final bool isOnline = provider['isOnline'] ?? false;

//     String calculateETA(double distance) {
//       double timeInHours = distance / 40; // 40 km/h average speed
//       int minutes = (timeInHours * 60).ceil();
//       return '${minutes} min';
//     }

//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Color(0xFF6D28D9).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(Icons.local_shipping, color: Color(0xFF6D28D9)),
//         ),
//         title: Row(
//           children: [
//             Text(driverName, style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(width: 8),
//             if (isOnline)
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text('Online', style: TextStyle(color: Colors.white, fontSize: 10)),
//               ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(truckType),
//             Text('Truck: $truckNumber'),
//             Row(
//               children: [
//                 Icon(Icons.star, color: Colors.amber, size: 16),
//                 SizedBox(width: 4),
//                 Text(rating.toStringAsFixed(1)),
//                 SizedBox(width: 8),
//                 Icon(Icons.work, color: Colors.grey, size: 16),
//                 SizedBox(width: 4),
//                 Text('$totalJobs jobs'),
//               ],
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('${distance.toStringAsFixed(1)} km', style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(calculateETA(distance), style: TextStyle(fontSize: 12, color: Colors.green)),
//           ],
//         ),
//         onTap: () {
//           Navigator.of(context).pop();
//           onProviderSelected(provider);
//         },
//       ),
//     );
//   }
// }

// class TowServiceRequestForm extends StatefulWidget {
//   final Map<String, dynamic> selectedProvider;
//   final Position userLocation;
//   final String? userEmail;

//   const TowServiceRequestForm({
//     super.key,
//     required this.selectedProvider,
//     required this.userLocation,
//     required this.userEmail,
//   });

//   @override
//   _TowServiceRequestFormState createState() => _TowServiceRequestFormState();
// }

// class _TowServiceRequestFormState extends State<TowServiceRequestForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _vehicleNumberController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   String? _userId;

//   String _selectedVehicleType = 'Car';
//   String _selectedIssueType = 'Breakdown';
//   String _selectedTowType = 'Standard Tow';
//   bool _isUrgent = false;

//   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
//   final List<String> _issueTypes = ['Breakdown', 'Accident', 'Flat Tire', 'Out of Fuel', 'Battery Issue', 'Lockout', 'Other'];
//   final List<String> _towTypes = ['Standard Tow', 'Flatbed Tow', 'Wheel-Lift Tow', 'Heavy Duty Tow'];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _initializeForm();
//   }

//   Future<void> _loadUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     setState(() {
//       _userId = user?.uid;
//     });
//   }

//   void _initializeForm() {
//     _locationController.text = '${widget.userLocation.latitude.toStringAsFixed(6)}, ${widget.userLocation.longitude.toStringAsFixed(6)}';
//   }

//   void _submitRequest() async {
//     if (!_formKey.currentState!.validate()) return;

//     final requestId = 'TOW${DateTime.now().millisecondsSinceEpoch}';
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     String calculateETA(double distance) {
//       double timeInHours = distance / 40;
//       int minutes = (timeInHours * 60).ceil();
//       return '${minutes} min';
//     }

//     final requestData = {
//       "name": _nameController.text,
//       "phone": _phoneController.text,
//       "location": _locationController.text,
//       "description": _descriptionController.text,
//       "requestId": requestId,
//       "vehicleNumber": _vehicleNumberController.text,
//       "vehicleType": _selectedVehicleType,
//       "issueType": _selectedIssueType,
//       "towType": _selectedTowType,
//       "isUrgent": _isUrgent,
//       "status": "pending",
//       "timestamp": timestamp,
//       "userEmail": widget.userEmail,
//       "userId": _userId,
//       "latitude": widget.userLocation.latitude,
//       "longitude": widget.userLocation.longitude,
//       "providerId": widget.selectedProvider['docId'],
//       "providerName": widget.selectedProvider['driverName'],
//       "providerEmail": widget.selectedProvider['email'],
//       "providerTruckType": widget.selectedProvider['truckType'],
//       "providerTruckNumber": widget.selectedProvider['truckNumber'],
//       "distance": widget.selectedProvider['distance'],
//       "estimatedArrival": calculateETA(widget.selectedProvider['distance']),
//     };

//     try {
//       // Save to user's requests
//       await FirebaseFirestore.instance
//           .collection('owner')
//           .doc(widget.userEmail)
//           .collection("towrequest")
//           .doc(requestId)
//           .set(requestData);

//       // Save to provider's incoming requests
//       await FirebaseFirestore.instance
//           .collection('tow')
//           .doc(widget.selectedProvider['docId'])
//           .collection('incoming_requests')
//           .doc(requestId)
//           .set({
//             ...requestData,
//             'providerNotificationRead': false,
//           });

//       // Save to realtime database
//       final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
//       await dbRef.child('tow_requests').child(requestId).set({
//         ...requestData,
//         'notificationRead': false,
//         'adminRead': false,
//       });

//       // Create notification for provider
//       final providerNotificationRef = dbRef
//           .child('provider_notifications')
//           .child(widget.selectedProvider['docId'])
//           .push();

//       await providerNotificationRef.set({
//         'id': providerNotificationRef.key,
//         'requestId': requestId,
//         'title': 'New Tow Request',
//         'message': 'New tow request from ${_nameController.text} for ${_vehicleNumberController.text}',
//         'timestamp': timestamp,
//         'read': false,
//         'type': 'new_tow_request',
//         'userEmail': widget.userEmail,
//         'vehicleNumber': _vehicleNumberController.text,
//         'location': _locationController.text,
//         'distance': widget.selectedProvider['distance'],
//         'estimatedArrival': calculateETA(widget.selectedProvider['distance']),
//       });

//       // Show confirmation
//       _showConfirmationDialog(requestId, calculateETA(widget.selectedProvider['distance']));

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
//       );
//     }
//   }

//   void _showConfirmationDialog(String requestId, String eta) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green),
//             SizedBox(width: 8),
//             Text('Request Sent!'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Your tow service request has been sent to:'),
//             SizedBox(height: 8),
//             Text(
//               widget.selectedProvider['driverName'],
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 4),
//             Text('Truck: ${widget.selectedProvider['truckNumber']}'),
//             Text('Type: ${widget.selectedProvider['truckType']}'),
//             SizedBox(height: 8),
//             Text(
//               'Estimated arrival: $eta',
//               style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Request ID: $requestId',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
//                 (route) => false,
//               );
//             },
//             child: Text('Back to Home'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProviderInfoCard() {
//     String calculateETA(double distance) {
//       double timeInHours = distance / 40;
//       int minutes = (timeInHours * 60).ceil();
//       return '${minutes} min';
//     }

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Selected Provider',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             ListTile(
//               leading: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.local_shipping, color: Color(0xFF6D28D9)),
//               ),
//               title: Text(
//                 widget.selectedProvider['driverName'],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.selectedProvider['truckType']),
//                   Text('Truck: ${widget.selectedProvider['truckNumber']}'),
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, size: 14, color: Colors.grey),
//                       SizedBox(width: 4),
//                       Text(
//                         '${widget.selectedProvider['distance'].toStringAsFixed(1)} km away',
//                         style: TextStyle(color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               trailing: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     calculateETA(widget.selectedProvider['distance']),
//                     style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//                   ),
//                   Text('ETA', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPersonalDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Personal Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVehicleDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Vehicle Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _vehicleNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Vehicle Number',
//                 hintText: 'e.g., MH12AB1234',
//                 prefixIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter vehicle number';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedVehicleType,
//               decoration: InputDecoration(
//                 labelText: 'Vehicle Type',
//                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _vehicleTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedVehicleType = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Additional Details',
//                 hintText: 'Describe your issue in detail...',
//                 prefixIcon: Icon(Icons.description_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               maxLines: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceTypeCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Service Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedTowType,
//               decoration: InputDecoration(
//                 labelText: 'Tow Service Type',
//                 prefixIcon: Icon(Icons.local_shipping_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _towTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedTowType = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _selectedIssueType,
//               decoration: InputDecoration(
//                 labelText: 'Issue Type',
//                 prefixIcon: Icon(Icons.warning_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _issueTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedIssueType = value!;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUrgentServiceCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Service Priority',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(Icons.emergency_rounded, color: _isUrgent ? Colors.red : Colors.grey),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Urgent Service',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       Text(
//                         'Get priority response (Additional charges may apply)',
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Switch(
//                   value: _isUrgent,
//                   onChanged: (value) {
//                     setState(() {
//                       _isUrgent = value;
//                     });
//                   },
//                   activeThumbColor: Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _submitRequest,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF6D28D9),
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: Text(
//           'Confirm Tow Request',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tow Service Request'),
//         backgroundColor: Color(0xFF6D28D9),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildProviderInfoCard(),
//               SizedBox(height: 12),
//               _buildPersonalDetailsCard(),
//               SizedBox(height: 12),
//               _buildVehicleDetailsCard(),
//               SizedBox(height: 12),
//               _buildServiceTypeCard(),
//               SizedBox(height: 12),
//               _buildUrgentServiceCard(),
//               SizedBox(height: 16),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TowRequestConfirmation extends StatelessWidget {
//   final String requestId;
//   final String vehicleNumber;
//   final String issueType;
//   final String towType;
//   final bool isUrgent;
//   final bool isLiveLocationEnabled;

//   const TowRequestConfirmation({
//     super.key,
//     required this.requestId,
//     required this.vehicleNumber,
//     required this.issueType,
//     required this.towType,
//     required this.isUrgent,
//     required this.isLiveLocationEnabled,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
//             SizedBox(height: 16),
//             Text(
//               'Tow Request Sent!',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Your tow service request has been submitted successfully.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             _buildDetailRow('Request ID', requestId),
//             _buildDetailRow('Vehicle', vehicleNumber),
//             _buildDetailRow('Issue Type', issueType),
//             _buildDetailRow('Service Type', towType),
//             _buildDetailRow('Priority', isUrgent ? 'Urgent' : 'Standard'),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
//                       (route) => false,
//                     ),
//                     child: Text('Back to Home'),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NotificationsPage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
//                     child: Text('View Notifications'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
//           SizedBox(width: 8),
//           Text(value),
//         ],
//       ),
//     );
//   }

// }

import 'package:smart_road_app/VehicleOwner/nearby_tow_provider_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;

class TowServiceRequestScreen extends StatefulWidget {
  final TowProvider selectedProvider;
  final Position userLocation;
  final String? userEmail;

  const TowServiceRequestScreen({
    super.key,
    required this.selectedProvider,
    required this.userLocation,
    required this.userEmail,
  });

  @override
  _TowServiceRequestScreenState createState() =>
      _TowServiceRequestScreenState();
}

class _TowServiceRequestScreenState extends State<TowServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  String _selectedVehicleType = 'Car';
  String _selectedIssueType = 'Breakdown';
  bool _isUrgent = false;

  final List<String> _vehicleTypes = [
    'Car',
    'SUV',
    'Truck',
    'Motorcycle',
    'Bus',
    'Other',
  ];
  final List<String> _issueTypes = [
    'Breakdown',
    'Accident',
    'Flat Tire',
    'Out of Fuel',
    'Battery Issue',
    'Lockout',
    'Other',
  ];

  // Location variables
  Position? _currentPosition;
  bool _isGettingLocation = false;
  String _locationAddress = '';

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    _initializeLocation();
  }

  void _prefillUserData() {
    _nameController.text = 'Vehicle Owner';
    _phoneController.text = '+91XXXXXXXXXX';
  }

  Future<void> _initializeLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationController.text =
            '${position.latitude}, ${position.longitude}';
      });

      await _getAddressFromLatLng(position);
    } catch (e) {
      print('Error getting initial location: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isGettingLocation = false;
        _locationController.text =
            '${position.latitude}, ${position.longitude}';
      });

      await _getAddressFromLatLng(position);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location captured: ${_locationAddress.isNotEmpty ? _locationAddress : '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'}',
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final geo.Placemark place = placemarks.first;

        final List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        setState(() {
          _locationAddress = addressParts.isNotEmpty
              ? addressParts.join(', ')
              : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        });
      } else {
        setState(() {
          _locationAddress =
              '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        _locationAddress =
            '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}';
      });
    }
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly.');
      return;
    }

    if (widget.userEmail == null || widget.userEmail!.isEmpty) {
      _showErrorSnackBar('User not authenticated. Please login again.');
      return;
    }

    // Ensure we have location
    if (_currentPosition == null && _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enable location or enter your location manually',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final requestId = 'TOW${DateTime.now().millisecondsSinceEpoch}';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // Prepare request data
      Map<String, dynamic> requestData = {
        "requestId": requestId,
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "vehicleNumber": _vehicleNumberController.text.trim(),
        "vehicleType": _selectedVehicleType,
        "issueType": _selectedIssueType,
        "location": _locationController.text.trim(),
        "description": _descriptionController.text.trim(),
        "isUrgent": _isUrgent,
        "status": "pending",
        "timestamp": timestamp,
        "userEmail": widget.userEmail,
        "userId": userId,
        // Location data
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
        "address": _locationAddress,
        // Tow provider information
        "providerId": widget.selectedProvider.id,
        "providerName": widget.selectedProvider.driverName,
        "providerPhone": widget.selectedProvider.phone,
        "providerEmail": widget.selectedProvider.email,
        "truckNumber": widget.selectedProvider.truckNumber,
        "truckType": widget.selectedProvider.truckType,
        "providerRating": widget.selectedProvider.rating,
        "providerLatitude": widget.selectedProvider.latitude,
        "providerLongitude": widget.selectedProvider.longitude,
        "distance": widget.selectedProvider.distance,
        "userLatitude": widget.userLocation.latitude,
        "userLongitude": widget.userLocation.longitude,
      };

      print(
        '📡 Submitting tow request to ${widget.selectedProvider.driverName}',
      );

      // 1. Save to user's collection
      await FirebaseFirestore.instance
          .collection('owner')
          .doc(widget.userEmail)
          .collection("tow_requests")
          .doc(requestId)
          .set(requestData);

      // 2. Save to provider's service_requests collection (NESTED STRUCTURE)
      await FirebaseFirestore.instance
          .collection('tow_providers')
          .doc(widget.selectedProvider.id)
          .collection('service_requests')
          .doc(requestId)
          .set(requestData);

      // 3. Save to Realtime Database for notifications
      final Map<String, dynamic> realtimeData = Map<String, dynamic>.from(requestData);
      
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('tow_requests').child(requestId).set({
        ...realtimeData,
        'notificationRead': false,
        'providerRead': false,
      });

      // 4. Create user notification
      final userNotificationRef = dbRef
          .child('notifications')
          .child(userId ?? 'unknown')
          .push();

      await userNotificationRef.set({
        'id': userNotificationRef.key,
        'requestId': requestId,
        'title': 'Tow Service Request Submitted',
        'message':
            'Your tow request has been sent to ${widget.selectedProvider.driverName}.',
        'timestamp': timestamp,
        'read': false,
        'type': 'tow_request_submitted',
        'vehicleNumber': _vehicleNumberController.text,
        'providerName': widget.selectedProvider.driverName,
        'status': 'pending',
      });

      // 5. Create provider notification
      final String sanitizedProviderId = widget.selectedProvider.id
          .replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
      
      final providerNotificationRef = dbRef
          .child('tow_provider_notifications')
          .child(sanitizedProviderId)
          .push();

      await providerNotificationRef.set({
        'id': providerNotificationRef.key,
        'requestId': requestId,
        'title': 'New Tow Request',
        'message':
            'New tow request from ${_nameController.text} for ${_vehicleNumberController.text}',
        'timestamp': timestamp,
        'read': false,
        'type': 'new_tow_request',
        'userEmail': widget.userEmail,
        'vehicleNumber': _vehicleNumberController.text,
        'location': _locationController.text,
        'issueType': _selectedIssueType,
        'isUrgent': _isUrgent,
        'userId': userId,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'address': _locationAddress,
      });

      print('✅ Tow request submitted successfully!');

      // Show success dialog
      _showSuccessDialog(requestId);
    } catch (e) {
      print('❌ Error submitting tow request: $e');
      _showErrorSnackBar('Failed to submit request: ${e.toString()}');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog(String requestId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Tow Request Sent!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your tow request has been sent to ${widget.selectedProvider.driverName}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.selectedProvider.distance.toStringAsFixed(1)} km away',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Request ID', requestId),
            _buildDetailRow('Vehicle', _vehicleNumberController.text),
            _buildDetailRow('Issue Type', _selectedIssueType),
            _buildDetailRow('Tow Provider', widget.selectedProvider.driverName),
            _buildDetailRow('Priority', _isUrgent ? 'Urgent' : 'Standard'),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back
                    },
                    child: Text('Back to Home'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      // Navigate to notifications or tracking page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Track Request'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(width: 8),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Tow - ${widget.selectedProvider.driverName}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isSubmitting ? _buildLoadingState() : _buildForm(),
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
            'Submitting your request...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Selected Provider Card
            _buildSelectedProviderCard(),
            SizedBox(height: 20),

            if (widget.userEmail != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Logged in as: ${widget.userEmail}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],

            _buildServiceDetailsCard(),
            SizedBox(height: 20),
            _buildPersonalDetailsCard(),
            SizedBox(height: 20),
            _buildVehicleDetailsCard(),
            SizedBox(height: 20),
            _buildLocationCard(),
            SizedBox(height: 20),
            _buildUrgentServiceCard(),
            SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProviderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.local_shipping, color: Colors.orange, size: 30),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedProvider.driverName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.selectedProvider.truckType,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${widget.selectedProvider.rating} (${widget.selectedProvider.reviews} reviews)',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.selectedProvider.distance.toStringAsFixed(1)} km away',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedIssueType,
              decoration: InputDecoration(
                labelText: 'Issue Type *',
                prefixIcon: Icon(Icons.warning_rounded, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _issueTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIssueType = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select issue type';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_rounded, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                prefixIcon: Icon(Icons.phone_rounded, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: 'Vehicle Number *',
                hintText: 'e.g., MH12AB1234',
                prefixIcon: Icon(
                  Icons.confirmation_number_rounded,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle number';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedVehicleType,
              decoration: InputDecoration(
                labelText: 'Vehicle Type *',
                prefixIcon: Icon(
                  Icons.directions_car_rounded,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _vehicleTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVehicleType = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select vehicle type';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Additional Details',
                hintText: 'Describe your issue in detail...',
                prefixIcon: Icon(
                  Icons.description_rounded,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),

            if (_currentPosition != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Location:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _locationAddress.isNotEmpty
                                ? _locationAddress
                                : '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],

            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location *',
                hintText: 'Enter your location or use button below',
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGettingLocation ? null : _getCurrentLocation,
                icon: _isGettingLocation
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.gps_fixed_rounded),
                label: Text(
                  _isGettingLocation
                      ? 'Getting Location...'
                      : 'Get Current Location',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentServiceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Priority',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.emergency_rounded,
                  color: _isUrgent ? Colors.red : Colors.grey,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Urgent Service',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Get priority response (Additional charges may apply)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value;
                    });
                  },
                  activeThumbColor: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Submitting...'),
                ],
              )
            : Text(
                'Request Tow from ${widget.selectedProvider.driverName}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}