import 'package:flutter/material.dart';
import 'package:smart_road_app/screens/onboarding/feature_tour_screen.dart';
import 'package:smart_road_app/services/onboarding_service.dart';

class PermissionsExplanationScreen extends StatefulWidget {
  const PermissionsExplanationScreen({super.key});

  @override
  State<PermissionsExplanationScreen> createState() =>
      _PermissionsExplanationScreenState();
}

class _PermissionsExplanationScreenState
    extends State<PermissionsExplanationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PermissionItem> _permissions = [
    PermissionItem(
      icon: Icons.location_on,
      title: 'Location Access',
      description:
          'We need your location to find nearby garages, tow services, and help providers reach you quickly in emergencies.',
      color: Colors.blue,
    ),
    PermissionItem(
      icon: Icons.camera_alt,
      title: 'Camera Access',
      description:
          'Camera access allows you to take photos of vehicle damage for accurate service requests and insurance claims.',
      color: Colors.green,
    ),
    PermissionItem(
      icon: Icons.notifications_active,
      title: 'Notifications',
      description:
          'Receive real-time updates about your service requests, payment confirmations, and important alerts.',
      color: Colors.orange,
    ),
    PermissionItem(
      icon: Icons.mic,
      title: 'Microphone',
      description:
          'Enable voice commands for hands-free operation of the AI assistant feature.',
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Why We Need Permissions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: List.generate(
                  _permissions.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  return _buildPermissionPage(_permissions[index]);
                },
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _permissions.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _continueToFeatureTour();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage < _permissions.length - 1
                            ? 'Next'
                            : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionPage(PermissionItem permission) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: permission.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              permission.icon,
              size: 60,
              color: permission.color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            permission.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            permission.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _continueToFeatureTour() async {
    await OnboardingService.markPermissionsExplained();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const FeatureTourScreen(),
        ),
      );
    }
  }
}

class PermissionItem {

  PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

