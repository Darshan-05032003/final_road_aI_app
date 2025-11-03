// import 'package:smart_road_app/Login/ToeProviderRegister.dart';
// import 'package:smart_road_app/ToeProvider/ToeProvider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class TowProviderLoginPage extends StatefulWidget {
//   const TowProviderLoginPage({super.key});

//   @override
//   _TowProviderLoginPageState createState() => _TowProviderLoginPageState();
// }

// class _TowProviderLoginPageState extends State<TowProviderLoginPage> {
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
//                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainDashboard()));
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
//               // Purple gradient background
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.34,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple[800]!, Colors.purple[600]!, Colors.purple[400]!],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//               ),

//               // Tow truck icon in background
//               Positioned(
//                 top: 50,
//                 right: 30,
//                 child: Opacity(
//                   opacity: 0.1,
//                   child: Icon(
//                     Icons.local_shipping,
//                     size: 150,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 10),

//                     // Logo and Title
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.purple.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.local_shipping,
//                         size: 45,
//                         color: Colors.purple[700],
//                       ),
//                     ),

//                     SizedBox(height: 25),

//                     Text(
//                       'Tow Provider Login',
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     SizedBox(height: 8),

//                     Text(
//                       '24/7 Roadside Assistance',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     SizedBox(height: 40),

//                     // Login Card
//                     Card(
//                       elevation: 12,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(28),
//                         child: Column(
//                           children: [
//                             // Welcome Text
//                             Text(
//                               'Welcome Back',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.purple[800],
//                               ),
//                             ),

//                             SizedBox(height: 5),

//                             // Email Field
//                             _buildTextField(
//                               controller: _emailController,
//                               label: 'Email / Phone',
//                               icon: Icons.email_outlined,
//                             ),

//                             SizedBox(height: 10),

//                             // Password Field
//                             _buildPasswordField(),

//                             SizedBox(height: 10),

//                             // Forgot Password & Remember Me
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Remember Me
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 20,
//                                       height: 20,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.purple[400]!),
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: Icon(
//                                         Icons.check,
//                                         size: 16,
//                                         color: Colors.purple[600],
//                                       ),
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       'Remember me',
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 // Forgot Password

//                               ],
//                             ),

//                             SizedBox(height: 10),

//                             // Login Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 55,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _login,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.purple[600],
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   elevation: 5,
//                                   shadowColor: Colors.purple.withOpacity(0.4),
//                                 ),
//                                 child: _isLoading
//                                     ? SizedBox(
//                                         height: 22,
//                                         width: 22,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2.5,
//                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       )
//                                     : Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             'LOGIN TO DASHBOARD',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           SizedBox(width: 8),
//                                           Icon(Icons.arrow_forward, size: 20),
//                                         ],
//                                       ),
//                               ),
//                             ),

//                             SizedBox(height: 5),

//                             // Divider
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Divider(color: Colors.grey[300]),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 15),
//                                   child: Text(
//                                     'or',
//                                     style: TextStyle(
//                                       color: Colors.grey[500],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Divider(color: Colors.grey[300]),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 5),

//                             // Register Link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "New tow provider? ",
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TowProviderRegistrationPage()));
//                                   },
//                                   child: Text(
//                                     'Join Now',
//                                     style: TextStyle(
//                                       color: Colors.purple[600],
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 10),

//                     // Emergency Contact
//                     Container(
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Colors.purple[50],
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(color: Colors.purple[100]!),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.emergency,
//                             color: Colors.purple[700],
//                             size: 18,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Emergency Hotline: 1800-TOW-HELP',
//                             style: TextStyle(
//                               color: Colors.purple[700],
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
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

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.emailAddress,
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

//   Widget _buildPasswordField() {
//     return TextField(
//       controller: _passwordController,
//       obscureText: _obscureText,
//       decoration: InputDecoration(
//         labelText: 'Password',
//         labelStyle: TextStyle(color: Colors.grey[600]),
//         prefixIcon: Icon(Icons.lock_outline, color: Colors.purple[400]),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//             color: Colors.purple[400],
//           ),
//           onPressed: () {
//             setState(() {
//               _obscureText = !_obscureText;
//             });
//           },
//         ),
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
// }

import 'package:smart_road_app/Login/ToeProviderRegister.dart';
import 'package:smart_road_app/ToeProvider/ToeProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/services/google_auth_service.dart';

class TowProviderLoginPage extends StatefulWidget {
  const TowProviderLoginPage({super.key});

  @override
  _TowProviderLoginPageState createState() => _TowProviderLoginPageState();
}

class _TowProviderLoginPageState extends State<TowProviderLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  // SharedPreferences keys
  static const String _isLoggedInKey = 'towProviderIsLoggedIn';
  static const String _userEmailKey = 'towProviderUserEmail';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn && mounted) {
        // Auto-navigate to tow provider dashboard if already logged in
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainDashboard()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error checking tow provider login status: $e');
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      print('Error saving tow provider login state: $e');
    }
  }

  // Clear login state from SharedPreferences
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userEmailKey);
    } catch (e) {
      print('Error during tow provider logout: $e');
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
        MaterialPageRoute(builder: (context) => MainDashboard()),
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

  // Forgot Password method
  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    
    // If email field is empty, show dialog to enter email
    if (email.isEmpty || !email.contains('@')) {
      _showForgotPasswordDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent! Check your inbox."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send reset email";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address format.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many requests. Please try again later.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send reset email. Please try again."),
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

  // Show forgot password dialog
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link:'),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty || !email.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a valid email address"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              await _sendPasswordResetEmail(email);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
            ),
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  // Send password reset email
  Future<void> _sendPasswordResetEmail(String email) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent! Check your inbox."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send reset email";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address format.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many requests. Please try again later.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send reset email. Please try again."),
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
            MaterialPageRoute(builder: (context) => MainDashboard()),
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
                // Purple gradient background
                Container(
                  height: MediaQuery.of(context).size.height * 0.34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple[800]!,
                        Colors.purple[600]!,
                        Colors.purple[400]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),

                // Tow truck icon in background
                Positioned(
                  top: 50,
                  right: 30,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.local_shipping,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),

                      // Logo and Title
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          size: 45,
                          color: Colors.purple[700],
                        ),
                      ),

                      SizedBox(height: 25),

                      Text(
                        'Tow Provider Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        '24/7 Roadside Assistance',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 40),

                      // Login Card
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(28),
                          child: Column(
                            children: [
                              // Welcome Text
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[800],
                                ),
                              ),

                              SizedBox(height: 5),

                              // Email Field
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email / Phone',
                                icon: Icons.email_outlined,
                              ),

                              SizedBox(height: 10),

                              // Password Field
                              _buildPasswordField(),

                              SizedBox(height: 10),

                              // Forgot Password & Remember Me
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Remember Me
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.purple[400]!,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.purple[600],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Forgot Password
                                  TextButton(
                                    onPressed: _isLoading ? null : _resetPassword,
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.purple[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.purple.withOpacity(0.4),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'LOGIN TO DASHBOARD',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward, size: 20),
                                          ],
                                        ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Divider with "OR"
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                ],
                                  ),

                              SizedBox(height: 20),

                              // Google Sign-In Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
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
                                      borderRadius: BorderRadius.circular(15),
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
                                    "New tow provider? ",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TowProviderRegistrationPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Join Now',
                                      style: TextStyle(
                                        color: Colors.purple[600],
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

                      SizedBox(height: 10),

                      // Emergency Contact
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.purple[100]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emergency,
                              color: Colors.purple[700],
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Emergency Hotline: 1800-TOW-HELP',
                              style: TextStyle(
                                color: Colors.purple[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.purple[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.purple[400]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.purple[400],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
