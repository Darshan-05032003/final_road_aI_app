

// import 'package:smart_road_app/Login/GarageRegister.dart';
// import 'package:smart_road_app/garage/garageDashboardd.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smart_road_app/services/google_auth_service.dart';

// class GarageLoginPage extends StatefulWidget {
//   const GarageLoginPage({super.key});

//   @override
//   _GarageLoginPageState createState() => _GarageLoginPageState();
// }

// class _GarageLoginPageState extends State<GarageLoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscureText = true;

//   // SharedPreferences keys
//   static const String _isLoggedInKey = 'garageIsLoggedIn';
//   static const String _userEmailKey = 'garageUserEmail';

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   // Check if user is already logged in
//   Future<void> _checkLoginStatus() async {
//     try {
//       // First check if user is authenticated with Firebase Auth
//       final currentUser = FirebaseAuth.instance.currentUser;
      
//       if (currentUser == null) {
//         // Not authenticated, clear any stale SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool(_isLoggedInKey, false);
//         await prefs.remove(_userEmailKey);
//         return;
//       }

//       // User is authenticated, verify SharedPreferences matches
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
//       final savedEmail = prefs.getString(_userEmailKey) ?? '';

//       // Only auto-navigate if both Firebase Auth and SharedPreferences indicate login
//       if (isLoggedIn && currentUser.email != null && currentUser.email == savedEmail && mounted) {
//         // Auto-navigate to garage dashboard if already logged in
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => GarageDashboard()),
//           (route) => false,
//         );
//       } else {
//         // Mismatch detected - clear stale data
//         await prefs.setBool(_isLoggedInKey, false);
//         await prefs.remove(_userEmailKey);
//         // Sign out from Firebase to be safe
//         await FirebaseAuth.instance.signOut();
//       }
//     } catch (e) {
//       print('Error checking garage login status: $e');
//       // On error, ensure we're signed out
//       try {
//         await FirebaseAuth.instance.signOut();
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool(_isLoggedInKey, false);
//         await prefs.remove(_userEmailKey);
//       } catch (signOutError) {
//         print('Error during cleanup: $signOutError');
//       }
//     }
//   }

//   // Save login state to SharedPreferences
//   Future<void> _saveLoginState(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, true);
//       await prefs.setString(_userEmailKey, email);
//     } catch (e) {
//       print('Error saving garage login state: $e');
//     }
//   }

//   void _login() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email and password")),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Save login state to SharedPreferences
//       await _saveLoginState(_emailController.text.trim());

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Sign in successful")));

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => GarageDashboard()),
//         (route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   // Forgot Password method
//   Future<void> _resetPassword() async {
//     String email = _emailController.text.trim();
    
//     // If email field is empty, show dialog to enter email
//     if (email.isEmpty || !email.contains('@')) {
//       _showForgotPasswordDialog();
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: email,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Password reset email sent! Check your inbox."),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Failed to send reset email";

//       if (e.code == 'user-not-found') {
//         errorMessage = "No user found with this email address.";
//       } else if (e.code == 'invalid-email') {
//         errorMessage = "Invalid email address format.";
//       } else if (e.code == 'too-many-requests') {
//         errorMessage = "Too many requests. Please try again later.";
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to send reset email. Please try again."),
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

//   // Show forgot password dialog
//   void _showForgotPasswordDialog() {
//     final emailController = TextEditingController();
    
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Reset Password'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Enter your email address to receive a password reset link:'),
//             const SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 hintText: 'Enter your email',
//                 prefixIcon: const Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               keyboardType: TextInputType.emailAddress,
//               autofocus: true,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final email = emailController.text.trim();
//               if (email.isEmpty || !email.contains('@')) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Please enter a valid email address"),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//                 return;
//               }
              
//               Navigator.pop(context);
//               await _sendPasswordResetEmail(email);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[600],
//             ),
//             child: const Text('Send Reset Link'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Send password reset email
//   Future<void> _sendPasswordResetEmail(String email) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: email,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Password reset email sent! Check your inbox."),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Failed to send reset email";

//       if (e.code == 'user-not-found') {
//         errorMessage = "No user found with this email address.";
//       } else if (e.code == 'invalid-email') {
//         errorMessage = "Invalid email address format.";
//       } else if (e.code == 'too-many-requests') {
//         errorMessage = "Too many requests. Please try again later.";
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to send reset email. Please try again."),
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

//   // Google Sign-In method
//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final UserCredential? userCredential = await GoogleAuthService.signInWithGoogle();

//       if (userCredential != null && userCredential.user != null) {
//         // Save login state to SharedPreferences
//         await _saveLoginState(userCredential.user!.email ?? '');

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Google Sign-In successful"),
//               backgroundColor: Colors.green,
//             ),
//           );

//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => GarageDashboard()),
//             (route) => false,
//           );
//         }
//       } else {
//         // User cancelled the sign-in
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Sign-In was cancelled"),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Google Sign-In failed: ${e.toString()}"),
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

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigate back to role selection instead of exiting app
//         Navigator.of(context).pop();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         body: SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Stack(
//               children: [
//                 // Blue gradient background
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue[800]!, Colors.blue[600]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 80),

//                       // Logo and Title
//                       Container(
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.blue.withOpacity(0.2),
//                               blurRadius: 15,
//                               offset: Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Icons.build,
//                           size: 40,
//                           color: Colors.blue[700],
//                         ),
//                       ),

//                       SizedBox(height: 20),

//                       Text(
//                         'Garage Login',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),

//                       SizedBox(height: 8),

//                       Text(
//                         'Manage your garage services',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 16,
//                         ),
//                       ),

//                       SizedBox(height: 80),

//                       // Login Card
//                       Card(
//                         elevation: 8,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(24),
//                           child: Column(
//                             children: [
//                               // Email Field
//                               TextField(
//                                 controller: _emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   labelText: 'Email / Phone',
//                                   prefixIcon: Icon(
//                                     Icons.email,
//                                     color: Colors.blue[400],
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.blue[400]!,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: 20),

//                               // Password Field
//                               TextField(
//                                 controller: _passwordController,
//                                 obscureText: _obscureText,
//                                 decoration: InputDecoration(
//                                   labelText: 'Password',
//                                   prefixIcon: Icon(
//                                     Icons.lock,
//                                     color: Colors.blue[400],
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _obscureText
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.blue[400],
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _obscureText = !_obscureText;
//                                       });
//                                     },
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       color: Colors.blue[400]!,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: 10),

//                               // Forgot Password
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                   onPressed: _isLoading ? null : _resetPassword,
//                                   child: Text(
//                                     'Forgot Password?',
//                                     style: TextStyle(
//                                       color: Colors.blue[600],
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: 20),

//                               // Login Button
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: _isLoading ? null : _login,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue[600],
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     elevation: 3,
//                                   ),
//                                   child: _isLoading
//                                       ? SizedBox(
//                                           height: 20,
//                                           width: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                   Colors.white,
//                                                 ),
//                                           ),
//                                         )
//                                       : Text(
//                                           'LOGIN TO GARAGE',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                 ),
//                               ),

//                               SizedBox(height: 20),

//                               // Divider with "OR"
//                               Row(
//                                 children: [
//                                   Expanded(child: Divider()),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     child: Text(
//                                       'OR',
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(child: Divider()),
//                                 ],
//                               ),

//                               SizedBox(height: 20),

//                               // Google Sign-In Button
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: OutlinedButton.icon(
//                                   onPressed: _isLoading ? null : _signInWithGoogle,
//                                   icon: Image.network(
//                                     'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
//                                     height: 24,
//                                     width: 24,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
//                                     },
//                                   ),
//                                   label: Text(
//                                     'Continue with Google',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[800],
//                                     ),
//                                   ),
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide(color: Colors.grey[300]!),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                           ),
//                                         ),
//                                 ),
//                               ),

//                               SizedBox(height: 20),

//                               // Register Link
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Don't have a garage account? ",
//                                     style: TextStyle(color: Colors.grey[600]),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               GarageRegistrationPage(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Register',
//                                       style: TextStyle(
//                                         color: Colors.blue[600],
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:smart_road_app/Login/GarageRegister.dart';
import 'package:smart_road_app/garage/garageDashboardd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/services/google_auth_service.dart';
import 'package:smart_road_app/shared_prefrences.dart' show AuthService, GarageAuth;

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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is already logged in using the centralized AuthService
  Future<void> _checkLoginStatus() async {
    try {
      final bool isLoggedIn = await AuthService.checkValidLogin();
      final String? userEmail = await AuthService.getUserEmail();
      final String? userRole = await AuthService.getUserRole();
      
      // Check if Firebase user matches our stored preferences
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (isLoggedIn && 
          userRole == 'garage' && 
          currentUser != null && 
          currentUser.email == userEmail &&
          mounted) {
        
        print('✅ Auto-login detected for garage: $userEmail');
        
        // Auto-navigate to garage dashboard if already logged in
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GarageDashboard()),
          (route) => false,
        );
      } else {
        // Clear any stale data if conditions don't match
        if (currentUser == null || currentUser.email != userEmail || userRole != 'garage') {
          await _clearStaleData();
        }
      }
    } catch (e) {
      print('❌ Error checking garage login status: $e');
      await _clearStaleData();
    }
  }

  // Clear stale login data - FIXED METHOD
  Future<void> _clearStaleData() async {
    try {
      // Only clear data if user is actually logged out
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        await GarageAuth.garageLogout();
        await AuthService.logout();
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  // Save login state using centralized services
  Future<void> _saveLoginState(String email) async {
    try {
      await GarageAuth.saveGarageLogin(email);
      print('✅ Garage login state saved for: $email');
    } catch (e) {
      print('❌ Error saving garage login state: $e');
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
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Save login state to SharedPreferences
        await _saveLoginState(_emailController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign in successful")),
        );

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const GarageDashboard()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many attempts. Try again later.";
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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

    await _sendPasswordResetEmail(email);
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
              backgroundColor: Colors.blue[600],
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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

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
            MaterialPageRoute(builder: (context) => const GarageDashboard()),
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      // Logo and Title
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.build,
                          size: 40,
                          color: Colors.blue[700],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Garage Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Manage your garage services',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Login Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
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

                              const SizedBox(height: 20),

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

                              const SizedBox(height: 10),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _isLoading ? null : _resetPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

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
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'LOGIN TO GARAGE',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Divider with "OR"
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
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
                                  const Expanded(child: Divider()),
                                ],
                              ),

                              const SizedBox(height: 20),

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
                                  label: const Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(66, 66, 66, 1),
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

                              const SizedBox(height: 20),

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
                                          builder: (context) => const GarageRegistrationPage(),
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