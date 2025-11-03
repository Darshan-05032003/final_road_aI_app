// import 'package:smart_road_app/controller/sharedprefrence.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class RequestInsuranceScreen extends StatefulWidget {
//   final bool isRenewal;
//   final Map<String, dynamic>? existingPolicy;
//   final String? selectedProvider;

//   const RequestInsuranceScreen({
//     super.key,
//     this.isRenewal = false,
//     this.existingPolicy,
//     this.selectedProvider,
//   });

//   @override
//   State<RequestInsuranceScreen> createState() => _RequestInsuranceScreenState();
// }

// class _RequestInsuranceScreenState extends State<RequestInsuranceScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _vehicleNumberController = TextEditingController();
//   final TextEditingController _vehicleModelController = TextEditingController();
//   final TextEditingController _vehicleYearController = TextEditingController();
//   final TextEditingController _vehicleColorController = TextEditingController();
//   final TextEditingController _chassisNumberController = TextEditingController();
//   final TextEditingController _engineNumberController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();

//   String _selectedFuelType = 'Petrol';
//   String _selectedInsuranceType = 'Comprehensive';
//   String _selectedPurpose = 'New Policy';
//   String _selectedVehicleType = 'Car';
//   String? _selectedProvider;
//   final List<Map<String, dynamic>> _uploadedDocuments = [];
//   bool _isLoading = false;
//   String? _userEmail;
//   final ImagePicker _picker = ImagePicker();

//   final List<String> _fuelTypes = ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'];
//   final List<String> _insuranceTypes = ['Third Party', 'Comprehensive', 'Zero Depreciation', 'Personal Accident Cover'];
//   final List<String> _purposes = ['New Policy', 'Renewal', 'Transfer', 'Modification'];
//   final List<String> _vehicleTypes = ['Car', 'Motorcycle', 'SUV', 'Commercial Vehicle', 'Three Wheeler'];

//   // Real Insurance Providers Data
//   final List<Map<String, dynamic>> _insuranceProviders = [
//     {
//       'id': 'provider_1',
//       'name': 'HDFC ERGO General Insurance',
//       'rating': 4.5,
//       'claimsSettlement': '95.2%',
//       'premiumRange': '₹4,200 - ₹6,500',
//       'services': ['Comprehensive Coverage', 'Zero Depreciation', 'Roadside Assistance', 'Engine Protection'],
//       'description': 'One of India\'s leading general insurers with quick claim settlement and extensive network.',
//       'established': '2002',
//       'customers': '15M+',
//       'claimProcessTime': '2-3 days',
//       'networkGarages': '10,000+',
//       'contact': '1800-2666',
//       'website': 'www.hdfcergo.com',
//       'color': Colors.blue,
//       'icon': Icons.security_rounded,
//       'features': ['Cashless claim at 10,000+ garages', '24/7 customer support', 'Quick claim processing']
//     },
//     {
//       'id': 'provider_2',
//       'name': 'ICICI Lombard General Insurance',
//       'rating': 4.6,
//       'claimsSettlement': '96.1%',
//       'premiumRange': '₹4,500 - ₹7,000',
//       'services': ['Comprehensive Insurance', 'Personal Accident Cover', 'Return to Invoice'],
//       'description': 'Trusted insurance partner with innovative products and digital claim process.',
//       'established': '2001',
//       'customers': '12M+',
//       'claimProcessTime': '1-2 days',
//       'networkGarages': '8,500+',
//       'contact': '1800-2666',
//       'website': 'www.icicilombard.com',
//       'color': Colors.green,
//       'icon': Icons.verified_user_rounded,
//       'features': ['Instant policy issuance', 'Digital claim process', '24x7 roadside assistance']
//     }
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _selectedProvider = widget.selectedProvider;
//     _loadUserData();

//     if (widget.isRenewal && widget.existingPolicy != null) {
//       _vehicleNumberController.text = widget.existingPolicy!['vehicleNumber'] ?? '';
//       _selectedPurpose = 'Renewal';
//       _selectedInsuranceType = widget.existingPolicy!['insuranceType'] ?? 'Comprehensive';
//       _selectedProvider = widget.existingPolicy!['preferredProvider'];
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       setState(() {
//         _userEmail = userEmail;
//         _emailController.text = userEmail ?? '';
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }

//   Future<void> _submitInsuranceRequest() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_userEmail == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please login to submit insurance request'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final requestId = 'INS${DateTime.now().millisecondsSinceEpoch}';
//       double basePremium = _calculatePremiumEstimate();

//       await FirebaseFirestore.instance
//           .collection('vehicle_owners')
//           .doc(_userEmail)
//           .collection('insurance_requests')
//           .doc(requestId)
//           .set({
//         'requestId': requestId,
//         'ownerName': _nameController.text.trim(),
//         'ownerEmail': _emailController.text.trim(),
//         'ownerPhone': _phoneController.text.trim(),
//         'ownerAddress': _addressController.text.trim(),
//         'vehicleNumber': _vehicleNumberController.text.trim().toUpperCase(),
//         'vehicleModel': _vehicleModelController.text.trim(),
//         'vehicleYear': _vehicleYearController.text.trim(),
//         'vehicleColor': _vehicleColorController.text.trim(),
//         'vehicleType': _selectedVehicleType,
//         'chassisNumber': _chassisNumberController.text.trim().toUpperCase(),
//         'engineNumber': _engineNumberController.text.trim().toUpperCase(),
//         'fuelType': _selectedFuelType,
//         'insuranceType': _selectedInsuranceType,
//         'purpose': _selectedPurpose,
//         'preferredProvider': _selectedProvider ?? 'Any Provider',
//         'uploadedDocuments': _uploadedDocuments,
//         'estimatedPremium': basePremium,
//         'status': 'pending_review',
//         'submittedDate': DateTime.now().toString(),
//         'estimatedCompletion': DateTime.now().add(const Duration(days: 7)).toString(),
//         'currentStep': 0,
//         'ownerId': _userEmail,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       if (mounted) {
//         showDialog(
//           context: context,
//           builder: (context) => InsuranceRequestConfirmation(
//             requestId: requestId,
//             vehicleNumber: _vehicleNumberController.text.trim(),
//             insuranceType: _selectedInsuranceType,
//             provider: _selectedProvider ?? 'Any Provider',
//             userEmail: _userEmail!,
//             estimatedPremium: basePremium,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to submit insurance request: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   double _calculatePremiumEstimate() {
//     double basePremium = 0;
//     switch (_selectedVehicleType) {
//       case 'Car': basePremium = 5000; break;
//       case 'Motorcycle': basePremium = 1500; break;
//       case 'SUV': basePremium = 7000; break;
//       default: basePremium = 5000;
//     }

//     if (_selectedInsuranceType == 'Comprehensive') {
//       basePremium *= 1.5;
//     } else if (_selectedInsuranceType == 'Zero Depreciation') basePremium *= 1.8;

//     final currentYear = DateTime.now().year;
//     final vehicleYear = int.tryParse(_vehicleYearController.text) ?? currentYear;
//     final vehicleAge = currentYear - vehicleYear;
//     if (vehicleAge > 5) basePremium *= 1.2;

//     return basePremium;
//   }

//   Future<void> _uploadDocument(String docType) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() { _isLoading = true; });

//         final String fileName = '${_userEmail}_${DateTime.now().millisecondsSinceEpoch}_$docType.jpg';
//         final Reference storageRef = FirebaseStorage.instance.ref().child('insurance_documents/$fileName');
//         final UploadTask uploadTask = storageRef.putFile(File(image.path));
//         final TaskSnapshot snapshot = await uploadTask;
//         final String downloadUrl = await snapshot.ref.getDownloadURL();

//         final documentData = {
//           'name': docType,
//           'fileName': fileName,
//           'url': downloadUrl,
//           'uploadedAt': DateTime.now().toString(),
//           'type': _getDocumentType(docType),
//         };

//         setState(() {
//           _uploadedDocuments.add(documentData);
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('$docType uploaded successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to upload document: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   String _getDocumentType(String docName) {
//     if (docName.contains('RC')) return 'rc_book';
//     if (docName.contains('ID')) return 'id_proof';
//     return 'other';
//   }

//   void _showDocumentUploadOptions(String docType) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Upload $docType'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_camera_rounded, color: Color(0xFF6D28D9)),
//               title: const Text('Take Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _uploadDocument(docType);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF6D28D9)),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _uploadDocument(docType);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Insurance Request'),
//         backgroundColor: const Color(0xFF6D28D9),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: _userEmail == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildRequestTypeCard(),
//                     const SizedBox(height: 20),
//                     _buildOwnerDetailsCard(),
//                     const SizedBox(height: 20),
//                     _buildVehicleDetailsCard(),
//                     const SizedBox(height: 20),
//                     _buildPremiumEstimateCard(),
//                     const SizedBox(height: 20),
//                     _buildInsuranceDetailsCard(),
//                     const SizedBox(height: 20),
//                     _buildDocumentsCard(),
//                     const SizedBox(height: 30),
//                     _buildSubmitButton(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildRequestTypeCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.request_quote_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Insurance Request Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               initialValue: _selectedPurpose,
//               decoration: InputDecoration(
//                 labelText: 'Insurance Purpose',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 filled: true,
//                 fillColor: Colors.grey[50],
//               ),
//               items: _purposes.map((purpose) {
//                 return DropdownMenuItem(value: purpose, child: Text(purpose));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() { _selectedPurpose = value!; });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOwnerDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Vehicle Owner Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Full Name as per RC',
//                 prefixIcon: const Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter your name';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             TextFormField(controller: _emailController, readOnly: true, decoration: InputDecoration(labelText: 'Email Address', prefixIcon: const Icon(Icons.email_rounded, color: Color(0xFF6D28D9))),),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _phoneController,
//               decoration: InputDecoration(labelText: 'Mobile Number', prefixIcon: const Icon(Icons.phone_rounded, color: Color(0xFF6D28D9))),
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter mobile number';
//                 if (value.length != 10) return 'Mobile number must be 10 digits';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _addressController,
//               maxLines: 3,
//               decoration: InputDecoration(labelText: 'Complete Address', prefixIcon: const Icon(Icons.home_rounded, color: Color(0xFF6D28D9))),
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter your address';
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
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Vehicle Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _vehicleNumberController,
//               decoration: InputDecoration(labelText: 'Vehicle Registration Number', prefixIcon: const Icon(Icons.confirmation_number_rounded, color: Color(0xFF6D28D9))),
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter vehicle number';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             Row(children: [
//               Expanded(child: TextFormField(controller: _vehicleModelController, decoration: InputDecoration(labelText: 'Vehicle Model', prefixIcon: const Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9))),)),
//               SizedBox(width: 12),
//               Expanded(child: TextFormField(controller: _vehicleColorController, decoration: InputDecoration(labelText: 'Vehicle Color', prefixIcon: const Icon(Icons.color_lens_rounded, color: Color(0xFF6D28D9))),)),
//             ]),
//             const SizedBox(height: 12),
//             Row(children: [
//               Expanded(child: TextFormField(controller: _vehicleYearController, decoration: InputDecoration(labelText: 'Manufacturing Year', prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF6D28D9))), keyboardType: TextInputType.number)),
//               SizedBox(width: 12),
//               Expanded(child: DropdownButtonFormField<String>(initialValue: _selectedVehicleType, decoration: InputDecoration(labelText: 'Vehicle Type'), items: _vehicleTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(), onChanged: (value) { setState(() { _selectedVehicleType = value!; }); },)),
//             ]),
//             const SizedBox(height: 12),
//             Row(children: [
//               Expanded(child: TextFormField(controller: _chassisNumberController, decoration: InputDecoration(labelText: 'Chassis Number', prefixIcon: const Icon(Icons.qr_code_rounded, color: Color(0xFF6D28D9))),)),
//               SizedBox(width: 12),
//               Expanded(child: TextFormField(controller: _engineNumberController, decoration: InputDecoration(labelText: 'Engine Number', prefixIcon: const Icon(Icons.engineering_rounded, color: Color(0xFF6D28D9))),)),
//             ]),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(initialValue: _selectedFuelType, decoration: InputDecoration(labelText: 'Fuel Type'), items: _fuelTypes.map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel))).toList(), onChanged: (value) { setState(() { _selectedFuelType = value!; }); },),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumEstimateCard() {
//     final estimatedPremium = _calculatePremiumEstimate();
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.attach_money_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Premium Estimate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue[100]!)),
//               child: Column(children: [
//                 Text('Estimated Annual Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue[800])),
//                 const SizedBox(height: 8),
//                 Text('₹${estimatedPremium.toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//                 const SizedBox(height: 8),
//                 Text('Based on $_selectedVehicleType • $_selectedInsuranceType', style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInsuranceDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Insurance Coverage Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(initialValue: _selectedInsuranceType, decoration: InputDecoration(labelText: 'Insurance Coverage Type'), items: _insuranceTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(), onChanged: (value) { setState(() { _selectedInsuranceType = value!; }); },),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(initialValue: _selectedProvider, decoration: InputDecoration(labelText: 'Preferred Insurance Company'), items: [const DropdownMenuItem(value: null, child: Text('Any Insurance Provider')), ..._insuranceProviders.map<DropdownMenuItem<String>>((provider) => DropdownMenuItem<String>(value: provider['name'], child: Text(provider['name'])))], onChanged: (value) { setState(() { _selectedProvider = value; }); },),
//             const SizedBox(height: 12),
//             if (_selectedProvider != null) ..._buildProviderInfo(_selectedProvider!),
//             const SizedBox(height: 16),
//             _buildProvidersList(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildProviderInfo(String providerName) {
//     final provider = _insuranceProviders.firstWhere((p) => p['name'] == providerName, orElse: () => {});
//     if (provider.isEmpty) return [];
//     return [
//       Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: provider['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: provider['color'].withOpacity(0.3))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(children: [Icon(provider['icon'], color: provider['color']), SizedBox(width: 8), Text('${provider['name']}', style: TextStyle(fontWeight: FontWeight.bold, color: provider['color'], fontSize: 16))]),
//           const SizedBox(height: 6),
//           Text(provider['description'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//           const SizedBox(height: 8),
//           Row(children: [Icon(Icons.star_rounded, color: Colors.amber, size: 16), Text(' ${provider['rating']} Rating'), SizedBox(width: 12), Icon(Icons.thumb_up_rounded, color: Colors.green, size: 14), Text(' ${provider['claimsSettlement']} Claim Settlement')]),
//           const SizedBox(height: 4),
//           Text('Premium Range: ${provider['premiumRange']}'),
//         ]),
//       ),
//     ];
//   }

//   Widget _buildProvidersList() {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text('Available Insurance Providers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//       const SizedBox(height: 12),
//       ..._insuranceProviders.map((provider) => _buildProviderCard(provider)),
//     ]);
//   }

//   Widget _buildProviderCard(Map<String, dynamic> provider) {
//     return Card(margin: const EdgeInsets.only(bottom: 12), elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [
//         Container(width: 40, height: 40, decoration: BoxDecoration(color: provider['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(provider['icon'], color: provider['color'])),
//         const SizedBox(width: 12),
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(provider['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Row(children: [Icon(Icons.star_rounded, color: Colors.amber, size: 16), Text(' ${provider['rating']}'), SizedBox(width: 8), Icon(Icons.people_rounded, color: Colors.grey, size: 14), Text(' ${provider['customers']}')])])),
//         ElevatedButton(onPressed: () { setState(() { _selectedProvider = provider['name']; }); }, style: ElevatedButton.styleFrom(backgroundColor: _selectedProvider == provider['name'] ? provider['color'] : Colors.grey[300], foregroundColor: _selectedProvider == provider['name'] ? Colors.white : Colors.grey[600]), child: Text(_selectedProvider == provider['name'] ? 'Selected' : 'Select')),
//       ]),
//       const SizedBox(height: 12),
//       Text(provider['description'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//     ])));
//   }

//   Widget _buildDocumentsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Icon(Icons.folder_rounded, color: Color(0xFF6D28D9)),
//               SizedBox(width: 8),
//               Text('Required Vehicle Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//             ]),
//             const SizedBox(height: 12),
//             Text('Upload clear photos/scans of the following documents:', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
//             const SizedBox(height: 12),
//             _buildDocumentItem('Vehicle RC Book Front & Back', Icons.description_rounded, 'Mandatory for all policies'),
//             _buildDocumentItem('Owner ID Proof (Aadhaar/PAN/Driving License)', Icons.credit_card_rounded, 'Mandatory for verification'),
//             _buildDocumentItem('Vehicle Photos (Front, Back, Side)', Icons.photo_camera_rounded, 'Show all sides of vehicle'),
//             if (_selectedPurpose == 'Renewal') _buildDocumentItem('Previous Insurance Policy Copy', Icons.history_rounded, 'Required for renewal'),
//             if (_selectedPurpose == 'Renewal') _buildDocumentItem('No Claim Bonus Certificate', Icons.verified_rounded, 'If applicable'),
//             const SizedBox(height: 16),
//             if (_uploadedDocuments.isNotEmpty) ...[
//               const Text('Uploaded Documents:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//               const SizedBox(height: 8),
//               ..._uploadedDocuments.map((doc) => Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: const Icon(Icons.attachment_rounded, color: Color(0xFF6D28D9)), title: Text(doc['name'], style: const TextStyle(fontSize: 14)), subtitle: Text('Uploaded: ${DateFormat('dd MMM yyyy').format(DateTime.parse(doc['uploadedAt']))}', style: TextStyle(fontSize: 10, color: Colors.grey[600])), trailing: IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red), onPressed: () { setState(() { _uploadedDocuments.remove(doc); }); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document removed'), backgroundColor: Colors.orange)); },)))),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentItem(String title, IconData icon, String description) {
//     return Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: Icon(icon, color: const Color(0xFF6D28D9)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), subtitle: Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])), trailing: ElevatedButton(onPressed: () => _showDocumentUploadOptions(title), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), foregroundColor: Colors.white), child: const Text('Upload', style: TextStyle(fontSize: 12)))));
//   }

//   Widget _buildSubmitButton() {
//     return Column(children: [
//       Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue[100]!)), child: Row(children: [Icon(Icons.info_rounded, color: Colors.blue[700], size: 20), SizedBox(width: 8), Expanded(child: Text('Your insurance request will be reviewed and you will receive quotes from providers within 24 hours.', style: TextStyle(color: Colors.blue[700], fontSize: 12)))])),
//       const SizedBox(height: 16),
//       SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isLoading ? null : _submitInsuranceRequest, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.send_rounded), SizedBox(width: 8), Text('Submit Insurance Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]))),
//     ]);
//   }
// }

// class InsuranceRequestConfirmation extends StatelessWidget {
//   final String requestId;
//   final String vehicleNumber;
//   final String insuranceType;
//   final String provider;
//   final String userEmail;
//   final double estimatedPremium;

//   const InsuranceRequestConfirmation({super.key, required this.requestId, required this.vehicleNumber, required this.insuranceType, required this.provider, required this.userEmail, required this.estimatedPremium});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
//       Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, size: 50, color: Colors.green)),
//       const SizedBox(height: 16),
//       const Text('Insurance Request Submitted!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
//       const SizedBox(height: 12),
//       Text('Your vehicle insurance request has been successfully submitted. Insurance providers will contact you with quotes shortly.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//       const SizedBox(height: 20),
//       Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)), child: Column(children: [
//         _buildDetailRow('Request ID', requestId),
//         _buildDetailRow('Vehicle Number', vehicleNumber),
//         _buildDetailRow('Insurance Type', insuranceType),
//         _buildDetailRow('Preferred Provider', provider),
//         _buildDetailRow('Estimated Premium', '₹${estimatedPremium.toStringAsFixed(0)}'),
//         _buildDetailRow('Submitted Date', DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())),
//       ])),
//       const SizedBox(height: 20),
//       const Text('What happens next?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//       const SizedBox(height: 8),
//       Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('• Insurance providers will review your request\n• You will receive quotes within 24 hours\n• Compare quotes and choose the best one\n• Complete payment to activate your policy', style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
//       const SizedBox(height: 24),
//       Row(children: [
//         Expanded(child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Back to Home'))),
//         const SizedBox(width: 12),
//         Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => TrackInsuranceRequest(requestId: requestId, userEmail: userEmail))); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Track Request'))),
//       ]),
//     ])));
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
//       Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
//     ]));
//   }
// }

// class TrackInsuranceRequest extends StatefulWidget {
//   final String requestId;
//   final String userEmail;
//   const TrackInsuranceRequest({super.key, required this.requestId, required this.userEmail});
//   @override
//   State<TrackInsuranceRequest> createState() => _TrackInsuranceRequestState();
// }

// class _TrackInsuranceRequestState extends State<TrackInsuranceRequest> {
//   Map<String, dynamic>? _requestDetails;
//   bool _isLoading = true;
//   final List<Map<String, dynamic>> _statusSteps = [
//     {'status': 'Request Submitted', 'description': 'Your insurance request has been received', 'completed': true},
//     {'status': 'Under Review', 'description': 'Insurance providers are reviewing your request', 'completed': false},
//     {'status': 'Quotes Received', 'description': 'Insurance quotes are available for comparison', 'completed': false},
//     {'status': 'Policy Selection', 'description': 'Choose your preferred insurance policy', 'completed': false},
//     {'status': 'Payment Processing', 'description': 'Complete payment for selected policy', 'completed': false},
//     {'status': 'Policy Active', 'description': 'Your vehicle insurance is now active', 'completed': false},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadRequestDetails();
//   }

//   Future<void> _loadRequestDetails() async {
//     try {
//       final doc = await FirebaseFirestore.instance.collection('vehicle_owners').doc(widget.userEmail).collection('insurance_requests').doc(widget.requestId).get();
//       if (doc.exists) {
//         setState(() {
//           _requestDetails = doc.data();
//           _isLoading = false;
//         });
//       } else {
//         setState(() { _isLoading = false; });
//       }
//     } catch (e) {
//       print('Error loading request details: $e');
//       setState(() { _isLoading = false; });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Track Insurance Request'), backgroundColor: const Color(0xFF6D28D9), foregroundColor: Colors.white),
//       body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
//         _buildRequestSummary(),
//         const SizedBox(height: 20),
//         _buildStatusTimeline(),
//         const SizedBox(height: 20),
//         _buildSupportSection(),
//       ])),
//     );
//   }

//   Widget _buildRequestSummary() {
//     return Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [Icon(Icons.request_quote_rounded, color: Color(0xFF6D28D9)), SizedBox(width: 8), Text('Insurance Request Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)))]),
//       const SizedBox(height: 12),
//       _buildSummaryRow('Request ID', _requestDetails?['requestId'] ?? 'N/A'),
//       _buildSummaryRow('Vehicle Number', _requestDetails?['vehicleNumber'] ?? 'N/A'),
//       _buildSummaryRow('Vehicle Model', _requestDetails?['vehicleModel'] ?? 'N/A'),
//       _buildSummaryRow('Insurance Type', _requestDetails?['insuranceType'] ?? 'N/A'),
//       _buildSummaryRow('Preferred Provider', _requestDetails?['preferredProvider'] ?? 'Any Provider'),
//       _buildSummaryRow('Current Status', _formatStatus(_requestDetails?['status'] ?? 'pending_review')),
//       _buildSummaryRow('Submitted Date', _formatDate(_requestDetails?['submittedDate'])),
//     ])));
//   }

//   Widget _buildSummaryRow(String label, String value) {
//     return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
//       Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
//     ]));
//   }

//   Widget _buildStatusTimeline() {
//     final currentStatus = _requestDetails?['status'] ?? 'pending_review';
//     final currentStepIndex = _getCurrentStepIndex(currentStatus);
//     return Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [Icon(Icons.timeline_rounded, color: Color(0xFF6D28D9)), SizedBox(width: 8), Text('Insurance Request Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)))]),
//       const SizedBox(height: 16),
//       ..._statusSteps.asMap().entries.map((entry) {
//         final index = entry.key;
//         final step = entry.value;
//         final isLast = index == _statusSteps.length - 1;
//         final isCompleted = index <= currentStepIndex;
//         return _buildTimelineStep(step: step, isLast: isLast, isActive: isCompleted);
//       }),
//     ])));
//   }

//   int _getCurrentStepIndex(String status) {
//     switch (status) {
//       case 'pending_review': return 0;
//       case 'under_review': return 1;
//       case 'quotes_received': return 2;
//       case 'policy_selected': return 3;
//       case 'payment_pending': return 4;
//       case 'active': return 5;
//       default: return 0;
//     }
//   }

//   String _formatStatus(String status) {
//     switch (status) {
//       case 'pending_review': return 'Pending Review';
//       case 'under_review': return 'Under Review';
//       case 'quotes_received': return 'Quotes Received';
//       case 'policy_selected': return 'Policy Selected';
//       case 'payment_pending': return 'Payment Pending';
//       case 'active': return 'Policy Active';
//       default: return status;
//     }
//   }

//   Widget _buildTimelineStep({required Map<String, dynamic> step, required bool isLast, required bool isActive}) {
//     return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Column(children: [
//         Container(width: 24, height: 24, decoration: BoxDecoration(color: isActive ? const Color(0xFF6D28D9) : Colors.grey[300]!, shape: BoxShape.circle), child: Icon(Icons.check_rounded, size: 16, color: Colors.white)),
//         if (!isLast) Container(width: 2, height: 40, color: isActive ? const Color(0xFF6D28D9) : Colors.grey[300]!),
//       ]),
//       const SizedBox(width: 12),
//       Expanded(child: Padding(padding: EdgeInsets.only(bottom: isLast ? 0 : 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(step['status'], style: TextStyle(fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF6D28D9) : Colors.grey[600], fontSize: 14)),
//         const SizedBox(height: 4),
//         Text(step['description'], style: TextStyle(color: isActive ? Colors.grey[800] : Colors.grey[600], fontSize: 12)),
//       ]))),
//     ]);
//   }

//   Widget _buildSupportSection() {
//     return Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text('Need Help with Your Insurance?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
//       const SizedBox(height: 12),
//       Row(children: [
//         Expanded(child: OutlinedButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting to insurance support...'), backgroundColor: Colors.blue)); }, icon: const Icon(Icons.support_agent_rounded), label: const Text('Contact Support'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)))),
//         const SizedBox(width: 12),
//         Expanded(child: ElevatedButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checking for available quotes...'), backgroundColor: Colors.green)); }, icon: const Icon(Icons.request_quote_rounded), label: const Text('View Quotes'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), padding: const EdgeInsets.symmetric(vertical: 12)))),
//       ]),
//     ])));
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(date);
//     } catch (e) {
//       return 'N/A';
//     }
//   }
// }

import 'package:smart_road_app/controller/sharedprefrence.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class RequestInsuranceScreen extends StatefulWidget {
  final bool isRenewal;
  final Map<String, dynamic>? existingPolicy;
  final String? selectedProvider;

  const RequestInsuranceScreen({
    super.key,
    this.isRenewal = false,
    this.existingPolicy,
    this.selectedProvider,
  });

  @override
  State<RequestInsuranceScreen> createState() => _RequestInsuranceScreenState();
}

class _RequestInsuranceScreenState extends State<RequestInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();
  final TextEditingController _chassisNumberController =
      TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedFuelType = 'Petrol';
  String _selectedInsuranceType = 'Comprehensive';
  String _selectedPurpose = 'New Policy';
  String _selectedVehicleType = 'Car';
  String? _selectedProvider;
  final List<Map<String, dynamic>> _uploadedDocuments = [];
  bool _isLoading = false;
  String? _userEmail;
  final ImagePicker _picker = ImagePicker();

  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'CNG',
    'Electric',
    'Hybrid',
  ];
  final List<String> _insuranceTypes = [
    'Third Party',
    'Comprehensive',
    'Zero Depreciation',
    'Personal Accident Cover',
  ];
  final List<String> _purposes = [
    'New Policy',
    'Renewal',
    'Transfer',
    'Modification',
  ];
  final List<String> _vehicleTypes = [
    'Car',
    'Motorcycle',
    'SUV',
    'Commercial Vehicle',
    'Three Wheeler',
  ];

  // Real Insurance Providers Data
  final List<Map<String, dynamic>> _insuranceProviders = [
    {
      'id': 'provider_1',
      'name': 'HDFC ERGO General Insurance',
      'rating': 4.5,
      'claimsSettlement': '95.2%',
      'premiumRange': '₹4,200 - ₹6,500',
      'services': [
        'Comprehensive Coverage',
        'Zero Depreciation',
        'Roadside Assistance',
        'Engine Protection',
      ],
      'description':
          'One of India\'s leading general insurers with quick claim settlement and extensive network.',
      'established': '2002',
      'customers': '15M+',
      'claimProcessTime': '2-3 days',
      'networkGarages': '10,000+',
      'contact': '1800-2666',
      'website': 'www.hdfcergo.com',
      'color': Colors.blue,
      'icon': Icons.security_rounded,
      'features': [
        'Cashless claim at 10,000+ garages',
        '24/7 customer support',
        'Quick claim processing',
      ],
    },
    {
      'id': 'provider_2',
      'name': 'ICICI Lombard General Insurance',
      'rating': 4.6,
      'claimsSettlement': '96.1%',
      'premiumRange': '₹4,500 - ₹7,000',
      'services': [
        'Comprehensive Insurance',
        'Personal Accident Cover',
        'Return to Invoice',
      ],
      'description':
          'Trusted insurance partner with innovative products and digital claim process.',
      'established': '2001',
      'customers': '12M+',
      'claimProcessTime': '1-2 days',
      'networkGarages': '8,500+',
      'contact': '1800-2666',
      'website': 'www.icicilombard.com',
      'color': Colors.green,
      'icon': Icons.verified_user_rounded,
      'features': [
        'Instant policy issuance',
        'Digital claim process',
        '24x7 roadside assistance',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.selectedProvider;
    _loadUserData();

    if (widget.isRenewal && widget.existingPolicy != null) {
      _vehicleNumberController.text =
          widget.existingPolicy!['vehicleNumber'] ?? '';
      _selectedPurpose = 'Renewal';
      _selectedInsuranceType =
          widget.existingPolicy!['insuranceType'] ?? 'Comprehensive';
      _selectedProvider = widget.existingPolicy!['preferredProvider'];
    }
  }

  Future<void> _loadUserData() async {
    try {
      String? userEmail = await AuthService.getUserEmail();
      setState(() {
        _userEmail = userEmail;
        _emailController.text = userEmail ?? '';
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _submitInsuranceRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to submit insurance request'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestId = 'INS${DateTime.now().millisecondsSinceEpoch}';
      double basePremium = _calculatePremiumEstimate();

      await FirebaseFirestore.instance
          .collection('vehicle_owners')
          .doc(_userEmail)
          .collection('insurance_requests')
          .doc(requestId)
          .set({
            'requestId': requestId,
            'ownerName': _nameController.text.trim(),
            'ownerEmail': _emailController.text.trim(),
            'ownerPhone': _phoneController.text.trim(),
            'ownerAddress': _addressController.text.trim(),
            'vehicleNumber': _vehicleNumberController.text.trim().toUpperCase(),
            'vehicleModel': _vehicleModelController.text.trim(),
            'vehicleYear': _vehicleYearController.text.trim(),
            'vehicleColor': _vehicleColorController.text.trim(),
            'vehicleType': _selectedVehicleType,
            'chassisNumber': _chassisNumberController.text.trim().toUpperCase(),
            'engineNumber': _engineNumberController.text.trim().toUpperCase(),
            'fuelType': _selectedFuelType,
            'insuranceType': _selectedInsuranceType,
            'purpose': _selectedPurpose,
            'preferredProvider': _selectedProvider ?? 'Any Provider',
            'uploadedDocuments': _uploadedDocuments,
            'estimatedPremium': basePremium,
            'status': 'pending_review',
            'submittedDate': DateTime.now().toString(),
            'estimatedCompletion': DateTime.now()
                .add(const Duration(days: 7))
                .toString(),
            'currentStep': 0,
            'ownerId': _userEmail,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => InsuranceRequestConfirmation(
            requestId: requestId,
            vehicleNumber: _vehicleNumberController.text.trim(),
            insuranceType: _selectedInsuranceType,
            provider: _selectedProvider ?? 'Any Provider',
            userEmail: _userEmail!,
            estimatedPremium: basePremium,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit insurance request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _calculatePremiumEstimate() {
    double basePremium = 0;
    switch (_selectedVehicleType) {
      case 'Car':
        basePremium = 5000;
        break;
      case 'Motorcycle':
        basePremium = 1500;
        break;
      case 'SUV':
        basePremium = 7000;
        break;
      default:
        basePremium = 5000;
    }

    if (_selectedInsuranceType == 'Comprehensive') {
      basePremium *= 1.5;
    } else if (_selectedInsuranceType == 'Zero Depreciation')
      basePremium *= 1.8;

    final currentYear = DateTime.now().year;
    final vehicleYear =
        int.tryParse(_vehicleYearController.text) ?? currentYear;
    final vehicleAge = currentYear - vehicleYear;
    if (vehicleAge > 5) basePremium *= 1.2;

    return basePremium;
  }

  // ENHANCED FIREBASE STORAGE DOCUMENT UPLOAD FUNCTIONALITY
  Future<void> _uploadDocument(String docType, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        // User cancelled the picker
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fileName =
          '${_userEmail}_${timestamp}_${docType.replaceAll(' ', '_')}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child(
        'insurance_documents/$_userEmail/$fileName',
      );

      // Upload file to Firebase Storage
      final File file = File(pickedFile.path);
      final UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': _userEmail!,
            'documentType': docType,
            'vehicleNumber': _vehicleNumberController.text.trim().toUpperCase(),
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload progress: $progress%');
      });

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Get file size
      final int fileSize = await file.length();

      // Create document data
      final documentData = {
        'name': docType,
        'fileName': fileName,
        'url': downloadUrl,
        'uploadedAt': DateTime.now().toIso8601String(),
        'type': _getDocumentType(docType),
        'fileSize': fileSize,
        'storagePath': snapshot.ref.fullPath,
      };

      setState(() {
        _uploadedDocuments.add(documentData);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$docType uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      print('Document uploaded successfully: $downloadUrl');
    } catch (e) {
      print('Error uploading document: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload document: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to delete document from Firebase Storage and local list
  Future<void> _deleteDocument(int index) async {
    try {
      final document = _uploadedDocuments[index];
      final String storagePath = document['storagePath'];

      // Delete from Firebase Storage
      await FirebaseStorage.instance.ref().child(storagePath).delete();
    
      // Remove from local list
      setState(() {
        _uploadedDocuments.removeAt(index);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting document: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getDocumentType(String docName) {
    if (docName.contains('RC')) return 'rc_book';
    if (docName.contains('ID Proof')) return 'id_proof';
    if (docName.contains('Vehicle Photos')) return 'vehicle_photos';
    if (docName.contains('Previous Insurance')) return 'previous_policy';
    if (docName.contains('No Claim Bonus')) return 'ncb_certificate';
    return 'other';
  }

  void _showDocumentUploadOptions(String docType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload $docType'),
        content: const Text('Choose how you want to upload the document'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _uploadDocument(docType, ImageSource.camera);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_camera, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text('Take Photo'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _uploadDocument(docType, ImageSource.gallery);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text('Choose from Gallery'),
              ],
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
        title: const Text('Insurance Request'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _userEmail == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildRequestTypeCard(),
                        const SizedBox(height: 20),
                        _buildOwnerDetailsCard(),
                        const SizedBox(height: 20),
                        _buildVehicleDetailsCard(),
                        const SizedBox(height: 20),
                        _buildPremiumEstimateCard(),
                        const SizedBox(height: 20),
                        _buildInsuranceDetailsCard(),
                        const SizedBox(height: 20),
                        _buildDocumentsCard(),
                        const SizedBox(height: 30),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF6D28D9),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Uploading Document...',
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
            ),
    );
  }

  Widget _buildRequestTypeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.request_quote_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Insurance Request Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedPurpose,
              decoration: InputDecoration(
                labelText: 'Insurance Purpose',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: _purposes.map((purpose) {
                return DropdownMenuItem(value: purpose, child: Text(purpose));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Vehicle Owner Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name as per RC',
                prefixIcon: const Icon(
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(
                  Icons.email_rounded,
                  color: Color(0xFF6D28D9),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: const Icon(
                  Icons.phone_rounded,
                  color: Color(0xFF6D28D9),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                if (value.length != 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Complete Address',
                prefixIcon: const Icon(
                  Icons.home_rounded,
                  color: Color(0xFF6D28D9),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Vehicle Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: 'Vehicle Registration Number',
                prefixIcon: const Icon(
                  Icons.confirmation_number_rounded,
                  color: Color(0xFF6D28D9),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _vehicleModelController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Model',
                      prefixIcon: const Icon(
                        Icons.directions_car_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _vehicleColorController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Color',
                      prefixIcon: const Icon(
                        Icons.color_lens_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _vehicleYearController,
                    decoration: InputDecoration(
                      labelText: 'Manufacturing Year',
                      prefixIcon: const Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedVehicleType,
                    decoration: InputDecoration(labelText: 'Vehicle Type'),
                    items: _vehicleTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _chassisNumberController,
                    decoration: InputDecoration(
                      labelText: 'Chassis Number',
                      prefixIcon: const Icon(
                        Icons.qr_code_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _engineNumberController,
                    decoration: InputDecoration(
                      labelText: 'Engine Number',
                      prefixIcon: const Icon(
                        Icons.engineering_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedFuelType,
              decoration: InputDecoration(labelText: 'Fuel Type'),
              items: _fuelTypes
                  .map(
                    (fuel) => DropdownMenuItem(value: fuel, child: Text(fuel)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFuelType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumEstimateCard() {
    final estimatedPremium = _calculatePremiumEstimate();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Premium Estimate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Estimated Annual Premium',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${estimatedPremium.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on $_selectedVehicleType • $_selectedInsuranceType',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Insurance Coverage Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedInsuranceType,
              decoration: InputDecoration(labelText: 'Insurance Coverage Type'),
              items: _insuranceTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedInsuranceType = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedProvider,
              decoration: InputDecoration(
                labelText: 'Preferred Insurance Company',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Any Insurance Provider'),
                ),
                ..._insuranceProviders.map<DropdownMenuItem<String>>(
                  (provider) => DropdownMenuItem<String>(
                    value: provider['name'],
                    child: Text(provider['name']),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProvider = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_selectedProvider != null)
              ..._buildProviderInfo(_selectedProvider!),
            const SizedBox(height: 16),
            _buildProvidersList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProviderInfo(String providerName) {
    final provider = _insuranceProviders.firstWhere(
      (p) => p['name'] == providerName,
      orElse: () => {},
    );
    if (provider.isEmpty) return [];
    return [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: provider['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: provider['color'].withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(provider['icon'], color: provider['color']),
                SizedBox(width: 8),
                Text(
                  '${provider['name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: provider['color'],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              provider['description'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                Text(' ${provider['rating']} Rating'),
                SizedBox(width: 12),
                Icon(Icons.thumb_up_rounded, color: Colors.green, size: 14),
                Text(' ${provider['claimsSettlement']} Claim Settlement'),
              ],
            ),
            const SizedBox(height: 4),
            Text('Premium Range: ${provider['premiumRange']}'),
          ],
        ),
      ),
    ];
  }

  Widget _buildProvidersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Insurance Providers',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D28D9),
          ),
        ),
        const SizedBox(height: 12),
        ..._insuranceProviders.map((provider) => _buildProviderCard(provider)),
      ],
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: provider['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(provider['icon'], color: provider['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          Text(' ${provider['rating']}'),
                          SizedBox(width: 8),
                          Icon(
                            Icons.people_rounded,
                            color: Colors.grey,
                            size: 14,
                          ),
                          Text(' ${provider['customers']}'),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedProvider = provider['name'];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedProvider == provider['name']
                        ? provider['color']
                        : Colors.grey[300],
                    foregroundColor: _selectedProvider == provider['name']
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                  child: Text(
                    _selectedProvider == provider['name']
                        ? 'Selected'
                        : 'Select',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              provider['description'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Required Vehicle Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Upload clear photos/scans of the following documents:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildDocumentItem(
              'Vehicle RC Book Front & Back',
              Icons.description_rounded,
              'Mandatory for all policies',
            ),
            _buildDocumentItem(
              'Owner ID Proof (Aadhaar/PAN/Driving License)',
              Icons.credit_card_rounded,
              'Mandatory for verification',
            ),
            _buildDocumentItem(
              'Vehicle Photos (Front, Back, Side)',
              Icons.photo_camera_rounded,
              'Show all sides of vehicle',
            ),
            if (_selectedPurpose == 'Renewal')
              _buildDocumentItem(
                'Previous Insurance Policy Copy',
                Icons.history_rounded,
                'Required for renewal',
              ),
            if (_selectedPurpose == 'Renewal')
              _buildDocumentItem(
                'No Claim Bonus Certificate',
                Icons.verified_rounded,
                'If applicable',
              ),
            const SizedBox(height: 16),
            if (_uploadedDocuments.isNotEmpty) ...[
              const Text(
                'Uploaded Documents:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D28D9),
                ),
              ),
              const SizedBox(height: 8),
              ..._uploadedDocuments.asMap().entries.map((entry) {
                final index = entry.key;
                final doc = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.attachment_rounded,
                      color: Color(0xFF6D28D9),
                    ),
                    title: Text(
                      doc['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      'Uploaded: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(doc['uploadedAt']))}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Colors.red),
                      onPressed: () =>
                          _showDeleteConfirmation(index, doc['name']),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int index, String docName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete $docName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDocument(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String title, IconData icon, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6D28D9)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: ElevatedButton(
          onPressed: () => _showDocumentUploadOptions(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D28D9),
            foregroundColor: Colors.white,
          ),
          child: const Text('Upload', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.blue[700], size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your insurance request will be reviewed and you will receive quotes from providers within 24 hours.',
                  style: TextStyle(color: Colors.blue[700], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitInsuranceRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Submit Insurance Request',
                        style: TextStyle(
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

class InsuranceRequestConfirmation extends StatelessWidget {
  final String requestId;
  final String vehicleNumber;
  final String insuranceType;
  final String provider;
  final String userEmail;
  final double estimatedPremium;

  const InsuranceRequestConfirmation({
    super.key,
    required this.requestId,
    required this.vehicleNumber,
    required this.insuranceType,
    required this.provider,
    required this.userEmail,
    required this.estimatedPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 50,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Insurance Request Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your vehicle insurance request has been successfully submitted. Insurance providers will contact you with quotes shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Request ID', requestId),
                  _buildDetailRow('Vehicle Number', vehicleNumber),
                  _buildDetailRow('Insurance Type', insuranceType),
                  _buildDetailRow('Preferred Provider', provider),
                  _buildDetailRow(
                    'Estimated Premium',
                    '₹${estimatedPremium.toStringAsFixed(0)}',
                  ),
                  _buildDetailRow(
                    'Submitted Date',
                    DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What happens next?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '• Insurance providers will review your request\n• You will receive quotes within 24 hours\n• Compare quotes and choose the best one\n• Complete payment to activate your policy',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackInsuranceRequest(
                            requestId: requestId,
                            userEmail: userEmail,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Track Request'),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackInsuranceRequest extends StatefulWidget {
  final String requestId;
  final String userEmail;
  const TrackInsuranceRequest({
    super.key,
    required this.requestId,
    required this.userEmail,
  });
  @override
  State<TrackInsuranceRequest> createState() => _TrackInsuranceRequestState();
}

class _TrackInsuranceRequestState extends State<TrackInsuranceRequest> {
  Map<String, dynamic>? _requestDetails;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _statusSteps = [
    {
      'status': 'Request Submitted',
      'description': 'Your insurance request has been received',
      'completed': true,
    },
    {
      'status': 'Under Review',
      'description': 'Insurance providers are reviewing your request',
      'completed': false,
    },
    {
      'status': 'Quotes Received',
      'description': 'Insurance quotes are available for comparison',
      'completed': false,
    },
    {
      'status': 'Policy Selection',
      'description': 'Choose your preferred insurance policy',
      'completed': false,
    },
    {
      'status': 'Payment Processing',
      'description': 'Complete payment for selected policy',
      'completed': false,
    },
    {
      'status': 'Policy Active',
      'description': 'Your vehicle insurance is now active',
      'completed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadRequestDetails();
  }

  Future<void> _loadRequestDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('vehicle_owners')
          .doc(widget.userEmail)
          .collection('insurance_requests')
          .doc(widget.requestId)
          .get();
      if (doc.exists) {
        setState(() {
          _requestDetails = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading request details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Insurance Request'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRequestSummary(),
                  const SizedBox(height: 20),
                  _buildStatusTimeline(),
                  const SizedBox(height: 20),
                  _buildSupportSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildRequestSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.request_quote_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Insurance Request Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Request ID',
              _requestDetails?['requestId'] ?? 'N/A',
            ),
            _buildSummaryRow(
              'Vehicle Number',
              _requestDetails?['vehicleNumber'] ?? 'N/A',
            ),
            _buildSummaryRow(
              'Vehicle Model',
              _requestDetails?['vehicleModel'] ?? 'N/A',
            ),
            _buildSummaryRow(
              'Insurance Type',
              _requestDetails?['insuranceType'] ?? 'N/A',
            ),
            _buildSummaryRow(
              'Preferred Provider',
              _requestDetails?['preferredProvider'] ?? 'Any Provider',
            ),
            _buildSummaryRow(
              'Current Status',
              _formatStatus(_requestDetails?['status'] ?? 'pending_review'),
            ),
            _buildSummaryRow(
              'Submitted Date',
              _formatDate(_requestDetails?['submittedDate']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final currentStatus = _requestDetails?['status'] ?? 'pending_review';
    final currentStepIndex = _getCurrentStepIndex(currentStatus);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline_rounded, color: Color(0xFF6D28D9)),
                SizedBox(width: 8),
                Text(
                  'Insurance Request Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._statusSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isLast = index == _statusSteps.length - 1;
              final isCompleted = index <= currentStepIndex;
              return _buildTimelineStep(
                step: step,
                isLast: isLast,
                isActive: isCompleted,
              );
            }),
          ],
        ),
      ),
    );
  }

  int _getCurrentStepIndex(String status) {
    switch (status) {
      case 'pending_review':
        return 0;
      case 'under_review':
        return 1;
      case 'quotes_received':
        return 2;
      case 'policy_selected':
        return 3;
      case 'payment_pending':
        return 4;
      case 'active':
        return 5;
      default:
        return 0;
    }
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
      default:
        return status;
    }
  }

  Widget _buildTimelineStep({
    required Map<String, dynamic> step,
    required bool isLast,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF6D28D9) : Colors.grey[300]!,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 16, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? const Color(0xFF6D28D9) : Colors.grey[300]!,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['status'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? const Color(0xFF6D28D9)
                        : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['description'],
                  style: TextStyle(
                    color: isActive ? Colors.grey[800] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help with Your Insurance?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Connecting to insurance support...'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent_rounded),
                    label: const Text('Contact Support'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checking for available quotes...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.request_quote_rounded),
                    label: const Text('View Quotes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
