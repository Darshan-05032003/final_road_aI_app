// lib/features/guardian_angel/guardian_angel.dart (Continued)
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GuardianAngelMode extends StatefulWidget {
  @override
  _GuardianAngelModeState createState() => _GuardianAngelModeState();
}

class _GuardianAngelModeState extends State<GuardianAngelMode> 
    with SingleTickerProviderStateMixin {
  late AnimationController _guardianController;
  late Animation<double> _pulseAnimation;
  
  bool _isActive = false;
  bool _isMonitoring = false;
  int _safetyScore = 85;
  List<SafetyAlert> _alerts = [];
  Timer? _safetyTimer;

  final List<GuardianContact> _trustedContacts = [
    GuardianContact(
      name: "Sarah Wilson",
      phone: "+1-555-0101",
      relationship: "Spouse",
      isPrimary: true,
      isNotified: false,
    ),
    GuardianContact(
      name: "John Davis", 
      phone: "+1-555-0102",
      relationship: "Brother",
      isPrimary: false,
      isNotified: false,
    ),
    GuardianContact(
      name: "Emergency Services",
      phone: "911",
      relationship: "Emergency",
      isPrimary: false,
      isNotified: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _guardianController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _guardianController, curve: Curves.easeInOut)
    );

    _loadSafetyAlerts();
  }

  void _loadSafetyAlerts() {
    setState(() {
      _alerts = [
        SafetyAlert(
          type: AlertType.nightDriving,
          message: "Night driving detected - Enhanced monitoring activated",
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          severity: Severity.medium,
        ),
        SafetyAlert(
          type: AlertType.remoteArea,
          message: "Entering low-population area - Safety check initiated",
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          severity: Severity.low,
        ),
      ];
    });
  }

  void _activateGuardianMode() {
    setState(() {
      _isActive = true;
      _isMonitoring = true;
    });

    _startSafetyMonitoring();
    _notifyContacts();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.health_and_safety, color: Colors.white),
            SizedBox(width: 8),
            Text("Guardian Angel Mode Activated"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deactivateGuardianMode() {
    setState(() {
      _isActive = false;
      _isMonitoring = false;
    });

    _safetyTimer?.cancel();
    _resetContacts();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Guardian Angel Mode Deactivated"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _startSafetyMonitoring() {
    _safetyTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_isMonitoring) {
        _updateSafetyMetrics();
      }
    });
  }

  void _updateSafetyMetrics() {
    final random = Random();
    setState(() {
      // Simulate safety score fluctuations
      _safetyScore = (_safetyScore + random.nextInt(5) - 2).clamp(70, 98);
      
      // Occasionally generate new alerts
      if (random.nextDouble() < 0.1) {
        _alerts.insert(0, SafetyAlert(
          type: AlertType.values[random.nextInt(AlertType.values.length)],
          message: _generateAlertMessage(),
          timestamp: DateTime.now(),
          severity: Severity.values[random.nextInt(Severity.values.length)],
        ));
      }
    });
  }

  String _generateAlertMessage() {
    final messages = [
      "Route safety analysis completed - All clear",
      "Weather conditions optimal for travel",
      "Traffic patterns normal - Safe driving conditions",
      "Vehicle systems operating within safe parameters",
      "Road conditions favorable - Maintain current speed",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  void _notifyContacts() {
    setState(() {
      for (var contact in _trustedContacts) {
        contact.isNotified = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("👼 Notified ${_trustedContacts.length} trusted contacts"),
      ),
    );
  }

  void _resetContacts() {
    setState(() {
      for (var contact in _trustedContacts) {
        contact.isNotified = false;
      }
    });
  }

  void _triggerEmergency() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text("Emergency Alert"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to trigger an emergency alert?"),
            SizedBox(height: 16),
            Text(
              "This will notify all emergency contacts and authorities with your location.",
              style: TextStyle(color: Colors.grey),
            ),
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
              _sendEmergencyAlerts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text("Trigger Emergency"),
          ),
        ],
      ),
    );
  }

  void _sendEmergencyAlerts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text("🚨 Emergency alerts sent to all contacts and authorities"),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );

    // Simulate emergency response
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _alerts.insert(0, SafetyAlert(
          type: AlertType.emergency,
          message: "EMERGENCY: Alerts sent to all contacts. Help is on the way.",
          timestamp: DateTime.now(),
          severity: Severity.high,
        ));
      });
    });
  }

  Widget _buildGuardianStatus() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isActive 
              ? [Colors.deepPurple, Colors.purple]
              : [Colors.grey, Colors.grey[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Icon(
              _isActive ? Icons.health_and_safety : Icons.security,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _isActive ? "GUARDIAN ACTIVE" : "GUARDIAN STANDBY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _isActive 
                ? "Monitoring your safety in real-time"
                : "Activate for enhanced safety monitoring",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (!_isActive)
            ElevatedButton(
              onPressed: _activateGuardianMode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text("Activate Guardian Mode"),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _deactivateGuardianMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                  ),
                  child: Text("Deactivate"),
                ),
                ElevatedButton(
                  onPressed: _triggerEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Emergency"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSafetyMetrics() {
    if (!_isActive) return SizedBox.shrink();

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Safety Metrics",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              value: _safetyScore / 100,
              strokeWidth: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(_safetyScore)),
            ),
            SizedBox(height: 16),
            Text(
              "$_safetyScore%",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Overall Safety Score",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem("Route Safety", "92%", Icons.route),
                _buildMetricItem("Vehicle Health", "88%", Icons.directions_car),
                _buildMetricItem("Environment", "95%", Icons.wb_sunny),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.deepPurple, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTrustedContacts() {
    return ExpansionTile(
      title: Text(
        "Trusted Contacts (${_trustedContacts.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        ..._trustedContacts.map((contact) => ContactCard(contact: contact)),
      ],
    );
  }

  Widget _buildSafetyAlerts() {
    return ExpansionTile(
      title: Text(
        "Safety Alerts (${_alerts.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        ..._alerts.map((alert) => AlertCard(alert: alert)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: Icon(Icons.location_on, color: Colors.blue),
                label: Text("Share Live Location"),
                onPressed: _shareLiveLocation,
              ),
              ActionChip(
                avatar: Icon(Icons.phone, color: Colors.green),
                label: Text("Quick Check-in"),
                onPressed: _quickCheckIn,
              ),
              ActionChip(
                avatar: Icon(Icons.timer, color: Colors.orange),
                label: Text("Set ETA Alert"),
                onPressed: _setETAAlert,
              ),
              ActionChip(
                avatar: Icon(Icons.medical_services, color: Colors.red),
                label: Text("Medical Info"),
                onPressed: _showMedicalInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareLiveLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📍 Live location sharing activated with trusted contacts"),
      ),
    );
  }

  void _quickCheckIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Check-in sent: All safe and on route"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _setETAAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set ETA Alert"),
        content: Text("Contacts will be notified if you don't arrive within your estimated time."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("⏰ ETA alert set for 30 minutes")),
              );
            },
            child: Text("Set Alert"),
          ),
        ],
      ),
    );
  }

  void _showMedicalInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Medical Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Blood Type: O+"),
            Text("Allergies: Penicillin, Peanuts"),
            Text("Emergency Contact: Sarah Wilson"),
            Text("Insurance: HealthGuard Inc."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guardian Angel Mode"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildGuardianStatus(),
          Expanded(
            child: ListView(
              children: [
                if (_isActive) _buildSafetyMetrics(),
                _buildQuickActions(),
                _buildTrustedContacts(),
                _buildSafetyAlerts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _guardianController.dispose();
    _safetyTimer?.cancel();
    super.dispose();
  }
}

class ContactCard extends StatelessWidget {
  final GuardianContact contact;

  const ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: contact.isPrimary ? Colors.deepPurple : Colors.blue,
          child: Icon(
            contact.isPrimary ? Icons.person : Icons.contact_phone,
            color: Colors.white,
          ),
        ),
        title: Text(contact.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.phone),
            Text(contact.relationship, style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (contact.isNotified)
              Icon(Icons.check_circle, color: Colors.green, size: 20),
            if (contact.isPrimary)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "PRIMARY",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final SafetyAlert alert;

  const AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getAlertColor(alert.severity).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getAlertIcon(alert.type),
                color: _getAlertColor(alert.severity),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.message,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTimeAgo(alert.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAlertColor(alert.severity).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getSeverityText(alert.severity),
                style: TextStyle(
                  color: _getAlertColor(alert.severity),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAlertColor(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Colors.red;
      case Severity.medium:
        return Colors.orange;
      case Severity.low:
        return Colors.green;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.nightDriving:
        return Icons.nightlight_round;
      case AlertType.remoteArea:
        return Icons.place;
      case AlertType.emergency:
        return Icons.warning;
      case AlertType.safetyCheck:
        return Icons.security;
      case AlertType.routeUpdate:
        return Icons.route;
    }
  }

  String _getSeverityText(Severity severity) {
    switch (severity) {
      case Severity.high:
        return "HIGH";
      case Severity.medium:
        return "MEDIUM";
      case Severity.low:
        return "LOW";
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes}m ago";
    if (difference.inDays < 1) return "${difference.inHours}h ago";
    return "${difference.inDays}d ago";
  }
}

enum AlertType { nightDriving, remoteArea, emergency, safetyCheck, routeUpdate }
enum Severity { low, medium, high }

class GuardianContact {
  String name;
  String phone;
  String relationship;
  bool isPrimary;
  bool isNotified;

  GuardianContact({
    required this.name,
    required this.phone,
    required this.relationship,
    required this.isPrimary,
    required this.isNotified,
  });
}

class SafetyAlert {
  final AlertType type;
  final String message;
  final DateTime timestamp;
  final Severity severity;

  SafetyAlert({
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
  });
}