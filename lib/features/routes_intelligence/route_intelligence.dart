// lib/features/route_intelligence/route_intelligence.dart
import 'package:flutter/material.dart';
import 'dart:math';

class RouteIntelligence extends StatefulWidget {
  @override
  _RouteIntelligenceState createState() => _RouteIntelligenceState();
}

class _RouteIntelligenceState extends State<RouteIntelligence> 
    with SingleTickerProviderStateMixin {
  late AnimationController _routeController;
  late Animation<double> _scaleAnimation;
  
  RoutePreference _userPreference = RoutePreference.balanced;
  List<IntelligentRoute> _suggestedRoutes = [];
  bool _isAnalyzing = false;
  String _currentDestination = "Downtown Office";

  final List<String> _popularDestinations = [
    "Downtown Office",
    "Shopping Mall", 
    "Airport",
    "Home",
    "Restaurant District",
    "Sports Arena",
  ];

  @override
  void initState() {
    super.initState();
    _routeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _routeController,
      curve: Curves.elasticOut,
    ));

    _routeController.forward();
    _analyzeRoutePreferences();
  }

  void _analyzeRoutePreferences() {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _suggestedRoutes = _generateRouteSuggestions();
        _isAnalyzing = false;
      });
    });
  }

  List<IntelligentRoute> _generateRouteSuggestions() {
    final random = Random();
    return [
      IntelligentRoute(
        id: '1',
        name: "Fastest Route",
        type: RouteType.fastest,
        duration: 25,
        distance: 18.5,
        advantages: [
          "15 mins faster than alternatives",
          "Minimal traffic congestion",
          "Direct highway access"
        ],
        disadvantages: [
          "Toll road (\$4.50)",
          "Higher fuel consumption",
          "More stressful driving"
        ],
        confidence: random.nextInt(15) + 80, // 80-95%
        color: Colors.blue,
        icon: Icons.rocket_launch,
        emoji: "🚀",
        safetyScore: 82,
        fuelEfficiency: 65,
        scenicRating: 40,
      ),
      IntelligentRoute(
        id: '2',
        name: "Safest Route",
        type: RouteType.safest,
        duration: 32,
        distance: 20.1,
        advantages: [
          "Low accident probability",
          "Well-lit roads",
          "Minimal sharp curves"
        ],
        disadvantages: [
          "8 mins longer",
          "More traffic lights",
          "Residential areas"
        ],
        confidence: random.nextInt(15) + 85, // 85-100%
        color: Colors.green,
        icon: Icons.security,
        emoji: "🛡️",
        safetyScore: 95,
        fuelEfficiency: 75,
        scenicRating: 60,
      ),
      IntelligentRoute(
        id: '3',
        name: "Eco Route",
        type: RouteType.eco,
        duration: 28,
        distance: 19.2,
        advantages: [
          "20% better fuel efficiency",
          "Smooth traffic flow",
          "Lower emissions"
        ],
        disadvantages: [
          "Slightly longer route",
          "Fewer overtaking opportunities",
          "Speed restrictions"
        ],
        confidence: random.nextInt(15) + 75, // 75-90%
        color: Colors.teal,
        icon: Icons.eco,
        emoji: "🌱",
        safetyScore: 88,
        fuelEfficiency: 90,
        scenicRating: 70,
      ),
      IntelligentRoute(
        id: '4',
        name: "Scenic Route",
        type: RouteType.scenic,
        duration: 45,
        distance: 25.8,
        advantages: [
          "Beautiful coastal views",
          "Relaxing drive experience",
          "Photo opportunities"
        ],
        disadvantages: [
          "20 mins longer",
          "Narrow roads in sections",
          "Limited services"
        ],
        confidence: random.nextInt(15) + 70, // 70-85%
        color: Colors.orange,
        icon: Icons.landscape,
        emoji: "🏞️",
        safetyScore: 85,
        fuelEfficiency: 80,
        scenicRating: 95,
      ),
    ];
  }

  void _changePreference(RoutePreference preference) {
    setState(() {
      _userPreference = preference;
    });
    _analyzeRoutePreferences();
  }

  void _selectRoute(IntelligentRoute route) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(route.emoji),
            SizedBox(width: 8),
            Text("Select ${route.name}?"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("This route is optimized for ${_getPreferenceDescription(route.type)}"),
            SizedBox(height: 12),
            _buildRouteStats(route),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNavigation(route);
            },
            child: Text("Start Navigation"),
          ),
        ],
      ),
    );
  }

  void _startNavigation(IntelligentRoute route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.navigation, color: Colors.white),
            SizedBox(width: 8),
            Text("Navigating via ${route.name}..."),
          ],
        ),
        backgroundColor: route.color,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.alt_route, color: Colors.white, size: 30),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Route Intelligence",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "AI-powered route optimization",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Destination:",
            style: TextStyle(color: Colors.white70),
          ),
          DropdownButton<String>(
            value: _currentDestination,
            dropdownColor: Colors.deepPurple,
            style: TextStyle(color: Colors.white, fontSize: 18),
            underline: Container(height: 0),
            items: _popularDestinations.map((destination) {
              return DropdownMenuItem(
                value: destination,
                child: Text(destination),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _currentDestination = value!;
              });
              _analyzeRoutePreferences();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Route Preference",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPreferenceButton(
                  RoutePreference.fastest,
                  "Fastest",
                  Icons.speed,
                  Colors.blue,
                ),
                _buildPreferenceButton(
                  RoutePreference.safest,
                  "Safest", 
                  Icons.security,
                  Colors.green,
                ),
                _buildPreferenceButton(
                  RoutePreference.eco,
                  "Eco",
                  Icons.eco,
                  Colors.teal,
                ),
                _buildPreferenceButton(
                  RoutePreference.scenic,
                  "Scenic",
                  Icons.landscape,
                  Colors.orange,
                ),
                _buildPreferenceButton(
                  RoutePreference.balanced,
                  "Balanced",
                  Icons.balance,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceButton(
    RoutePreference preference, 
    String label, 
    IconData icon, 
    Color color,
  ) {
    final isSelected = _userPreference == preference;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _changePreference(preference),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSuggestions() {
    if (_isAnalyzing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "AI is analyzing routes...",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Considering traffic, weather, and your preferences",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "AI-Suggested Routes (${_suggestedRoutes.length})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ..._suggestedRoutes.map((route) => RouteCard(
          route: route,
          onSelect: _selectRoute,
          isRecommended: _isRecommendedRoute(route),
        )).toList(),
      ],
    );
  }

  bool _isRecommendedRoute(IntelligentRoute route) {
    switch (_userPreference) {
      case RoutePreference.fastest:
        return route.type == RouteType.fastest;
      case RoutePreference.safest:
        return route.type == RouteType.safest;
      case RoutePreference.eco:
        return route.type == RouteType.eco;
      case RoutePreference.scenic:
        return route.type == RouteType.scenic;
      case RoutePreference.balanced:
        return route.type == RouteType.fastest; // Default to fastest for balanced
    }
  }

  Widget _buildRouteStats(IntelligentRoute route) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow("Duration", "${route.duration} mins", Icons.timer),
        _buildStatRow("Distance", "${route.distance} km", Icons.alt_route),
        _buildStatRow("Safety Score", "${route.safetyScore}%", Icons.security),
        _buildStatRow("Fuel Efficiency", "${route.fuelEfficiency}%", Icons.local_gas_station),
        _buildStatRow("Scenic Rating", "${route.scenicRating}%", Icons.landscape),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _getPreferenceDescription(RouteType type) {
    switch (type) {
      case RouteType.fastest:
        return "minimum travel time";
      case RouteType.safest:
        return "maximum safety";
      case RouteType.eco:
        return "optimal fuel efficiency";
      case RouteType.scenic:
        return "most enjoyable scenery";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Intelligence"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _analyzeRoutePreferences,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildPreferenceSelector(),
          Divider(),
          Expanded(
            child: _buildRouteSuggestions(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _routeController.dispose();
    super.dispose();
  }
}

class RouteCard extends StatelessWidget {
  final IntelligentRoute route;
  final Function(IntelligentRoute) onSelect;
  final bool isRecommended;

  const RouteCard({
    required this.route,
    required this.onSelect,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: kAlwaysCompleteAnimation,
        curve: Curves.elasticOut,
      )),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isRecommended 
              ? BorderSide(color: route.color, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () => onSelect(route),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with recommendation badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: route.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(route.icon, color: route.color),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                route.emoji,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                route.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${route.duration} mins • ${route.distance} km",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isRecommended)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: route.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "RECOMMENDED",
                          style: TextStyle(
                            color: route.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12),

                // Confidence and stats
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${route.confidence}% AI Match",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    _buildMiniStat("🛡️", "${route.safetyScore}%"),
                    SizedBox(width: 8),
                    _buildMiniStat("⛽", "${route.fuelEfficiency}%"),
                    SizedBox(width: 8),
                    _buildMiniStat("🏞️", "${route.scenicRating}%"),
                  ],
                ),

                SizedBox(height: 12),

                // Advantages
                Text(
                  "Advantages:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                ...route.advantages.take(2).map((advantage) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          advantage,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )).toList(),

                SizedBox(height: 8),

                // Select Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSelect(route),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: route.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Select This Route"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "$icon $value",
        style: TextStyle(fontSize: 11),
      ),
    );
  }
}

// Data Models
enum RoutePreference { fastest, safest, eco, scenic, balanced }
enum RouteType { fastest, safest, eco, scenic }

class IntelligentRoute {
  final String id;
  final String name;
  final RouteType type;
  final int duration;
  final double distance;
  final List<String> advantages;
  final List<String> disadvantages;
  final int confidence;
  final Color color;
  final IconData icon;
  final String emoji;
  final int safetyScore;
  final int fuelEfficiency;
  final int scenicRating;

  IntelligentRoute({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.distance,
    required this.advantages,
    required this.disadvantages,
    required this.confidence,
    required this.color,
    required this.icon,
    required this.emoji,
    required this.safetyScore,
    required this.fuelEfficiency,
    required this.scenicRating,
  });
}