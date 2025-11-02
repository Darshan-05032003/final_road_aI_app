
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TowProviderRegistrationPage extends StatefulWidget {
  const TowProviderRegistrationPage({super.key});

  @override
  _TowProviderRegistrationPageState createState() => _TowProviderRegistrationPageState();
}

class _TowProviderRegistrationPageState extends State<TowProviderRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _truckNoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;
  bool _locationLoading = false;
  String? _selectedTruckType;
  Position? _currentLocation;
  String _currentAddress = 'Tap to select your location';

  final List<String> _truckTypes = [
    'Flatbed Tow Truck',
    'Hook and Chain',
    'Wheel Lift',
    'Integrated Tow Truck',
    'Heavy Duty',
    'Light Duty'
  ];

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          setState(() {
            _locationLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission permanently denied')),
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
      String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";

      setState(() {
        _currentLocation = position;
        _currentAddress = address;
        _locationController.text = address;
        _locationLoading = false;
      });

      print('📍 Tow Provider Location: ${position.latitude}, ${position.longitude}');
      print('🏠 Address: $address');

    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
      setState(() {
        _locationLoading = false;
      });
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Check if location is selected
      if (_currentLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your location')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );

        // Get the created user
        User? user = userCredential.user;
        
        if (user != null) {
          // Prepare tow provider data for Firestore with location
          Map<String, dynamic> towProviderData = {
            'driverName': _driverNameController.text.trim(),
            'email': _emailController.text.trim(),
            'truckNumber': _truckNoController.text.trim(),
            'truckType': _selectedTruckType ?? 'Not Specified',
            'location': _locationController.text.trim(),
            'serviceArea': _locationController.text.trim(),
            'latitude': _currentLocation!.latitude,
            'longitude': _currentLocation!.longitude,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'userId': user.uid,
            'status': 'active',
            'rating': 0.0,
            'totalJobs': 0,
            'isOnline': false,
            'isActive': true,
            'isAvailable': true,
            'reviews': 0,
          };

          // Save tow provider data to Firestore in tow_providers collection
          await _firestore
              .collection('tow_providers')
              .doc(_emailController.text.trim())
              .set(towProviderData);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful! Welcome to our tow provider network."),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate back to login
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Registration failed. Please try again.";
        
        if (e.code == 'weak-password') {
          errorMessage = "Password is too weak. Please use a stronger password.";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "An account already exists with this email.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email address format.";
        } else if (e.code == 'network-request-failed') {
          errorMessage = "Network error. Please check your internet connection.";
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration error: ${e.toString()}"),
            backgroundColor: Colors.red,
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
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _truckNoController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Header
              _buildHeader(),
              
              const SizedBox(height: 30),
              
              // Registration Form
              _buildRegistrationForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[700]!, Colors.orange[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Join as Tow Provider',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start providing roadside assistance services',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Driver Name Field
              _buildTextField(
                controller: _driverNameController,
                label: 'Driver Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters long';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Password Field
              _buildTextField(
                controller: _passController,
                label: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Tow Truck No. Field
              _buildTextField(
                controller: _truckNoController,
                label: 'Tow Truck Number',
                icon: Icons.confirmation_number_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter truck number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Truck Type Dropdown
              _buildTruckTypeDropdown(),
              
              const SizedBox(height: 20),
              
              // Location Field with GPS Button
              _buildLocationFieldWithGPS(),
              
              const SizedBox(height: 30),
              
              // Features List
              _buildFeaturesList(),
              
              const SizedBox(height: 30),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.orange.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_shipping, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'REGISTER AS TOW PROVIDER',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already registered? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_isLoading) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.orange[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildTruckTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTruckType,
      decoration: InputDecoration(
        labelText: 'Truck Type *',
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.build_outlined, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: _truckTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTruckType = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select truck type';
        }
        return null;
      },
    );
  }

  Widget _buildLocationFieldWithGPS() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Location *',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: TextStyle(
                          color: _currentLocation != null ? Colors.green[700] : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _locationLoading ? null : _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
                    label: Text(_locationLoading ? 'Getting Location...' : 'Use Current Location'),
                  ),
                ),
                if (_currentLocation != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Coordinates: ${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}',
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
        SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          maxLines: 2,
          readOnly: true, // Make it read-only since we auto-fill from GPS
          decoration: InputDecoration(
            labelText: 'Service Area (Auto-filled)',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: const Icon(Icons.area_chart, color: Colors.orange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange[400]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            hintText: 'Address will be auto-filled from location',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your location using GPS';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_outline, color: Colors.orange[600], size: 18),
              const SizedBox(width: 8),
              Text(
                'Why Join Us?',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFeatureItem('24/7 Emergency Requests'),
          _buildFeatureItem('Real-time Job Notifications'),
          _buildFeatureItem('Competitive Pricing'),
          _buildFeatureItem('GPS Navigation Support'),
          _buildFeatureItem('Instant Payment Processing'),
          _buildFeatureItem('Customer Rating System'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.orange[400], size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}



// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';

// // // class TowProviderRegistrationPage extends StatefulWidget {
// // //   const TowProviderRegistrationPage({super.key});

// // //   @override
// // //   _TowProviderRegistrationPageState createState() => _TowProviderRegistrationPageState();
// // // }

// // // class _TowProviderRegistrationPageState extends State<TowProviderRegistrationPage> {
// // //   final _formKey = GlobalKey<FormState>();
  
// // //   final TextEditingController _driverNameController = TextEditingController();
// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passController = TextEditingController();
// // //   final TextEditingController _truckNoController = TextEditingController();
// // //   final TextEditingController _locationController = TextEditingController();

// // //   bool _isLoading = false;
// // //   String? _selectedTruckType;

// // //   final List<String> _truckTypes = [
// // //     'Flatbed Tow Truck',
// // //     'Hook and Chain',
// // //     'Wheel Lift',
// // //     'Integrated Tow Truck',
// // //     'Heavy Duty',
// // //     'Light Duty'
// // //   ];

// // //   // Firebase instances
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// // //   void _register() async {
// // //     if (_formKey.currentState!.validate()) {
// // //       setState(() {
// // //         _isLoading = true;
// // //       });

// // //       try {
// // //         // Create user with email and password
// // //         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
// // //           email: _emailController.text.trim(),
// // //           password: _passController.text.trim(),
// // //         );

// // //         // Get the created user
// // //         User? user = userCredential.user;
        
// // //         if (user != null) {
// // //           // Prepare tow provider data for Firestore
// // //           Map<String, dynamic> towProviderData = {
// // //             'driverName': _driverNameController.text.trim(),
// // //             'email': _emailController.text.trim(),
// // //             'truckNumber': _truckNoController.text.trim(),
// // //             'truckType': _selectedTruckType ?? 'Not Specified',
// // //             'location': _locationController.text.trim(),
// // //             'createdAt': FieldValue.serverTimestamp(),
// // //             'updatedAt': FieldValue.serverTimestamp(),
// // //             'userId': user.uid,
// // //             'status': 'active', // active, inactive, busy
// // //             'rating': 0.0,
// // //             'totalJobs': 0,
// // //             'isOnline': false,
// // //             'serviceArea': _locationController.text.trim(),
// // //           };

// // //           // Save tow provider data to Firestore
// // //           await _firestore
// // //               .collection('tow')
// // //               .doc(_emailController.text.trim()) // Using email as document ID
// // //               .collection('profile')
// // //               .doc('provider_details') // Fixed document ID for profile
// // //               .set(towProviderData);

// // //           // Show success message
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text("Registration successful! Welcome to our tow provider network."),
// // //               backgroundColor: Colors.green,
// // //               duration: Duration(seconds: 3),
// // //             ),
// // //           );

// // //           // Navigate back to login
// // //           if (mounted) {
// // //             Navigator.of(context).pop();
// // //           }
// // //         }
// // //       } on FirebaseAuthException catch (e) {
// // //         String errorMessage = "Registration failed. Please try again.";
        
// // //         if (e.code == 'weak-password') {
// // //           errorMessage = "Password is too weak. Please use a stronger password.";
// // //         } else if (e.code == 'email-already-in-use') {
// // //           errorMessage = "An account already exists with this email.";
// // //         } else if (e.code == 'invalid-email') {
// // //           errorMessage = "Invalid email address format.";
// // //         } else if (e.code == 'network-request-failed') {
// // //           errorMessage = "Network error. Please check your internet connection.";
// // //         }
        
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(errorMessage),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       } catch (e) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text("Registration error: ${e.toString()}"),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       } finally {
// // //         if (mounted) {
// // //           setState(() {
// // //             _isLoading = false;
// // //           });
// // //         }
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     // Dispose all controllers
// // //     _driverNameController.dispose();
// // //     _emailController.dispose();
// // //     _passController.dispose();
// // //     _truckNoController.dispose();
// // //     _locationController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[50],
// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(20),
// // //           child: Column(
// // //             children: [
// // //               const SizedBox(height: 40),
              
// // //               // Header
// // //               _buildHeader(),
              
// // //               const SizedBox(height: 30),
              
// // //               // Registration Form
// // //               _buildRegistrationForm(),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildHeader() {
// // //     return Column(
// // //       children: [
// // //         Container(
// // //           padding: const EdgeInsets.all(20),
// // //           decoration: BoxDecoration(
// // //             gradient: LinearGradient(
// // //               colors: [Colors.purple[700]!, Colors.purple[500]!],
// // //               begin: Alignment.topLeft,
// // //               end: Alignment.bottomRight,
// // //             ),
// // //             shape: BoxShape.circle,
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.purple.withOpacity(0.3),
// // //                 blurRadius: 15,
// // //                 offset: const Offset(0, 5),
// // //               ),
// // //             ],
// // //           ),
// // //           child: const Icon(
// // //             Icons.local_shipping,
// // //             size: 45,
// // //             color: Colors.white,
// // //           ),
// // //         ),
// // //         const SizedBox(height: 20),
// // //         Text(
// // //           'Join as Tow Provider',
// // //           style: TextStyle(
// // //             fontSize: 26,
// // //             fontWeight: FontWeight.bold,
// // //             color: Colors.purple[800],
// // //           ),
// // //         ),
// // //         const SizedBox(height: 8),
// // //         Text(
// // //           'Start providing roadside assistance services',
// // //           style: TextStyle(
// // //             color: Colors.grey[600],
// // //             fontSize: 15,
// // //           ),
// // //           textAlign: TextAlign.center,
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildRegistrationForm() {
// // //     return Card(
// // //       elevation: 8,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(20),
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(25),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             children: [
// // //               // Driver Name Field
// // //               _buildTextField(
// // //                 controller: _driverNameController,
// // //                 label: 'Driver Name',
// // //                 icon: Icons.person_outline,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) {
// // //                     return 'Please enter driver name';
// // //                   }
// // //                   if (value.length < 2) {
// // //                     return 'Name must be at least 2 characters long';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
              
// // //               const SizedBox(height: 20),
              
// // //               // Email Field
// // //               _buildTextField(
// // //                 controller: _emailController,
// // //                 label: 'Email Address',
// // //                 icon: Icons.email_outlined,
// // //                 keyboardType: TextInputType.emailAddress,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) {
// // //                     return 'Please enter email address';
// // //                   }
// // //                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
// // //                     return 'Please enter a valid email address';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
              
// // //               const SizedBox(height: 20),
              
// // //               // Password Field
// // //               _buildTextField(
// // //                 controller: _passController,
// // //                 label: 'Password',
// // //                 icon: Icons.lock_outline,
// // //                 isPassword: true,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) {
// // //                     return 'Please enter password';
// // //                   }
// // //                   if (value.length < 6) {
// // //                     return 'Password must be at least 6 characters long';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
              
// // //               const SizedBox(height: 20),
              
// // //               // Tow Truck No. Field
// // //               _buildTextField(
// // //                 controller: _truckNoController,
// // //                 label: 'Tow Truck Number',
// // //                 icon: Icons.confirmation_number_outlined,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) {
// // //                     return 'Please enter truck number';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
              
// // //               const SizedBox(height: 20),
              
// // //               // Truck Type Dropdown
// // //               _buildTruckTypeDropdown(),
              
// // //               const SizedBox(height: 20),
              
// // //               // Location Field
// // //               _buildLocationField(),
              
// // //               const SizedBox(height: 30),
              
// // //               // Features List
// // //               _buildFeaturesList(),
              
// // //               const SizedBox(height: 30),
              
// // //               // Register Button
// // //               SizedBox(
// // //                 width: double.infinity,
// // //                 height: 55,
// // //                 child: ElevatedButton(
// // //                   onPressed: _isLoading ? null : _register,
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.purple[600],
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     elevation: 4,
// // //                     shadowColor: Colors.purple.withOpacity(0.3),
// // //                   ),
// // //                   child: _isLoading
// // //                       ? const SizedBox(
// // //                           height: 22,
// // //                           width: 22,
// // //                           child: CircularProgressIndicator(
// // //                             strokeWidth: 2.5,
// // //                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// // //                           ),
// // //                         )
// // //                       : Row(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             const Icon(Icons.local_shipping, size: 20),
// // //                             const SizedBox(width: 10),
// // //                             Text(
// // //                               'REGISTER AS TOW PROVIDER',
// // //                               style: TextStyle(
// // //                                 fontSize: 16,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: Colors.white,
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                 ),
// // //               ),
              
// // //               const SizedBox(height: 20),
              
// // //               // Login Link
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   Text(
// // //                     "Already registered? ",
// // //                     style: TextStyle(
// // //                       color: Colors.grey[600],
// // //                       fontSize: 15,
// // //                     ),
// // //                   ),
// // //                   GestureDetector(
// // //                     onTap: () {
// // //                       if (!_isLoading) {
// // //                         Navigator.pop(context);
// // //                       }
// // //                     },
// // //                     child: Text(
// // //                       'Login here',
// // //                       style: TextStyle(
// // //                         color: Colors.purple[600],
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 15,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildTextField({
// // //     required TextEditingController controller,
// // //     required String label,
// // //     required IconData icon,
// // //     TextInputType keyboardType = TextInputType.text,
// // //     bool isPassword = false,
// // //     required String? Function(String?) validator,
// // //   }) {
// // //     return TextFormField(
// // //       controller: controller,
// // //       keyboardType: keyboardType,
// // //       obscureText: isPassword,
// // //       validator: validator,
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         labelStyle: TextStyle(color: Colors.grey[600]),
// // //         prefixIcon: Icon(icon, color: Colors.purple[400]),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.grey[300]!),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // //         ),
// // //         filled: true,
// // //         fillColor: Colors.grey[50],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildTruckTypeDropdown() {
// // //     return DropdownButtonFormField<String>(
// // //       initialValue: _selectedTruckType,
// // //       decoration: InputDecoration(
// // //         labelText: 'Truck Type',
// // //         labelStyle: TextStyle(color: Colors.grey[600]),
// // //         prefixIcon: const Icon(Icons.build_outlined, color: Colors.purple),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // //         ),
// // //         filled: true,
// // //         fillColor: Colors.grey[50],
// // //       ),
// // //       items: _truckTypes.map((String type) {
// // //         return DropdownMenuItem<String>(
// // //           value: type,
// // //           child: Text(type),
// // //         );
// // //       }).toList(),
// // //       onChanged: (String? newValue) {
// // //         setState(() {
// // //           _selectedTruckType = newValue;
// // //         });
// // //       },
// // //       validator: (value) {
// // //         if (value == null || value.isEmpty) {
// // //           return 'Please select truck type';
// // //         }
// // //         return null;
// // //       },
// // //     );
// // //   }

// // //   Widget _buildLocationField() {
// // //     return TextFormField(
// // //       controller: _locationController,
// // //       maxLines: 2,
// // //       validator: (value) {
// // //         if (value == null || value.isEmpty) {
// // //           return 'Please enter your location';
// // //         }
// // //         return null;
// // //       },
// // //       decoration: InputDecoration(
// // //         labelText: 'Service Location',
// // //         labelStyle: TextStyle(color: Colors.grey[600]),
// // //         prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.purple),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.grey[300]!),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // //         ),
// // //         filled: true,
// // //         fillColor: Colors.grey[50],
// // //         hintText: 'Enter your service area or address...',
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFeaturesList() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.purple[50],
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.purple[100]!),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Icon(Icons.star_outline, color: Colors.purple[600], size: 18),
// // //               const SizedBox(width: 8),
// // //               Text(
// // //                 'Why Join Us?',
// // //                 style: TextStyle(
// // //                   color: Colors.purple[700],
// // //                   fontWeight: FontWeight.bold,
// // //                   fontSize: 16,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 10),
// // //           _buildFeatureItem('24/7 Emergency Requests'),
// // //           _buildFeatureItem('Real-time Job Notifications'),
// // //           _buildFeatureItem('Competitive Pricing'),
// // //           _buildFeatureItem('GPS Navigation Support'),
// // //           _buildFeatureItem('Instant Payment Processing'),
// // //           _buildFeatureItem('Customer Rating System'),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFeatureItem(String text) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 4),
// // //       child: Row(
// // //         children: [
// // //           Icon(Icons.check_circle, color: Colors.purple[400], size: 16),
// // //           const SizedBox(width: 8),
// // //           Text(
// // //             text,
// // //             style: TextStyle(
// // //               color: Colors.purple[700],
// // //               fontSize: 13,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }


// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:geocoding/geocoding.dart';

// // class TowProviderRegistrationPage extends StatefulWidget {
// //   const TowProviderRegistrationPage({super.key});

// //   @override
// //   _TowProviderRegistrationPageState createState() => _TowProviderRegistrationPageState();
// // }

// // class _TowProviderRegistrationPageState extends State<TowProviderRegistrationPage> {
// //   final _formKey = GlobalKey<FormState>();
  
// //   final TextEditingController _driverNameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passController = TextEditingController();
// //   final TextEditingController _truckNoController = TextEditingController();
// //   final TextEditingController _locationController = TextEditingController();

// //   bool _isLoading = false;
// //   bool _locationLoading = false;
// //   String? _selectedTruckType;
// //   Position? _currentLocation;
// //   String _currentAddress = 'Tap to select your location';

// //   final List<String> _truckTypes = [
// //     'Flatbed Tow Truck',
// //     'Hook and Chain',
// //     'Wheel Lift',
// //     'Integrated Tow Truck',
// //     'Heavy Duty',
// //     'Light Duty'
// //   ];

// //   // Firebase instances
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   // Method to get current location
// //   Future<void> _getCurrentLocation() async {
// //     setState(() {
// //       _locationLoading = true;
// //     });

// //     try {
// //       // Check permission
// //       LocationPermission permission = await Geolocator.checkPermission();
// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //         if (permission == LocationPermission.denied) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Location permission denied')),
// //           );
// //           setState(() {
// //             _locationLoading = false;
// //           });
// //           return;
// //         }
// //       }

// //       if (permission == LocationPermission.deniedForever) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Location permission permanently denied')),
// //         );
// //         setState(() {
// //           _locationLoading = false;
// //         });
// //         return;
// //       }

// //       // Get current position
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );

// //       // Get address from coordinates
// //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //         position.latitude,
// //         position.longitude,
// //       );

// //       Placemark place = placemarks[0];
// //       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";

// //       setState(() {
// //         _currentLocation = position;
// //         _currentAddress = address;
// //         _locationController.text = address;
// //         _locationLoading = false;
// //       });

// //       print('📍 Location captured: ${position.latitude}, ${position.longitude}');
// //       print('🏠 Address: $address');

// //     } catch (e) {
// //       print('Error getting location: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to get location: $e')),
// //       );
// //       setState(() {
// //         _locationLoading = false;
// //       });
// //     }
// //   }

// //   // Method to save tow provider profile to Firestore with location
// //   Future<void> _saveTowProviderProfile(User user) async {
// //     try {
// //       final userEmail = _emailController.text.trim();
      
// //       if (_currentLocation == null) {
// //         throw Exception("Please select your location");
// //       }

// //       final towProviderData = {
// //         'driverName': _driverNameController.text.trim(),
// //         'email': userEmail,
// //         'truckNumber': _truckNoController.text.trim(),
// //         'truckType': _selectedTruckType ?? 'Not Specified',
// //         'serviceLocation': _locationController.text.trim(),
// //         'latitude': _currentLocation!.latitude,
// //         'longitude': _currentLocation!.longitude,
// //         'userId': user.uid,
// //         'userType': 'tow_provider',
// //         'status': 'active',
// //         'rating': 0.0,
// //         'totalJobs': 0,
// //         'isOnline': false,
// //         'isAvailable': true,
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       };

// //       // Save to tow providers collection
// //       await _firestore
// //           .collection('tow_providers')
// //           .doc(userEmail)
// //           .set(towProviderData);

// //       print("✅ Tow provider profile saved successfully!");
// //       print("📊 Tow provider data: $towProviderData");

// //     } on FirebaseException catch (e) {
// //       print("❌ Firestore error: ${e.code} - ${e.message}");
// //       throw Exception("Failed to save tow provider profile: ${e.message}");
// //     } catch (e) {
// //       print("❌ Unexpected error: $e");
// //       throw Exception("An unexpected error occurred");
// //     }
// //   }

// //   void _register() async {
// //     if (_formKey.currentState!.validate()) {
// //       // Additional validation for location
// //       if (_currentLocation == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Please select your location")),
// //         );
// //         return;
// //       }

// //       setState(() {
// //         _isLoading = true;
// //       });

// //       try {
// //         // Create user with email and password
// //         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
// //           email: _emailController.text.trim(),
// //           password: _passController.text.trim(),
// //         );

// //         // Get the created user
// //         User? user = userCredential.user;
        
// //         if (user != null) {
// //           // Save tow provider profile to Firestore with location
// //           await _saveTowProviderProfile(user);

// //           // Show success message
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Registration successful! Welcome to our tow provider network."),
// //               backgroundColor: Colors.green,
// //               duration: Duration(seconds: 3),
// //             ),
// //           );

// //           // Navigate back to login
// //           if (mounted) {
// //             Navigator.of(context).pop();
// //           }
// //         }
// //       } on FirebaseAuthException catch (e) {
// //         String errorMessage = "Registration failed. Please try again.";
        
// //         if (e.code == 'weak-password') {
// //           errorMessage = "Password is too weak. Please use a stronger password.";
// //         } else if (e.code == 'email-already-in-use') {
// //           errorMessage = "An account already exists with this email.";
// //         } else if (e.code == 'invalid-email') {
// //           errorMessage = "Invalid email address format.";
// //         } else if (e.code == 'network-request-failed') {
// //           errorMessage = "Network error. Please check your internet connection.";
// //         }
        
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(errorMessage),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       } on FirebaseException catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Database error: ${e.message}"),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Registration error: ${e.toString()}"),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       } finally {
// //         if (mounted) {
// //           setState(() {
// //             _isLoading = false;
// //           });
// //         }
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     // Dispose all controllers
// //     _driverNameController.dispose();
// //     _emailController.dispose();
// //     _passController.dispose();
// //     _truckNoController.dispose();
// //     _locationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 40),
              
// //               // Header
// //               _buildHeader(),
              
// //               const SizedBox(height: 30),
              
// //               // Registration Form
// //               _buildRegistrationForm(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Column(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(20),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Colors.purple[700]!, Colors.purple[500]!],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //             shape: BoxShape.circle,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.purple.withOpacity(0.3),
// //                 blurRadius: 15,
// //                 offset: const Offset(0, 5),
// //               ),
// //             ],
// //           ),
// //           child: const Icon(
// //             Icons.local_shipping,
// //             size: 45,
// //             color: Colors.white,
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         Text(
// //           'Join as Tow Provider',
// //           style: TextStyle(
// //             fontSize: 26,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.purple[800],
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           'Start providing roadside assistance services',
// //           style: TextStyle(
// //             color: Colors.grey[600],
// //             fontSize: 15,
// //           ),
// //           textAlign: TextAlign.center,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRegistrationForm() {
// //     return Card(
// //       elevation: 8,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(25),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               // Driver Name Field
// //               _buildTextField(
// //                 controller: _driverNameController,
// //                 label: 'Driver Name',
// //                 icon: Icons.person_outline,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter driver name';
// //                   }
// //                   if (value.length < 2) {
// //                     return 'Name must be at least 2 characters long';
// //                   }
// //                   return null;
// //                 },
// //               ),
              
// //               const SizedBox(height: 20),
              
// //               // Email Field
// //               _buildTextField(
// //                 controller: _emailController,
// //                 label: 'Email Address',
// //                 icon: Icons.email_outlined,
// //                 keyboardType: TextInputType.emailAddress,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter email address';
// //                   }
// //                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
// //                     return 'Please enter a valid email address';
// //                   }
// //                   return null;
// //                 },
// //               ),
              
// //               const SizedBox(height: 20),
              
// //               // Password Field
// //               _buildTextField(
// //                 controller: _passController,
// //                 label: 'Password',
// //                 icon: Icons.lock_outline,
// //                 isPassword: true,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter password';
// //                   }
// //                   if (value.length < 6) {
// //                     return 'Password must be at least 6 characters long';
// //                   }
// //                   return null;
// //                 },
// //               ),
              
// //               const SizedBox(height: 20),
              
// //               // Tow Truck No. Field
// //               _buildTextField(
// //                 controller: _truckNoController,
// //                 label: 'Tow Truck Number',
// //                 icon: Icons.confirmation_number_outlined,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter truck number';
// //                   }
// //                   return null;
// //                 },
// //               ),
              
// //               const SizedBox(height: 20),
              
// //               // Truck Type Dropdown
// //               _buildTruckTypeDropdown(),
              
// //               const SizedBox(height: 20),
              
// //               // Location Selection Card
// //               _buildLocationCard(),
              
// //               const SizedBox(height: 20),
              
// //               // Location Field (Auto-filled)
// //               _buildLocationField(),
              
// //               const SizedBox(height: 30),
              
// //               // Features List
// //               _buildFeaturesList(),
              
// //               const SizedBox(height: 30),
              
// //               // Register Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 55,
// //                 child: ElevatedButton(
// //                   onPressed: _isLoading ? null : _register,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.purple[600],
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     elevation: 4,
// //                     shadowColor: Colors.purple.withOpacity(0.3),
// //                   ),
// //                   child: _isLoading
// //                       ? const SizedBox(
// //                           height: 22,
// //                           width: 22,
// //                           child: CircularProgressIndicator(
// //                             strokeWidth: 2.5,
// //                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                           ),
// //                         )
// //                       : Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             const Icon(Icons.local_shipping, size: 20),
// //                             const SizedBox(width: 10),
// //                             Text(
// //                               'REGISTER AS TOW PROVIDER',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                 ),
// //               ),
              
// //               const SizedBox(height: 20),
              
// //               // Login Link
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     "Already registered? ",
// //                     style: TextStyle(
// //                       color: Colors.grey[600],
// //                       fontSize: 15,
// //                     ),
// //                   ),
// //                   GestureDetector(
// //                     onTap: () {
// //                       if (!_isLoading) {
// //                         Navigator.pop(context);
// //                       }
// //                     },
// //                     child: Text(
// //                       'Login here',
// //                       style: TextStyle(
// //                         color: Colors.purple[600],
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 15,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String label,
// //     required IconData icon,
// //     TextInputType keyboardType = TextInputType.text,
// //     bool isPassword = false,
// //     required String? Function(String?) validator,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       keyboardType: keyboardType,
// //       obscureText: isPassword,
// //       validator: validator,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: TextStyle(color: Colors.grey[600]),
// //         prefixIcon: Icon(icon, color: Colors.purple[400]),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey[300]!),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// //         ),
// //         filled: true,
// //         fillColor: Colors.grey[50],
// //       ),
// //     );
// //   }

// //   Widget _buildTruckTypeDropdown() {
// //     return DropdownButtonFormField<String>(
// //       value: _selectedTruckType,
// //       decoration: InputDecoration(
// //         labelText: 'Truck Type *',
// //         labelStyle: TextStyle(color: Colors.grey[600]),
// //         prefixIcon: const Icon(Icons.build_outlined, color: Colors.purple),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// //         ),
// //         filled: true,
// //         fillColor: Colors.grey[50],
// //       ),
// //       items: _truckTypes.map((String type) {
// //         return DropdownMenuItem<String>(
// //           value: type,
// //           child: Text(type),
// //         );
// //       }).toList(),
// //       onChanged: (String? newValue) {
// //         setState(() {
// //           _selectedTruckType = newValue;
// //         });
// //       },
// //       validator: (value) {
// //         if (value == null || value.isEmpty) {
// //           return 'Please select truck type';
// //         }
// //         return null;
// //       },
// //     );
// //   }

// //   Widget _buildLocationCard() {
// //     return Card(
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(Icons.location_on, color: Colors.purple[600]),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   'Service Location *',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                     color: Colors.purple[700],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               _currentAddress,
// //               style: TextStyle(
// //                 color: _currentLocation != null ? Colors.green[700] : Colors.grey,
// //                 fontSize: 14,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 onPressed: _locationLoading ? null : _getCurrentLocation,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.purple[600],
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 icon: _locationLoading 
// //                     ? SizedBox(
// //                         width: 16,
// //                         height: 16,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                     : const Icon(Icons.my_location),
// //                 label: Text(_locationLoading ? 'Getting Location...' : 'Use Current Location'),
// //               ),
// //             ),
// //             if (_currentLocation != null) ...[
// //               const SizedBox(height: 8),
// //               Text(
// //                 'Coordinates: ${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}',
// //                 style: TextStyle(
// //                   fontSize: 12,
// //                   color: Colors.grey[600],
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildLocationField() {
// //     return TextFormField(
// //       controller: _locationController,
// //       maxLines: 2,
// //       readOnly: true, // Make it read-only since it's auto-filled
// //       decoration: InputDecoration(
// //         labelText: 'Service Address (Auto-filled)',
// //         labelStyle: TextStyle(color: Colors.grey[600]),
// //         prefixIcon: const Icon(Icons.home_work, color: Colors.purple),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey[300]!),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// //         ),
// //         filled: true,
// //         fillColor: Colors.grey[100],
// //         helperText: 'Address will be auto-filled from location',
// //       ),
// //     );
// //   }

// //   Widget _buildFeaturesList() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.purple[50],
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.purple[100]!),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Icons.star_outline, color: Colors.purple[600], size: 18),
// //               const SizedBox(width: 8),
// //               Text(
// //                 'Why Join Us?',
// //                 style: TextStyle(
// //                   color: Colors.purple[700],
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 16,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           _buildFeatureItem('24/7 Emergency Requests'),
// //           _buildFeatureItem('Real-time Job Notifications'),
// //           _buildFeatureItem('GPS Navigation Support'),
// //           _buildFeatureItem('Instant Payment Processing'),
// //           _buildFeatureItem('Customer Rating System'),
// //           _buildFeatureItem('Live Location Tracking'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFeatureItem(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           Icon(Icons.check_circle, color: Colors.purple[400], size: 16),
// //           const SizedBox(width: 8),
// //           Text(
// //             text,
// //             style: TextStyle(
// //               color: Colors.purple[700],
// //               fontSize: 13,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // ToeProviderRegister.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class TowProviderRegistrationPage extends StatefulWidget {
//   const TowProviderRegistrationPage({super.key});

//   @override
//   _TowProviderRegistrationPageState createState() => _TowProviderRegistrationPageState();
// }

// class _TowProviderRegistrationPageState extends State<TowProviderRegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
  
//   final TextEditingController _driverNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passController = TextEditingController();
//   final TextEditingController _truckNoController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   bool _isLoading = false;
//   String? _selectedTruckType;
//   Position? _currentPosition;
//   bool _locationLoading = false;

//   final List<String> _truckTypes = [
//     'Flatbed Tow Truck',
//     'Hook and Chain',
//     'Wheel Lift',
//     'Integrated Tow Truck',
//     'Heavy Duty',
//     'Light Duty'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _locationLoading = true;
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
//         _locationController.text = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
//         _locationLoading = false;
//       });

//     } catch (e) {
//       setState(() {
//         _locationLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//     }
//   }

//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passController.text.trim(),
//         );

//         User? user = userCredential.user;
        
//         if (user != null) {
//           Map<String, dynamic> towProviderData = {
//             'driverName': _driverNameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'truckNumber': _truckNoController.text.trim(),
//             'truckType': _selectedTruckType ?? 'Not Specified',
//             'location': _locationController.text.trim(),
//             'latitude': _currentPosition?.latitude,
//             'longitude': _currentPosition?.longitude,
//             'createdAt': FieldValue.serverTimestamp(),
//             'updatedAt': FieldValue.serverTimestamp(),
//             'userId': user.uid,
//             'status': 'active',
//             'rating': 0.0,
//             'totalJobs': 0,
//             'isOnline': true,
//             'serviceArea': _locationController.text.trim(),
//           };

//           await _firestore
//               .collection('tow')
//               .doc(_emailController.text.trim())
//               .collection('profile')
//               .doc('provider_details')
//               .set(towProviderData);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Registration successful! Welcome to our tow provider network."),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 3),
//             ),
//           );

//           if (mounted) {
//             Navigator.of(context).pop();
//           }
//         }
//       } on FirebaseAuthException catch (e) {
//         String errorMessage = "Registration failed. Please try again.";
        
//         if (e.code == 'weak-password') {
//           errorMessage = "Password is too weak. Please use a stronger password.";
//         } else if (e.code == 'email-already-in-use') {
//           errorMessage = "An account already exists with this email.";
//         } else if (e.code == 'invalid-email') {
//           errorMessage = "Invalid email address format.";
//         } else if (e.code == 'network-request-failed') {
//           errorMessage = "Network error. Please check your internet connection.";
//         }
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Registration error: ${e.toString()}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _driverNameController.dispose();
//     _emailController.dispose();
//     _passController.dispose();
//     _truckNoController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               _buildHeader(),
//               const SizedBox(height: 30),
//               _buildRegistrationForm(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.purple[700]!, Colors.purple[500]!],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.purple.withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.local_shipping,
//             size: 45,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Join as Tow Provider',
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.purple[800],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Start providing roadside assistance services',
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 15,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildRegistrationForm() {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildTextField(
//                 controller: _driverNameController,
//                 label: 'Driver Name',
//                 icon: Icons.person_outline,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter driver name';
//                   }
//                   if (value.length < 2) {
//                     return 'Name must be at least 2 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _emailController,
//                 label: 'Email Address',
//                 icon: Icons.email_outlined,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email address';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _passController,
//                 label: 'Password',
//                 icon: Icons.lock_outline,
//                 isPassword: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _truckNoController,
//                 label: 'Tow Truck Number',
//                 icon: Icons.confirmation_number_outlined,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter truck number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTruckTypeDropdown(),
//               const SizedBox(height: 20),
//               _buildLocationField(),
//               const SizedBox(height: 30),
//               _buildFeaturesList(),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _register,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple[600],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 4,
//                     shadowColor: Colors.purple.withOpacity(0.3),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.5,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.local_shipping, size: 20),
//                             const SizedBox(width: 10),
//                             Text(
//                               'REGISTER AS TOW PROVIDER',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already registered? ",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 15,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (!_isLoading) {
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(
//                       'Login here',
//                       style: TextStyle(
//                         color: Colors.purple[600],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool isPassword = false,
//     required String? Function(String?) validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: isPassword,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.grey[600]),
//         prefixIcon: Icon(icon, color: Colors.purple[400]),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//     );
//   }

//   Widget _buildTruckTypeDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _selectedTruckType,
//       decoration: InputDecoration(
//         labelText: 'Truck Type',
//         labelStyle: TextStyle(color: Colors.grey[600]),
//         prefixIcon: const Icon(Icons.build_outlined, color: Colors.purple),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//       items: _truckTypes.map((String type) {
//         return DropdownMenuItem<String>(
//           value: type,
//           child: Text(type),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedTruckType = newValue;
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select truck type';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildLocationField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: _locationController,
//           maxLines: 2,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your location';
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             labelText: 'Service Location',
//             labelStyle: TextStyle(color: Colors.grey[600]),
//             prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.purple),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
//             ),
//             filled: true,
//             fillColor: Colors.grey[50],
//             hintText: 'Enter your service area or address...',
//           ),
//         ),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _locationLoading ? null : _getCurrentLocation,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple[50],
//                   foregroundColor: Colors.purple,
//                 ),
//                 icon: _locationLoading 
//                     ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
//                     : Icon(Icons.gps_fixed),
//                 label: Text(_locationLoading ? 'Getting Location...' : 'Use Current Location'),
//               ),
//             ),
//           ],
//         ),
//         if (_currentPosition != null) ...[
//           SizedBox(height: 8),
//           Text(
//             'Location captured: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
//             style: TextStyle(fontSize: 12, color: Colors.green),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildFeaturesList() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.purple[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.purple[100]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.star_outline, color: Colors.purple[600], size: 18),
//               const SizedBox(width: 8),
//               Text(
//                 'Why Join Us?',
//                 style: TextStyle(
//                   color: Colors.purple[700],
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildFeatureItem('24/7 Emergency Requests'),
//           _buildFeatureItem('Real-time Job Notifications'),
//           _buildFeatureItem('Competitive Pricing'),
//           _buildFeatureItem('GPS Navigation Support'),
//           _buildFeatureItem('Instant Payment Processing'),
//           _buildFeatureItem('Customer Rating System'),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeatureItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(Icons.check_circle, color: Colors.purple[400], size: 16),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(
//               color: Colors.purple[700],
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }