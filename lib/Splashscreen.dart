import 'dart:math';

import 'package:smart_road_app/Roleselection.dart';
import 'package:smart_road_app/screens/onboarding/welcome_screen.dart';
import 'package:smart_road_app/services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation for the main logo
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Fade animation for elements
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Slide animation for text
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
          ),
        );

    // Color animation for background gradient
    _colorAnimation = ColorTween(
      begin: const Color(0xFF6A11CB),
      end: const Color(0xFF2575FC),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animations
    _controller.forward();

    // Navigate to next screen after 3 seconds
    Timer(const Duration(milliseconds: 3000), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final isOnboardingCompleted = await OnboardingService.isOnboardingCompleted();
    
    if (mounted) {
      if (isOnboardingCompleted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _colorAnimation.value!,
                  const Color(0xFF8A2BE2),
                  const Color(0xFF9370DB),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background elements
                _buildAnimatedBackground(),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main animated logo
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Car icon
                              Icon(
                                Icons.directions_car_filled,
                                size: 50,
                                color: Colors.purple[800],
                              ),

                              // Rotating gear
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _controller,
                                      curve: Curves.linear,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    size: 20,
                                    color: Colors.purple[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App name with slide and fade animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'AutoConnect',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.purple[900]!,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tagline with fade animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Your Complete Automotive Ecosystem',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Loading indicator
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom wave decoration
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildWaveDecoration(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Floating circles
        Positioned(
          top: 100,
          left: 30,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ),

        Positioned(
          top: 200,
          right: 40,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 150,
          left: 50,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
        ),

        // Animated icons representing different services
        Positioned(
          top: 80,
          right: 80,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Icon(
              Icons.build_circle,
              size: 30,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),

        Positioned(
          bottom: 200,
          right: 60,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Icon(
              Icons.local_shipping,
              size: 25,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),

        Positioned(
          top: 150,
          left: 80,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Icon(
              Icons.security,
              size: 28,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaveDecoration() {
    return SizedBox(
      height: 80,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 80),
        painter: _WavePainter(animation: _controller),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {

  _WavePainter({required this.animation}) : super(repaint: animation);
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 2;
    final baseHeight = size.height;

    path.moveTo(0, baseHeight);

    for (double i = 0; i < size.width; i++) {
      final y =
          waveHeight *
              sin((i / waveLength * 2 * pi) + (animation.value * 2 * pi)) +
          baseHeight -
          waveHeight;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}











// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   // Keys for SharedPreferences
//   static const String _isLoggedInKey = 'isLoggedIn';
//   static const String _userEmailKey = 'userEmail';
//   static const String _userRoleKey = 'userRole';
//   static const String _loginTimeKey = 'loginTime';
//   static const String _userIdKey = 'userId';
//   static const String _userNameKey = 'userName';

//   // Save login data
//   static Future<void> saveLoginData({
//     required String email,
//     String? role,
//     String? userId,
//     String? userName,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, true);
//       await prefs.setString(_userEmailKey, email);
//       await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
      
//       if (role != null) {
//         await prefs.setString(_userRoleKey, role);
//       }
      
//       if (userId != null) {
//         await prefs.setString(_userIdKey, userId);
//       }
      
//       if (userName != null) {
//         await prefs.setString(_userNameKey, userName);
//       }
      
//       print('✅ Login data saved successfully for: $email');
//     } catch (e) {
//       print('❌ Error saving login data: $e');
//       throw Exception('Failed to save login data');
//     }
//   }

//   // Check if user is logged in
//   static Future<bool> checkValidLogin() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
//       if (isLoggedIn) {
//         // Optional: Check if login session is still valid (e.g., within 30 days)
//         final loginTime = prefs.getString(_loginTimeKey);
//         if (loginTime != null) {
//           final loginDateTime = DateTime.parse(loginTime);
//           final now = DateTime.now();
//           final difference = now.difference(loginDateTime);
          
//           // Session expires after 30 days (optional)
//           if (difference.inDays > 30) {
//             await logout();
//             return false;
//           }
//         }
//       }
      
//       return isLoggedIn;
//     } catch (e) {
//       print('❌ Error checking login status: $e');
//       return false;
//     }
//   }

//   // Get user email
//   static Future<String?> getUserEmail() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userEmailKey);
//     } catch (e) {
//       print('❌ Error getting user email: $e');
//       return null;
//     }
//   }

//   // Get user role
//   static Future<String?> getUserRole() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userRoleKey);
//     } catch (e) {
//       print('❌ Error getting user role: $e');
//       return null;
//     }
//   }

//   // Get user ID
//   static Future<String?> getUserId() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userIdKey);
//     } catch (e) {
//       print('❌ Error getting user ID: $e');
//       return null;
//     }
//   }

//   // Get user name
//   static Future<String?> getUserName() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_userNameKey);
//     } catch (e) {
//       print('❌ Error getting user name: $e');
//       return null;
//     }
//   }

//   // Get login time
//   static Future<DateTime?> getLoginTime() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final loginTimeString = prefs.getString(_loginTimeKey);
//       return loginTimeString != null ? DateTime.parse(loginTimeString) : null;
//     } catch (e) {
//       print('❌ Error getting login time: $e');
//       return null;
//     }
//   }

//   // Logout user
//   static Future<void> logout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_isLoggedInKey, false);
//       await prefs.remove(_userEmailKey);
//       await prefs.remove(_userRoleKey);
//       await prefs.remove(_userIdKey);
//       await prefs.remove(_userNameKey);
//       await prefs.remove(_loginTimeKey);
      
//       print('✅ User logged out successfully');
//     } catch (e) {
//       print('❌ Error during logout: $e');
//       throw Exception('Failed to logout');
//     }
//   }

//   // Clear all data (for debugging or app reset)
//   static Future<void> clearAllData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       print('✅ All SharedPreferences data cleared');
//     } catch (e) {
//       print('❌ Error clearing all data: $e');
//       throw Exception('Failed to clear data');
//     }
//   }

//   // Check if first time app launch
//   static Future<bool> isFirstTime() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isFirstTime = prefs.getBool('first_time') ?? true;
//       if (isFirstTime) {
//         await prefs.setBool('first_time', false);
//       }
//       return isFirstTime;
//     } catch (e) {
//       print('❌ Error checking first time: $e');
//       return true;
//     }
//   }

//   // Get all stored data (for debugging)
//   static Future<Map<String, dynamic>> getAllStoredData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return {
//         'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
//         'userEmail': prefs.getString(_userEmailKey),
//         'userRole': prefs.getString(_userRoleKey),
//         'userId': prefs.getString(_userIdKey),
//         'userName': prefs.getString(_userNameKey),
//         'loginTime': prefs.getString(_loginTimeKey),
//       };
//     } catch (e) {
//       print('❌ Error getting all stored data: $e');
//       return {};
//     }
//   }
// }

// // Role-specific SharedPreferences services
// class VehicleOwnerAuth {
//   static const String _vehicleOwnerLoggedInKey = 'vehicleOwnerIsLoggedIn';
//   static const String _vehicleOwnerEmailKey = 'vehicleOwnerEmail';

//   static Future<void> saveVehicleOwnerLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_vehicleOwnerLoggedInKey, true);
//       await prefs.setString(_vehicleOwnerEmailKey, email);
//       // Also save in main auth service
//       await AuthService.saveLoginData(email: email, role: 'vehicle_owner');
//     } catch (e) {
//       print('❌ Error saving vehicle owner login: $e');
//     }
//   }

//   static Future<bool> isVehicleOwnerLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_vehicleOwnerLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking vehicle owner login: $e');
//       return false;
//     }
//   }

//   static Future<void> vehicleOwnerLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_vehicleOwnerLoggedInKey, false);
//       await prefs.remove(_vehicleOwnerEmailKey);
//     } catch (e) {
//       print('❌ Error during vehicle owner logout: $e');
//     }
//   }
// }

// class GarageAuth {
//   static const String _garageLoggedInKey = 'garageIsLoggedIn';
//   static const String _garageEmailKey = 'garageEmail';

//   static Future<void> saveGarageLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_garageLoggedInKey, true);
//       await prefs.setString(_garageEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'garage');
//     } catch (e) {
//       print('❌ Error saving garage login: $e');
//     }
//   }

//   static Future<bool> isGarageLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_garageLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking garage login: $e');
//       return false;
//     }
//   }

//   static Future<void> garageLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_garageLoggedInKey, false);
//       await prefs.remove(_garageEmailKey);
//     } catch (e) {
//       print('❌ Error during garage logout: $e');
//     }
//   }
// }

// class TowProviderAuth {
//   static const String _towProviderLoggedInKey = 'towProviderIsLoggedIn';
//   static const String _towProviderEmailKey = 'towProviderEmail';

//   static Future<void> saveTowProviderLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_towProviderLoggedInKey, true);
//       await prefs.setString(_towProviderEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'tow_provider');
//     } catch (e) {
//       print('❌ Error saving tow provider login: $e');
//     }
//   }

//   static Future<bool> isTowProviderLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_towProviderLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking tow provider login: $e');
//       return false;
//     }
//   }

//   static Future<void> towProviderLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_towProviderLoggedInKey, false);
//       await prefs.remove(_towProviderEmailKey);
//     } catch (e) {
//       print('❌ Error during tow provider logout: $e');
//     }
//   }
// }

// class InsuranceAuth {
//   static const String _insuranceLoggedInKey = 'insuranceIsLoggedIn';
//   static const String _insuranceEmailKey = 'insuranceEmail';

//   static Future<void> saveInsuranceLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_insuranceLoggedInKey, true);
//       await prefs.setString(_insuranceEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'insurance');
//     } catch (e) {
//       print('❌ Error saving insurance login: $e');
//     }
//   }

//   static Future<bool> isInsuranceLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_insuranceLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking insurance login: $e');
//       return false;
//     }
//   }

//   static Future<void> insuranceLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_insuranceLoggedInKey, false);
//       await prefs.remove(_insuranceEmailKey);
//     } catch (e) {
//       print('❌ Error during insurance logout: $e');
//     }
//   }
// }

// class AdminAuth {
//   static const String _adminLoggedInKey = 'adminIsLoggedIn';
//   static const String _adminEmailKey = 'adminEmail';

//   static Future<void> saveAdminLogin(String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_adminLoggedInKey, true);
//       await prefs.setString(_adminEmailKey, email);
//       await AuthService.saveLoginData(email: email, role: 'admin');
//     } catch (e) {
//       print('❌ Error saving admin login: $e');
//     }
//   }

//   static Future<bool> isAdminLoggedIn() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_adminLoggedInKey) ?? false;
//     } catch (e) {
//       print('❌ Error checking admin login: $e');
//       return false;
//     }
//   }

//   static Future<void> adminLogout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_adminLoggedInKey, false);
//       await prefs.remove(_adminEmailKey);
//     } catch (e) {
//       print('❌ Error during admin logout: $e');
//     }
//   }
// }

// // Utility class for app settings
// class AppSettings {
//   static const String _themeModeKey = 'themeMode';
//   static const String _languageKey = 'language';
//   static const String _notificationKey = 'notificationsEnabled';

//   // Theme mode
//   static Future<void> setThemeMode(String themeMode) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_themeModeKey, themeMode);
//     } catch (e) {
//       print('❌ Error saving theme mode: $e');
//     }
//   }

//   static Future<String> getThemeMode() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_themeModeKey) ?? 'light';
//     } catch (e) {
//       print('❌ Error getting theme mode: $e');
//       return 'light';
//     }
//   }

//   // Language
//   static Future<void> setLanguage(String language) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_languageKey, language);
//     } catch (e) {
//       print('❌ Error saving language: $e');
//     }
//   }

//   static Future<String> getLanguage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_languageKey) ?? 'en';
//     } catch (e) {
//       print('❌ Error getting language: $e');
//       return 'en';
//     }
//   }

//   // Notifications
//   static Future<void> setNotificationsEnabled(bool enabled) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool(_notificationKey, enabled);
//     } catch (e) {
//       print('❌ Error saving notification settings: $e');
//     }
//   }

//   static Future<bool> getNotificationsEnabled() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool(_notificationKey) ?? true;
//     } catch (e) {
//       print('❌ Error getting notification settings: $e');
//       return true;
//     }
//   }
// }