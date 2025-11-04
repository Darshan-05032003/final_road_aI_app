import 'package:flutter/material.dart';
import 'package:smart_road_app/Roleselection.dart';
import 'package:smart_road_app/services/onboarding_service.dart';

class FeatureTourScreen extends StatefulWidget {
  const FeatureTourScreen({super.key});

  @override
  State<FeatureTourScreen> createState() => _FeatureTourScreenState();
}

class _FeatureTourScreenState extends State<FeatureTourScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<FeatureItem> _features = [
    FeatureItem(
      icon: Icons.build_circle,
      title: 'Find Garage Services',
      description:
          'Search and connect with nearby garages and mechanics. Get instant quotes and book services with just a few taps.',
      color: Colors.orange,
      illustration: Icons.build_circle,
    ),
    FeatureItem(
      icon: Icons.local_shipping,
      title: 'Tow Services',
      description:
          'Request emergency towing services with live tracking. Get help when you need it most, wherever you are.',
      color: Colors.green,
      illustration: Icons.local_shipping,
    ),
    FeatureItem(
      icon: Icons.security,
      title: 'Insurance Claims',
      description:
          'File insurance claims directly through the app. Upload photos, track claim status, and get quick approvals.',
      color: Colors.red,
      illustration: Icons.security,
    ),
    FeatureItem(
      icon: Icons.account_balance_wallet,
      title: 'Easy Payments',
      description:
          'Pay for services securely using UPI. Get digital receipts and track all your transactions in one place.',
      color: Colors.blue,
      illustration: Icons.payment,
    ),
    FeatureItem(
      icon: Icons.assistant,
      title: 'AI Assistant',
      description:
          'Get instant help with our voice-enabled AI assistant. Get vehicle diagnostics, service recommendations, and more.',
      color: Colors.purple,
      illustration: Icons.assistant,
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
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _skipTour,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: List.generate(
                  _features.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _features[index].color
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
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  return _buildFeaturePage(_features[index]);
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
                        if (_currentPage < _features.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _features[_currentPage].color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage < _features.length - 1
                            ? 'Next'
                            : 'Get Started',
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

  Widget _buildFeaturePage(FeatureItem feature) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  feature.color.withOpacity(0.2),
                  feature.color.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              feature.illustration,
              size: 100,
              color: feature.color,
            ),
          ),
          const SizedBox(height: 40),
          Icon(
            feature.icon,
            size: 48,
            color: feature.color,
          ),
          const SizedBox(height: 24),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            feature.description,
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

  void _skipTour() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await OnboardingService.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RoleSelectionScreen(),
        ),
      );
    }
  }
}

class FeatureItem {

  FeatureItem({
    required this.icon,
    required this.illustration,
    required this.title,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final IconData illustration;
  final String title;
  final String description;
  final Color color;
}

