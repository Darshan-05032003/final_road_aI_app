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
  final Animation<double> animation;

  _WavePainter({required this.animation}) : super(repaint: animation);

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
