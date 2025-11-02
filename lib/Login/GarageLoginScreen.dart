// import 'package:smart_road_app/Login/GarageRegister.dart';
// import 'package:smart_road_app/garage/garageDashboardd.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class GarageLoginPage extends StatefulWidget {
//   const GarageLoginPage({super.key});

//   @override
//   _GarageLoginPageState createState() => _GarageLoginPageState();
// }

// class _GarageLoginPageState extends State<GarageLoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final bool _isLoading = false;
//   bool _obscureText = true;

//   void _login() async {
//   try {
//                         await FirebaseAuth.instance.signInWithEmailAndPassword(
//                           email: _emailController.text.trim(),
//                           password: _passwordController.text.trim(),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Sign in successful")),
//                         );
//                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GarageDashboard()));
//                       } catch (e) {
//                         ScaffoldMessenger.of(
//                           context,
//                         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//                       }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: [
//               // Blue gradient background
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue[800]!, Colors.blue[600]!],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 80),

//                     // Logo and Title
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.2),
//                             blurRadius: 15,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.build,
//                         size: 40,
//                         color: Colors.blue[700],
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     Text(
//                       'Garage Login',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 8),

//                     Text(
//                       'Manage your garage services',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 16,
//                       ),
//                     ),

//                     SizedBox(height: 80),

//                     // Login Card
//                     Card(
//                       elevation: 8,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(24),
//                         child: Column(
//                           children: [
//                             // Email Field
//                             TextField(
//                               controller: _emailController,
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 labelText: 'Email / Phone',
//                                 prefixIcon: Icon(Icons.email, color: Colors.blue[400]),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: 20),

//                             // Password Field
//                             TextField(
//                               controller: _passwordController,
//                               obscureText: _obscureText,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 prefixIcon: Icon(Icons.lock, color: Colors.blue[400]),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _obscureText ? Icons.visibility : Icons.visibility_off,
//                                     color: Colors.blue[400],
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscureText = !_obscureText;
//                                     });
//                                   },
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: 10),

//                             // Forgot Password
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {
//                                   // Navigate to forgot password
//                                 },
//                                 child: Text(
//                                   'Forgot Password?',
//                                   style: TextStyle(
//                                     color: Colors.blue[600],
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: 20),

//                             // Login Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _login,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[600],
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 3,
//                                 ),
//                                 child: _isLoading
//                                     ? SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       )
//                                     : Text(
//                                         'LOGIN TO GARAGE',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                               ),
//                             ),

//                             SizedBox(height: 20),

//                             // Register Link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Don't have a garage account? ",
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GarageRegistrationPage()));
//                                   },
//                                   child: Text(
//                                     'Register',
//                                     style: TextStyle(
//                                       color: Colors.blue[600],
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // // In your main.dart or wherever you navigate to these screens
// // import 'package:smart_road_app/VehicleOwner/nearby_garages_screen.dart';
// // import 'package:smart_road_app/garage/garage_service_providerscreen.dart';
// // import 'package:smart_road_app/Login/GarageLoginScreen.dart';

// // class GarageLoginScreen extends StatefulWidget {
// //   const GarageLoginScreen({super.key});

// //   @override
// //   _GarageLoginScreenState createState() => _GarageLoginScreenState();
// // }

// // class _GarageLoginScreenState extends State<GarageLoginScreen> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   bool _isLoading = false;

// //   Future<void> _loginGarage() async {
// //     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter email and password')),
// //       );
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       // Check if garage exists in Firestore
// //       final garageSnapshot = await FirebaseFirestore.instance
// //           .collection('garages')
// //           .where('email', isEqualTo: _emailController.text.trim())
// //           .limit(1)
// //           .get();

// //       if (garageSnapshot.docs.isEmpty) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('No garage found with this email')),
// //         );
// //         return;
// //       }

// //       final garageData = garageSnapshot.docs.first.data();

// //       // For demo purposes, we'll just check if the garage exists
// //       // In production, you should implement proper authentication

// //       print('✅ Garage login successful: ${_emailController.text}');

// //       // Navigate to garage service provider screen
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => GarageServiceProviderScreen(
// //             garageEmail: _emailController.text.trim(),
// //           ),
// //         ),
// //       );

// //     } catch (e) {
// //       print('❌ Garage login error: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Login failed: ${e.toString()}')),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Garage Login'),
// //         backgroundColor: Color(0xFF6D28D9),
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.build_circle_rounded, size: 80, color: Color(0xFF6D28D9)),
// //             SizedBox(height: 24),
// //             Text(
// //               'Garage Service Provider',
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               'Login to manage your service requests',
// //               style: TextStyle(color: Colors.grey[600]),
// //             ),
// //             SizedBox(height: 32),
// //             TextFormField(
// //               controller: _emailController,
// //               decoration: InputDecoration(
// //                 labelText: 'Garage Email',
// //                 prefixIcon: Icon(Icons.email_rounded),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               keyboardType: TextInputType.emailAddress,
// //             ),
// //             SizedBox(height: 16),
// //             TextFormField(
// //               controller: _passwordController,
// //               decoration: InputDecoration(
// //                 labelText: 'Password',
// //                 prefixIcon: Icon(Icons.lock_rounded),
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //               ),
// //               obscureText: true,
// //             ),
// //             SizedBox(height: 24),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: _isLoading ? null : _loginGarage,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xFF6D28D9),
// //                   foregroundColor: Colors.white,
// //                   padding: EdgeInsets.symmetric(vertical: 16),
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //                 ),
// //                 child: _isLoading
// //                     ? Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           SizedBox(
// //                             width: 20,
// //                             height: 20,
// //                             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// //                           ),
// //                           SizedBox(width: 12),
// //                           Text('Logging in...'),
// //                         ],
// //                       )
// //                     : Text('Login as Garage Provider'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:smart_road_app/Login/GarageRegister.dart';
import 'package:smart_road_app/garage/garageDashboardd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/services/google_auth_service.dart';

class GarageLoginPage extends StatefulWidget {
  const GarageLoginPage({super.key});

  @override
  _GarageLoginPageState createState() => _GarageLoginPageState();
}

class _GarageLoginPageState extends State<GarageLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  // SharedPreferences keys
  static const String _isLoggedInKey = 'garageIsLoggedIn';
  static const String _userEmailKey = 'garageUserEmail';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      // First check if user is authenticated with Firebase Auth
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        // Not authenticated, clear any stale SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, false);
        await prefs.remove(_userEmailKey);
        return;
      }

      // User is authenticated, verify SharedPreferences matches
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final savedEmail = prefs.getString(_userEmailKey) ?? '';

      // Only auto-navigate if both Firebase Auth and SharedPreferences indicate login
      if (isLoggedIn && currentUser.email != null && currentUser.email == savedEmail && mounted) {
        // Auto-navigate to garage dashboard if already logged in
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => GarageDashboard()),
          (route) => false,
        );
      } else {
        // Mismatch detected - clear stale data
        await prefs.setBool(_isLoggedInKey, false);
        await prefs.remove(_userEmailKey);
        // Sign out from Firebase to be safe
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      print('Error checking garage login status: $e');
      // On error, ensure we're signed out
      try {
        await FirebaseAuth.instance.signOut();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, false);
        await prefs.remove(_userEmailKey);
      } catch (signOutError) {
        print('Error during cleanup: $signOutError');
      }
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      print('Error saving garage login state: $e');
    }
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save login state to SharedPreferences
      await _saveLoginState(_emailController.text.trim());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sign in successful")));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GarageDashboard()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Google Sign-In method
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential? userCredential = await GoogleAuthService.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        // Save login state to SharedPreferences
        await _saveLoginState(userCredential.user!.email ?? '');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Google Sign-In successful"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GarageDashboard()),
            (route) => false,
          );
        }
      } else {
        // User cancelled the sign-in
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sign-In was cancelled"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Google Sign-In failed: ${e.toString()}"),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to role selection instead of exiting app
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Blue gradient background
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[800]!, Colors.blue[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),

                      // Logo and Title
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.build,
                          size: 40,
                          color: Colors.blue[700],
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Garage Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Manage your garage services',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 80),

                      // Login Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Email Field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email / Phone',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.blue[400],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue[400]!,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Password Field
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue[400],
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.blue[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue[400]!,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to forgot password
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'LOGIN TO GARAGE',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Divider with "OR"
                              Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),

                              SizedBox(height: 20),

                              // Google Sign-In Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading ? null : _signInWithGoogle,
                                  icon: Image.network(
                                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                    height: 24,
                                    width: 24,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
                                    },
                                  ),
                                  label: Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey[300]!),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have a garage account? ",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GarageRegistrationPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
