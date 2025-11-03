// lib/features/emergency_response/emergency_response.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class EmergencyResponse extends StatefulWidget {
  @override
  _EmergencyResponseState createState() => _EmergencyResponseState();
}

class _EmergencyResponseSystem {
  static bool _crashDetected = false;
  static DateTime? _lastCrashTime;

  static bool detectCrash(double impactForce, double speed, double angle) {
    // Simulate crash detection logic
    final crashProbability = (impactForce * speed * (angle.abs() / 180)) / 1000;
    return crashProbability > 0.7 && !_crashDetected;
  }

  static void triggerEmergencyProtocol() {
    _crashDetected = true;
    _lastCrashTime = DateTime.now();
  }

  static void reset() {
    _crashDetected = false;
  }
}

class _EmergencyResponseState extends State<EmergencyResponse> 
    with SingleTickerProviderStateMixin {
  late AnimationController _emergencyController;
  late Animation<double> _pulseAnimation;
  
  bool _isEmergencyActive = false;
  bool _isMonitoring = true;
  int _countdown = 10;
  Timer? _crashTimer;
  Timer? _countdownTimer;

  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      name: "Sarah Wilson",
      phone: "+1-555-0101",
      relationship: "Spouse",
      isPrimary: true,
    ),
    EmergencyContact(
      name: "John Davis",
      phone: "+1-555-0102", 
      relationship: "Brother",
      isPrimary: false,
    ),
    EmergencyContact(
      name: "Emergency Services",
      phone: "911",
      relationship: "Emergency",
      isPrimary: false,
    ),
  ];

  final MedicalInfo _medicalInfo = MedicalInfo(
    bloodType: "O+",
    allergies: ["Penicillin", "Peanuts"],
    conditions: ["Asthma"],
    emergencyContact: "Sarah Wilson",
    insuranceProvider: "HealthGuard Inc.",
  );

  @override
  void initState() {
    super.initState();
    _emergencyController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _emergencyController, curve: Curves.easeInOut)
    );

    _startCrashMonitoring();
  }

  void _startCrashMonitoring() {
    _crashTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_isMonitoring && !_isEmergencyActive) {
        _simulateCrashDetection();
      }
    });
  }

  void _simulateCrashDetection() {
    // Simulate random crash detection (5% chance)
    if (Random().nextDouble() < 0.05) {
      _triggerEmergency();
    }
  }

  void _triggerEmergency() {
    setState(() {
      _isEmergencyActive = true;
      _countdown = 10;
    });

    _startCountdown();
    _sendEmergencyAlerts();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        _contactEmergencyServices();
      }
    });
  }

  void _sendEmergencyAlerts() {
    // Simulate sending alerts to emergency contacts
    for (final contact in _emergencyContacts.where((c) => c.isPrimary)) {
      _showAlertSent(contact);
    }
  }

  void _showAlertSent(EmergencyContact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text("Alert sent to ${contact.name}"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _contactEmergencyServices() {
    _showEmergencyServicesContacted();
    _startLiveLocationSharing();
  }

  void _showEmergencyServicesContacted() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text("Emergency Services Alerted"),
          ],
        ),
        content: Text("Emergency services have been notified with your location and medical information."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _startLiveLocationSharing() {
    // Simulate live location sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📍 Live location sharing activated"),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _cancelEmergency() {
    _countdownTimer?.cancel();
    setState(() {
      _isEmergencyActive = false;
      _countdown = 10;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Emergency cancelled"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _testEmergency() {
    _triggerEmergency();
  }

  void _toggleMonitoring() {
    setState(() {
      _isMonitoring = !_isMonitoring;
    });
  }

  Widget _buildEmergencyStatus() {
    if (_isEmergencyActive) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.red[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(Icons.emergency, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "EMERGENCY DETECTED!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Contacting emergency services in",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "$_countdown",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancelEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Manual emergency call
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  child: Text("CALL NOW"),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.green[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.security, size: 60, color: Colors.white),
            SizedBox(height: 16),
            Text(
              "SYSTEM ACTIVE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Crash detection monitoring is ${_isMonitoring ? 'ENABLED' : 'PAUSED'}",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _testEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  child: Text("TEST"),
                ),
                ElevatedButton(
                  onPressed: _toggleMonitoring,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  child: Text(_isMonitoring ? "PAUSE" : "RESUME"),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmergencyContacts() {
    return ExpansionTile(
      title: Text(
        "Emergency Contacts",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        ..._emergencyContacts.map((contact) => ContactCard(contact: contact)),
      ],
    );
  }

  Widget _buildMedicalInfo() {
    return ExpansionTile(
      title: Text(
        "Medical Information",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        MedicalInfoCard(medicalInfo: _medicalInfo),
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
                avatar: Icon(Icons.medical_services, color: Colors.red),
                label: Text("Share Medical Info"),
                onPressed: () => _shareMedicalInfo(),
              ),
              ActionChip(
                avatar: Icon(Icons.location_on, color: Colors.blue),
                label: Text("Share Location"),
                onPressed: () => _shareLocation(),
              ),
              ActionChip(
                avatar: Icon(Icons.phone, color: Colors.green),
                label: Text("Call Emergency"),
                onPressed: () => _callEmergency(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareMedicalInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Medical Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Blood Type: ${_medicalInfo.bloodType}"),
            Text("Allergies: ${_medicalInfo.allergies.join(', ')}"),
            Text("Conditions: ${_medicalInfo.conditions.join(', ')}"),
            Text("Emergency Contact: ${_medicalInfo.emergencyContact}"),
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

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📍 Location shared with emergency contacts")),
    );
  }

  void _callEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📞 Calling emergency services...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Response"),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildEmergencyStatus(),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                _buildQuickActions(),
                _buildEmergencyContacts(),
                _buildMedicalInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    _crashTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}

class ContactCard extends StatelessWidget {
  final EmergencyContact contact;

  const ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: contact.isPrimary ? Colors.red : Colors.blue,
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
        trailing: contact.isPrimary 
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "PRIMARY",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class MedicalInfoCard extends StatelessWidget {
  final MedicalInfo medicalInfo;

  const MedicalInfoCard({required this.medicalInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Blood Type", medicalInfo.bloodType),
            _buildInfoRow("Allergies", medicalInfo.allergies.join(', ')),
            _buildInfoRow("Medical Conditions", medicalInfo.conditions.join(', ')),
            _buildInfoRow("Emergency Contact", medicalInfo.emergencyContact),
            _buildInfoRow("Insurance", medicalInfo.insuranceProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relationship,
    required this.isPrimary,
  });
}

class MedicalInfo {
  final String bloodType;
  final List<String> allergies;
  final List<String> conditions;
  final String emergencyContact;
  final String insuranceProvider;

  MedicalInfo({
    required this.bloodType,
    required this.allergies,
    required this.conditions,
    required this.emergencyContact,
    required this.insuranceProvider,
  });
}