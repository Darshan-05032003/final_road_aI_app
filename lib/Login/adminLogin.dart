// import 'package:smart_road_app/Login/adminRegister.dart';
// import 'package:smart_road_app/admin/adminDashbord.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AdminLoginPage extends StatefulWidget {
//   const AdminLoginPage({super.key});

//   @override
//   _AdminLoginPageState createState() => _AdminLoginPageState();
// }

// class _AdminLoginPageState extends State<AdminLoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final bool _isLoading = false;
//   bool _obscureText = true;

//   void _login() async {
//     try {
//                         await FirebaseAuth.instance.signInWithEmailAndPassword(
//                           email: _emailController.text.trim(),
//                           password: _passwordController.text.trim(),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Sign in successful")),
//                         );
//                       } catch (e) {
//                         ScaffoldMessenger.of(
//                           context,
//                         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//                       }
//     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VehicleAssistAdminApp()));
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
//               height: 300,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.purple[900]!, Colors.purple[700]!],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(50),
//                   bottomRight: Radius.circular(50),
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.admin_panel_settings,
//                       size: 80,
//                       color: Colors.white,
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Admin Portal',
//                       style: TextStyle(
//                         fontSize: 32,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'System Administration',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Login Form
//             Padding(
//               padding: EdgeInsets.all(30),
//               child: Column(
//                 children: [
//                   // Username Field
//                   TextField(
//                     controller: _usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Admin Username',
//                       prefixIcon: Icon(Icons.person, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 20),
//                    TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Admin Username',
//                       prefixIcon: Icon(Icons.person, color: Colors.purple),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 20),

//                   // Password Field
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: _obscureText,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: Icon(Icons.lock, color: Colors.purple),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureText ? Icons.visibility : Icons.visibility_off,
//                           color: Colors.purple,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple[800],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'ADMIN LOGIN',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),

//                   SizedBox(height: 20),

//                   // Security Note
//                   Container(
//                     padding: EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.purple[50],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.security, color: Colors.purple, size: 20),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             'Restricted access. Authorized personnel only.',
//                             style: TextStyle(
//                               color: Colors.purple[700],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                             // Register Link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Don't have a account? ",
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminRegistrationPage()));
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
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:smart_road_app/Login/adminRegister.dart';
import 'package:smart_road_app/admin/adminDashbord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/services/google_auth_service.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  // SharedPreferences keys
  static const String _isLoggedInKey = 'adminIsLoggedIn';
  static const String _userEmailKey = 'adminUserEmail';

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
        // Auto-navigate to admin dashboard if already logged in
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => VehicleAssistAdminApp()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error checking admin login status: $e');
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      print('Error saving admin login state: $e');
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
      print('Error during admin logout: $e');
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
        MaterialPageRoute(builder: (context) => VehicleAssistAdminApp()),
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
            MaterialPageRoute(builder: (context) => VehicleAssistAdminApp()),
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[900]!, Colors.purple[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Admin Portal',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'System Administration',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              // Login Form
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Admin Username',
                        prefixIcon: Icon(Icons.person, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Admin Email',
                        prefixIcon: Icon(Icons.email, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
                        prefixIcon: Icon(Icons.lock, color: Colors.purple),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'ADMIN LOGIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Security Note
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.security, color: Colors.purple, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Restricted access. Authorized personnel only.',
                              style: TextStyle(
                                color: Colors.purple[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have a account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminRegistrationPage(),
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
            ],
          ),
        ),
      ),
    );
  }
}
