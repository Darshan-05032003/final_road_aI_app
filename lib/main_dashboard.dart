// lib/main_dashboard.dart
import 'package:flutter/material.dart';
import 'package:smart_road_app/features/ai_travel_companion/ai_travel_companion.dart';
import 'package:smart_road_app/features/emotional_ai/emotional_voice_assistant.dart';
import 'package:smart_road_app/features/safety_gamification/safety_gamification.dart';
import 'package:smart_road_app/features/community_guardian/community_guardian.dart';
import 'package:smart_road_app/features/ar_windshield/ar_windshield.dart';
import 'package:smart_road_app/features/emergency_response/emergency_response.dart';
import 'package:smart_road_app/features/smart_integration/smart_integration.dart';
import 'package:smart_road_app/features/routes_intelligence/route_intelligence.dart';
import 'package:smart_road_app/features/trip_memories/trip_memories.dart';
import 'package:smart_road_app/features/smart_parking/smart_parking.dart';
import 'package:smart_road_app/features/guardian_angel/guardian_angle.dart';
import 'package:smart_road_app/features/predictive_hazard/predictive_hazard_detector.dart';

class MainAiDashboard extends StatefulWidget {
  @override
  _MainAiDashboardState createState() => _MainAiDashboardState();
}

class _MainAiDashboardState extends State<MainAiDashboard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _dashboardController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  List<AIFeature> _features = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFeatures();
  }

  void _initializeAnimations() {
    _dashboardController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.easeOutCubic,
    ));

    _dashboardController.forward();
  }

  void _loadFeatures() {
    // Initialize all AI features
    setState(() {
      _features = [
        AIFeature(
          id: 1,
          title: "AI Travel Companion",
          description: "Chat with AI for navigation & route optimization",
          icon: Icons.smart_toy,
          color: Colors.blue,
          featureWidget: AITravelCompanion(),
          isPremium: true,
          badge: "AI",
        ),
        AIFeature(
          id: 2,
          title: "Emotional Voice Assistant", 
          description: "AI that understands your mood & stress levels",
          icon: Icons.psychology,
          color: Colors.purple,
          featureWidget: EmotionalVoiceAssistant(),
          isPremium: true,
          badge: "AI",
        ),
        AIFeature(
          id: 3,
          title: "Predictive Hazard Detection",
          description: "AI predicts road hazards before you reach them",
          icon: Icons.warning_amber,
          color: Colors.orange,
          featureWidget: PredictiveHazardDetector(),
          isPremium: true,
          badge: "AI",
        ),
        AIFeature(
          id: 4,
          title: "Safety Gamification",
          description: "Earn points for safe driving & compete with friends",
          icon: Icons.emoji_events,
          color: Colors.green,
          featureWidget: SafetyGamification(),
          isPremium: false,
          badge: "GAME",
        ),
        AIFeature(
          id: 5,
          title: "Community Road Guardian",
          description: "Report road issues & help other drivers",
          icon: Icons.people,
          color: Colors.teal,
          featureWidget: CommunityGuardian(),
          isPremium: false,
          badge: "SOCIAL",
        ),
        AIFeature(
          id: 6,
          title: "AR Windshield Mode",
          description: "Augmented reality navigation & hazard highlights",
          icon: Icons.hdr_on_sharp,
          color: Colors.indigo,
          featureWidget: ARWindshield(),
          isPremium: true,
          badge: "AR",
        ),
        AIFeature(
          id: 7,
          title: "Emergency Auto-Response",
          description: "Automatic crash detection & emergency alerts",
          icon: Icons.emergency,
          color: Colors.red,
          featureWidget: EmergencyResponse(),
          isPremium: true,
          badge: "SAFETY",
        ),
        AIFeature(
          id: 8,
          title: "Smart City Integration",
          description: "Connect with traffic lights & smart infrastructure",
          icon: Icons.traffic,
          color: Colors.cyan,
          featureWidget: SmartIntegration(),
          isPremium: true,
          badge: "V2X",
        ),
        AIFeature(
          id: 9,
          title: "Route Intelligence",
          description: "AI suggests routes based on your preferences",
          icon: Icons.alt_route,
          color: Colors.deepOrange,
          featureWidget: RouteIntelligence(),
          isPremium: true,
          badge: "AI",
        ),
        AIFeature(
          id: 10,
          title: "Trip Memory Creator",
          description: "AI generates beautiful trip stories automatically",
          icon: Icons.photo_library,
          color: Colors.pink,
          featureWidget: TripMemoryCreator(),
          isPremium: false,
          badge: "AI",
        ),
        AIFeature(
          id: 11,
          title: "Smart Parking Oracle",
          description: "AI predicts parking availability & reservations",
          icon: Icons.local_parking,
          color: Colors.amber,
          featureWidget: SmartParkingOracle(),
          isPremium: true,
          badge: "AI",
        ),
        AIFeature(
          id: 12,
          title: "Guardian Angel Mode",
          description: "Safety monitoring for night/remote driving",
          icon: Icons.health_and_safety,
          color: Colors.deepPurple,
          featureWidget: GuardianAngelMode(),
          isPremium: true,
          badge: "SAFETY",
        ),
      ];
      _isLoading = false;
    });
  }

  void _navigateToFeature(AIFeature feature) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => feature.featureWidget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        final feature = _features[index];
        return AnimatedFeatureCard(
          feature: feature,
          delay: index * 100,
          onTap: () => _navigateToFeature(feature),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.purple[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Travel Command Center",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "12 Intelligent Features Powered by AI",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("AI Features", "8", Icons.psychology),
              _buildStatItem("Safety", "4", Icons.security),
              _buildStatItem("Active", "12", Icons.rocket_launch),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Section
          _buildHeader(),
          
          // Features Grid
          Expanded(
            child: _isLoading 
                ? Center(child: CircularProgressIndicator())
                : _buildFeatureGrid(),
          ),
        ],
      ),
      
      // Floating Action Button for Quick Access
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick access to AI Travel Companion
          _navigateToFeature(_features[0]);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.travel_explore, color: Colors.white),
        elevation: 8,
      ),
    );
  }

  @override
  void dispose() {
    _dashboardController.dispose();
    super.dispose();
  }
}

class AnimatedFeatureCard extends StatelessWidget {
  final AIFeature feature;
  final int delay;
  final VoidCallback onTap;

  const AnimatedFeatureCard({
    required this.feature,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOut,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: kAlwaysCompleteAnimation,
            curve: Interval(delay / 1000, 1.0, curve: Curves.elasticOut),
          ),
        ),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    feature.color.withOpacity(0.1),
                    feature.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge & Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Premium Badge
                      if (feature.isPremium)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "PREMIUM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "FREE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      
                      // Feature Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: feature.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          feature.badge,
                          style: TextStyle(
                            color: feature.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Feature Icon
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: feature.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        feature.icon,
                        color: feature.color,
                        size: 32,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Feature Title
                  Text(
                    feature.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Feature Description
                  Expanded(
                    child: Text(
                      feature.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Explore Button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: feature.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "EXPLORE →",
                        style: TextStyle(
                          color: feature.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AIFeature {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget featureWidget;
  final bool isPremium;
  final String badge;

  AIFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.featureWidget,
    required this.isPremium,
    required this.badge,
  });
}