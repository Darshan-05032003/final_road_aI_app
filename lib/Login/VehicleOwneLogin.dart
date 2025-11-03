

// // // // import 'package:smart_road_app/Login/VehicleownerRegister.dart';
// // // // import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// // // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:smart_road_app/services/google_auth_service.dart';

// // // // class VehicleLoginPage extends StatefulWidget {
// // // //   const VehicleLoginPage({super.key});

// // // //   @override
// // // //   _LoginPageState createState() => _LoginPageState();
// // // // }

// // // // class _LoginPageState extends State<VehicleLoginPage>
// // // //     with SingleTickerProviderStateMixin {
// // // //   late AnimationController _controller;
// // // //   late Animation<double> _animation;
// // // //   late Animation<Offset> _slideAnimation;

// // // //   final TextEditingController _emailController = TextEditingController();
// // // //   final TextEditingController _passwordController = TextEditingController();

// // // //   bool _isLoading = false;
// // // //   bool _obscureText = true;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();

// // // //     _controller = AnimationController(
// // // //       duration: const Duration(seconds: 2),
// // // //       vsync: this,
// // // //     );

// // // //     _animation = Tween<double>(
// // // //       begin: 0,
// // // //       end: 1,
// // // //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

// // // //     _slideAnimation = Tween<Offset>(
// // // //       begin: const Offset(0, 0.5),
// // // //       end: Offset.zero,
// // // //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

// // // //     _controller.forward();

// // // //     // Check if user is already logged in
// // // //     _checkLoginStatus();
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _controller.dispose();
// // // //     _emailController.dispose();
// // // //     _passwordController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   // Check if user is already logged in
// // // //   void _checkLoginStatus() async {
// // // //     try {
// // // //       print('🔍 Checking login status...');
// // // //       bool isValidLogin = await AuthService.checkValidLogin();

// // // //       if (isValidLogin) {
// // // //         String? userEmail = await AuthService.getUserEmail();
// // // //         print('✅ User already logged in: $userEmail');

// // // //         // Auto-navigate to dashboard if already logged in
// // // //         if (mounted) {
// // // //           WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //             Navigator.pushAndRemoveUntil(
// // // //               context,
// // // //               MaterialPageRoute(
// // // //                 builder: (context) => EnhancedVehicleDashboard(),
// // // //               ),
// // // //               (route) => false,
// // // //             );
// // // //           });
// // // //         }
// // // //       } else {
// // // //         print('ℹ️ No valid login found, staying on login page');
// // // //       }
// // // //     } catch (e) {
// // // //       print("❌ Error checking login status: $e");
// // // //     }
// // // //   }

// // // //   // Google Sign-In method
// // // //   Future<void> _signInWithGoogle() async {
// // // //     setState(() {
// // // //       _isLoading = true;
// // // //     });

// // // //     try {
// // // //       final UserCredential? userCredential = await GoogleAuthService.signInWithGoogle();

// // // //       if (userCredential != null && userCredential.user != null) {
// // // //         // Save login data to shared preferences
// // // //         await AuthService.saveLoginData(userCredential.user!.email ?? '');

// // // //         if (mounted) {
// // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // //             const SnackBar(
// // // //               content: Text("Google Sign-In successful"),
// // // //               backgroundColor: Colors.green,
// // // //             ),
// // // //           );

// // // //           Navigator.pushAndRemoveUntil(
// // // //             context,
// // // //             MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// // // //             (route) => false,
// // // //           );
// // // //         }
// // // //       } else {
// // // //         // User cancelled the sign-in
// // // //         if (mounted) {
// // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // //             const SnackBar(
// // // //               content: Text("Sign-In was cancelled"),
// // // //               backgroundColor: Colors.orange,
// // // //             ),
// // // //           );
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text("Google Sign-In failed: ${e.toString()}"),
// // // //             backgroundColor: Colors.red,
// // // //           ),
// // // //         );
// // // //       }
// // // //     } finally {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           _isLoading = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   void _login() async {
// // // //     // Validate inputs
// // // //     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(
// // // //           content: Text("Please enter email and password"),
// // // //           backgroundColor: Colors.red,
// // // //         ),
// // // //       );
// // // //       return;
// // // //     }

// // // //     if (!_emailController.text.contains('@')) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(
// // // //           content: Text("Please enter a valid email address"),
// // // //           backgroundColor: Colors.red,
// // // //         ),
// // // //       );
// // // //       return;
// // // //     }

// // // //     setState(() {
// // // //       _isLoading = true;
// // // //     });

// // // //     try {
// // // //       await FirebaseAuth.instance.signInWithEmailAndPassword(
// // // //         email: _emailController.text.trim(),
// // // //         password: _passwordController.text.trim(),
// // // //       );

// // // //       // Save login data to shared preferences
// // // //       await AuthService.saveLoginData(_emailController.text.trim());

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           const SnackBar(
// // // //             content: Text("Sign in successful"),
// // // //             backgroundColor: Colors.green,
// // // //           ),
// // // //         );

// // // //         Navigator.pushAndRemoveUntil(
// // // //           context,
// // // //           MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// // // //           (route) => false,
// // // //         );
// // // //       }
// // // //     } on FirebaseAuthException catch (e) {
// // // //       String errorMessage = "An error occurred during sign in";

// // // //       if (e.code == 'user-not-found') {
// // // //         errorMessage = "No user found for that email.";
// // // //       } else if (e.code == 'wrong-password') {
// // // //         errorMessage = "Wrong password provided.";
// // // //       } else if (e.code == 'invalid-email') {
// // // //         errorMessage = "Invalid email address format.";
// // // //       } else if (e.code == 'user-disabled') {
// // // //         errorMessage = "This user account has been disabled.";
// // // //       } else if (e.code == 'too-many-requests') {
// // // //         errorMessage = "Too many attempts. Please try again later.";
// // // //       } else if (e.code == 'network-request-failed') {
// // // //         errorMessage = "Network error. Please check your internet connection.";
// // // //       }

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text("An unexpected error occurred. Please try again."),
// // // //             backgroundColor: Colors.red,
// // // //           ),
// // // //         );
// // // //       }
// // // //     } finally {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           _isLoading = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   void _resetPassword() async {
// // // //     if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(
// // // //           content: Text("Please enter a valid email address to reset password"),
// // // //           backgroundColor: Colors.red,
// // // //         ),
// // // //       );
// // // //       return;
// // // //     }

// // // //     setState(() {
// // // //       _isLoading = true;
// // // //     });

// // // //     try {
// // // //       await FirebaseAuth.instance.sendPasswordResetEmail(
// // // //         email: _emailController.text.trim(),
// // // //       );

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           const SnackBar(
// // // //             content: Text("Password reset email sent! Check your inbox."),
// // // //             backgroundColor: Colors.green,
// // // //           ),
// // // //         );
// // // //       }
// // // //     } on FirebaseAuthException catch (e) {
// // // //       String errorMessage = "Failed to send reset email";

// // // //       if (e.code == 'user-not-found') {
// // // //         errorMessage = "No user found with this email address.";
// // // //       } else if (e.code == 'invalid-email') {
// // // //         errorMessage = "Invalid email address format.";
// // // //       }

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           const SnackBar(
// // // //             content: Text("Failed to send reset email. Please try again."),
// // // //             backgroundColor: Colors.red,
// // // //           ),
// // // //         );
// // // //       }
// // // //     } finally {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           _isLoading = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return WillPopScope(
// // // //       onWillPop: () async {
// // // //         // Navigate back to role selection instead of exiting app
// // // //         Navigator.of(context).pop();
// // // //         return false;
// // // //       },
// // // //       child: Scaffold(
// // // //         backgroundColor: Colors.grey[50],
// // // //         body: SingleChildScrollView(
// // // //           child: SizedBox(
// // // //             height: MediaQuery.of(context).size.height,
// // // //             child: Stack(
// // // //               children: [
// // // //                 // Background with gradient
// // // //                 Container(
// // // //                   height: MediaQuery.of(context).size.height * 0.4,
// // // //                   decoration: BoxDecoration(
// // // //                     gradient: LinearGradient(
// // // //                       colors: [Colors.purple[800]!, Colors.purple[600]!],
// // // //                       begin: Alignment.topLeft,
// // // //                       end: Alignment.bottomRight,
// // // //                     ),
// // // //                     borderRadius: const BorderRadius.only(
// // // //                       bottomLeft: Radius.circular(40),
// // // //                       bottomRight: Radius.circular(40),
// // // //                     ),
// // // //                   ),
// // // //                 ),

// // // //                 // Animated content
// // // //                 FadeTransition(
// // // //                   opacity: _animation,
// // // //                   child: SlideTransition(
// // // //                     position: _slideAnimation,
// // // //                     child: Padding(
// // // //                       padding: const EdgeInsets.all(24.0),
// // // //                       child: Column(
// // // //                         mainAxisAlignment: MainAxisAlignment.center,
// // // //                         children: [
// // // //                           const SizedBox(height: 80),

// // // //                           // Logo and Title
// // // //                           Container(
// // // //                             padding: const EdgeInsets.all(16),
// // // //                             decoration: BoxDecoration(
// // // //                               color: Colors.white,
// // // //                               shape: BoxShape.circle,
// // // //                               boxShadow: [
// // // //                                 BoxShadow(
// // // //                                   color: Colors.purple.withOpacity(0.2),
// // // //                                   blurRadius: 15,
// // // //                                   offset: const Offset(0, 5),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                             child: Icon(
// // // //                               Icons.directions_car,
// // // //                               size: 40,
// // // //                               color: Colors.purple[700],
// // // //                             ),
// // // //                           ),

// // // //                           const SizedBox(height: 20),

// // // //                           Text(
// // // //                             'Owner Login',
// // // //                             style: TextStyle(
// // // //                               fontSize: 28,
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.white,
// // // //                             ),
// // // //                           ),

// // // //                           const SizedBox(height: 8),

// // // //                           Text(
// // // //                             'Access your vehicle services',
// // // //                             style: TextStyle(
// // // //                               color: Colors.white.withOpacity(0.9),
// // // //                               fontSize: 16,
// // // //                             ),
// // // //                           ),

// // // //                           const SizedBox(height: 40),

// // // //                           // Login Card
// // // //                           Card(
// // // //                             elevation: 8,
// // // //                             shape: RoundedRectangleBorder(
// // // //                               borderRadius: BorderRadius.circular(20),
// // // //                             ),
// // // //                             child: Padding(
// // // //                               padding: const EdgeInsets.all(24),
// // // //                               child: Column(
// // // //                                 children: [
// // // //                                   // Email Field
// // // //                                   _buildTextField(
// // // //                                     controller: _emailController,
// // // //                                     label: 'Email',
// // // //                                     icon: Icons.email,
// // // //                                     keyboardType: TextInputType.emailAddress,
// // // //                                   ),

// // // //                                   const SizedBox(height: 20),

// // // //                                   // Password Field
// // // //                                   _buildPasswordField(),

// // // //                                   const SizedBox(height: 10),

// // // //                                   // Forgot Password
// // // //                                   Align(
// // // //                                     alignment: Alignment.centerRight,
// // // //                                     child: TextButton(
// // // //                                       onPressed: _isLoading
// // // //                                           ? null
// // // //                                           : _resetPassword,
// // // //                                       child: Text(
// // // //                                         'Forgot Password?',
// // // //                                         style: TextStyle(
// // // //                                           color: Colors.purple[600],
// // // //                                           fontWeight: FontWeight.w500,
// // // //                                         ),
// // // //                                       ),
// // // //                                     ),
// // // //                                   ),

// // // //                                   const SizedBox(height: 20),

// // // //                                   // Login Button
// // // //                                   SizedBox(
// // // //                                     width: double.infinity,
// // // //                                     height: 50,
// // // //                                     child: ElevatedButton(
// // // //                                       onPressed: _isLoading ? null : _login,
// // // //                                       style: ElevatedButton.styleFrom(
// // // //                                         backgroundColor: Colors.purple[600],
// // // //                                         shape: RoundedRectangleBorder(
// // // //                                           borderRadius: BorderRadius.circular(
// // // //                                             12,
// // // //                                           ),
// // // //                                         ),
// // // //                                         elevation: 3,
// // // //                                       ),
// // // //                                       child: _isLoading
// // // //                                           ? const SizedBox(
// // // //                                               height: 20,
// // // //                                               width: 20,
// // // //                                               child: CircularProgressIndicator(
// // // //                                                 strokeWidth: 2,
// // // //                                                 valueColor:
// // // //                                                     AlwaysStoppedAnimation<
// // // //                                                       Color
// // // //                                                     >(Colors.white),
// // // //                                               ),
// // // //                                             )
// // // //                                           : const Text(
// // // //                                               'LOGIN',
// // // //                                               style: TextStyle(
// // // //                                                 fontSize: 16,
// // // //                                                 fontWeight: FontWeight.bold,
// // // //                                                 color: Colors.white,
// // // //                                               ),
// // // //                                             ),
// // // //                                     ),
// // // //                                   ),

// // // //                                   const SizedBox(height: 20),

// // // //                                   // Divider with "OR"
// // // //                                   Row(
// // // //                                     children: [
// // // //                                       Expanded(child: Divider()),
// // // //                                       Padding(
// // // //                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // //                                         child: Text(
// // // //                                           'OR',
// // // //                                           style: TextStyle(
// // // //                                             color: Colors.grey[600],
// // // //                                             fontWeight: FontWeight.w500,
// // // //                                           ),
// // // //                                         ),
// // // //                                       ),
// // // //                                       Expanded(child: Divider()),
// // // //                                     ],
// // // //                                   ),

// // // //                                   const SizedBox(height: 20),

// // // //                                   // Google Sign-In Button
// // // //                                   SizedBox(
// // // //                                     width: double.infinity,
// // // //                                     height: 50,
// // // //                                     child: OutlinedButton.icon(
// // // //                                       onPressed: _isLoading ? null : _signInWithGoogle,
// // // //                                       icon: Image.network(
// // // //                                         'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
// // // //                                         height: 24,
// // // //                                         width: 24,
// // // //                                         errorBuilder: (context, error, stackTrace) {
// // // //                                           return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
// // // //                                         },
// // // //                                       ),
// // // //                                       label: Text(
// // // //                                         'Continue with Google',
// // // //                                         style: TextStyle(
// // // //                                           fontSize: 16,
// // // //                                           fontWeight: FontWeight.w600,
// // // //                                           color: Colors.grey[800],
// // // //                                         ),
// // // //                                       ),
// // // //                                       style: OutlinedButton.styleFrom(
// // // //                                         side: BorderSide(color: Colors.grey[300]!),
// // // //                                         shape: RoundedRectangleBorder(
// // // //                                           borderRadius: BorderRadius.circular(12),
// // // //                                         ),
// // // //                                       ),
// // // //                                     ),
// // // //                                   ),

// // // //                                   const SizedBox(height: 20),

// // // //                                   // Register Link
// // // //                                   Row(
// // // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                                     children: [
// // // //                                       Text(
// // // //                                         "Don't have an account? ",
// // // //                                         style: TextStyle(
// // // //                                           color: Colors.grey[600],
// // // //                                         ),
// // // //                                       ),
// // // //                                       GestureDetector(
// // // //                                         onTap: _isLoading
// // // //                                             ? null
// // // //                                             : () {
// // // //                                                 Navigator.of(context).push(
// // // //                                                   MaterialPageRoute(
// // // //                                                     builder: (context) =>
// // // //                                                         const RegistrationPage(),
// // // //                                                   ),
// // // //                                                 );
// // // //                                               },
// // // //                                         child: Text(
// // // //                                           'Register',
// // // //                                           style: TextStyle(
// // // //                                             color: Colors.purple[600],
// // // //                                             fontWeight: FontWeight.bold,
// // // //                                           ),
// // // //                                         ),
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildTextField({
// // // //     required TextEditingController controller,
// // // //     required String label,
// // // //     required IconData icon,
// // // //     TextInputType keyboardType = TextInputType.text,
// // // //   }) {
// // // //     return TextField(
// // // //       controller: controller,
// // // //       keyboardType: keyboardType,
// // // //       decoration: InputDecoration(
// // // //         labelText: label,
// // // //         prefixIcon: Icon(icon, color: Colors.purple[400]),
// // // //         border: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.grey[300]!),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // // //         ),
// // // //         filled: true,
// // // //         fillColor: Colors.grey[50],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildPasswordField() {
// // // //     return TextField(
// // // //       controller: _passwordController,
// // // //       obscureText: _obscureText,
// // // //       decoration: InputDecoration(
// // // //         labelText: 'Password',
// // // //         prefixIcon: Icon(Icons.lock, color: Colors.purple[400]),
// // // //         suffixIcon: IconButton(
// // // //           icon: Icon(
// // // //             _obscureText ? Icons.visibility : Icons.visibility_off,
// // // //             color: Colors.purple[400],
// // // //           ),
// // // //           onPressed: () {
// // // //             setState(() {
// // // //               _obscureText = !_obscureText;
// // // //             });
// // // //           },
// // // //         ),
// // // //         border: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.grey[300]!),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // // //         ),
// // // //         filled: true,
// // // //         fillColor: Colors.grey[50],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //   import 'package:smart_road_app/Login/VehicleownerRegister.dart';
// // // import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// // // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:smart_road_app/services/google_auth_service.dart';

// // // class VehicleLoginPage extends StatefulWidget {
// // //   const VehicleLoginPage({super.key});

// // //   @override
// // //   _LoginPageState createState() => _LoginPageState();
// // // }

// // // class _LoginPageState extends State<VehicleLoginPage>
// // //     with SingleTickerProviderStateMixin {
// // //   late AnimationController _controller;
// // //   late Animation<double> _animation;
// // //   late Animation<Offset> _slideAnimation;

// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passwordController = TextEditingController();

// // //   bool _isLoading = false;
// // //   bool _obscureText = true;
// // //   String? _emailError;

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     _controller = AnimationController(
// // //       duration: const Duration(seconds: 2),
// // //       vsync: this,
// // //     );

// // //     _animation = Tween<double>(
// // //       begin: 0,
// // //       end: 1,
// // //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

// // //     _slideAnimation = Tween<Offset>(
// // //       begin: const Offset(0, 0.5),
// // //       end: Offset.zero,
// // //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

// // //     _controller.forward();

// // //     // Check if user is already logged in
// // //     _checkLoginStatus();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     _emailController.dispose();
// // //     _passwordController.dispose();
// // //     super.dispose();
// // //   }

// // //   // Check if user is already logged in
// // //   void _checkLoginStatus() async {
// // //     try {
// // //       print('🔍 Checking login status...');
// // //       bool isValidLogin = await AuthService.checkValidLogin();

// // //       if (isValidLogin) {
// // //         String? userEmail = await AuthService.getUserEmail();
// // //         print('✅ User already logged in: $userEmail');

// // //         // Auto-navigate to dashboard if already logged in
// // //         if (mounted) {
// // //           WidgetsBinding.instance.addPostFrameCallback((_) {
// // //             Navigator.pushAndRemoveUntil(
// // //               context,
// // //               MaterialPageRoute(
// // //                 builder: (context) => EnhancedVehicleDashboard(),
// // //               ),
// // //               (route) => false,
// // //             );
// // //           });
// // //         }
// // //       } else {
// // //         print('ℹ️ No valid login found, staying on login page');
// // //       }
// // //     } catch (e) {
// // //       print("❌ Error checking login status: $e");
// // //     }
// // //   }

// // //   // Google Sign-In method
// // //   Future<void> _signInWithGoogle() async {
// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     try {
// // //       final UserCredential? userCredential = await GoogleAuthService.signInWithGoogle();

// // //       if (userCredential != null && userCredential.user != null) {
// // //         // Save login data to shared preferences
// // //         await AuthService.saveLoginData(
// // //           email: userCredential.user!.email ?? '',
// // //           userId: userCredential.user!.uid,
// // //           userName: userCredential.user!.displayName,
// // //           role: 'vehicle_owner'
// // //         );

// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text("Google Sign-In successful"),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );

// // //           Navigator.pushAndRemoveUntil(
// // //             context,
// // //             MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// // //             (route) => false,
// // //           );
// // //         }
// // //       } else {
// // //         // User cancelled the sign-in
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text("Sign-In was cancelled"),
// // //               backgroundColor: Colors.orange,
// // //             ),
// // //           );
// // //         }
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text("Google Sign-In failed: ${e.toString()}"),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   void _login() async {
// // //     // Clear previous errors
// // //     setState(() {
// // //       _emailError = null;
// // //     });

// // //     // Validate inputs
// // //     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text("Please enter email and password"),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     // Email validation
// // //     final email = _emailController.text.trim();
// // //     if (!_isValidEmail(email)) {
// // //       setState(() {
// // //         _emailError = "Please enter a valid email address";
// // //       });
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     try {
// // //       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
// // //         email: email,
// // //         password: _passwordController.text.trim(),
// // //       );

// // //       // Save login data to shared preferences
// // //       await AuthService.saveLoginData(
// // //         email: email,
// // //         userId: userCredential.user!.uid,
// // //         userName: userCredential.user!.displayName,
// // //         role: 'vehicle_owner'
// // //       );

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text("Sign in successful"),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );

// // //         Navigator.pushAndRemoveUntil(
// // //           context,
// // //           MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// // //           (route) => false,
// // //         );
// // //       }
// // //     } on FirebaseAuthException catch (e) {
// // //       String errorMessage = "An error occurred during sign in";

// // //       if (e.code == 'user-not-found') {
// // //         errorMessage = "No user found for that email.";
// // //       } else if (e.code == 'wrong-password') {
// // //         errorMessage = "Wrong password provided.";
// // //       } else if (e.code == 'invalid-email') {
// // //         setState(() {
// // //           _emailError = "Invalid email address format.";
// // //         });
// // //         errorMessage = "Invalid email address format.";
// // //       } else if (e.code == 'user-disabled') {
// // //         errorMessage = "This user account has been disabled.";
// // //       } else if (e.code == 'too-many-requests') {
// // //         errorMessage = "Too many attempts. Please try again later.";
// // //       } else if (e.code == 'network-request-failed') {
// // //         errorMessage = "Network error. Please check your internet connection.";
// // //       }

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text("An unexpected error occurred. Please try again."),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   bool _isValidEmail(String email) {
// // //     final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
// // //     return emailRegex.hasMatch(email);
// // //   }

// // //   void _resetPassword() async {
// // //     // Clear previous errors
// // //     setState(() {
// // //       _emailError = null;
// // //     });

// // //     final email = _emailController.text.trim();
    
// // //     if (email.isEmpty) {
// // //       setState(() {
// // //         _emailError = "Please enter your email address";
// // //       });
// // //       return;
// // //     }

// // //     if (!_isValidEmail(email)) {
// // //       setState(() {
// // //         _emailError = "Please enter a valid email address";
// // //       });
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     try {
// // //       await FirebaseAuth.instance.sendPasswordResetEmail(
// // //         email: email,
// // //       );

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text("Password reset email sent! Check your inbox."),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       }
// // //     } on FirebaseAuthException catch (e) {
// // //       String errorMessage = "Failed to send reset email";

// // //       if (e.code == 'user-not-found') {
// // //         setState(() {
// // //           _emailError = "No user found with this email address.";
// // //         });
// // //         errorMessage = "No user found with this email address.";
// // //       } else if (e.code == 'invalid-email') {
// // //         setState(() {
// // //           _emailError = "Invalid email address format.";
// // //         });
// // //         errorMessage = "Invalid email address format.";
// // //       }

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text("Failed to send reset email. Please try again."),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   void _onEmailChanged(String value) {
// // //     // Clear error when user starts typing
// // //     if (_emailError != null) {
// // //       setState(() {
// // //         _emailError = null;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return WillPopScope(
// // //       onWillPop: () async {
// // //         // Navigate back to role selection instead of exiting app
// // //         Navigator.of(context).pop();
// // //         return false;
// // //       },
// // //       child: Scaffold(
// // //         backgroundColor: Colors.grey[50],
// // //         body: SingleChildScrollView(
// // //           child: SizedBox(
// // //             height: MediaQuery.of(context).size.height,
// // //             child: Stack(
// // //               children: [
// // //                 // Background with gradient
// // //                 Container(
// // //                   height: MediaQuery.of(context).size.height * 0.4,
// // //                   decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [Colors.purple[800]!, Colors.purple[600]!],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                     borderRadius: const BorderRadius.only(
// // //                       bottomLeft: Radius.circular(40),
// // //                       bottomRight: Radius.circular(40),
// // //                     ),
// // //                   ),
// // //                 ),

// // //                 // Animated content
// // //                 FadeTransition(
// // //                   opacity: _animation,
// // //                   child: SlideTransition(
// // //                     position: _slideAnimation,
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.all(24.0),
// // //                       child: Column(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           const SizedBox(height: 80),

// // //                           // Logo and Title
// // //                           Container(
// // //                             padding: const EdgeInsets.all(16),
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.white,
// // //                               shape: BoxShape.circle,
// // //                               boxShadow: [
// // //                                 BoxShadow(
// // //                                   color: Colors.purple.withOpacity(0.2),
// // //                                   blurRadius: 15,
// // //                                   offset: const Offset(0, 5),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             child: Icon(
// // //                               Icons.directions_car,
// // //                               size: 40,
// // //                               color: Colors.purple[700],
// // //                             ),
// // //                           ),

// // //                           const SizedBox(height: 20),

// // //                           Text(
// // //                             'Owner Login',
// // //                             style: TextStyle(
// // //                               fontSize: 28,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.white,
// // //                             ),
// // //                           ),

// // //                           const SizedBox(height: 8),

// // //                           Text(
// // //                             'Access your vehicle services',
// // //                             style: TextStyle(
// // //                               color: Colors.white.withOpacity(0.9),
// // //                               fontSize: 16,
// // //                             ),
// // //                           ),

// // //                           const SizedBox(height: 40),

// // //                           // Login Card
// // //                           Card(
// // //                             elevation: 8,
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(20),
// // //                             ),
// // //                             child: Padding(
// // //                               padding: const EdgeInsets.all(24),
// // //                               child: Column(
// // //                                 children: [
// // //                                   // Email Field
// // //                                   _buildEmailField(),

// // //                                   const SizedBox(height: 20),

// // //                                   // Password Field
// // //                                   _buildPasswordField(),

// // //                                   const SizedBox(height: 10),

// // //                                   // Forgot Password
// // //                                   Align(
// // //                                     alignment: Alignment.centerRight,
// // //                                     child: TextButton(
// // //                                       onPressed: _isLoading
// // //                                           ? null
// // //                                           : _resetPassword,
// // //                                       child: Text(
// // //                                         'Forgot Password?',
// // //                                         style: TextStyle(
// // //                                           color: Colors.purple[600],
// // //                                           fontWeight: FontWeight.w500,
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   ),

// // //                                   const SizedBox(height: 20),

// // //                                   // Login Button
// // //                                   SizedBox(
// // //                                     width: double.infinity,
// // //                                     height: 50,
// // //                                     child: ElevatedButton(
// // //                                       onPressed: _isLoading ? null : _login,
// // //                                       style: ElevatedButton.styleFrom(
// // //                                         backgroundColor: Colors.purple[600],
// // //                                         shape: RoundedRectangleBorder(
// // //                                           borderRadius: BorderRadius.circular(
// // //                                             12,
// // //                                           ),
// // //                                         ),
// // //                                         elevation: 3,
// // //                                       ),
// // //                                       child: _isLoading
// // //                                           ? const SizedBox(
// // //                                               height: 20,
// // //                                               width: 20,
// // //                                               child: CircularProgressIndicator(
// // //                                                 strokeWidth: 2,
// // //                                                 valueColor:
// // //                                                     AlwaysStoppedAnimation<
// // //                                                       Color
// // //                                                     >(Colors.white),
// // //                                               ),
// // //                                             )
// // //                                           : const Text(
// // //                                               'LOGIN',
// // //                                               style: TextStyle(
// // //                                                 fontSize: 16,
// // //                                                 fontWeight: FontWeight.bold,
// // //                                                 color: Colors.white,
// // //                                               ),
// // //                                             ),
// // //                                     ),
// // //                                   ),

// // //                                   const SizedBox(height: 20),

// // //                                   // Divider with "OR"
// // //                                   Row(
// // //                                     children: [
// // //                                       Expanded(child: Divider()),
// // //                                       Padding(
// // //                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // //                                         child: Text(
// // //                                           'OR',
// // //                                           style: TextStyle(
// // //                                             color: Colors.grey[600],
// // //                                             fontWeight: FontWeight.w500,
// // //                                           ),
// // //                                         ),
// // //                                       ),
// // //                                       Expanded(child: Divider()),
// // //                                     ],
// // //                                   ),

// // //                                   const SizedBox(height: 20),

// // //                                   // Google Sign-In Button
// // //                                   SizedBox(
// // //                                     width: double.infinity,
// // //                                     height: 50,
// // //                                     child: OutlinedButton.icon(
// // //                                       onPressed: _isLoading ? null : _signInWithGoogle,
// // //                                       icon: Image.network(
// // //                                         'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
// // //                                         height: 24,
// // //                                         width: 24,
// // //                                         errorBuilder: (context, error, stackTrace) {
// // //                                           return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
// // //                                         },
// // //                                       ),
// // //                                       label: Text(
// // //                                         'Continue with Google',
// // //                                         style: TextStyle(
// // //                                           fontSize: 16,
// // //                                           fontWeight: FontWeight.w600,
// // //                                           color: Colors.grey[800],
// // //                                         ),
// // //                                       ),
// // //                                       style: OutlinedButton.styleFrom(
// // //                                         side: BorderSide(color: Colors.grey[300]!),
// // //                                         shape: RoundedRectangleBorder(
// // //                                           borderRadius: BorderRadius.circular(12),
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   ),

// // //                                   const SizedBox(height: 20),

// // //                                   // Register Link
// // //                                   Row(
// // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // //                                     children: [
// // //                                       Text(
// // //                                         "Don't have an account? ",
// // //                                         style: TextStyle(
// // //                                           color: Colors.grey[600],
// // //                                         ),
// // //                                       ),
// // //                                       GestureDetector(
// // //                                         onTap: _isLoading
// // //                                             ? null
// // //                                             : () {
// // //                                                 Navigator.of(context).push(
// // //                                                   MaterialPageRoute(
// // //                                                     builder: (context) =>
// // //                                                         const RegistrationPage(),
// // //                                                   ),
// // //                                                 );
// // //                                               },
// // //                                         child: Text(
// // //                                           'Register',
// // //                                           style: TextStyle(
// // //                                             color: Colors.purple[600],
// // //                                             fontWeight: FontWeight.bold,
// // //                                           ),
// // //                                         ),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmailField() {
// // //     return TextField(
// // //       controller: _emailController,
// // //       keyboardType: TextInputType.emailAddress,
// // //       onChanged: _onEmailChanged,
// // //       decoration: InputDecoration(
// // //         labelText: 'Email',
// // //         prefixIcon: Icon(Icons.email, color: Colors.purple[400]),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.grey[300]!),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// // //         ),
// // //         errorText: _emailError,
// // //         errorBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: const BorderSide(color: Colors.red, width: 1),
// // //         ),
// // //         focusedErrorBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: const BorderSide(color: Colors.red, width: 2),
// // //         ),
// // //         filled: true,
// // //         fillColor: Colors.grey[50],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildPasswordField() {
// // //     return TextField(
// // //       controller: _passwordController,
// // //       obscureText: _obscureText,
// // //       decoration: InputDecoration(
// // //         labelText: 'Password',
// // //         prefixIcon: Icon(Icons.lock, color: Colors.purple[400]),
// // //         suffixIcon: IconButton(
// // //           icon: Icon(
// // //             _obscureText ? Icons.visibility : Icons.visibility_off,
// // //             color: Colors.purple[400],
// // //           ),
// // //           onPressed: () {
// // //             setState(() {
// // //               _obscureText = !_obscureText;
// // //             });
// // //           },
// // //         ),
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
// // // }  


// // import 'package:smart_road_app/Login/VehicleownerRegister.dart';
// // import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// // import 'package:smart_road_app/controller/sharedprefrence.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:smart_road_app/services/google_auth_service.dart';

// // class VehicleLoginPage extends StatefulWidget {
// //   const VehicleLoginPage({super.key});

// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<VehicleLoginPage>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;
// //   late Animation<Offset> _slideAnimation;

// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   bool _isLoading = false;
// //   bool _obscureText = true;
// //   String? _emailError;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       duration: const Duration(seconds: 2),
// //       vsync: this,
// //     );

// //     _animation = Tween<double>(
// //       begin: 0,
// //       end: 1,
// //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

// //     _slideAnimation = Tween<Offset>(
// //       begin: const Offset(0, 0.5),
// //       end: Offset.zero,
// //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

// //     _controller.forward();

// //     // Check if user is already logged in
// //     _checkLoginStatus();
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   // Check if user is already logged in
// //   void _checkLoginStatus() async {
// //     try {
// //       print('🔍 Checking login status...');
// //       bool isValidLogin = await AuthService.checkValidLogin();

// //       if (isValidLogin) {
// //         String? userEmail = await AuthService.getUserEmail();
// //         print('✅ User already logged in: $userEmail');

// //         // Auto-navigate to dashboard if already logged in
// //         if (mounted) {
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             Navigator.pushAndRemoveUntil(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => EnhancedVehicleDashboard(),
// //               ),
// //               (route) => false,
// //             );
// //           });
// //         }
// //       } else {
// //         print('ℹ️ No valid login found, staying on login page');
// //       }
// //     } catch (e) {
// //       print("❌ Error checking login status: $e");
// //     }
// //   }

// //   // Google Sign-In method
// //   Future<void> _signInWithGoogle() async {
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       final UserCredential? userCredential = await GoogleAuthService.signInWithGoogle();

// //       if (userCredential != null && userCredential.user != null) {
// //         // Save login data to shared preferences - FIXED
// //         await AuthService.saveLoginData(
// //           email: userCredential.user!.email ?? '',
// //           userId: userCredential.user!.uid,
// //           userName: userCredential.user!.displayName ?? 'User',
// //           role: 'vehicle_owner'
// //         );

// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Google Sign-In successful"),
// //               backgroundColor: Colors.green,
// //             ),
// //           );

// //           Navigator.pushAndRemoveUntil(
// //             context,
// //             MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// //             (route) => false,
// //           );
// //         }
// //       } else {
// //         // User cancelled the sign-in
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Sign-In was cancelled"),
// //               backgroundColor: Colors.orange,
// //             ),
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Google Sign-In failed: ${e.toString()}"),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   void _login() async {
// //     // Clear previous errors
// //     setState(() {
// //       _emailError = null;
// //     });

// //     // Validate inputs
// //     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Please enter email and password"),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     // Email validation
// //     final email = _emailController.text.trim();
// //     if (!_isValidEmail(email)) {
// //       setState(() {
// //         _emailError = "Please enter a valid email address";
// //       });
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
// //         email: email,
// //         password: _passwordController.text.trim(),
// //       );

// //       // Save login data to shared preferences - FIXED
// //       await AuthService.saveLoginData(
// //         email: email,
// //         userId: userCredential.user!.uid,
// //         userName: userCredential.user!.displayName ?? 'User',
// //         role: 'vehicle_owner'
// //       );

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("Sign in successful"),
// //             backgroundColor: Colors.green,
// //           ),
// //         );

// //         Navigator.pushAndRemoveUntil(
// //           context,
// //           MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
// //           (route) => false,
// //         );
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       String errorMessage = "An error occurred during sign in";

// //       if (e.code == 'user-not-found') {
// //         errorMessage = "No user found for that email.";
// //       } else if (e.code == 'wrong-password') {
// //         errorMessage = "Wrong password provided.";
// //       } else if (e.code == 'invalid-email') {
// //         setState(() {
// //           _emailError = "Invalid email address format.";
// //         });
// //         errorMessage = "Invalid email address format.";
// //       } else if (e.code == 'user-disabled') {
// //         errorMessage = "This user account has been disabled.";
// //       } else if (e.code == 'too-many-requests') {
// //         errorMessage = "Too many attempts. Please try again later.";
// //       } else if (e.code == 'network-request-failed') {
// //         errorMessage = "Network error. Please check your internet connection.";
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("An unexpected error occurred. Please try again."),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   bool _isValidEmail(String email) {
// //     final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
// //     return emailRegex.hasMatch(email);
// //   }

// //   void _resetPassword() async {
// //     // Clear previous errors
// //     setState(() {
// //       _emailError = null;
// //     });

// //     final email = _emailController.text.trim();
    
// //     if (email.isEmpty) {
// //       setState(() {
// //         _emailError = "Please enter your email address";
// //       });
// //       return;
// //     }

// //     if (!_isValidEmail(email)) {
// //       setState(() {
// //         _emailError = "Please enter a valid email address";
// //       });
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       await FirebaseAuth.instance.sendPasswordResetEmail(
// //         email: email,
// //       );

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("Password reset email sent! Check your inbox."),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       String errorMessage = "Failed to send reset email";

// //       if (e.code == 'user-not-found') {
// //         setState(() {
// //           _emailError = "No user found with this email address.";
// //         });
// //         errorMessage = "No user found with this email address.";
// //       } else if (e.code == 'invalid-email') {
// //         setState(() {
// //           _emailError = "Invalid email address format.";
// //         });
// //         errorMessage = "Invalid email address format.";
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("Failed to send reset email. Please try again."),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   void _onEmailChanged(String value) {
// //     // Clear error when user starts typing
// //     if (_emailError != null) {
// //       setState(() {
// //         _emailError = null;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         // Navigate back to role selection instead of exiting app
// //         Navigator.of(context).pop();
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: Colors.grey[50],
// //         body: SingleChildScrollView(
// //           child: SizedBox(
// //             height: MediaQuery.of(context).size.height,
// //             child: Stack(
// //               children: [
// //                 // Background with gradient
// //                 Container(
// //                   height: MediaQuery.of(context).size.height * 0.4,
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [Colors.purple[800]!, Colors.purple[600]!],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                     borderRadius: const BorderRadius.only(
// //                       bottomLeft: Radius.circular(40),
// //                       bottomRight: Radius.circular(40),
// //                     ),
// //                   ),
// //                 ),

// //                 // Animated content
// //                 FadeTransition(
// //                   opacity: _animation,
// //                   child: SlideTransition(
// //                     position: _slideAnimation,
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(24.0),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           const SizedBox(height: 80),

// //                           // Logo and Title
// //                           Container(
// //                             padding: const EdgeInsets.all(16),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.purple.withOpacity(0.2),
// //                                   blurRadius: 15,
// //                                   offset: const Offset(0, 5),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Icon(
// //                               Icons.directions_car,
// //                               size: 40,
// //                               color: Colors.purple[700],
// //                             ),
// //                           ),

// //                           const SizedBox(height: 20),

// //                           Text(
// //                             'Owner Login',
// //                             style: TextStyle(
// //                               fontSize: 28,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                             ),
// //                           ),

// //                           const SizedBox(height: 8),

// //                           Text(
// //                             'Access your vehicle services',
// //                             style: TextStyle(
// //                               color: Colors.white.withOpacity(0.9),
// //                               fontSize: 16,
// //                             ),
// //                           ),

// //                           const SizedBox(height: 40),

// //                           // Login Card
// //                           Card(
// //                             elevation: 8,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(20),
// //                             ),
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(24),
// //                               child: Column(
// //                                 children: [
// //                                   // Email Field
// //                                   _buildEmailField(),

// //                                   const SizedBox(height: 20),

// //                                   // Password Field
// //                                   _buildPasswordField(),

// //                                   const SizedBox(height: 10),

// //                                   // Forgot Password
// //                                   Align(
// //                                     alignment: Alignment.centerRight,
// //                                     child: TextButton(
// //                                       onPressed: _isLoading
// //                                           ? null
// //                                           : _resetPassword,
// //                                       child: Text(
// //                                         'Forgot Password?',
// //                                         style: TextStyle(
// //                                           color: Colors.purple[600],
// //                                           fontWeight: FontWeight.w500,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),

// //                                   const SizedBox(height: 20),

// //                                   // Login Button
// //                                   SizedBox(
// //                                     width: double.infinity,
// //                                     height: 50,
// //                                     child: ElevatedButton(
// //                                       onPressed: _isLoading ? null : _login,
// //                                       style: ElevatedButton.styleFrom(
// //                                         backgroundColor: Colors.purple[600],
// //                                         shape: RoundedRectangleBorder(
// //                                           borderRadius: BorderRadius.circular(
// //                                             12,
// //                                           ),
// //                                         ),
// //                                         elevation: 3,
// //                                       ),
// //                                       child: _isLoading
// //                                           ? const SizedBox(
// //                                               height: 20,
// //                                               width: 20,
// //                                               child: CircularProgressIndicator(
// //                                                 strokeWidth: 2,
// //                                                 valueColor:
// //                                                     AlwaysStoppedAnimation<
// //                                                       Color
// //                                                     >(Colors.white),
// //                                               ),
// //                                             )
// //                                           : const Text(
// //                                               'LOGIN',
// //                                               style: TextStyle(
// //                                                 fontSize: 16,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.white,
// //                                               ),
// //                                             ),
// //                                     ),
// //                                   ),

// //                                   const SizedBox(height: 20),

// //                                   // Divider with "OR"
// //                                   Row(
// //                                     children: [
// //                                       Expanded(child: Divider()),
// //                                       Padding(
// //                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                                         child: Text(
// //                                           'OR',
// //                                           style: TextStyle(
// //                                             color: Colors.grey[600],
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       Expanded(child: Divider()),
// //                                     ],
// //                                   ),

// //                                   const SizedBox(height: 20),

// //                                   // Google Sign-In Button
// //                                   SizedBox(
// //                                     width: double.infinity,
// //                                     height: 50,
// //                                     child: OutlinedButton.icon(
// //                                       onPressed: _isLoading ? null : _signInWithGoogle,
// //                                       icon: Image.network(
// //                                         'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
// //                                         height: 24,
// //                                         width: 24,
// //                                         errorBuilder: (context, error, stackTrace) {
// //                                           return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
// //                                         },
// //                                       ),
// //                                       label: Text(
// //                                         'Continue with Google',
// //                                         style: TextStyle(
// //                                           fontSize: 16,
// //                                           fontWeight: FontWeight.w600,
// //                                           color: Colors.grey[800],
// //                                         ),
// //                                       ),
// //                                       style: OutlinedButton.styleFrom(
// //                                         side: BorderSide(color: Colors.grey[300]!),
// //                                         shape: RoundedRectangleBorder(
// //                                           borderRadius: BorderRadius.circular(12),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),

// //                                   const SizedBox(height: 20),

// //                                   // Register Link
// //                                   Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       Text(
// //                                         "Don't have an account? ",
// //                                         style: TextStyle(
// //                                           color: Colors.grey[600],
// //                                         ),
// //                                       ),
// //                                       GestureDetector(
// //                                         onTap: _isLoading
// //                                             ? null
// //                                             : () {
// //                                                 Navigator.of(context).push(
// //                                                   MaterialPageRoute(
// //                                                     builder: (context) =>
// //                                                         const RegistrationPage(),
// //                                                   ),
// //                                                 );
// //                                               },
// //                                         child: Text(
// //                                           'Register',
// //                                           style: TextStyle(
// //                                             color: Colors.purple[600],
// //                                             fontWeight: FontWeight.bold,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmailField() {
// //     return TextField(
// //       controller: _emailController,
// //       keyboardType: TextInputType.emailAddress,
// //       onChanged: _onEmailChanged,
// //       decoration: InputDecoration(
// //         labelText: 'Email',
// //         prefixIcon: Icon(Icons.email, color: Colors.purple[400]),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey[300]!),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
// //         ),
// //         errorText: _emailError,
// //         errorBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: Colors.red, width: 1),
// //         ),
// //         focusedErrorBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: Colors.red, width: 2),
// //         ),
// //         filled: true,
// //         fillColor: Colors.grey[50],
// //       ),
// //     );
// //   }

// //   Widget _buildPasswordField() {
// //     return TextField(
// //       controller: _passwordController,
// //       obscureText: _obscureText,
// //       decoration: InputDecoration(
// //         labelText: 'Password',
// //         prefixIcon: Icon(Icons.lock, color: Colors.purple[400]),
// //         suffixIcon: IconButton(
// //           icon: Icon(
// //             _obscureText ? Icons.visibility : Icons.visibility_off,
// //             color: Colors.purple[400],
// //           ),
// //           onPressed: () {
// //             setState(() {
// //               _obscureText = !_obscureText;
// //             });
// //           },
// //         ),
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
// // } 

// import 'package:smart_road_app/Login/VehicleownerRegister.dart';
// import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
// import 'package:smart_road_app/controller/sharedprefrence.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_road_app/services/google_auth_service.dart';

// class VehicleLoginPage extends StatefulWidget {
//   const VehicleLoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<VehicleLoginPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late Animation<Offset> _slideAnimation;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscureText = true;
//   String? _emailError;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     _animation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     _controller.forward();

//     // Check if user is already logged in
//     _checkLoginStatus();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Check if user is already logged in
//   void _checkLoginStatus() async {
//     try {
//       print('🔍 Checking login status...');
//       bool isValidLogin = await AuthService.checkValidLogin();

//       if (isValidLogin) {
//         String? userEmail = await AuthService.getUserEmail();
//         print('✅ User already logged in: $userEmail');

//         // Auto-navigate to dashboard if already logged in
//         if (mounted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EnhancedVehicleDashboard(),
//               ),
//               (route) => false,
//             );
//           });
//         }
//       } else {
//         print('ℹ️ No valid login found, staying on login page');
//       }
//     } catch (e) {
//       print("❌ Error checking login status: $e");
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
//         // FIXED: Save login data to shared preferences
//         await AuthService.saveLoginData(
//           email: userCredential.user!.email ?? '',
//           role: 'vehicle_owner',
//           userId: userCredential.user!.uid,
//           userName: userCredential.user!.displayName ?? 'User',
//         );

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Google Sign-In successful"),
//               backgroundColor: Colors.green,
//             ),
//           );

//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
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

//   void _login() async {
//     // Clear previous errors
//     setState(() {
//       _emailError = null;
//     });

//     // Validate inputs
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please enter email and password"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Email validation
//     final email = _emailController.text.trim();
//     if (!_isValidEmail(email)) {
//       setState(() {
//         _emailError = "Please enter a valid email address";
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: _passwordController.text.trim(),
//       );

//       // FIXED: Save login data to shared preferences
//       await AuthService.saveLoginData(
//         email: email,
//         role: 'vehicle_owner',
//         userId: userCredential.user!.uid,
//         userName: userCredential.user!.displayName ?? 'User',
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Sign in successful"),
//             backgroundColor: Colors.green,
//           ),
//         );

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
//           (route) => false,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "An error occurred during sign in";

//       if (e.code == 'user-not-found') {
//         errorMessage = "No user found for that email.";
//       } else if (e.code == 'wrong-password') {
//         errorMessage = "Wrong password provided.";
//       } else if (e.code == 'invalid-email') {
//         setState(() {
//           _emailError = "Invalid email address format.";
//         });
//         errorMessage = "Invalid email address format.";
//       } else if (e.code == 'user-disabled') {
//         errorMessage = "This user account has been disabled.";
//       } else if (e.code == 'too-many-requests') {
//         errorMessage = "Too many attempts. Please try again later.";
//       } else if (e.code == 'network-request-failed') {
//         errorMessage = "Network error. Please check your internet connection.";
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("An unexpected error occurred. Please try again."),
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

//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//     return emailRegex.hasMatch(email);
//   }

//   void _resetPassword() async {
//     // Clear previous errors
//     setState(() {
//       _emailError = null;
//     });

//     final email = _emailController.text.trim();
    
//     if (email.isEmpty) {
//       setState(() {
//         _emailError = "Please enter your email address";
//       });
//       return;
//     }

//     if (!_isValidEmail(email)) {
//       setState(() {
//         _emailError = "Please enter a valid email address";
//       });
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
//         setState(() {
//           _emailError = "No user found with this email address.";
//         });
//         errorMessage = "No user found with this email address.";
//       } else if (e.code == 'invalid-email') {
//         setState(() {
//           _emailError = "Invalid email address format.";
//         });
//         errorMessage = "Invalid email address format.";
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

//   void _onEmailChanged(String value) {
//     // Clear error when user starts typing
//     if (_emailError != null) {
//       setState(() {
//         _emailError = null;
//       });
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
//                 // Background with gradient
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.purple[800]!, Colors.purple[600]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),

//                 // Animated content
//                 FadeTransition(
//                   opacity: _animation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 80),

//                           // Logo and Title
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.purple.withOpacity(0.2),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.directions_car,
//                               size: 40,
//                               color: Colors.purple[700],
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           Text(
//                             'Owner Login',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),

//                           const SizedBox(height: 8),

//                           Text(
//                             'Access your vehicle services',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 16,
//                             ),
//                           ),

//                           const SizedBox(height: 40),

//                           // Login Card
//                           Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(24),
//                               child: Column(
//                                 children: [
//                                   // Email Field
//                                   _buildEmailField(),

//                                   const SizedBox(height: 20),

//                                   // Password Field
//                                   _buildPasswordField(),

//                                   const SizedBox(height: 10),

//                                   // Forgot Password
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: _isLoading
//                                           ? null
//                                           : _resetPassword,
//                                       child: Text(
//                                         'Forgot Password?',
//                                         style: TextStyle(
//                                           color: Colors.purple[600],
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   const SizedBox(height: 20),

//                                   // Login Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 50,
//                                     child: ElevatedButton(
//                                       onPressed: _isLoading ? null : _login,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.purple[600],
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                         elevation: 3,
//                                       ),
//                                       child: _isLoading
//                                           ? const SizedBox(
//                                               height: 20,
//                                               width: 20,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                                 valueColor:
//                                                     AlwaysStoppedAnimation<
//                                                       Color
//                                                     >(Colors.white),
//                                               ),
//                                             )
//                                           : const Text(
//                                               'LOGIN',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                     ),
//                                   ),

//                                   const SizedBox(height: 20),

//                                   // Divider with "OR"
//                                   Row(
//                                     children: [
//                                       Expanded(child: Divider()),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                         child: Text(
//                                           'OR',
//                                           style: TextStyle(
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(child: Divider()),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 20),

//                                   // Google Sign-In Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 50,
//                                     child: OutlinedButton.icon(
//                                       onPressed: _isLoading ? null : _signInWithGoogle,
//                                       icon: Image.network(
//                                         'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
//                                         height: 24,
//                                         width: 24,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Icon(Icons.g_mobiledata, size: 24, color: Colors.red[600]);
//                                         },
//                                       ),
//                                       label: Text(
//                                         'Continue with Google',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.grey[800],
//                                         ),
//                                       ),
//                                       style: OutlinedButton.styleFrom(
//                                         side: BorderSide(color: Colors.grey[300]!),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   const SizedBox(height: 20),

//                                   // Register Link
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Don't have an account? ",
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: _isLoading
//                                             ? null
//                                             : () {
//                                                 Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         const RegistrationPage(),
//                                                   ),
//                                                 );
//                                               },
//                                         child: Text(
//                                           'Register',
//                                           style: TextStyle(
//                                             color: Colors.purple[600],
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailField() {
//     return TextField(
//       controller: _emailController,
//       keyboardType: TextInputType.emailAddress,
//       onChanged: _onEmailChanged,
//       decoration: InputDecoration(
//         labelText: 'Email',
//         prefixIcon: Icon(Icons.email, color: Colors.purple[400]),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
//         ),
//         errorText: _emailError,
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
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
//         prefixIcon: Icon(Icons.lock, color: Colors.purple[400]),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _obscureText ? Icons.visibility : Icons.visibility_off,
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


import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/Login/VehicleownerRegister.dart';
import 'package:smart_road_app/VehicleOwner/OwnerDashboard.dart';
import 'package:smart_road_app/controller/sharedprefrence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_road_app/services/google_auth_service.dart';

class VehicleLoginPage extends StatefulWidget {
  const VehicleLoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<VehicleLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _emailError;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Check if user is already logged in
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check if user is already logged in
  void _checkLoginStatus() async {
    try {
      print('🔍 Checking login status...');
      bool isValidLogin = await AuthService.checkValidLogin();

      if (isValidLogin) {
        String? userEmail = await AuthService.getUserEmail();
        print('✅ User already logged in: $userEmail');

        // Auto-navigate to dashboard if already logged in
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => EnhancedVehicleDashboard(),
              ),
              (route) => false,
            );
          });
        }
      } else {
        print('ℹ️ No valid login found, staying on login page');
      }
    } catch (e) {
      print("❌ Error checking login status: $e");
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
        // FIXED: Save login data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', userCredential.user!.email ?? '');
        await prefs.setString('userRole', 'vehicle_owner');
        await prefs.setString('userId', userCredential.user!.uid);
        await prefs.setString('userName', userCredential.user!.displayName ?? 'User');
        await prefs.setString('loginTime', DateTime.now().toIso8601String());
        print('✅ Login data saved successfully for: ${userCredential.user!.email}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Google Sign-In successful"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
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

  void _login() async {
    // Clear previous errors
    setState(() {
      _emailError = null;
    });

    // Validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Email validation
    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      // FIXED: Save login data directly to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userRole', 'vehicle_owner');
      await prefs.setString('userId', userCredential.user!.uid);
      await prefs.setString('userName', userCredential.user!.displayName ?? 'User');
      await prefs.setString('loginTime', DateTime.now().toIso8601String());
      print('✅ Login data saved successfully for: $email');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign in successful"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EnhancedVehicleDashboard()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred during sign in";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        setState(() {
          _emailError = "Invalid email address format.";
        });
        errorMessage = "Invalid email address format.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This user account has been disabled.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many attempts. Please try again later.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Network error. Please check your internet connection.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred. Please try again."),
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _resetPassword() async {
    // Clear previous errors
    setState(() {
      _emailError = null;
    });

    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _emailError = "Please enter your email address";
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
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
        setState(() {
          _emailError = "No user found with this email address.";
        });
        errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        setState(() {
          _emailError = "Invalid email address format.";
        });
        errorMessage = "Invalid email address format.";
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

  void _onEmailChanged(String value) {
    // Clear error when user starts typing
    if (_emailError != null) {
      setState(() {
        _emailError = null;
      });
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
                // Background with gradient
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[800]!, Colors.purple[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // Animated content
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
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
                                  color: Colors.purple.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.directions_car,
                              size: 40,
                              color: Colors.purple[700],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'Owner Login',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Access your vehicle services',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 40),

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
                                  _buildEmailField(),

                                  const SizedBox(height: 20),

                                  // Password Field
                                  _buildPasswordField(),

                                  const SizedBox(height: 10),

                                  // Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _resetPassword,
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.purple[600],
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
                                        backgroundColor: Colors.purple[600],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 3,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'LOGIN',
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

                                  const SizedBox(height: 20),

                                  // Register Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _isLoading
                                            ? null
                                            : () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegistrationPage(),
                                                  ),
                                                );
                                              },
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                            color: Colors.purple[600],
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: _onEmailChanged,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email, color: Colors.purple[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
        ),
        errorText: _emailError,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
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
        prefixIcon: Icon(Icons.lock, color: Colors.purple[400]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
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