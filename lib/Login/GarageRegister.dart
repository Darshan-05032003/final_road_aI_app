// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class InsuranceRegistrationPage extends StatefulWidget {
//   const InsuranceRegistrationPage({super.key});

//   @override
//   _InsuranceRegistrationPageState createState() => _InsuranceRegistrationPageState();
// }

// class _InsuranceRegistrationPageState extends State<InsuranceRegistrationPage> {
//   final TextEditingController _companyNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passController = TextEditingController();
//   final TextEditingController _companyIdController = TextEditingController();
//   final TextEditingController _contactInfoController = TextEditingController();

//   bool _isLoading = false;

//   // Method to save company profile to Firestore in the correct structure
//   Future<void> _saveCompanyProfile(User user) async {
//     try {
//       final userEmail = _emailController.text.trim();

//       final companyData = {
//         'companyName': _companyNameController.text.trim(),
//         'companyId': _companyIdController.text.trim(),
//         'contactInfo': _contactInfoController.text.trim(),
//         'email': userEmail,
//         'userId': user.uid,
//         'userType': 'insurance',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       // Save to the correct Firebase structure:
//       // collection('garage').doc(_userEmail).collection("profile").doc()
//       await FirebaseFirestore.instance
//           .collection('garage')
//           .doc(userEmail) // Using email as document ID in garage collection
//           .collection("profile")
//           .doc('companyDetails') // You can use a specific doc ID or generate one
//           .set(companyData);

//       print("Company profile saved successfully to garage/$userEmail/profile/companyDetails");
//     } on FirebaseException catch (e) {
//       print("Firestore error: ${e.code} - ${e.message}");
//       throw Exception("Failed to save company profile: ${e.message}");
//     } catch (e) {
//       print("Unexpected error: $e");
//       throw Exception("An unexpected error occurred");
//     }
//   }

//   // Alternative method if you want to auto-generate document ID
//   Future<void> _saveCompanyProfileWithAutoId(User user) async {
//     try {
//       final userEmail = _emailController.text.trim();

//       final companyData = {
//         'companyName': _companyNameController.text.trim(),
//         'companyId': _companyIdController.text.trim(),
//         'contactInfo': _contactInfoController.text.trim(),
//         'email': userEmail,
//         'userId': user.uid,
//         'userType': 'insurance',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       // Auto-generate document ID using .doc() without parameters
//       await FirebaseFirestore.instance
//           .collection('garage')
//           .doc(userEmail)
//           .collection("profile")
//           .doc() // Auto-generated ID
//           .set(companyData);

//       print("Company profile saved with auto-generated ID");
//     } catch (e) {
//       print("Error saving with auto ID: $e");
//       throw Exception("Failed to save company profile");
//     }
//   }

//   void _register() async {
//     // Validate form before proceeding
//     if (_companyNameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _passController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill in all required fields")),
//       );
//       return;
//     }

//     // Validate email format
//     final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
//     if (!emailRegex.hasMatch(_emailController.text.trim())) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid email address")),
//       );
//       return;
//     }

//     // Validate password length
//     if (_passController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password must be at least 6 characters")),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Create user with Firebase Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//             email: _emailController.text.trim(),
//             password: _passController.text.trim(),
//           );

//       // Save company profile to Firestore with the correct structure
//       await _saveCompanyProfile(userCredential.user!);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration successful!")),
//       );

//       // Navigate after successful registration
//       if (mounted) {
//         Navigator.of(context).pop();
//       }

//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Registration failed: ";
//       switch (e.code) {
//         case 'email-already-in-use':
//           errorMessage = "This email is already registered. Please use a different email or login.";
//           break;
//         case 'weak-password':
//           errorMessage = "Password is too weak. Please use a stronger password.";
//           break;
//         case 'invalid-email':
//           errorMessage = "Invalid email address. Please check your email format.";
//           break;
//         case 'operation-not-allowed':
//           errorMessage = "Email/password accounts are not enabled. Please contact support.";
//           break;
//         case 'network-request-failed':
//           errorMessage = "Network error. Please check your internet connection.";
//           break;
//         default:
//           errorMessage = "An unexpected error occurred: ${e.message}";
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } on FirebaseException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Database error: ${e.message}"),
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Unexpected error: $e"),
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // Clean up controllers
//     _companyNameController.dispose();
//     _emailController.dispose();
//     _passController.dispose();
//     _companyIdController.dispose();
//     _contactInfoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               height: 250,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.purple[800]!, Colors.purple[600]!],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(40),
//                   bottomRight: Radius.circular(40),
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.business,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                     const SizedBox(height: 15),
//                     const Text(
//                       'Company Registration',
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Join our insurance network',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Registration Form
//             Padding(
//               padding: const EdgeInsets.all(30),
//               child: Column(
//                 children: [
//                   // Company Name Field
//                   TextField(
//                     controller: _companyNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Company Name *',
//                       prefixIcon: Icon(Icons.business, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Email Field
//                   TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       labelText: 'Email address *',
//                       prefixIcon: Icon(Icons.email, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Password Field
//                   TextField(
//                     controller: _passController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password *',
//                       prefixIcon: Icon(Icons.lock, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       helperText: 'Must be at least 6 characters',
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Company ID Field
//                   TextField(
//                     controller: _companyIdController,
//                     decoration: InputDecoration(
//                       labelText: 'Company ID',
//                       prefixIcon: Icon(Icons.badge, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Contact Info Field
//                   TextField(
//                     controller: _contactInfoController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       labelText: 'Contact Information',
//                       prefixIcon: Icon(Icons.contact_phone, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.purple),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       hintText: 'Phone, Email, Address...',
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Benefits Card
//                   Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.purple[50],
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.purple[100]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.purple, size: 20),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             'Get access to our partner network and insurance services',
//                             style: TextStyle(
//                               color: Colors.purple[700],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Register Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _register,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 2,
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Text(
//                               'REGISTER COMPANY',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Login Link
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already registered? "),
//                       GestureDetector(
//                         onTap: _isLoading ? null : () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Login here',
//                           style: TextStyle(
//                             color: Colors.purple,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Required fields note
//                   const SizedBox(height: 10),
//                   const Text(
//                     '* Required fields',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
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
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GarageRegistrationPage extends StatefulWidget {
  const GarageRegistrationPage({super.key});

  @override
  _GarageRegistrationPageState createState() => _GarageRegistrationPageState();
}

class _GarageRegistrationPageState extends State<GarageRegistrationPage> {
  final TextEditingController _garageNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specialtiesController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  bool _isLoading = false;
  bool _locationLoading = false;
  Position? _shopLocation;
  String _shopAddress = 'Tap to select shop location';
  final List<String> _selectedServices = [];
  final double _shopRating = 4.0; // Default rating for new garages

  final List<String> _availableServices = [
    'Engine Repair',
    'Brake Service',
    'AC Repair',
    'Oil Change',
    'Tire Repair',
    'Electrical Repair',
    'Transmission',
    'Suspension',
    'Battery Service',
    'General Maintenance',
    'Denting & Painting',
    'Car Wash',
    'Wheel Alignment',
    'Diagnostics',
  ];

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationLoading = true;
    });

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Location permission denied')));
          setState(() {
            _locationLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission permanently denied')),
        );
        setState(() {
          _locationLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";

      setState(() {
        _shopLocation = position;
        _shopAddress = address;
        _addressController.text = address;
        _locationLoading = false;
      });

      print(
        '📍 Location captured: ${position.latitude}, ${position.longitude}',
      );
      print('🏠 Address: $address');
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      setState(() {
        _locationLoading = false;
      });
    }
  }

  // Method to save garage profile to Firestore with location
  Future<void> _saveGarageProfile(User user) async {
    try {
      final userEmail = _emailController.text.trim();

      if (_shopLocation == null) {
        throw Exception("Please select shop location");
      }

      final garageData = {
        'garageName': _garageNameController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'email': userEmail,
        'phone': _phoneController.text.trim(),
        'upiId': _upiIdController.text.trim(),
        'userId': user.uid,
        'userType': 'garage',
        'shopAddress': _addressController.text.trim(),
        'latitude': _shopLocation!.latitude,
        'longitude': _shopLocation!.longitude,
        'specialties': _selectedServices,
        'rating': _shopRating,
        'reviews': 0, // Initial reviews count
        'isActive': true,
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save to garage collection
      await FirebaseFirestore.instance
          .collection('garages')
          .doc(userEmail)
          .set(garageData);

      print("✅ Garage profile saved successfully!");
      print("📊 Garage data: $garageData");
    } on FirebaseException catch (e) {
      print("❌ Firestore error: ${e.code} - ${e.message}");
      throw Exception("Failed to save garage profile: ${e.message}");
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw Exception("An unexpected error occurred");
    }
  }

  void _registerGarage() async {
    // Validate form before proceeding
    if (_garageNameController.text.isEmpty ||
        _ownerNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _upiIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields including UPI ID"),
        ),
      );
      return;
    }

    if (_shopLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your shop location")),
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    // Validate password length
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    // Validate UPI ID format if provided
    final upiId = _upiIdController.text.trim();
    if (upiId.isNotEmpty) {
      final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
      if (!upiRegex.hasMatch(upiId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enter a valid UPI ID format (e.g., yourname@paytm)",
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Save garage profile to Firestore with location
      await _saveGarageProfile(userCredential.user!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registration successful! Your garage is now visible to customers.",
          ),
        ),
      );

      // Navigate after successful registration
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed: ";
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              "This email is already registered. Please use a different email or login.";
          break;
        case 'weak-password':
          errorMessage =
              "Password is too weak. Please use a stronger password.";
          break;
        case 'invalid-email':
          errorMessage =
              "Invalid email address. Please check your email format.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Email/password accounts are not enabled. Please contact support.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection.";
          break;
        default:
          errorMessage = "An unexpected error occurred: ${e.message}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 5),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Database error: ${e.message}"),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _garageNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _specialtiesController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[800]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.build_circle_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Garage Registration',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join our mechanic network',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // Registration Form
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // Garage Name Field
                  TextField(
                    controller: _garageNameController,
                    decoration: InputDecoration(
                      labelText: 'Garage Name *',
                      prefixIcon: Icon(
                        Icons.build_circle_rounded,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Owner Name Field
                  TextField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(
                      labelText: 'Owner Name *',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address *',
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      helperText: 'Must be at least 6 characters',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone Field
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: Icon(Icons.phone, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Location Selection Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Shop Location *',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            _shopAddress,
                            style: TextStyle(
                              color: _shopLocation != null
                                  ? Colors.green[700]
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _locationLoading
                                  ? null
                                  : _getCurrentLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              icon: _locationLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Icons.my_location),
                              label: Text(
                                _locationLoading
                                    ? 'Getting Location...'
                                    : 'Use Current Location',
                              ),
                            ),
                          ),
                          if (_shopLocation != null) ...[
                            SizedBox(height: 8),
                            Text(
                              'Coordinates: ${_shopLocation!.latitude.toStringAsFixed(4)}, ${_shopLocation!.longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address Field
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Shop Address (Auto-filled)',
                      prefixIcon: Icon(Icons.home_work, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      helperText: 'Address will be auto-filled from location',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // UPI ID Field
                  TextField(
                    controller: _upiIdController,
                    decoration: InputDecoration(
                      labelText: 'UPI ID *',
                      hintText: 'yourname@paytm',
                      prefixIcon: Icon(Icons.payment, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      helperText:
                          'Required for receiving payments (e.g., yourname@paytm, yourname@ybl)',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Services Selection
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Services Offered *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Select the services your garage provides:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _availableServices.map((service) {
                              final isSelected = _selectedServices.contains(
                                service,
                              );
                              return FilterChip(
                                label: Text(service),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedServices.add(service);
                                    } else {
                                      _selectedServices.remove(service);
                                    }
                                  });
                                },
                                selectedColor: Colors.blue.withOpacity(0.2),
                                checkmarkColor: Colors.blue,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[700],
                                ),
                              );
                            }).toList(),
                          ),
                          if (_selectedServices.isNotEmpty) ...[
                            SizedBox(height: 12),
                            Text(
                              'Selected: ${_selectedServices.join(', ')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Benefits Card
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Get visible to customers in your area and receive service requests',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerGarage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'REGISTER GARAGE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already registered? "),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text(
                          'Login here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Required fields note
                  const SizedBox(height: 10),
                  const Text(
                    '* Required fields',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
