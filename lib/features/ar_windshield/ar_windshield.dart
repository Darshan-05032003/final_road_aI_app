// lib/features/ar_windshield/ar_windshield.dart
import 'package:flutter/material.dart';
import 'dart:math';

class ARWindshield extends StatefulWidget {
  @override
  _ARWindshieldState createState() => _ARWindshieldState();
}

class _ARWindshieldState extends State<ARWindshield> 
    with SingleTickerProviderStateMixin {
  late AnimationController _arController;
  late Animation<double> _fadeAnimation;
  
  List<ARObject> _arObjects = [];
  bool _isARActive = true;
  String _currentView = "navigation";

  @override
  void initState() {
    super.initState();
    _arController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _arController, curve: Curves.easeInOut)
    );

    _loadARObjects();
  }

  void _loadARObjects() {
    setState(() {
      _arObjects = [
        ARObject(
          id: '1',
          type: ARType.navigation,
          title: "Next Turn",
          subtitle: "Right in 500m",
          position: Offset(0.7, 0.3),
          color: Colors.blue,
          icon: Icons.turn_right,
        ),
        ARObject(
          id: '2',
          type: ARType.speed,
          title: "Speed Limit",
          subtitle: "65 mph",
          position: Offset(0.8, 0.1),
          color: Colors.green,
          icon: Icons.speed,
        ),
        ARObject(
          id: '3',
          type: ARType.hazard,
          title: "Construction",
          subtitle: "1.2km ahead",
          position: Offset(0.4, 0.6),
          color: Colors.orange,
          icon: Icons.construction,
        ),
        ARObject(
          id: '4',
          type: ARType.poi,
          title: "Gas Station",
          subtitle: "Next exit",
          position: Offset(0.2, 0.4),
          color: Colors.purple,
          icon: Icons.local_gas_station,
        ),
        ARObject(
          id: '5',
          type: ARType.traffic,
          title: "Traffic Alert",
          subtitle: "Slow traffic ahead",
          position: Offset(0.5, 0.8),
          color: Colors.red,
          icon: Icons.traffic,
        ),
      ];
    });
  }

  void _toggleAR() {
    setState(() {
      _isARActive = !_isARActive;
    });
  }

  void _changeView(String view) {
    setState(() {
      _currentView = view;
    });
  }

  bool _shouldShowObject(ARObject object) {
    if (!_isARActive) return false;
    
    switch (_currentView) {
      case "navigation":
        return object.type == ARType.navigation || object.type == ARType.speed;
      case "hazards":
        return object.type == ARType.hazard || object.type == ARType.traffic;
      case "poi":
        return object.type == ARType.poi;
      case "all":
        return true;
      default:
        return true;
    }
  }

  Widget _buildAROverlay() {
    return Stack(
      children: _arObjects.map((arObject) {
        if (_shouldShowObject(arObject)) {
          return Positioned(
            left: MediaQuery.of(context).size.width * arObject.position.dx,
            top: MediaQuery.of(context).size.height * arObject.position.dy,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ARElement(object: arObject),
            ),
          );
        }
        return SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildRoadView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(
        painter: RoadPainter(),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AR Windshield",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _isARActive,
                    onChanged: (value) => _toggleAR(),
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildViewButton("navigation", "Navigation", Icons.navigation),
                    _buildViewButton("hazards", "Hazards", Icons.warning),
                    _buildViewButton("poi", "POI", Icons.place),
                    _buildViewButton("all", "All", Icons.layers),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton(String view, String label, IconData icon) {
    final isSelected = _currentView == view;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _changeView(view),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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

  Widget _buildInfoPanel() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AR Overlay Active",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Displaying ${_currentView} information on windshield",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AR Windshield"),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Settings would go here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Road Background
          _buildRoadView(),
          
          // AR Overlay
          if (_isARActive) _buildAROverlay(),
          
          // UI Controls
          _buildInfoPanel(),
          _buildControlPanel(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _arController.dispose();
    super.dispose();
  }
}

class ARElement extends StatelessWidget {
  final ARObject object;

  const ARElement({required this.object});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: object.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: object.color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(object.icon, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                object.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                object.subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final roadPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    // Draw road
    final roadPath = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(0, size.height * 0.6)
      ..close();
    
    canvas.drawPath(roadPath, roadPaint);

    // Draw road markings
    final dashPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, size.height * 0.5),
        Offset(i + 20, size.height * 0.5),
        dashPaint,
      );
    }

    // Draw horizon
    final horizonPaint = Paint()
      ..color = Colors.blue[800]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height * 0.4)),
      horizonPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum ARType { navigation, speed, hazard, poi, traffic }

class ARObject {
  final String id;
  final ARType type;
  final String title;
  final String subtitle;
  final Offset position;
  final Color color;
  final IconData icon;

  ARObject({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.position,
    required this.color,
    required this.icon,
  });
}