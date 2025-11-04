// import 'package:smart_road_app/Login/GarageLoginScreen.dart';
// import 'package:smart_road_app/Login/InsuranceLogin.dart';
// import 'package:smart_road_app/Login/ToeProviderLogin.dart';
// import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
// import 'package:smart_road_app/Login/adminLogin.dart';
// import 'package:flutter/material.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
//     ));

//     _slideAnimation = Tween<double>(
//       begin: 80.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
//     ));

//     _colorAnimation = ColorTween(
//       begin: const Color(0xFF6A11CB),
//       end: const Color(0xFF2575FC),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.grey[50]!,
//                 Colors.purple[50]!.withOpacity(0.3),
//               ],
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header with enhanced styling
//                     Transform.translate(
//                       offset: Offset(0, _slideAnimation.value),
//                       child: FadeTransition(
//                         opacity: _fadeAnimation,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 4,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         const Color(0xFF8A2BE2),
//                                         _colorAnimation.value!,
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(2),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     'Choose Your Role',
//                                     style: TextStyle(
//                                       fontSize: 32,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.purple[900],
//                                       letterSpacing: -0.8,
//                                       shadows: [
//                                         Shadow(
//                                           blurRadius: 10,
//                                           color: Colors.purple.withOpacity(0.1),
//                                           offset: const Offset(2, 2),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 16),
//                               child: Text(
//                                 'Select how you want to use AutoConnect ecosystem',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[700],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 50),

//                     // Role Selection Grid with enhanced animations
//                     Expanded(
//                       child: FadeTransition(
//                         opacity: _fadeAnimation,
//                         child: GridView.count(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 20,
//                           mainAxisSpacing: 20,
//                           childAspectRatio: 0.85,
//                           padding: const EdgeInsets.only(bottom: 20),
//                           children: [
//                             _buildEnhancedRoleCard(
//                               icon: Icons.directions_car_rounded,
//                               title: 'Vehicle Owner',
//                               subtitle: 'Car owner or driver',
//                               color: const Color(0xFF6366F1), // Indigo
//                               index: 0,
//                             ),
//                             _buildEnhancedRoleCard(
//                               icon: Icons.build_circle_rounded,
//                               title: 'Garage / Mechanic',
//                               subtitle: 'Auto repair shop',
//                               color: const Color(0xFFF59E0B), // Amber
//                               index: 1,
//                             ),
//                             _buildEnhancedRoleCard(
//                               icon: Icons.local_shipping_rounded,
//                               title: 'Tow Provider',
//                               subtitle: 'Towing services',
//                               color: const Color(0xFF10B981), // Emerald
//                               index: 2,
//                             ),
//                             _buildEnhancedRoleCard(
//                               icon: Icons.security_rounded,
//                               title: 'Insurance Comp',
//                               subtitle: 'Insurance ',
//                               color: const Color(0xFFEF4444), // Red
//                               index: 3,
//                             ),
//                             _buildEnhancedRoleCard(
//                               icon: Icons.admin_panel_settings_rounded,
//                               title: 'Admin',
//                               subtitle: 'System administrator',
//                               color: const Color(0xFF8B5CF6), // Violet
//                               index: 4,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedRoleCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required int index,
//   }) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: Transform.translate(
//         offset: Offset(0, _slideAnimation.value * (1 + index * 0.15)),
//         child: InkWell(
//           onTap: () => _handleEnhancedRoleSelection(title, color),
//           borderRadius: BorderRadius.circular(24),
//           splashColor: color.withOpacity(0.2),
//           highlightColor: color.withOpacity(0.1),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.25),
//                   blurRadius: 20,
//                   spreadRadius: 1,
//                   offset: const Offset(0, 8),
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//                 BoxShadow(
//                   color: Colors.white.withOpacity(0.9),
//                   blurRadius: 2,
//                   offset: const Offset(0, -1),
//                   spreadRadius: 1,
//                 ),
//               ],
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   color.withOpacity(0.08),
//                   color.withOpacity(0.02),
//                   Colors.white,
//                 ],
//               ),
//               border: Border.all(
//                 color: color.withOpacity(0.1),
//                 width: 1,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Background pattern
//                 Positioned(
//                   top: -10,
//                   right: -10,
//                   child: Opacity(
//                     opacity: 0.05,
//                     child: Icon(
//                       icon,
//                       size: 80,
//                       color: color,
//                     ),
//                   ),
//                 ),

//                 // Main content
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Animated Icon Container
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               color.withOpacity(0.15),
//                               color.withOpacity(0.05),
//                             ],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: color.withOpacity(0.2),
//                               blurRadius: 15,
//                               offset: const Offset(0, 5),
//                             ),
//                             BoxShadow(
//                               color: Colors.white,
//                               blurRadius: 5,
//                               offset: const Offset(-2, -2),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: color.withOpacity(0.2),
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Icon(
//                           icon,
//                           size: 36,
//                           color: color,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Title with gradient text
//                       ShaderMask(
//                         shaderCallback: (bounds) => LinearGradient(
//                           colors: [color, _darkenColor(color, 0.3)],
//                         ).createShader(bounds),
//                         child: Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                             letterSpacing: -0.2,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       // Subtitle
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                           height: 1.3,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),

//                       const SizedBox(height: 12),

//                       // Animated selection indicator
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         width: 32,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [color, _lightenColor(color, 0.3)],
//                           ),
//                           borderRadius: BorderRadius.circular(3),
//                           boxShadow: [
//                             BoxShadow(
//                               color: color.withOpacity(0.4),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
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

//   void _handleEnhancedRoleSelection(String role, Color color) {
//     // Haptic feedback simulation
//     _playSelectionAnimation();

//     // Navigate based on role with delay for animation
//     Future.delayed(const Duration(milliseconds: 500), () {
//       switch (role) {
//         case 'Vehicle Owner':
//           _navigateToVehicleOwnerScreen();
//           break;
//         case 'Garage / Mechanic':
//           _navigateToGarageScreen();
//           break;
//         case 'Tow Provider':
//           _navigateToTowProviderScreen();
//           break;
//         case 'Insurance Comp':
//           _navigateToInsuranceScreen();
//           break;
//         case 'Admin':
//           _navigateToAdminScreen();
//           break;
//       }
//     });
//   }

//   void _playSelectionAnimation() {
//     // You can add haptic feedback here if needed
//     // HapticFeedback.lightImpact();
//   }

//   Color _darkenColor(Color color, [double amount = 0.1]) {
//     assert(amount >= 0 && amount <= 1);
//     final hsl = HSLColor.fromColor(color);
//     final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
//     return hslDark.toColor();
//   }

//   Color _lightenColor(Color color, [double amount = 0.1]) {
//     assert(amount >= 0 && amount <= 1);
//     final hsl = HSLColor.fromColor(color);
//     final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
//     return hslLight.toColor();
//   }

//   void _navigateToVehicleOwnerScreen() {
//   //  print('Navigate to Vehicle Owner Screen');
//      Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleLoginPage()));
//   }

//   void _navigateToGarageScreen() {
//     print('Navigate to Garage Screen');
//      Navigator.push(context, MaterialPageRoute(builder: (_) => GarageLoginPage()));
//   }

//   void _navigateToTowProviderScreen() {
//     print('Navigate to Tow Provider Screen');
//      Navigator.push(context, MaterialPageRoute(builder: (_) => TowProviderLoginPage()));
//   }

//   void _navigateToInsuranceScreen() {
//     print('Navigate to Insurance Screen');
//     Navigator.push(context, MaterialPageRoute(builder: (_) => InsuranceLoginPage()));
//   }

//   void _navigateToAdminScreen() {
//     print('Navigate to Admin Screen');
//      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminLoginPage()));
//   }
// }

import 'package:smart_road_app/Login/GarageLoginScreen.dart';
import 'package:smart_road_app/Login/InsuranceLogin.dart';
import 'package:smart_road_app/Login/ToeProviderLogin.dart';
import 'package:smart_road_app/Login/VehicleOwneLogin.dart';
import 'package:smart_road_app/Login/adminLogin.dart';
import 'package:smart_road_app/screens/AboutUsPage.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF6A11CB),
      end: const Color(0xFF2575FC),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Let the system handle the back button (exit app)
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                  Colors.purple[50]!.withOpacity(0.3),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with enhanced styling
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF8A2BE2),
                                          _colorAnimation.value!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Choose Your Role',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.purple[900],
                                        letterSpacing: -0.8,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.purple.withOpacity(
                                              0.1,
                                            ),
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Select how you want to use Smart Road App',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Role Selection Grid with enhanced animations
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.85,
                            padding: const EdgeInsets.only(bottom: 20),
                            children: [
                              _buildEnhancedRoleCard(
                                icon: Icons.directions_car_rounded,
                                title: 'Vehicle Owner',
                                subtitle: 'Car owner or driver',
                                color: const Color(0xFF6366F1), // Indigo
                                index: 0,
                              ),
                              _buildEnhancedRoleCard(
                                icon: Icons.build_circle_rounded,
                                title: 'Garage / Mechanic',
                                subtitle: 'Auto repair shop',
                                color: const Color(0xFFF59E0B), // Amber
                                index: 1,
                              ),
                              _buildEnhancedRoleCard(
                                icon: Icons.local_shipping_rounded,
                                title: 'Tow Provider',
                                subtitle: 'Towing services',
                                color: const Color(0xFF10B981), // Emerald
                                index: 2,
                              ),
                              _buildEnhancedRoleCard(
                                icon: Icons.security_rounded,
                                title: 'Insurance Comp',
                                subtitle: 'Insurance ',
                                color: const Color(0xFFEF4444), // Red
                                index: 3,
                              ),
                              _buildEnhancedRoleCard(
                                icon: Icons.admin_panel_settings_rounded,
                                title: 'Admin',
                                subtitle: 'System administrator',
                                color: const Color(0xFF8B5CF6), // Violet
                                index: 4,
                              ),
                              _buildEnhancedRoleCard(
                                icon: Icons.info_rounded,
                                title: 'About Us',
                                subtitle: '',
                                color: const Color(0xFFFF6B35), // Orange/Teal
                                index: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int index,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Transform.translate(
        offset: Offset(0, _slideAnimation.value * (1 + index * 0.15)),
        child: InkWell(
          onTap: () => _handleEnhancedRoleSelection(title, color),
          borderRadius: BorderRadius.circular(24),
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                  spreadRadius: 1,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.08),
                  color.withOpacity(0.02),
                  Colors.white,
                ],
              ),
              border: Border.all(color: color.withOpacity(0.1), width: 1),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -10,
                  right: -10,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(icon, size: 80, color: color),
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.15),
                              color.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: const Offset(-2, -2),
                            ),
                          ],
                          border: Border.all(
                            color: color.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(icon, size: 36, color: color),
                      ),

                      const SizedBox(height: 20),

                      // Title with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [color, _darkenColor(color, 0.3)],
                        ).createShader(bounds),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Animated selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 32,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, _lightenColor(color, 0.3)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
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

  void _handleEnhancedRoleSelection(String role, Color color) {
    // Haptic feedback simulation
    _playSelectionAnimation();

    // Navigate based on role with delay for animation
    Future.delayed(const Duration(milliseconds: 500), () {
      switch (role) {
        case 'Vehicle Owner':
          _navigateToVehicleOwnerScreen();
          break;
        case 'Garage / Mechanic':
          _navigateToGarageScreen();
          break;
        case 'Tow Provider':
          _navigateToTowProviderScreen();
          break;
        case 'Insurance Comp':
          _navigateToInsuranceScreen();
          break;
        case 'Admin':
          _navigateToAdminScreen();
          break;
        case 'About Us':
          _navigateToAboutUsScreen();
          break;
      }
    });
  }

  void _playSelectionAnimation() {
    // You can add haptic feedback here if needed
    // HapticFeedback.lightImpact();
  }

  Color _darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color _lightenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  void _navigateToVehicleOwnerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VehicleLoginPage()),
    );
  }

  void _navigateToGarageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GarageLoginPage()),
    );
  }

  void _navigateToTowProviderScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TowProviderLoginPage()),
    );
  }

  void _navigateToInsuranceScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InsuranceLoginPage()),
    );
  }

  void _navigateToAdminScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginPage()),
    );
  }

  void _navigateToAboutUsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutUsPage()),
    );
  }
}
