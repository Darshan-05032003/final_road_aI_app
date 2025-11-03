// lib/features/predictive_hazard/predictive_hazard_detector.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class PredictiveHazardDetector extends StatefulWidget {
  @override
  _PredictiveHazardDetectorState createState() => _PredictiveHazardDetectorState();
}

class _PredictiveHazardDetectorState extends State<PredictiveHazardDetector> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  List<HazardAlert> _alerts = [];
  Timer? _hazardTimer;
  bool _isMonitoring = true;

  // Simulated hazard data
  final List<HazardAlert> _hazardDatabase = [
    HazardAlert(
      id: '1',
      type: HazardType.accidentProne,
      location: "2.3km ahead",
      confidence: 85,
      reason: "Sharp curve + Rain forecast + High accident history",
      severity: Severity.high,
      distance: 2.3,
      eta: "4 mins",
      coordinates: "37.7749,-122.4194",
    ),
    HazardAlert(
      id: '2',
      type: HazardType.roadWork,
      location: "5.1km ahead",
      confidence: 92,
      reason: "Construction zone - Lane closure detected",
      severity: Severity.medium,
      distance: 5.1,
      eta: "8 mins",
      coordinates: "37.7849,-122.4094",
    ),
    HazardAlert(
      id: '3',
      type: HazardType.weather,
      location: "8.7km ahead",
      confidence: 78,
      reason: "Heavy rain expected - Reduced visibility",
      severity: Severity.medium,
      distance: 8.7,
      eta: "14 mins",
      coordinates: "37.7949,-122.3994",
    ),
    HazardAlert(
      id: '4',
      type: HazardType.traffic,
      location: "12.2km ahead",
      confidence: 88,
      reason: "Major congestion - Accident reported",
      severity: Severity.high,
      distance: 12.2,
      eta: "22 mins",
      coordinates: "37.8049,-122.3894",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
    );

    _startHazardMonitoring();
  }

  void _startHazardMonitoring() {
    // Simulate real-time hazard detection
    _hazardTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_isMonitoring) {
        _simulateNewHazardDetection();
      }
    });

    // Load initial hazards
    _loadInitialHazards();
  }

  void _loadInitialHazards() {
    setState(() {
      _alerts = _hazardDatabase.sublist(0, 2); // Show first 2 hazards initially
    });
  }

  void _simulateNewHazardDetection() {
    if (_alerts.length < _hazardDatabase.length) {
      final newHazard = _hazardDatabase[_alerts.length];
      setState(() {
        _alerts.add(newHazard);
      });

      // Show notification for new hazard
      _showHazardNotification(newHazard);
    }
  }

  void _showHazardNotification(HazardAlert hazard) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _getSeverityColor(hazard.severity),
        content: Row(
          children: [
            Icon(_getAlertIcon(hazard.type), color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getAlertTitle(hazard.type),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    hazard.location,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleMonitoring() {
    setState(() {
      _isMonitoring = !_isMonitoring;
    });
    
    if (_isMonitoring) {
      _startHazardMonitoring();
    } else {
      _hazardTimer?.cancel();
    }
  }

  void _dismissHazard(String hazardId) {
    setState(() {
      _alerts.removeWhere((alert) => alert.id == hazardId);
    });
  }

  Color _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Colors.red;
      case Severity.medium:
        return Colors.orange;
      case Severity.low:
        return Colors.yellow;
    }
  }

  Color _getSeverityLightColor(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Color(0xFFFF6B6B);
      case Severity.medium:
        return Color(0xFFFFA726);
      case Severity.low:
        return Color(0xFFFFEE58);
    }
  }

  IconData _getAlertIcon(HazardType type) {
    switch (type) {
      case HazardType.accidentProne:
        return Icons.car_crash;
      case HazardType.roadWork:
        return Icons.construction;
      case HazardType.weather:
        return Icons.cloudy_snowing;
      case HazardType.traffic:
        return Icons.traffic;
    }
  }

  String _getAlertTitle(HazardType type) {
    switch (type) {
      case HazardType.accidentProne:
        return "HIGH RISK ZONE";
      case HazardType.roadWork:
        return "CONSTRUCTION AHEAD";
      case HazardType.weather:
        return "WEATHER HAZARD";
      case HazardType.traffic:
        return "TRAFFIC CONGESTION";
    }
  }

  String _getSeverityText(Severity severity) {
    switch (severity) {
      case Severity.high:
        return "HIGH ALERT";
      case Severity.medium:
        return "MEDIUM ALERT";
      case Severity.low:
        return "LOW ALERT";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predictive Hazard Detection"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(_isMonitoring ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleMonitoring,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.warning_amber, color: Colors.white, size: 30),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI HAZARD MONITORING",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _isMonitoring 
                            ? "Active - ${_alerts.length} hazards detected"
                            : "Paused",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "AI ${Random().nextInt(20) + 80}%",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hazard List
          Expanded(
            child: _alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 80, color: Colors.green),
                        SizedBox(height: 16),
                        Text(
                          "No Hazards Detected",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "All routes are clear and safe",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _alerts.length,
                    itemBuilder: (context, index) {
                      final alert = _alerts[index];
                      return HazardAlertCard(
                        alert: alert,
                        onDismiss: _dismissHazard,
                        index: index,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_alerts.length < _hazardDatabase.length) {
            _simulateNewHazardDetection();
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hazardTimer?.cancel();
    super.dispose();
  }
}

class HazardAlertCard extends StatelessWidget {
  final HazardAlert alert;
  final Function(String) onDismiss;
  final int index;

  const HazardAlertCard({
    required this.alert,
    required this.onDismiss,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: _getSeverityColor(alert.severity).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getSeverityLightColor(alert.severity).withOpacity(0.1),
              _getSeverityLightColor(alert.severity).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with severity and confidence
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(alert.severity),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _getSeverityText(alert.severity),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${alert.confidence}% AI Confidence",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Hazard details
              Row(
                children: [
                  Icon(
                    _getAlertIcon(alert.type),
                    color: _getSeverityColor(alert.severity),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAlertTitle(alert.type),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          alert.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Reason and details
              Text(
                alert.reason,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 12),

              // Additional info and actions
              Row(
                children: [
                  Icon(Icons.timelapse, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "ETA: ${alert.eta}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Spacer(),
                  Icon(Icons.place, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "${alert.distance}km",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () => onDismiss(alert.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Dismiss",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Colors.red;
      case Severity.medium:
        return Colors.orange;
      case Severity.low:
        return Colors.yellow;
    }
  }

  Color _getSeverityLightColor(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Color(0xFFFF6B6B);
      case Severity.medium:
        return Color(0xFFFFA726);
      case Severity.low:
        return Color(0xFFFFEE58);
    }
  }

  IconData _getAlertIcon(HazardType type) {
    switch (type) {
      case HazardType.accidentProne:
        return Icons.car_crash;
      case HazardType.roadWork:
        return Icons.construction;
      case HazardType.weather:
        return Icons.cloudy_snowing;
      case HazardType.traffic:
        return Icons.traffic;
    }
  }

  String _getAlertTitle(HazardType type) {
    switch (type) {
      case HazardType.accidentProne:
        return "HIGH RISK ZONE";
      case HazardType.roadWork:
        return "CONSTRUCTION AHEAD";
      case HazardType.weather:
        return "WEATHER HAZARD";
      case HazardType.traffic:
        return "TRAFFIC CONGESTION";
    }
  }

  String _getSeverityText(Severity severity) {
    switch (severity) {
      case Severity.high:
        return "HIGH ALERT";
      case Severity.medium:
        return "MEDIUM ALERT";
      case Severity.low:
        return "LOW ALERT";
    }
  }
}

enum HazardType { accidentProne, roadWork, weather, traffic }
enum Severity { low, medium, high }

class HazardAlert {
  final String id;
  final HazardType type;
  final String location;
  final int confidence;
  final String reason;
  final Severity severity;
  final double distance;
  final String eta;
  final String coordinates;

  HazardAlert({
    required this.id,
    required this.type,
    required this.location,
    required this.confidence,
    required this.reason,
    required this.severity,
    required this.distance,
    required this.eta,
    required this.coordinates,
  });
}