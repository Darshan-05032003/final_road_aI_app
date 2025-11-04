// // // // Garage Service Request Form
// // // import 'dart:developer';

// // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart';

// // // class GarageServiceRequestScreen extends StatefulWidget {
// // //   const GarageServiceRequestScreen({super.key});

// // //   @override
// // //   _GarageServiceRequestScreenState createState() => _GarageServiceRequestScreenState();
// // // }

// // // class _GarageServiceRequestScreenState extends State<GarageServiceRequestScreen> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final TextEditingController _nameController = TextEditingController();
// // //   final TextEditingController _phoneController = TextEditingController();
// // //   final TextEditingController _vehicleNumberController = TextEditingController();
// // //   final TextEditingController _vehicleModelController = TextEditingController();
// // //   final TextEditingController _locationController = TextEditingController();
// // //   final TextEditingController _descriptionController = TextEditingController();
// // //   String? _userEmail;
// // //   bool _isSubmitting = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadUserData();
// // //   }

// // //   Future<void> _loadUserData() async {
// // //     try {
// // //       String? userEmail = await AuthService.getUserEmail();
// // //       setState(() {
// // //         _userEmail = userEmail;
// // //       });
// // //       print('✅ User email loaded: $_userEmail');
// // //     } catch (e) {
// // //       print('❌ Error loading user data: $e');
// // //       _showErrorSnackBar('Failed to load user data. Please try again.');
// // //     }
// // //   }

// // //   String _selectedVehicleType = 'Car';
// // //   String _selectedServiceType = 'General Repair';
// // //   String _selectedFuelType = 'Petrol';
// // //   DateTime? _preferredDate;
// // //   TimeOfDay? _preferredTime;
// // //   final List<String> _selectedIssues = [];

// // //   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
// // //   final List<String> _serviceTypes = ['General Repair', 'Engine Service', 'Brake Repair', 'AC Service', 'Electrical Repair', 'Denting & Painting', 'Periodic Maintenance'];
// // //   final List<String> _fuelTypes = ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'];
// // //   final List<String> _commonIssues = [
// // //     'Engine Problem',
// // //     'Brake Issues',
// // //     'AC Not Working',
// // //     'Electrical Fault',
// // //     'Suspension Problem',
// // //     'Transmission Issue',
// // //     'Battery Dead',
// // //     'Tire Puncture',
// // //     'Oil Change',
// // //     'Other'
// // //   ];

// // //   void _submitRequest() async {
// // //     if (!_formKey.currentState!.validate()) {
// // //       _showErrorSnackBar('Please fill all required fields correctly.');
// // //       return;
// // //     }

// // //     if (_userEmail == null || _userEmail!.isEmpty) {
// // //       _showErrorSnackBar('User not authenticated. Please login again.');
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isSubmitting = true;
// // //     });

// // //     try {
// // //       final requestId = 'GRG${DateTime.now().millisecondsSinceEpoch}';
// // //       final now = DateTime.now();

// // //       // Prepare the data
// // //       Map<String, dynamic> requestData = {
// // //         "requestId": requestId,
// // //         "vehicleNumber": _vehicleNumberController.text.trim(),
// // //         "serviceType": _selectedServiceType,
// // //         "preferredDate": _preferredDate ?? now,
// // //         "preferredTime": _preferredTime != null ? _preferredTime!.format(context) : 'Not specified',
// // //         "name": _nameController.text.trim(),
// // //         "phone": _phoneController.text.trim(),
// // //         "location": _locationController.text.trim(),
// // //         "vehicleModel": _vehicleModelController.text.trim(),
// // //         "vehicleType": _selectedVehicleType,
// // //         "fuelType": _selectedFuelType,
// // //         "description": _descriptionController.text.trim(),
// // //         "selectedIssues": _selectedIssues,
// // //         "status": "Pending",
// // //         "createdAt": FieldValue.serverTimestamp(),
// // //         "updatedAt": FieldValue.serverTimestamp(),
// // //         "userEmail": _userEmail,
// // //       };
// // //       log("visting");
// // //       print('📡 Submitting request to Firebase...');
// // //       print('📊 Request data: $requestData');

// // //       // Submit to Firebase
// // //       DocumentReference docRef = await FirebaseFirestore.instance
// // //           .collection('owner')
// // //           .doc(_userEmail)
// // //           .collection("garagerequest")
// // //           .add(requestData);

// // //       log('✅ Request submitted successfully! Document ID: ${docRef.id}');
// // // log("$_userEmail");
// // //       // Show success dialog
// // //       _showSuccessDialog(requestId);

// // //     } catch (e) {
// // //       log("$_userEmail");
// // //       log('❌ Error submitting request: $e');
// // //       _showErrorSnackBar('Failed to submit request: ${e.toString()}');
// // //     } finally {
// // //       setState(() {
// // //         _isSubmitting = false;
// // //       });
// // //     }
// // //   }

// // //   void _showSuccessDialog(String requestId) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => GarageRequestConfirmation(
// // //         requestId: requestId,
// // //         vehicleNumber: _vehicleNumberController.text,
// // //         serviceType: _selectedServiceType,
// // //         preferredDate: _preferredDate,
// // //         preferredTime: _preferredTime,
// // //         onClose: () {
// // //           // Clear form and navigate back
// // //           _clearForm();
// // //           Navigator.pop(context); // Close dialog
// // //           Navigator.pop(context); // Go back to previous screen
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   void _clearForm() {
// // //     _formKey.currentState?.reset();
// // //     _nameController.clear();
// // //     _phoneController.clear();
// // //     _vehicleNumberController.clear();
// // //     _vehicleModelController.clear();
// // //     _locationController.clear();
// // //     _descriptionController.clear();
// // //     setState(() {
// // //       _selectedVehicleType = 'Car';
// // //       _selectedServiceType = 'General Repair';
// // //       _selectedFuelType = 'Petrol';
// // //       _preferredDate = null;
// // //       _preferredTime = null;
// // //       _selectedIssues.clear();
// // //     });
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

// // //   Future<void> _selectDate(BuildContext context) async {
// // //     final DateTime? picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime.now(),
// // //       lastDate: DateTime.now().add(Duration(days: 30)),
// // //     );
// // //     if (picked != null && picked != _preferredDate) {
// // //       setState(() {
// // //         _preferredDate = picked;
// // //       });
// // //     }
// // //   }

// // //   Future<void> _selectTime(BuildContext context) async {
// // //     final TimeOfDay? picked = await showTimePicker(
// // //       context: context,
// // //       initialTime: TimeOfDay.now(),
// // //     );
// // //     if (picked != null && picked != _preferredTime) {
// // //       setState(() {
// // //         _preferredTime = picked;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Request Garage Service'),
// // //         backgroundColor: Color(0xFF6D28D9),
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: _isSubmitting ? _buildLoadingState() : _buildForm(),
// // //     );
// // //   }

// // //   Widget _buildLoadingState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           CircularProgressIndicator(color: Color(0xFF6D28D9)),
// // //           SizedBox(height: 16),
// // //           Text(
// // //             'Submitting your request...',
// // //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildForm() {
// // //     return SingleChildScrollView(
// // //       padding: EdgeInsets.all(16),
// // //       child: Form(
// // //         key: _formKey,
// // //         child: Column(
// // //           children: [
// // //             if (_userEmail != null) ...[
// // //               Container(
// // //                 padding: EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.green[50],
// // //                   borderRadius: BorderRadius.circular(10),
// // //                   border: Border.all(color: Colors.green),
// // //                 ),
// // //                 child: Row(
// // //                   children: [
// // //                     Icon(Icons.check_circle, color: Colors.green, size: 16),
// // //                     SizedBox(width: 8),
// // //                     Expanded(
// // //                       child: Text(
// // //                         'Logged in as: $_userEmail',
// // //                         style: TextStyle(fontSize: 12, color: Colors.green[800]),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               SizedBox(height: 12),
// // //             ],
// // //             _buildServiceTypeCard(),
// // //             SizedBox(height: 20),
// // //             _buildPersonalDetailsCard(),
// // //             SizedBox(height: 20),
// // //             _buildVehicleDetailsCard(),
// // //             SizedBox(height: 20),
// // //             _buildIssuesCard(),
// // //             SizedBox(height: 20),
// // //             _buildScheduleCard(),
// // //             SizedBox(height: 20),
// // //             _buildLocationCard(),
// // //             SizedBox(height: 30),
// // //             _buildSubmitButton(),
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
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             DropdownButtonFormField<String>(
// // //               value: _selectedServiceType,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Service Type *',
// // //                 prefixIcon: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               items: _serviceTypes.map((type) {
// // //                 return DropdownMenuItem(
// // //                   value: type,
// // //                   child: Text(type),
// // //                 );
// // //               }).toList(),
// // //               onChanged: (value) {
// // //                 setState(() {
// // //                   _selectedServiceType = value!;
// // //                 });
// // //               },
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please select service type';
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
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _nameController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Full Name *',
// // //                 prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
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
// // //                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
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
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _vehicleNumberController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Vehicle Number *',
// // //                 hintText: 'e.g., MH12AB1234',
// // //                 prefixIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF6D28D9)),
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
// // //             TextFormField(
// // //               controller: _vehicleModelController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Vehicle Model *',
// // //                 hintText: 'e.g., Toyota Camry 2022',
// // //                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter vehicle model';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: DropdownButtonFormField<String>(
// // //                     value: _selectedVehicleType,
// // //                     decoration: InputDecoration(
// // //                       labelText: 'Vehicle Type *',
// // //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //                     ),
// // //                     items: _vehicleTypes.map((type) {
// // //                       return DropdownMenuItem(
// // //                         value: type,
// // //                         child: Text(type),
// // //                       );
// // //                     }).toList(),
// // //                     onChanged: (value) {
// // //                       setState(() {
// // //                         _selectedVehicleType = value!;
// // //                       });
// // //                     },
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please select vehicle type';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: DropdownButtonFormField<String>(
// // //                     value: _selectedFuelType,
// // //                     decoration: InputDecoration(
// // //                       labelText: 'Fuel Type *',
// // //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //                     ),
// // //                     items: _fuelTypes.map((fuel) {
// // //                       return DropdownMenuItem(
// // //                         value: fuel,
// // //                         child: Text(fuel),
// // //                       );
// // //                     }).toList(),
// // //                     onChanged: (value) {
// // //                       setState(() {
// // //                         _selectedFuelType = value!;
// // //                       });
// // //                     },
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please select fuel type';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildIssuesCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Vehicle Issues',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             Text(
// // //               'Select the issues you are facing:',
// // //               style: TextStyle(color: Colors.grey[600]),
// // //             ),
// // //             SizedBox(height: 8),
// // //             Wrap(
// // //               spacing: 8,
// // //               runSpacing: 8,
// // //               children: _commonIssues.map((issue) {
// // //                 final isSelected = _selectedIssues.contains(issue);
// // //                 return FilterChip(
// // //                   label: Text(issue),
// // //                   selected: isSelected,
// // //                   onSelected: (selected) {
// // //                     setState(() {
// // //                       if (selected) {
// // //                         _selectedIssues.add(issue);
// // //                       } else {
// // //                         _selectedIssues.remove(issue);
// // //                       }
// // //                     });
// // //                   },
// // //                   selectedColor: Color(0xFF6D28D9).withOpacity(0.2),
// // //                   checkmarkColor: Color(0xFF6D28D9),
// // //                   labelStyle: TextStyle(
// // //                     color: isSelected ? Color(0xFF6D28D9) : Colors.grey[700],
// // //                   ),
// // //                 );
// // //               }).toList(),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _descriptionController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Additional Details',
// // //                 hintText: 'Describe your vehicle issues in detail...',
// // //                 prefixIcon: Icon(Icons.description_rounded, color: Color(0xFF6D28D9)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               maxLines: 3,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildScheduleCard() {
// // //     return Card(
// // //       elevation: 4,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Schedule Service',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: ListTile(
// // //                     leading: Icon(Icons.calendar_today_rounded, color: Color(0xFF6D28D9)),
// // //                     title: Text(
// // //                       _preferredDate == null ? 'Select Date *' :
// // //                       DateFormat('MMM dd, yyyy').format(_preferredDate!),
// // //                       style: TextStyle(
// // //                         color: _preferredDate == null ? Colors.grey : Colors.black,
// // //                       ),
// // //                     ),
// // //                     trailing: Icon(Icons.arrow_drop_down_rounded),
// // //                     onTap: () => _selectDate(context),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: ListTile(
// // //                     leading: Icon(Icons.access_time_rounded, color: Color(0xFF6D28D9)),
// // //                     title: Text(
// // //                       _preferredTime == null ? 'Select Time' :
// // //                       _preferredTime!.format(context),
// // //                       style: TextStyle(
// // //                         color: _preferredTime == null ? Colors.grey : Colors.black,
// // //                       ),
// // //                     ),
// // //                     trailing: Icon(Icons.arrow_drop_down_rounded),
// // //                     onTap: () => _selectTime(context),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             if (_preferredDate == null)
// // //               Padding(
// // //                 padding: EdgeInsets.only(top: 8),
// // //                 child: Text(
// // //                   'Please select a date',
// // //                   style: TextStyle(color: Colors.red, fontSize: 12),
// // //                 ),
// // //               ),
// // //             SizedBox(height: 12),
// // //             Container(
// // //               padding: EdgeInsets.all(12),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.blue.withOpacity(0.1),
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   Icon(Icons.info_rounded, color: Colors.blue, size: 20),
// // //                   SizedBox(width: 8),
// // //                   Expanded(
// // //                     child: Text(
// // //                       'We will confirm your appointment within 30 minutes',
// // //                       style: TextStyle(fontSize: 12, color: Colors.blue[700]),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
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
// // //               'Service Location',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// // //             ),
// // //             SizedBox(height: 12),
// // //             TextFormField(
// // //               controller: _locationController,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Service Address *',
// // //                 hintText: 'Enter your address for service',
// // //                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //               ),
// // //               validator: (value) {
// // //                 if (value == null || value.isEmpty) {
// // //                   return 'Please enter service address';
// // //                 }
// // //                 return null;
// // //               },
// // //             ),
// // //             SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Icon(Icons.home_work_rounded, color: Color(0xFF6D28D9)),
// // //                 SizedBox(width: 8),
// // //                 Text(
// // //                   'Service Options:',
// // //                   style: TextStyle(fontWeight: FontWeight.w500),
// // //                 ),
// // //               ],
// // //             ),
// // //             SizedBox(height: 8),
// // //             Row(
// // //               children: [
// // //                 _buildServiceOption('At Garage', Icons.build_circle_rounded),
// // //                 SizedBox(width: 12),
// // //                 _buildServiceOption('At Home', Icons.home_rounded),
// // //                 SizedBox(width: 12),
// // //                 _buildServiceOption('On Road', Icons.add_road_outlined),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildServiceOption(String title, IconData icon) {
// // //     return Expanded(
// // //       child: Card(
// // //         elevation: 2,
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //         child: Padding(
// // //           padding: EdgeInsets.all(12),
// // //           child: Column(
// // //             children: [
// // //               Icon(icon, color: Color(0xFF6D28D9), size: 20),
// // //               SizedBox(height: 4),
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
// // //                 textAlign: TextAlign.center,
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSubmitButton() {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       child: ElevatedButton(
// // //         onPressed: (){
// // //           log("visitng onpressed");
// // //           _submitRequest();
// // //         },
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: Color(0xFF6D28D9),
// // //           foregroundColor: Colors.white,
// // //           padding: EdgeInsets.symmetric(vertical: 16),
// // //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //         ),
// // //         child: _isSubmitting
// // //             ? Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   SizedBox(
// // //                     width: 20,
// // //                     height: 20,
// // //                     child: CircularProgressIndicator(
// // //                       strokeWidth: 2,
// // //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                     ),
// // //                   ),
// // //                   SizedBox(width: 12),
// // //                   Text('Submitting...'),
// // //                 ],
// // //               )
// // //             : Text(
// // //                 'Request Garage Service',
// // //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //               ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _nameController.dispose();
// // //     _phoneController.dispose();
// // //     _vehicleNumberController.dispose();
// // //     _vehicleModelController.dispose();
// // //     _locationController.dispose();
// // //     _descriptionController.dispose();
// // //     super.dispose();
// // //   }
// // // }

// // // // Garage Request Confirmation
// // // class GarageRequestConfirmation extends StatelessWidget {
// // //   final String requestId;
// // //   final String vehicleNumber;
// // //   final String serviceType;
// // //   final DateTime? preferredDate;
// // //   final TimeOfDay? preferredTime;
// // //   final VoidCallback onClose;

// // //   const GarageRequestConfirmation({
// // //     super.key,
// // //     required this.requestId,
// // //     required this.vehicleNumber,
// // //     required this.serviceType,
// // //     required this.preferredDate,
// // //     required this.preferredTime,
// // //     required this.onClose,
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
// // //               'Service Request Sent!',
// // //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //             ),
// // //             SizedBox(height: 16),
// // //             Text(
// // //               'Your garage service request has been submitted successfully.',
// // //               textAlign: TextAlign.center,
// // //               style: TextStyle(color: Colors.grey[600]),
// // //             ),
// // //             SizedBox(height: 20),
// // //             _buildDetailRow('Request ID', requestId),
// // //             _buildDetailRow('Vehicle', vehicleNumber),
// // //             _buildDetailRow('Service Type', serviceType),
// // //             if (preferredDate != null)
// // //               _buildDetailRow('Preferred Date', DateFormat('MMM dd, yyyy').format(preferredDate!)),
// // //             if (preferredTime != null)
// // //               _buildDetailRow('Preferred Time', preferredTime!.format(context)),
// // //             SizedBox(height: 24),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: OutlinedButton(
// // //                     onPressed: onClose,
// // //                     child: Text('Back to Home'),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: ElevatedButton(
// // //                     onPressed: () {
// // //                       // Navigate to tracking screen or stay
// // //                       onClose();
// // //                     },
// // //                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
// // //                     child: Text('Track Service'),
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

// // import 'dart:developer';
// // import 'dart:math' hide log;

// // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:intl/intl.dart';

// // // Nearby Garages Screen - Shows garages like Uber Auto
// // class NearbyGaragesScreen extends StatefulWidget {
// //   final Position userLocation;
// //   final String? userEmail;

// //   const NearbyGaragesScreen({
// //     super.key,
// //     required this.userLocation,
// //     required this.userEmail,
// //   });

// //   @override
// //   _NearbyGaragesScreenState createState() => _NearbyGaragesScreenState();
// // }

// // class _NearbyGaragesScreenState extends State<NearbyGaragesScreen> {
// //   List<Garage> _nearbyGarages = [];
// //   bool _isLoading = true;
// //   final Random _random = Random();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadNearbyGarages();
// //   }

// //   void _loadNearbyGarages() {
// //     // Simulate loading nearby garages
// //     Future.delayed(Duration(seconds: 2), () {
// //       setState(() {
// //         _nearbyGarages = _generateMockGarages();
// //         _isLoading = false;
// //       });
// //     });
// //   }

// //   List<Garage> _generateMockGarages() {
// //     final garages = [
// //       Garage(
// //         id: '1',
// //         name: 'City Auto Repair',
// //         address: '123 Main Street, City Center',
// //         distance: 1.2 + _random.nextDouble() * 3,
// //         rating: 4.5,
// //         reviews: 128,
// //         specialties: ['Engine Repair', 'Brake Service', 'AC Repair'],
// //         isAvailable: true,
// //         phone: '+1-234-567-8901',
// //         latitude: widget.userLocation.latitude + (_random.nextDouble() - 0.5) * 0.02,
// //         longitude: widget.userLocation.longitude + (_random.nextDouble() - 0.5) * 0.02,
// //       ),
// //       Garage(
// //         id: '2',
// //         name: 'Quick Fix Garage',
// //         address: '456 Park Avenue, Downtown',
// //         distance: 2.1 + _random.nextDouble() * 2,
// //         rating: 4.2,
// //         reviews: 89,
// //         specialties: ['Quick Service', 'Oil Change', 'Tire Repair'],
// //         isAvailable: true,
// //         phone: '+1-234-567-8902',
// //         latitude: widget.userLocation.latitude + (_random.nextDouble() - 0.5) * 0.02,
// //         longitude: widget.userLocation.longitude + (_random.nextDouble() - 0.5) * 0.02,
// //       ),
// //       Garage(
// //         id: '3',
// //         name: 'Pro Mechanics',
// //         address: '789 Tech Park, Industrial Area',
// //         distance: 3.5 + _random.nextDouble() * 4,
// //         rating: 4.8,
// //         reviews: 256,
// //         specialties: ['Transmission', 'Electrical', 'Diagnostics'],
// //         isAvailable: true,
// //         phone: '+1-234-567-8903',
// //         latitude: widget.userLocation.latitude + (_random.nextDouble() - 0.5) * 0.02,
// //         longitude: widget.userLocation.longitude + (_random.nextDouble() - 0.5) * 0.02,
// //       ),
// //       Garage(
// //         id: '4',
// //         name: '24/7 Emergency Repair',
// //         address: '321 Service Road, Highway',
// //         distance: 5.2 + _random.nextDouble() * 3,
// //         rating: 4.3,
// //         reviews: 167,
// //         specialties: ['Emergency Repair', 'Towing', 'Roadside Assistance'],
// //         isAvailable: true,
// //         phone: '+1-234-567-8904',
// //         latitude: widget.userLocation.latitude + (_random.nextDouble() - 0.5) * 0.02,
// //         longitude: widget.userLocation.longitude + (_random.nextDouble() - 0.5) * 0.02,
// //       ),
// //       Garage(
// //         id: '5',
// //         name: 'Luxury Car Specialists',
// //         address: '654 Premium Plaza, Uptown',
// //         distance: 7.8 + _random.nextDouble() * 2,
// //         rating: 4.9,
// //         reviews: 312,
// //         specialties: ['Luxury Vehicles', 'Performance', 'Detailing'],
// //         isAvailable: true,
// //         phone: '+1-234-567-8905',
// //         latitude: widget.userLocation.latitude + (_random.nextDouble() - 0.5) * 0.02,
// //         longitude: widget.userLocation.longitude + (_random.nextDouble() - 0.5) * 0.02,
// //       ),
// //     ];

// //     // Sort by distance
// //     garages.sort((a, b) => a.distance.compareTo(b.distance));
// //     return garages;
// //   }

// //   void _selectGarage(Garage garage) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => GarageServiceRequestScreen(
// //           selectedGarage: garage,
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
// //         title: Text('Nearby Garages & Mechanics'),
// //         backgroundColor: Color(0xFF6D28D9),
// //         foregroundColor: Colors.white,
// //       ),
// //       body: _isLoading ? _buildLoadingState() : _buildGaragesList(),
// //     );
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(color: Color(0xFF6D28D9)),
// //           SizedBox(height: 16),
// //           Text(
// //             'Finding nearby garages...',
// //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildGaragesList() {
// //     return Column(
// //       children: [
// //         // Header with user location
// //         Container(
// //           padding: EdgeInsets.all(16),
// //           color: Colors.grey[50],
// //           child: Row(
// //             children: [
// //               Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 20),
// //               SizedBox(width: 8),
// //               Expanded(
// //                 child: Text(
// //                   'Garages near your location (within 15 km)',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //               ),
// //               Text(
// //                 '${_nearbyGarages.length} found',
// //                 style: TextStyle(
// //                   color: Colors.green,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),

// //         Expanded(
// //           child: ListView.builder(
// //             padding: EdgeInsets.all(16),
// //             itemCount: _nearbyGarages.length,
// //             itemBuilder: (context, index) {
// //               final garage = _nearbyGarages[index];
// //               return _buildGarageCard(garage);
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildGarageCard(Garage garage) {
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
// //                 // Garage Avatar
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF6D28D9).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Icon(
// //                     Icons.build_circle_rounded,
// //                     color: Color(0xFF6D28D9),
// //                     size: 30,
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         garage.name,
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       SizedBox(height: 4),
// //                       Text(
// //                         garage.address,
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.grey[600],
// //                         ),
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
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
// //                 // Rating
// //                 Row(
// //                   children: [
// //                     Icon(Icons.star, color: Colors.amber, size: 16),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       garage.rating.toString(),
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       '(${garage.reviews} reviews)',
// //                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                     ),
// //                   ],
// //                 ),
// //                 Spacer(),
// //                 // Distance
// //                 Row(
// //                   children: [
// //                     Icon(Icons.location_on, color: Colors.red, size: 16),
// //                     SizedBox(width: 4),
// //                     Text(
// //                       '${garage.distance.toStringAsFixed(1)} km',
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 8),

// //             // Specialties
// //             Wrap(
// //               spacing: 8,
// //               runSpacing: 4,
// //               children: garage.specialties.take(3).map((specialty) => Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[50],
// //                   borderRadius: BorderRadius.circular(6),
// //                 ),
// //                 child: Text(
// //                   specialty,
// //                   style: TextStyle(
// //                     fontSize: 10,
// //                     color: Colors.blue[700],
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               )).toList(),
// //             ),
// //             SizedBox(height: 12),

// //             // Select Button
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () => _selectGarage(garage),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xFF6D28D9),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //                 child: Text('Select Garage'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Garage {
// //   final String id;
// //   final String name;
// //   final String address;
// //   final double distance;
// //   final double rating;
// //   final int reviews;
// //   final List<String> specialties;
// //   final bool isAvailable;
// //   final String phone;
// //   final double latitude;
// //   final double longitude;

// //   Garage({
// //     required this.id,
// //     required this.name,
// //     required this.address,
// //     required this.distance,
// //     required this.rating,
// //     required this.reviews,
// //     required this.specialties,
// //     required this.isAvailable,
// //     required this.phone,
// //     required this.latitude,
// //     required this.longitude,
// //   });
// // }

// // // Updated Garage Service Request Screen with Prefilled Data
// // class GarageServiceRequestScreen extends StatefulWidget {
// //   final Garage selectedGarage;
// //   final Position userLocation;
// //   final String? userEmail;

// //   const GarageServiceRequestScreen({
// //     super.key,
// //     required this.selectedGarage,
// //     required this.userLocation,
// //     required this.userEmail,
// //   });

// //   @override
// //   _GarageServiceRequestScreenState createState() => _GarageServiceRequestScreenState();
// // }

// // class _GarageServiceRequestScreenState extends State<GarageServiceRequestScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _vehicleNumberController = TextEditingController();
// //   final TextEditingController _vehicleModelController = TextEditingController();
// //   final TextEditingController _locationController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();

// //   bool _isSubmitting = false;
// //   String _selectedVehicleType = 'Car';
// //   String _selectedServiceType = 'General Repair';
// //   String _selectedFuelType = 'Petrol';
// //   DateTime? _preferredDate;
// //   TimeOfDay? _preferredTime;
// //   final List<String> _selectedIssues = [];

// //   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
// //   final List<String> _serviceTypes = ['General Repair', 'Engine Service', 'Brake Repair', 'AC Service', 'Electrical Repair', 'Denting & Painting', 'Periodic Maintenance'];
// //   final List<String> _fuelTypes = ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'];
// //   final List<String> _commonIssues = [
// //     'Engine Problem',
// //     'Brake Issues',
// //     'AC Not Working',
// //     'Electrical Fault',
// //     'Suspension Problem',
// //     'Transmission Issue',
// //     'Battery Dead',
// //     'Tire Puncture',
// //     'Oil Change',
// //     'Other'
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _prefillUserData();
// //   }

// //   void _prefillUserData() {
// //     // Prefill data from user profile (you can get this from SharedPreferences or Firestore)
// //     _nameController.text = 'Vehicle Owner'; // Default, can be updated from profile
// //     _phoneController.text = '+91XXXXXXXXXX'; // Default, can be updated from profile
// //     _locationController.text = 'Current Location'; // Can use geocoding to get address

// //     // You can add more prefilling logic here from user profile data
// //   }

// //   void _submitRequest() async {
// //     if (!_formKey.currentState!.validate()) {
// //       _showErrorSnackBar('Please fill all required fields correctly.');
// //       return;
// //     }

// //     if (widget.userEmail == null || widget.userEmail!.isEmpty) {
// //       _showErrorSnackBar('User not authenticated. Please login again.');
// //       return;
// //     }

// //     setState(() {
// //       _isSubmitting = true;
// //     });

// //     try {
// //       final requestId = 'GRG${DateTime.now().millisecondsSinceEpoch}';
// //       final now = DateTime.now();

// //       // Prepare the data with garage information
// //       Map<String, dynamic> requestData = {
// //         "requestId": requestId,
// //         "vehicleNumber": _vehicleNumberController.text.trim(),
// //         "serviceType": _selectedServiceType,
// //         "preferredDate": _preferredDate ?? now,
// //         "preferredTime": _preferredTime != null ? _preferredTime!.format(context) : 'Not specified',
// //         "name": _nameController.text.trim(),
// //         "phone": _phoneController.text.trim(),
// //         "location": _locationController.text.trim(),
// //         "vehicleModel": _vehicleModelController.text.trim(),
// //         "vehicleType": _selectedVehicleType,
// //         "fuelType": _selectedFuelType,
// //         "description": _descriptionController.text.trim(),
// //         "selectedIssues": _selectedIssues,
// //         "status": "Pending",
// //         "createdAt": FieldValue.serverTimestamp(),
// //         "updatedAt": FieldValue.serverTimestamp(),
// //         "userEmail": widget.userEmail,
// //         // Garage information
// //         "garageId": widget.selectedGarage.id,
// //         "garageName": widget.selectedGarage.name,
// //         "garageAddress": widget.selectedGarage.address,
// //         "garagePhone": widget.selectedGarage.phone,
// //         "garageRating": widget.selectedGarage.rating,
// //         "userLatitude": widget.userLocation.latitude,
// //         "userLongitude": widget.userLocation.longitude,
// //       };

// //       log("Submitting request to selected garage...");
// //       print('📡 Submitting request to Firebase...');
// //       print('📊 Request data: $requestData');

// //       // Submit to Firebase - to user's collection
// //       DocumentReference docRef = await FirebaseFirestore.instance
// //           .collection('owner')
// //           .doc(widget.userEmail)
// //           .collection("garagerequest")
// //           .add(requestData);

// //       // Also submit to garage's collection for them to see the request
// //       await FirebaseFirestore.instance
// //           .collection('garages')
// //           .doc(widget.selectedGarage.id)
// //           .collection('service_requests')
// //           .add(requestData);

// //       log('✅ Request submitted successfully! Document ID: ${docRef.id}');
// //       log("${widget.userEmail}");

// //       // Show success dialog
// //       _showSuccessDialog(requestId);

// //     } catch (e) {
// //       log("${widget.userEmail}");
// //       log('❌ Error submitting request: $e');
// //       _showErrorSnackBar('Failed to submit request: ${e.toString()}');
// //     } finally {
// //       setState(() {
// //         _isSubmitting = false;
// //       });
// //     }
// //   }

// //   void _showSuccessDialog(String requestId) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => GarageRequestConfirmation(
// //         requestId: requestId,
// //         vehicleNumber: _vehicleNumberController.text,
// //         serviceType: _selectedServiceType,
// //         preferredDate: _preferredDate,
// //         preferredTime: _preferredTime,
// //         garageName: widget.selectedGarage.name,
// //         onClose: () {
// //           // Clear form and navigate back
// //           _clearForm();
// //           Navigator.pop(context); // Close dialog
// //           Navigator.pop(context); // Go back to previous screen
// //         },
// //       ),
// //     );
// //   }

// //   void _clearForm() {
// //     _formKey.currentState?.reset();
// //     _nameController.clear();
// //     _phoneController.clear();
// //     _vehicleNumberController.clear();
// //     _vehicleModelController.clear();
// //     _locationController.clear();
// //     _descriptionController.clear();
// //     setState(() {
// //       _selectedVehicleType = 'Car';
// //       _selectedServiceType = 'General Repair';
// //       _selectedFuelType = 'Petrol';
// //       _preferredDate = null;
// //       _preferredTime = null;
// //       _selectedIssues.clear();
// //     });
// //   }

// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.red,
// //         duration: Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime.now().add(Duration(days: 30)),
// //     );
// //     if (picked != null && picked != _preferredDate) {
// //       setState(() {
// //         _preferredDate = picked;
// //       });
// //     }
// //   }

// //   Future<void> _selectTime(BuildContext context) async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: TimeOfDay.now(),
// //     );
// //     if (picked != null && picked != _preferredTime) {
// //       setState(() {
// //         _preferredTime = picked;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Request Service - ${widget.selectedGarage.name}'),
// //         backgroundColor: Color(0xFF6D28D9),
// //         foregroundColor: Colors.white,
// //       ),
// //       body: _isSubmitting ? _buildLoadingState() : _buildForm(),
// //     );
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(color: Color(0xFF6D28D9)),
// //           SizedBox(height: 16),
// //           Text(
// //             'Submitting your request...',
// //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildForm() {
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(16),
// //       child: Form(
// //         key: _formKey,
// //         child: Column(
// //           children: [
// //             // Selected Garage Card
// //             _buildSelectedGarageCard(),
// //             SizedBox(height: 20),

// //             if (widget.userEmail != null) ...[
// //               Container(
// //                 padding: EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.green[50],
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(color: Colors.green),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.check_circle, color: Colors.green, size: 16),
// //                     SizedBox(width: 8),
// //                     Expanded(
// //                       child: Text(
// //                         'Logged in as: ${widget.userEmail}',
// //                         style: TextStyle(fontSize: 12, color: Colors.green[800]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 12),
// //             ],
// //             _buildServiceTypeCard(),
// //             SizedBox(height: 20),
// //             _buildPersonalDetailsCard(),
// //             SizedBox(height: 20),
// //             _buildVehicleDetailsCard(),
// //             SizedBox(height: 20),
// //             _buildIssuesCard(),
// //             SizedBox(height: 20),
// //             _buildScheduleCard(),
// //             SizedBox(height: 20),
// //             _buildLocationCard(),
// //             SizedBox(height: 30),
// //             _buildSubmitButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSelectedGarageCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 50,
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF6D28D9).withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(
// //                 Icons.build_circle_rounded,
// //                 color: Color(0xFF6D28D9),
// //                 size: 30,
// //               ),
// //             ),
// //             SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     widget.selectedGarage.name,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     widget.selectedGarage.address,
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: Colors.grey[600],
// //                     ),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Row(
// //                     children: [
// //                       Icon(Icons.star, color: Colors.amber, size: 14),
// //                       SizedBox(width: 4),
// //                       Text(
// //                         '${widget.selectedGarage.rating} (${widget.selectedGarage.reviews} reviews)',
// //                         style: TextStyle(fontSize: 12),
// //                       ),
// //                       SizedBox(width: 12),
// //                       Icon(Icons.location_on, color: Colors.red, size: 14),
// //                       SizedBox(width: 4),
// //                       Text(
// //                         '${widget.selectedGarage.distance.toStringAsFixed(1)} km',
// //                         style: TextStyle(fontSize: 12),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Keep all the existing _build methods (ServiceTypeCard, PersonalDetailsCard, etc.)
// //   // They remain the same as in your original GarageServiceRequestScreen

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
// //               value: _selectedServiceType,
// //               decoration: InputDecoration(
// //                 labelText: 'Service Type *',
// //                 prefixIcon: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               items: _serviceTypes.map((type) {
// //                 return DropdownMenuItem(
// //                   value: type,
// //                   child: Text(type),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedServiceType = value!;
// //                 });
// //               },
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please select service type';
// //                 }
// //                 return null;
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
// //                 labelText: 'Full Name *',
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
// //                 labelText: 'Phone Number *',
// //                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               keyboardType: TextInputType.phone,
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter your phone number';
// //                 }
// //                 if (value.length < 10) {
// //                   return 'Please enter a valid phone number';
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
// //                 labelText: 'Vehicle Number *',
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
// //             TextFormField(
// //               controller: _vehicleModelController,
// //               decoration: InputDecoration(
// //                 labelText: 'Vehicle Model *',
// //                 hintText: 'e.g., Toyota Camry 2022',
// //                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter vehicle model';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: DropdownButtonFormField<String>(
// //                     value: _selectedVehicleType,
// //                     decoration: InputDecoration(
// //                       labelText: 'Vehicle Type *',
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //                     ),
// //                     items: _vehicleTypes.map((type) {
// //                       return DropdownMenuItem(
// //                         value: type,
// //                         child: Text(type),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _selectedVehicleType = value!;
// //                       });
// //                     },
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please select vehicle type';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: DropdownButtonFormField<String>(
// //                     value: _selectedFuelType,
// //                     decoration: InputDecoration(
// //                       labelText: 'Fuel Type *',
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //                     ),
// //                     items: _fuelTypes.map((fuel) {
// //                       return DropdownMenuItem(
// //                         value: fuel,
// //                         child: Text(fuel),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _selectedFuelType = value!;
// //                       });
// //                     },
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please select fuel type';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildIssuesCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Vehicle Issues',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             Text(
// //               'Select the issues you are facing:',
// //               style: TextStyle(color: Colors.grey[600]),
// //             ),
// //             SizedBox(height: 8),
// //             Wrap(
// //               spacing: 8,
// //               runSpacing: 8,
// //               children: _commonIssues.map((issue) {
// //                 final isSelected = _selectedIssues.contains(issue);
// //                 return FilterChip(
// //                   label: Text(issue),
// //                   selected: isSelected,
// //                   onSelected: (selected) {
// //                     setState(() {
// //                       if (selected) {
// //                         _selectedIssues.add(issue);
// //                       } else {
// //                         _selectedIssues.remove(issue);
// //                       }
// //                     });
// //                   },
// //                   selectedColor: Color(0xFF6D28D9).withOpacity(0.2),
// //                   checkmarkColor: Color(0xFF6D28D9),
// //                   labelStyle: TextStyle(
// //                     color: isSelected ? Color(0xFF6D28D9) : Colors.grey[700],
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _descriptionController,
// //               decoration: InputDecoration(
// //                 labelText: 'Additional Details',
// //                 hintText: 'Describe your vehicle issues in detail...',
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

// //   Widget _buildScheduleCard() {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Schedule Service',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: ListTile(
// //                     leading: Icon(Icons.calendar_today_rounded, color: Color(0xFF6D28D9)),
// //                     title: Text(
// //                       _preferredDate == null ? 'Select Date *' :
// //                       DateFormat('MMM dd, yyyy').format(_preferredDate!),
// //                       style: TextStyle(
// //                         color: _preferredDate == null ? Colors.grey : Colors.black,
// //                       ),
// //                     ),
// //                     trailing: Icon(Icons.arrow_drop_down_rounded),
// //                     onTap: () => _selectDate(context),
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: ListTile(
// //                     leading: Icon(Icons.access_time_rounded, color: Color(0xFF6D28D9)),
// //                     title: Text(
// //                       _preferredTime == null ? 'Select Time' :
// //                       _preferredTime!.format(context),
// //                       style: TextStyle(
// //                         color: _preferredTime == null ? Colors.grey : Colors.black,
// //                       ),
// //                     ),
// //                     trailing: Icon(Icons.arrow_drop_down_rounded),
// //                     onTap: () => _selectTime(context),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             if (_preferredDate == null)
// //               Padding(
// //                 padding: EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   'Please select a date',
// //                   style: TextStyle(color: Colors.red, fontSize: 12),
// //                 ),
// //               ),
// //             SizedBox(height: 12),
// //             Container(
// //               padding: EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.blue.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.info_rounded, color: Colors.blue, size: 20),
// //                   SizedBox(width: 8),
// //                   Expanded(
// //                     child: Text(
// //                       'We will confirm your appointment within 30 minutes',
// //                       style: TextStyle(fontSize: 12, color: Colors.blue[700]),
// //                     ),
// //                   ),
// //                 ],
// //               ),
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
// //               'Service Location',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
// //             ),
// //             SizedBox(height: 12),
// //             TextFormField(
// //               controller: _locationController,
// //               decoration: InputDecoration(
// //                 labelText: 'Service Address *',
// //                 hintText: 'Enter your address for service',
// //                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter service address';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Icon(Icons.home_work_rounded, color: Color(0xFF6D28D9)),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   'Service Options:',
// //                   style: TextStyle(fontWeight: FontWeight.w500),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 8),
// //             Row(
// //               children: [
// //                 _buildServiceOption('At Garage', Icons.build_circle_rounded),
// //                 SizedBox(width: 12),
// //                 _buildServiceOption('At Home', Icons.home_rounded),
// //                 SizedBox(width: 12),
// //                 _buildServiceOption('On Road', Icons.add_road_outlined),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildServiceOption(String title, IconData icon) {
// //     return Expanded(
// //       child: Card(
// //         elevation: 2,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         child: Padding(
// //           padding: EdgeInsets.all(12),
// //           child: Column(
// //             children: [
// //               Icon(icon, color: Color(0xFF6D28D9), size: 20),
// //               SizedBox(height: 4),
// //               Text(
// //                 title,
// //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSubmitButton() {
// //     return SizedBox(
// //       width: double.infinity,
// //       child: ElevatedButton(
// //         onPressed: (){
// //           log("Submitting request to selected garage");
// //           _submitRequest();
// //         },
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Color(0xFF6D28D9),
// //           foregroundColor: Colors.white,
// //           padding: EdgeInsets.symmetric(vertical: 16),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         ),
// //         child: _isSubmitting
// //             ? Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2,
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                     ),
// //                   ),
// //                   SizedBox(width: 12),
// //                   Text('Submitting...'),
// //                 ],
// //               )
// //             : Text(
// //                 'Request Service from ${widget.selectedGarage.name}',
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 textAlign: TextAlign.center,
// //               ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _phoneController.dispose();
// //     _vehicleNumberController.dispose();
// //     _vehicleModelController.dispose();
// //     _locationController.dispose();
// //     _descriptionController.dispose();
// //     super.dispose();
// //   }
// // }

// // // Updated Garage Request Confirmation with Garage Info
// // class GarageRequestConfirmation extends StatelessWidget {
// //   final String requestId;
// //   final String vehicleNumber;
// //   final String serviceType;
// //   final DateTime? preferredDate;
// //   final TimeOfDay? preferredTime;
// //   final String garageName;
// //   final VoidCallback onClose;

// //   const GarageRequestConfirmation({
// //     super.key,
// //     required this.requestId,
// //     required this.vehicleNumber,
// //     required this.serviceType,
// //     required this.preferredDate,
// //     required this.preferredTime,
// //     required this.garageName,
// //     required this.onClose,
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
// //               'Service Request Sent!',
// //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 16),
// //             Text(
// //               'Your service request has been sent to $garageName',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: Colors.grey[600]),
// //             ),
// //             SizedBox(height: 20),
// //             _buildDetailRow('Request ID', requestId),
// //             _buildDetailRow('Vehicle', vehicleNumber),
// //             _buildDetailRow('Service Type', serviceType),
// //             _buildDetailRow('Garage', garageName),
// //             if (preferredDate != null)
// //               _buildDetailRow('Preferred Date', DateFormat('MMM dd, yyyy').format(preferredDate!)),
// //             if (preferredTime != null)
// //               _buildDetailRow('Preferred Time', preferredTime!.format(context)),
// //             SizedBox(height: 24),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: OutlinedButton(
// //                     onPressed: onClose,
// //                     child: Text('Back to Home'),
// //                   ),
// //                 ),
// //                 SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       // Navigate to tracking screen or stay
// //                       onClose();
// //                     },
// //                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
// //                     child: Text('Track Service'),
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
// //           Expanded(
// //             child: Text(
// //               value,
// //               style: TextStyle(color: Colors.grey[700]),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:developer';
// import 'dart:math' hide log;

// import 'package:smart_road_app/controller/sharedprefrence.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';

// class NearbyGaragesScreen extends StatefulWidget {
//   final Position userLocation;
//   final String? userEmail;

//   const NearbyGaragesScreen({
//     super.key,
//     required this.userLocation,
//     required this.userEmail,
//   });

//   @override
//   _NearbyGaragesScreenState createState() => _NearbyGaragesScreenState();
// }

// class _NearbyGaragesScreenState extends State<NearbyGaragesScreen> {
//   List<Garage> _nearbyGarages = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadNearbyGarages();
//   }

//   // Calculate distance between two coordinates in kilometers using Haversine formula
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double earthRadius = 6371; // Earth's radius in kilometers

//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);

//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//         sin(dLon / 2) * sin(dLon / 2);

//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = earthRadius * c;

//     return distance;
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   Future<void> _loadNearbyGarages() async {
//     try {
//       print('📍 User location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}');
//       print('🔍 Loading registered garages from Firestore...');

//       // Fetch all active garages from Firestore
//       final garagesSnapshot = await FirebaseFirestore.instance
//           .collection('garages')
//           .where('isActive', isEqualTo: true)
//           .where('isAvailable', isEqualTo: true)
//           .get();

//       print('📊 Total garages found in system: ${garagesSnapshot.docs.length}');

//       List<Garage> allGarages = [];

//       for (var doc in garagesSnapshot.docs) {
//         try {
//           final data = doc.data();
//           print('\n🔍 Processing garage: ${data['garageName']}');

//           // Check if garage has location data
//           if (data['latitude'] == null || data['longitude'] == null) {
//             print('⚠️ Garage ${data['garageName']} has no location data - skipping');
//             continue;
//           }

//           double garageLat = data['latitude'] is int
//               ? (data['latitude'] as int).toDouble()
//               : data['latitude'].toDouble();

//           double garageLon = data['longitude'] is int
//               ? (data['longitude'] as int).toDouble()
//               : data['longitude'].toDouble();

//           // Calculate distance from user
//           double distance = _calculateDistance(
//             widget.userLocation.latitude,
//             widget.userLocation.longitude,
//             garageLat,
//             garageLon,
//           );

//           print('📏 Distance to ${data['garageName']}: ${distance.toStringAsFixed(1)} km');

//           // Only include garages within 15 km radius
//           if (distance <= 15) {
//             Garage garage = Garage(
//               id: doc.id,
//               name: data['garageName'] ?? 'Unknown Garage',
//               address: data['shopAddress'] ?? 'Address not provided',
//               distance: distance,
//               rating: (data['rating'] ?? 4.0).toDouble(),
//               reviews: (data['reviews'] ?? 0).toInt(),
//               specialties: List<String>.from(data['specialties'] ?? ['General Repair']),
//               isAvailable: data['isAvailable'] ?? true,
//               phone: data['phone'] ?? 'Not provided',
//               latitude: garageLat,
//               longitude: garageLon,
//               ownerName: data['ownerName'] ?? 'Not provided',
//               email: data['email'] ?? 'Not provided',
//             );

//             allGarages.add(garage);
//             print('✅ ADDED: ${garage.name} (${distance.toStringAsFixed(1)} km away)');
//           } else {
//             print('❌ TOO FAR: ${data['garageName']} - ${distance.toStringAsFixed(1)} km');
//           }

//         } catch (e) {
//           print('❌ Error processing garage document: $e');
//           print('📋 Problematic data: ${doc.data()}');
//         }
//       }

//       // Sort by distance (nearest first)
//       allGarages.sort((a, b) => a.distance.compareTo(b.distance));

//       setState(() {
//         _nearbyGarages = allGarages;
//         _isLoading = false;
//         _hasError = false;
//       });

//       print('\n🎉 FINAL RESULTS:');
//       print('📍 User Location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}');
//       print('📊 Nearby garages loaded: ${_nearbyGarages.length} within 15km');
//       print('📈 Distance range: ${_nearbyGarages.isNotEmpty ? _nearbyGarages.first.distance.toStringAsFixed(1) : 0}km - ${_nearbyGarages.isNotEmpty ? _nearbyGarages.last.distance.toStringAsFixed(1) : 0}km');

//     } catch (e) {
//       print('❌ CRITICAL ERROR loading nearby garages: $e');
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'Failed to load garages: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }

//   void _selectGarage(Garage garage) {
//     print('🎯 Selected garage: ${garage.name} (${garage.distance.toStringAsFixed(1)} km)');

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GarageServiceRequestScreen(
//           selectedGarage: garage,
//           userLocation: widget.userLocation,
//           userEmail: widget.userEmail,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Garages & Mechanics'),
//         backgroundColor: Color(0xFF6D28D9),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _isLoading = true;
//                 _hasError = false;
//               });
//               _loadNearbyGarages();
//             },
//             tooltip: 'Refresh',
//           ),
//           IconButton(
//             icon: Icon(Icons.info_outline),
//             onPressed: _showLocationInfo,
//             tooltip: 'Location Info',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildLoadingState()
//           : _hasError
//             ? _buildErrorState()
//             : _buildGaragesList(),
//     );
//   }

//   void _showLocationInfo() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Location Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Your Current Location:'),
//             SizedBox(height: 8),
//             Text('Lat: ${widget.userLocation.latitude.toStringAsFixed(6)}'),
//             Text('Lng: ${widget.userLocation.longitude.toStringAsFixed(6)}'),
//             SizedBox(height: 12),
//             Text('Search Radius: 15 km'),
//             Text('Garages Found: ${_nearbyGarages.length}'),
//             if (_nearbyGarages.isNotEmpty) ...[
//               SizedBox(height: 8),
//               Text('Nearest: ${_nearbyGarages.first.distance.toStringAsFixed(1)} km'),
//               Text('Farthest: ${_nearbyGarages.last.distance.toStringAsFixed(1)} km'),
//             ],
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF6D28D9)),
//           SizedBox(height: 16),
//           Text(
//             'Finding Nearby Garages...',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Searching within 15km of your location',
//             style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//           ),
//           SizedBox(height: 4),
//           Text(
//             'Lat: ${widget.userLocation.latitude.toStringAsFixed(4)}, Lng: ${widget.userLocation.longitude.toStringAsFixed(4)}',
//             style: TextStyle(fontSize: 10, color: Colors.grey[400]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 80, color: Colors.orange),
//             SizedBox(height: 16),
//             Text(
//               'Unable to Load Garages',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 12),
//             Text(
//               _errorMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _loadNearbyGarages,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF6D28D9),
//                 foregroundColor: Colors.white,
//               ),
//               child: Text('Try Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGaragesList() {
//     return Column(
//       children: [
//         // Header with user location and results
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 206, 196, 196))),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 20),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Garages Near You',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       '${_nearbyGarages.length} garages found within 15km • Sorted by distance',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: _nearbyGarages.isNotEmpty ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_nearbyGarages.isNotEmpty)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.green[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green),
//                   ),
//                   child: Text(
//                     '${_nearbyGarages.length} found',
//                     style: TextStyle(
//                       color: Colors.green[700],
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),

//         if (_nearbyGarages.isEmpty)
//           _buildNoGaragesState()
//         else
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _loadNearbyGarages,
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: _nearbyGarages.length,
//                 itemBuilder: (context, index) {
//                   final garage = _nearbyGarages[index];
//                   return _buildGarageCard(garage, index);
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildNoGaragesState() {
//     return Expanded(
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey[300]),
//               SizedBox(height: 16),
//               Text(
//                 'No Garages Found Nearby',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'We couldn\'t find any registered garages within 15km of your current location.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[500]),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 'Your location: ${widget.userLocation.latitude.toStringAsFixed(4)}, ${widget.userLocation.longitude.toStringAsFixed(4)}',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 10, color: Colors.grey[400]),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _loadNearbyGarages,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF6D28D9),
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text('Search Again'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGarageCard(Garage garage, int index) {
//     Color distanceColor = _getDistanceColor(garage.distance);

//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with position indicator for nearest garages
//             if (index < 3) _buildPositionIndicator(index),

//             Row(
//               children: [
//                 // Garage Avatar with distance badge
//                 Stack(
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color(0xFF6D28D9).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         Icons.build_circle_rounded,
//                         color: Color(0xFF6D28D9),
//                         size: 30,
//                       ),
//                     ),
//                     Positioned(
//                       right: -5,
//                       top: -5,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: distanceColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '${garage.distance.toStringAsFixed(1)}km',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 8,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         garage.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         garage.address,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Rating and Contact Info
//             Row(
//               children: [
//                 // Rating
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       garage.rating.toStringAsFixed(1),
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       '(${garage.reviews} reviews)',
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 // Phone
//                 Row(
//                   children: [
//                     Icon(Icons.phone, color: Colors.green, size: 14),
//                     SizedBox(width: 4),
//                     Text(
//                       garage.phone != 'Not provided' ? 'Available' : 'No phone',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: garage.phone != 'Not provided' ? Colors.green : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),

//             // Specialties
//             if (garage.specialties.isNotEmpty) ...[
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 4,
//                 children: garage.specialties.take(3).map((specialty) => Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     specialty,
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.blue[700],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 )).toList(),
//               ),
//               SizedBox(height: 12),
//             ],

//             // Select Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => _selectGarage(garage),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF6D28D9),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Request Service from ${garage.name.split(' ').first}'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPositionIndicator(int index) {
//     List<Color> positionColors = [
//       Colors.amber[700]!,
//       Colors.grey[600]!,
//       Colors.orange[700]!,
//     ];

//     List<String> positionTexts = ['Nearest', '2nd Nearest', '3rd Nearest'];

//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: positionColors[index].withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: positionColors[index].withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.emoji_events,
//             color: positionColors[index],
//             size: 14,
//           ),
//           SizedBox(width: 4),
//           Text(
//             positionTexts[index],
//             style: TextStyle(
//               color: positionColors[index],
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getDistanceColor(double distance) {
//     if (distance <= 2) return Colors.green;
//     if (distance <= 5) return Colors.blue;
//     if (distance <= 10) return Colors.orange;
//     return Colors.red;
//   }
// }

// class Garage {
//   final String id;
//   final String name;
//   final String address;
//   final double distance;
//   final double rating;
//   final int reviews;
//   final List<String> specialties;
//   final bool isAvailable;
//   final String phone;
//   final double latitude;
//   final double longitude;
//   final String ownerName;
//   final String email;

//   Garage({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.distance,
//     required this.rating,
//     required this.reviews,
//     required this.specialties,
//     required this.isAvailable,
//     required this.phone,
//     required this.latitude,
//     required this.longitude,
//     required this.ownerName,
//     required this.email,
//   });
// }

// // Updated Garage Service Request Screen
// class GarageServiceRequestScreen extends StatefulWidget {
//   final Garage selectedGarage;
//   final Position userLocation;
//   final String? userEmail;

//   const GarageServiceRequestScreen({
//     super.key,
//     required this.selectedGarage,
//     required this.userLocation,
//     required this.userEmail,
//   });

//   @override
//   _GarageServiceRequestScreenState createState() => _GarageServiceRequestScreenState();
// }

// class _GarageServiceRequestScreenState extends State<GarageServiceRequestScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _vehicleNumberController = TextEditingController();
//   final TextEditingController _vehicleModelController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   bool _isSubmitting = false;
//   String _selectedVehicleType = 'Car';
//   String _selectedServiceType = 'General Repair';
//   String _selectedFuelType = 'Petrol';
//   DateTime? _preferredDate;
//   TimeOfDay? _preferredTime;
//   final List<String> _selectedIssues = [];

//   final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Motorcycle', 'Bus', 'Other'];
//   final List<String> _serviceTypes = ['General Repair', 'Engine Service', 'Brake Repair', 'AC Service', 'Electrical Repair', 'Denting & Painting', 'Periodic Maintenance'];
//   final List<String> _fuelTypes = ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'];
//   final List<String> _commonIssues = [
//     'Engine Problem',
//     'Brake Issues',
//     'AC Not Working',
//     'Electrical Fault',
//     'Suspension Problem',
//     'Transmission Issue',
//     'Battery Dead',
//     'Tire Puncture',
//     'Oil Change',
//     'Other'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _prefillUserData();
//   }

//   void _prefillUserData() {
//     // Prefill data from user profile (you can get this from SharedPreferences or Firestore)
//     _nameController.text = 'Vehicle Owner'; // Default, can be updated from profile
//     _phoneController.text = '+91XXXXXXXXXX'; // Default, can be updated from profile
//     _locationController.text = 'Current Location'; // Can use geocoding to get address

//     // You can add more prefilling logic here from user profile data
//   }

//   void _submitRequest() async {
//     if (!_formKey.currentState!.validate()) {
//       _showErrorSnackBar('Please fill all required fields correctly.');
//       return;
//     }

//     if (widget.userEmail == null || widget.userEmail!.isEmpty) {
//       _showErrorSnackBar('User not authenticated. Please login again.');
//       return;
//     }

//     setState(() {
//       _isSubmitting = true;
//     });

//     try {
//       final requestId = 'GRG${DateTime.now().millisecondsSinceEpoch}';
//       final now = DateTime.now();

//       // Prepare the data with garage information
//       Map<String, dynamic> requestData = {
//         "requestId": requestId,
//         "vehicleNumber": _vehicleNumberController.text.trim(),
//         "serviceType": _selectedServiceType,
//         "preferredDate": _preferredDate ?? now,
//         "preferredTime": _preferredTime != null ? _preferredTime!.format(context) : 'Not specified',
//         "name": _nameController.text.trim(),
//         "phone": _phoneController.text.trim(),
//         "location": _locationController.text.trim(),
//         "vehicleModel": _vehicleModelController.text.trim(),
//         "vehicleType": _selectedVehicleType,
//         "fuelType": _selectedFuelType,
//         "description": _descriptionController.text.trim(),
//         "selectedIssues": _selectedIssues,
//         "status": "Pending",
//         "createdAt": FieldValue.serverTimestamp(),
//         "updatedAt": FieldValue.serverTimestamp(),
//         "userEmail": widget.userEmail,
//         // Garage information
//         "garageId": widget.selectedGarage.id,
//         "garageName": widget.selectedGarage.name,
//         "garageAddress": widget.selectedGarage.address,
//         "garagePhone": widget.selectedGarage.phone,
//         "garageRating": widget.selectedGarage.rating,
//         "garageSpecialties": widget.selectedGarage.specialties,
//         "userLatitude": widget.userLocation.latitude,
//         "userLongitude": widget.userLocation.longitude,
//         "garageLatitude": widget.selectedGarage.latitude,
//         "garageLongitude": widget.selectedGarage.longitude,
//         "distance": widget.selectedGarage.distance,
//       };

//       log("🚗 Submitting service request to ${widget.selectedGarage.name}");
//       print('📡 Submitting request to Firebase...');
//       print('📊 Request data: $requestData');

//       // Submit to Firebase - to user's collection
//       DocumentReference docRef = await FirebaseFirestore.instance
//           .collection('owner')
//           .doc(widget.userEmail)
//           .collection("garagerequest")
//           .add(requestData);

//       // Also submit to garage's collection for them to see the request
//       await FirebaseFirestore.instance
//           .collection('garages')
//           .doc(widget.selectedGarage.id)
//           .collection('service_requests')
//           .add(requestData);

//       log('✅ Request submitted successfully! Document ID: ${docRef.id}');
//       log("👤 User: ${widget.userEmail}");

//       // Show success dialog
//       _showSuccessDialog(requestId);

//     } catch (e) {
//       log("❌ Error submitting request: $e");
//       log("👤 User: ${widget.userEmail}");
//       _showErrorSnackBar('Failed to submit request: ${e.toString()}');
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }

//   void _showSuccessDialog(String requestId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => GarageRequestConfirmation(
//         requestId: requestId,
//         vehicleNumber: _vehicleNumberController.text,
//         serviceType: _selectedServiceType,
//         preferredDate: _preferredDate,
//         preferredTime: _preferredTime,
//         garageName: widget.selectedGarage.name,
//         garageDistance: widget.selectedGarage.distance,
//         onClose: () {
//           // Clear form and navigate back
//           _clearForm();
//           Navigator.pop(context); // Close dialog
//           Navigator.pop(context); // Go back to previous screen
//         },
//       ),
//     );
//   }

//   void _clearForm() {
//     _formKey.currentState?.reset();
//     _nameController.clear();
//     _phoneController.clear();
//     _vehicleNumberController.clear();
//     _vehicleModelController.clear();
//     _locationController.clear();
//     _descriptionController.clear();
//     setState(() {
//       _selectedVehicleType = 'Car';
//       _selectedServiceType = 'General Repair';
//       _selectedFuelType = 'Petrol';
//       _preferredDate = null;
//       _preferredTime = null;
//       _selectedIssues.clear();
//     });
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 30)),
//     );
//     if (picked != null && picked != _preferredDate) {
//       setState(() {
//         _preferredDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != _preferredTime) {
//       setState(() {
//         _preferredTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Request Service - ${widget.selectedGarage.name}'),
//         backgroundColor: Color(0xFF6D28D9),
//         foregroundColor: Colors.white,
//       ),
//       body: _isSubmitting ? _buildLoadingState() : _buildForm(),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF6D28D9)),
//           SizedBox(height: 16),
//           Text(
//             'Submitting your request...',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'To ${widget.selectedGarage.name}',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             // Selected Garage Card with distance
//             _buildSelectedGarageCard(),
//             SizedBox(height: 20),

//             if (widget.userEmail != null) ...[
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.green),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.green, size: 16),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Logged in as: ${widget.userEmail}',
//                         style: TextStyle(fontSize: 12, color: Colors.green[800]),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12),
//             ],
//             _buildServiceTypeCard(),
//             SizedBox(height: 20),
//             _buildPersonalDetailsCard(),
//             SizedBox(height: 20),
//             _buildVehicleDetailsCard(),
//             SizedBox(height: 20),
//             _buildIssuesCard(),
//             SizedBox(height: 20),
//             _buildScheduleCard(),
//             SizedBox(height: 20),
//             _buildLocationCard(),
//             SizedBox(height: 30),
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectedGarageCard() {
//     Color distanceColor = _getDistanceColor(widget.selectedGarage.distance);

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF6D28D9).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.build_circle_rounded,
//                     color: Color(0xFF6D28D9),
//                     size: 30,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.selectedGarage.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         widget.selectedGarage.address,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: Colors.amber, size: 14),
//                           SizedBox(width: 4),
//                           Text(
//                             '${widget.selectedGarage.rating} (${widget.selectedGarage.reviews} reviews)',
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           SizedBox(width: 12),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: distanceColor,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${widget.selectedGarage.distance.toStringAsFixed(1)} km away',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             if (widget.selectedGarage.specialties.isNotEmpty) ...[
//               Divider(),
//               SizedBox(height: 8),
//               Text(
//                 'Specialties: ${widget.selectedGarage.specialties.join(', ')}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.blue[700],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getDistanceColor(double distance) {
//     if (distance <= 2) return Colors.green;
//     if (distance <= 5) return Colors.blue;
//     if (distance <= 10) return Colors.orange;
//     return Colors.red;
//   }

//   // Keep all the existing _build methods (ServiceTypeCard, PersonalDetailsCard, etc.)
//   // They remain the same as in your original GarageServiceRequestScreen
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
//               value: _selectedServiceType,
//               decoration: InputDecoration(
//                 labelText: 'Service Type *',
//                 prefixIcon: Icon(Icons.handyman_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               items: _serviceTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedServiceType = value!;
//                 });
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select service type';
//                 }
//                 return null;
//               },
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
//                 labelText: 'Full Name *',
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
//                 labelText: 'Phone Number *',
//                 prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 }
//                 if (value.length < 10) {
//                   return 'Please enter a valid phone number';
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
//                 labelText: 'Vehicle Number *',
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
//             TextFormField(
//               controller: _vehicleModelController,
//               decoration: InputDecoration(
//                 labelText: 'Vehicle Model *',
//                 hintText: 'e.g., Toyota Camry 2022',
//                 prefixIcon: Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter vehicle model';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedVehicleType,
//                     decoration: InputDecoration(
//                       labelText: 'Vehicle Type *',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     items: _vehicleTypes.map((type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(type),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedVehicleType = value!;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select vehicle type';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedFuelType,
//                     decoration: InputDecoration(
//                       labelText: 'Fuel Type *',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     items: _fuelTypes.map((fuel) {
//                       return DropdownMenuItem(
//                         value: fuel,
//                         child: Text(fuel),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedFuelType = value!;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select fuel type';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIssuesCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Vehicle Issues',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Select the issues you are facing:',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: _commonIssues.map((issue) {
//                 final isSelected = _selectedIssues.contains(issue);
//                 return FilterChip(
//                   label: Text(issue),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() {
//                       if (selected) {
//                         _selectedIssues.add(issue);
//                       } else {
//                         _selectedIssues.remove(issue);
//                       }
//                     });
//                   },
//                   selectedColor: Color(0xFF6D28D9).withOpacity(0.2),
//                   checkmarkColor: Color(0xFF6D28D9),
//                   labelStyle: TextStyle(
//                     color: isSelected ? Color(0xFF6D28D9) : Colors.grey[700],
//                   ),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Additional Details',
//                 hintText: 'Describe your vehicle issues in detail...',
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

//   Widget _buildScheduleCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Schedule Service',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: ListTile(
//                     leading: Icon(Icons.calendar_today_rounded, color: Color(0xFF6D28D9)),
//                     title: Text(
//                       _preferredDate == null ? 'Select Date *' :
//                       DateFormat('MMM dd, yyyy').format(_preferredDate!),
//                       style: TextStyle(
//                         color: _preferredDate == null ? Colors.grey : Colors.black,
//                       ),
//                     ),
//                     trailing: Icon(Icons.arrow_drop_down_rounded),
//                     onTap: () => _selectDate(context),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ListTile(
//                     leading: Icon(Icons.access_time_rounded, color: Color(0xFF6D28D9)),
//                     title: Text(
//                       _preferredTime == null ? 'Select Time' :
//                       _preferredTime!.format(context),
//                       style: TextStyle(
//                         color: _preferredTime == null ? Colors.grey : Colors.black,
//                       ),
//                     ),
//                     trailing: Icon(Icons.arrow_drop_down_rounded),
//                     onTap: () => _selectTime(context),
//                   ),
//                 ),
//               ],
//             ),
//             if (_preferredDate == null)
//               Padding(
//                 padding: EdgeInsets.only(top: 8),
//                 child: Text(
//                   'Please select a date',
//                   style: TextStyle(color: Colors.red, fontSize: 12),
//                 ),
//               ),
//             SizedBox(height: 12),
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_rounded, color: Colors.blue, size: 20),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'We will confirm your appointment within 30 minutes',
//                       style: TextStyle(fontSize: 12, color: Colors.blue[700]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
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
//               'Service Location',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: 'Service Address *',
//                 hintText: 'Enter your address for service',
//                 prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter service address';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(Icons.home_work_rounded, color: Color(0xFF6D28D9)),
//                 SizedBox(width: 8),
//                 Text(
//                   'Service Options:',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 _buildServiceOption('At Garage', Icons.build_circle_rounded),
//                 SizedBox(width: 12),
//                 _buildServiceOption('At Home', Icons.home_rounded),
//                 SizedBox(width: 12),
//                 _buildServiceOption('On Road', Icons.add_road_outlined),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceOption(String title, IconData icon) {
//     return Expanded(
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Icon(icon, color: Color(0xFF6D28D9), size: 20),
//               SizedBox(height: 4),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: (){
//           log("🚗 Submitting request to ${widget.selectedGarage.name}");
//           _submitRequest();
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF6D28D9),
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: _isSubmitting
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Text('Submitting to ${widget.selectedGarage.name.split(' ').first}...'),
//                 ],
//               )
//             : Text(
//                 'Request Service from ${widget.selectedGarage.name}',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _vehicleNumberController.dispose();
//     _vehicleModelController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

// // Updated Garage Request Confirmation with Distance Info
// class GarageRequestConfirmation extends StatelessWidget {
//   final String requestId;
//   final String vehicleNumber;
//   final String serviceType;
//   final DateTime? preferredDate;
//   final TimeOfDay? preferredTime;
//   final String garageName;
//   final double garageDistance;
//   final VoidCallback onClose;

//   const GarageRequestConfirmation({
//     super.key,
//     required this.requestId,
//     required this.vehicleNumber,
//     required this.serviceType,
//     required this.preferredDate,
//     required this.preferredTime,
//     required this.garageName,
//     required this.garageDistance,
//     required this.onClose,
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
//               'Service Request Sent!',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Your service request has been sent to $garageName',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 8),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 '${garageDistance.toStringAsFixed(1)} km away',
//                 style: TextStyle(
//                   color: Colors.blue[700],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildDetailRow('Request ID', requestId),
//             _buildDetailRow('Vehicle', vehicleNumber),
//             _buildDetailRow('Service Type', serviceType),
//             _buildDetailRow('Garage', garageName),
//             if (preferredDate != null)
//               _buildDetailRow('Preferred Date', DateFormat('MMM dd, yyyy').format(preferredDate!)),
//             if (preferredTime != null)
//               _buildDetailRow('Preferred Time', preferredTime!.format(context)),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: onClose,
//                     child: Text('Back to Home'),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Navigate to tracking screen or stay
//                       onClose();
//                     },
//                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6D28D9)),
//                     child: Text('Track Service'),
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
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.grey[700]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:smart_road_app/VehicleOwner/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';

class NearbyGaragesScreen extends StatefulWidget {

  const NearbyGaragesScreen({
    super.key,
    required this.userLocation,
    required this.userEmail,
  });
  final Position userLocation;
  final String? userEmail;

  @override
  _NearbyGaragesScreenState createState() => _NearbyGaragesScreenState();
}

class _NearbyGaragesScreenState extends State<NearbyGaragesScreen> {
  List<Garage> _nearbyGarages = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadNearbyGarages();
  }

  // Calculate distance between two coordinates in kilometers using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

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

  Future<void> _loadNearbyGarages() async {
    try {
      print(
        '📍 User location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}',
      );
      print('🔍 Loading registered garages from Firestore...');

      // Fetch all active garages from Firestore
      final garagesSnapshot = await FirebaseFirestore.instance
          .collection('garages')
          .where('isActive', isEqualTo: true)
          .where('isAvailable', isEqualTo: true)
          .get();

      print('📊 Total garages found in system: ${garagesSnapshot.docs.length}');

      List<Garage> allGarages = [];

      for (var doc in garagesSnapshot.docs) {
        try {
          final data = doc.data();
          print('\n🔍 Processing garage: ${data['garageName']}');

          // Check if garage has location data
          if (data['latitude'] == null || data['longitude'] == null) {
            print(
              '⚠️ Garage ${data['garageName']} has no location data - skipping',
            );
            continue;
          }

          double garageLat = data['latitude'] is int
              ? (data['latitude'] as int).toDouble()
              : data['latitude'].toDouble();

          double garageLon = data['longitude'] is int
              ? (data['longitude'] as int).toDouble()
              : data['longitude'].toDouble();

          // Calculate distance from user
          double distance = _calculateDistance(
            widget.userLocation.latitude,
            widget.userLocation.longitude,
            garageLat,
            garageLon,
          );

          print(
            '📏 Distance to ${data['garageName']}: ${distance.toStringAsFixed(1)} km',
          );

          // Only include garages within 15 km radius
          if (distance <= 15) {
            Garage garage = Garage(
              id: doc.id,
              name: data['garageName'] ?? 'Unknown Garage',
              address: data['shopAddress'] ?? 'Address not provided',
              distance: distance,
              rating: (data['rating'] ?? 4.0).toDouble(),
              reviews: (data['reviews'] ?? 0).toInt(),
              specialties: List<String>.from(
                data['specialties'] ?? ['General Repair'],
              ),
              isAvailable: data['isAvailable'] ?? true,
              phone: data['phone'] ?? 'Not provided',
              latitude: garageLat,
              longitude: garageLon,
              ownerName: data['ownerName'] ?? 'Not provided',
              email: data['email'] ?? 'Not provided',
            );

            allGarages.add(garage);
            print(
              '✅ ADDED: ${garage.name} (${distance.toStringAsFixed(1)} km away)',
            );
          } else {
            print(
              '❌ TOO FAR: ${data['garageName']} - ${distance.toStringAsFixed(1)} km',
            );
          }
        } catch (e) {
          print('❌ Error processing garage document: $e');
          print('📋 Problematic data: ${doc.data()}');
        }
      }

      // Sort by distance (nearest first)
      allGarages.sort((a, b) => a.distance.compareTo(b.distance));

      setState(() {
        _nearbyGarages = allGarages;
        _isLoading = false;
        _hasError = false;
      });

      print('\n🎉 FINAL RESULTS:');
      print(
        '📍 User Location: ${widget.userLocation.latitude}, ${widget.userLocation.longitude}',
      );
      print('📊 Nearby garages loaded: ${_nearbyGarages.length} within 15km');
      print(
        '📈 Distance range: ${_nearbyGarages.isNotEmpty ? _nearbyGarages.first.distance.toStringAsFixed(1) : 0}km - ${_nearbyGarages.isNotEmpty ? _nearbyGarages.last.distance.toStringAsFixed(1) : 0}km',
      );
    } catch (e) {
      print('❌ CRITICAL ERROR loading nearby garages: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load garages: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _selectGarage(Garage garage) {
    print(
      '🎯 Selected garage: ${garage.name} (${garage.distance.toStringAsFixed(1)} km)',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GarageServiceRequestScreen(
          selectedGarage: garage,
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
        title: Text('Nearby Garages & Mechanics'),
        backgroundColor: Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _loadNearbyGarages();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _hasError
          ? _buildErrorState()
          : _buildGaragesList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF6D28D9)),
          SizedBox(height: 16),
          Text(
            'Finding Nearby Garages...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
              'Unable to Load Garages',
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
              onPressed: _loadNearbyGarages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D28D9),
                foregroundColor: Colors.white,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaragesList() {
    return Column(
      children: [
        // Header with user location and results
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(
                color: const Color.fromARGB(255, 234, 217, 217),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF6D28D9), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Garages Near You',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${_nearbyGarages.length} garages found within 15km • Sorted by distance',
                      style: TextStyle(
                        fontSize: 12,
                        color: _nearbyGarages.isNotEmpty
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

        if (_nearbyGarages.isEmpty)
          _buildNoGaragesState()
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNearbyGarages,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _nearbyGarages.length,
                itemBuilder: (context, index) {
                  final garage = _nearbyGarages[index];
                  return _buildGarageCard(garage, index);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoGaragesState() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build_circle_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              SizedBox(height: 16),
              Text(
                'No Garages Found Nearby',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'We couldn\'t find any registered garages within 15km of your current location.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500]),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadNearbyGarages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D28D9),
                  foregroundColor: Colors.white,
                ),
                child: Text('Search Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGarageCard(Garage garage, int index) {
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF6D28D9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.build_circle_rounded,
                    color: Color(0xFF6D28D9),
                    size: 30,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        garage.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        garage.address,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
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
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      garage.rating.toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${garage.reviews} reviews)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${garage.distance.toStringAsFixed(1)} km',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),

            // Select Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _selectGarage(garage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D28D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Request Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Garage {

  Garage({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.specialties,
    required this.isAvailable,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.ownerName,
    required this.email,
  });
  final String id;
  final String name;
  final String address;
  final double distance;
  final double rating;
  final int reviews;
  final List<String> specialties;
  final bool isAvailable;
  final String phone;
  final double latitude;
  final double longitude;
  final String ownerName;
  final String email;
}

// Updated Garage Service Request Screen with Live Location
class GarageServiceRequestScreen extends StatefulWidget {

  const GarageServiceRequestScreen({
    super.key,
    required this.selectedGarage,
    required this.userLocation,
    required this.userEmail,
  });
  final Garage selectedGarage;
  final Position userLocation;
  final String? userEmail;

  @override
  _GarageServiceRequestScreenState createState() =>
      _GarageServiceRequestScreenState();
}

class _GarageServiceRequestScreenState
    extends State<GarageServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  String _selectedVehicleType = 'Car';
  String _selectedServiceType = 'General Repair';
  String _selectedFuelType = 'Petrol';
  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;
  final List<String> _selectedIssues = [];

  // Location variables
  Position? _currentPosition;
  bool _isGettingLocation = false;
  bool _isLocationEnabled = false;
  String _locationAddress = '';
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _userId;

  final List<String> _vehicleTypes = [
    'Car',
    'SUV',
    'Truck',
    'Motorcycle',
    'Bus',
    'Other',
  ];
  final List<String> _serviceTypes = [
    'General Repair',
    'Engine Service',
    'Brake Repair',
    'AC Service',
    'Electrical Repair',
    'Denting & Painting',
    'Periodic Maintenance',
  ];
  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'CNG',
    'Electric',
    'Hybrid',
  ];
  final List<String> _commonIssues = [
    'Engine Problem',
    'Brake Issues',
    'AC Not Working',
    'Electrical Fault',
    'Suspension Problem',
    'Transmission Issue',
    'Battery Dead',
    'Tire Puncture',
    'Oil Change',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    _loadUserData();
    _initializeLocation();
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }

  void _loadUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userId = user?.uid;
    });
  }

  void _prefillUserData() {
    _nameController.text = 'Vehicle Owner';
    _phoneController.text = '+91XXXXXXXXXX';
    _locationController.text = 'Current Location';
  }

  // Location Methods
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _initializeLocation() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

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
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

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
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    }
  }

  Future<void> _startLiveLocationSharing() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    setState(() {
      _isLocationEnabled = true;
      _isGettingLocation = true;
    });

    // First get current location
    await _getCurrentLocation();

    // Then start live updates
    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Update every 10 meters
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = position;
            _isGettingLocation = false;
          });

          // Update location in controller
          _locationController.text =
              '${position.latitude}, ${position.longitude}';

          // Get address for the new position
          _getAddressFromLatLng(position);

          // Update location in Firebase if request is already submitted
          _updateLiveLocationInFirebase(position);
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Live location sharing started')),
    );
  }

  void _stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    if (mounted) {
      setState(() {
        _isLocationEnabled = false;
        _isGettingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Live location sharing stopped')),
      );
    }
  }

  Future<void> _updateLiveLocationInFirebase(Position position) async {
    if (_userId == null) return;

    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('garage_live_locations').child(_userId!).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userEmail': widget.userEmail,
        'vehicleNumber': _vehicleNumberController.text.isNotEmpty
            ? _vehicleNumberController.text
            : 'Unknown',
        'address': _locationAddress,
        'garageName': widget.selectedGarage.name,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating live location: $e');
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

    // // Ensure date is selected
    // if (_preferredDate == null) {
    //   _showErrorSnackBar('Please select a preferred date.');
    //   return;
    // }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final requestId = 'GRG${DateTime.now().millisecondsSinceEpoch}';
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Fix DateTime serialization issue - convert to Timestamp
      final preferredDateTimestamp = _preferredDate != null
          ? Timestamp.fromDate(_preferredDate!)
          : Timestamp.now();

      final preferredTimeString = _preferredTime != null
          ? _preferredTime!.format(context)
          : 'Not specified';

      // Prepare the data with location information
      Map<String, dynamic> requestData = {
        "requestId": requestId,
        "vehicleNumber": _vehicleNumberController.text.trim(),
        "serviceType": _selectedServiceType,
        "preferredDate":
            preferredDateTimestamp, // Use Timestamp instead of DateTime
        "preferredTime": preferredTimeString,
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "location": _locationController.text.trim(),
        "vehicleModel": _vehicleModelController.text.trim(),
        "vehicleType": _selectedVehicleType,
        "fuelType": _selectedFuelType,
        "description": _descriptionController.text.trim(),
        "selectedIssues": _selectedIssues,
        "status": "Pending",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "userEmail": widget.userEmail,
        "userId": _userId,
        // Location data
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
        "address": _locationAddress,
        "liveLocationEnabled": _isLocationEnabled,
        // Garage information
        "garageId": widget.selectedGarage.id,
        "garageName": widget.selectedGarage.name,
        "garageAddress": widget.selectedGarage.address,
        "garagePhone": widget.selectedGarage.phone,
        "garageRating": widget.selectedGarage.rating,
        "garageSpecialties": widget.selectedGarage.specialties,
        "userLatitude": widget.userLocation.latitude,
        "userLongitude": widget.userLocation.longitude,
        "garageLatitude": widget.selectedGarage.latitude,
        "garageLongitude": widget.selectedGarage.longitude,
        "distance": widget.selectedGarage.distance,
      };

      log("🚗 Submitting service request to ${widget.selectedGarage.name}");
      print('📡 Submitting request to Firebase...');

      // 1. Submit to Firebase - to user's collection
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('owner')
          .doc(widget.userEmail)
          .collection("garagerequest")
          .add(requestData);

      // 2. Also submit to garage's collection for them to see the request
      await FirebaseFirestore.instance
          .collection('garages')
          .doc(widget.selectedGarage.id)
          .collection('service_requests')
          .add(requestData);

      // 3. Save to Realtime Database for notifications
      // Create a copy without FieldValue objects (Realtime DB doesn't support them)
      final Map<String, dynamic> realtimeData = Map<String, dynamic>.from(requestData);
      // Convert FieldValue.serverTimestamp() to milliseconds
      realtimeData['createdAt'] = timestamp;
      realtimeData['updatedAt'] = timestamp;
      // Convert Timestamp to milliseconds for Realtime DB
      if (realtimeData['preferredDate'] is Timestamp) {
        realtimeData['preferredDate'] = (realtimeData['preferredDate'] as Timestamp).millisecondsSinceEpoch;
      } else if (_preferredDate != null) {
        realtimeData['preferredDate'] = _preferredDate!.millisecondsSinceEpoch;
      }
      
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('garage_requests').child(requestId).set({
        ...realtimeData,
        'notificationRead': false,
        'garageRead': false,
      });

      // 4. Save initial live location if enabled
      if (_isLocationEnabled && _currentPosition != null) {
        await dbRef.child('garage_live_locations').child(_userId!).set({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'timestamp': timestamp,
          'userEmail': widget.userEmail,
          'vehicleNumber': _vehicleNumberController.text,
          'address': _locationAddress,
          'garageName': widget.selectedGarage.name,
          'requestId': requestId,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }

      // 5. Create user notification
      // Sanitize user ID for Realtime Database path (remove invalid characters)
      final String sanitizedUserId = (_userId ?? 'unknown')
          .replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
      
      final userNotificationRef = dbRef
          .child('notifications')
          .child(sanitizedUserId)
          .push();

      await userNotificationRef.set({
        'id': userNotificationRef.key,
        'requestId': requestId,
        'title': 'Garage Service Request Submitted',
        'message':
            'Your service request for ${_vehicleNumberController.text} has been sent to ${widget.selectedGarage.name}.',
        'timestamp': timestamp,
        'read': false,
        'type': 'garage_request_submitted',
        'vehicleNumber': _vehicleNumberController.text,
        'garageName': widget.selectedGarage.name,
        'status': 'pending',
        'liveLocationEnabled': _isLocationEnabled,
      });

      // 6. Create garage notification
      // Sanitize garage ID for Realtime Database path (remove invalid characters)
      final String sanitizedGarageId = widget.selectedGarage.id
          .replaceAll(RegExp(r'[\.#\$\[\]]'), '_');
      
      final garageNotificationRef = dbRef
          .child('garage_notifications')
          .child(sanitizedGarageId)
          .push();

      await garageNotificationRef.set({
        'id': garageNotificationRef.key,
        'requestId': requestId,
        'title': 'New Service Request',
        'message':
            'New service request from ${_nameController.text} for ${_vehicleNumberController.text}',
        'timestamp': timestamp,
        'read': false,
        'type': 'new_garage_request',
        'userEmail': widget.userEmail,
        'vehicleNumber': _vehicleNumberController.text,
        'location': _locationController.text,
        'serviceType': _selectedServiceType,
        'userId': _userId,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'liveLocationEnabled': _isLocationEnabled,
      });

      log('✅ Request submitted successfully! Document ID: ${docRef.id}');

      // Show success dialog
      _showSuccessDialog(requestId);
    } catch (e) {
      log("❌ Error submitting request: $e");
      _showErrorSnackBar('Request send successfully');
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
      builder: (context) => GarageRequestConfirmation(
        requestId: requestId,
        vehicleNumber: _vehicleNumberController.text,
        serviceType: _selectedServiceType,
        preferredDate: _preferredDate,
        preferredTime: _preferredTime,
        garageName: widget.selectedGarage.name,
        garageDistance: widget.selectedGarage.distance,
        isLiveLocationEnabled: _isLocationEnabled,
        onClose: () {
          // Clear form and navigate back
          _clearForm();
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Go back to previous screen
        },
        onTrack: () {
          Navigator.pop(context); // Close dialog
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
        },
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _vehicleNumberController.clear();
    _vehicleModelController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedVehicleType = 'Car';
      _selectedServiceType = 'General Repair';
      _selectedFuelType = 'Petrol';
      _preferredDate = null;
      _preferredTime = null;
      _selectedIssues.clear();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 3, 119, 71),
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != _preferredDate) {
      setState(() {
        _preferredDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _preferredTime) {
      setState(() {
        _preferredTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Service - ${widget.selectedGarage.name}'),
        backgroundColor: Color(0xFF6D28D9),
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
          CircularProgressIndicator(color: Color(0xFF6D28D9)),
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
            // Selected Garage Card
            _buildSelectedGarageCard(),
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

            _buildServiceTypeCard(),
            SizedBox(height: 20),
            _buildPersonalDetailsCard(),
            SizedBox(height: 20),
            _buildVehicleDetailsCard(),
            SizedBox(height: 20),
            _buildIssuesCard(),
            SizedBox(height: 20),
            _buildScheduleCard(),
            SizedBox(height: 20),
            _buildLocationCard(), // Updated location card with live sharing
            SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGarageCard() {
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
                color: Color(0xFF6D28D9).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.build_circle_rounded,
                color: Color(0xFF6D28D9),
                size: 30,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedGarage.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.selectedGarage.address,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${widget.selectedGarage.rating} (${widget.selectedGarage.reviews} reviews)',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.selectedGarage.distance.toStringAsFixed(1)} km away',
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

  Widget _buildServiceTypeCard() {
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
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedServiceType,
              decoration: InputDecoration(
                labelText: 'Service Type *',
                prefixIcon: Icon(
                  Icons.handyman_rounded,
                  color: Color(0xFF6D28D9),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _serviceTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedServiceType = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select service type';
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
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF6D28D9),
                ),
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
                prefixIcon: Icon(Icons.phone_rounded, color: Color(0xFF6D28D9)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
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
                color: Color(0xFF6D28D9),
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
                  color: Color(0xFF6D28D9),
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
            TextFormField(
              controller: _vehicleModelController,
              decoration: InputDecoration(
                labelText: 'Vehicle Model *',
                hintText: 'e.g., Toyota Camry 2022',
                prefixIcon: Icon(
                  Icons.directions_car_rounded,
                  color: Color(0xFF6D28D9),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle model';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedVehicleType,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Type *',
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
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedFuelType,
                    decoration: InputDecoration(
                      labelText: 'Fuel Type *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _fuelTypes.map((fuel) {
                      return DropdownMenuItem(value: fuel, child: Text(fuel));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFuelType = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select fuel type';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Issues',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Select the issues you are facing:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonIssues.map((issue) {
                final isSelected = _selectedIssues.contains(issue);
                return FilterChip(
                  label: Text(issue),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedIssues.add(issue);
                      } else {
                        _selectedIssues.remove(issue);
                      }
                    });
                  },
                  selectedColor: Color(0xFF6D28D9).withOpacity(0.2),
                  checkmarkColor: Color(0xFF6D28D9),
                  labelStyle: TextStyle(
                    color: isSelected ? Color(0xFF6D28D9) : Colors.grey[700],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Additional Details',
                hintText: 'Describe your vehicle issues in detail...',
                prefixIcon: Icon(
                  Icons.description_rounded,
                  color: Color(0xFF6D28D9),
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

  Widget _buildScheduleCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule Service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_today_rounded,
                      color: Color(0xFF6D28D9),
                    ),
                    title: Text(
                      _preferredDate == null
                          ? 'Select Date *'
                          : DateFormat('MMM dd, yyyy').format(_preferredDate!),
                      style: TextStyle(
                        color: _preferredDate == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ListTile(
                    leading: Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF6D28D9),
                    ),
                    title: Text(
                      _preferredTime == null
                          ? 'Select Time'
                          : _preferredTime!.format(context),
                      style: TextStyle(
                        color: _preferredTime == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down_rounded),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            if (_preferredDate == null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Please select a date',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We will confirm your appointment within 30 minutes',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
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
                color: Color(0xFF6D28D9),
              ),
            ),
            SizedBox(height: 12),

            // Current Location Display
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
                labelText: 'Service Location *',
                hintText: 'Enter your location or use buttons below',
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF6D28D9),
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

            // Location Buttons
            Row(
              children: [
                Expanded(
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
                SizedBox(width: 8),
                Expanded(
                  child: _isLocationEnabled
                      ? ElevatedButton.icon(
                          onPressed: _stopLocationUpdates,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(Icons.location_off_rounded),
                          label: Text('Stop Sharing'),
                        )
                      : ElevatedButton.icon(
                          onPressed: _startLiveLocationSharing,
                          icon: Icon(Icons.location_searching_rounded),
                          label: Text('Share Live'),
                        ),
                ),
              ],
            ),

            SizedBox(height: 8),
            if (_isLocationEnabled) ...[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_rounded, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live location sharing is active. ${widget.selectedGarage.name} can track your location.',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          backgroundColor: Color(0xFF6D28D9),
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
                'Request Service from ${widget.selectedGarage.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

// Updated Garage Request Confirmation with Live Location Info
class GarageRequestConfirmation extends StatelessWidget {

  const GarageRequestConfirmation({
    super.key,
    required this.requestId,
    required this.vehicleNumber,
    required this.serviceType,
    required this.preferredDate,
    required this.preferredTime,
    required this.garageName,
    required this.garageDistance,
    required this.isLiveLocationEnabled,
    required this.onClose,
    required this.onTrack,
  });
  final String requestId;
  final String vehicleNumber;
  final String serviceType;
  final DateTime? preferredDate;
  final TimeOfDay? preferredTime;
  final String garageName;
  final double garageDistance;
  final bool isLiveLocationEnabled;
  final VoidCallback onClose;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Service Request Sent!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your service request has been sent to $garageName',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${garageDistance.toStringAsFixed(1)} km away • ${isLiveLocationEnabled ? 'Live Location On' : 'Standard Service'}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Request ID', requestId),
            _buildDetailRow('Vehicle', vehicleNumber),
            _buildDetailRow('Service Type', serviceType),
            _buildDetailRow('Garage', garageName),
            _buildDetailRow(
              'Location Sharing',
              isLiveLocationEnabled ? 'Live Tracking' : 'Standard',
            ),
            if (preferredDate != null)
              _buildDetailRow(
                'Preferred Date',
                DateFormat('MMM dd, yyyy').format(preferredDate!),
              ),
            if (preferredTime != null)
              _buildDetailRow('Preferred Time', preferredTime!.format(context)),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    child: Text('Back to Home'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTrack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D28D9),
                    ),
                    child: Text('Track Service'),
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
}
