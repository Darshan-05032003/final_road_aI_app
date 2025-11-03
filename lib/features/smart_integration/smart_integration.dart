// lib/features/smart_integration/smart_integration.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class SmartIntegration extends StatefulWidget {
  @override
  _SmartIntegrationState createState() => _SmartIntegrationState();
}

class _SmartIntegrationState extends State<SmartIntegration> 
    with SingleTickerProviderStateMixin {
  late AnimationController _integrationController;
  late Animation<double> _pulseAnimation;
  
  List<SmartDevice> _connectedDevices = [];
  TrafficLight? _nextTrafficLight;
  bool _greenWaveActive = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _integrationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _integrationController, curve: Curves.easeInOut)
    );

    _loadConnectedDevices();
    _startTrafficLightSimulation();
  }

  void _loadConnectedDevices() {
    setState(() {
      _connectedDevices = [
        SmartDevice(
          id: '1',
          type: DeviceType.trafficLight,
          name: "Smart Traffic Light #247",
          status: "Connected",
          signal: 95,
          location: "Main St & 5th Ave",
          isActive: true,
        ),
        SmartDevice(
          id: '2',
          type: DeviceType.roadSensor,
          name: "Road Condition Sensor",
          status: "Monitoring",
          signal: 88,
          location: "Highway 101, Mile 25",
          isActive: true,
        ),
        SmartDevice(
          id: '3',
          type: DeviceType.emergency,
          name: "Emergency Vehicle Link",
          status: "Standby",
          signal: 92,
          location: "Citywide",
          isActive: false,
        ),
        SmartDevice(
          id: '4',
          type: DeviceType.parking,
          name: "Smart Parking System",
          status: "Connected",
          signal: 85,
          location: "Downtown Area",
          isActive: true,
        ),
      ];
    });
  }

  void _startTrafficLightSimulation() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        _updateTrafficLightData();
      }
    });
  }

  void _updateTrafficLightData() {
    final random = Random();
    final lights = [
      TrafficLight(
        id: '1',
        location: "Main St & 5th Ave",
        distance: 0.8,
        currentState: random.nextBool() ? LightState.green : LightState.red,
        timeToChange: random.nextInt(20) + 5,
        canOptimize: random.nextBool(),
      ),
      TrafficLight(
        id: '2',
        location: "Oak St & Pine Rd",
        distance: 1.5,
        currentState: random.nextBool() ? LightState.green : LightState.yellow,
        timeToChange: random.nextInt(15) + 10,
        canOptimize: random.nextBool(),
      ),
    ];

    final optimalLight = lights.firstWhere(
      (light) => light.canOptimize && light.distance < 2.0,
      orElse: () => lights.first,
    );

    setState(() {
      _nextTrafficLight = optimalLight;
      _greenWaveActive = optimalLight.canOptimize && optimalLight.currentState == LightState.green;
    });
  }

  void _toggleConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });
    
    if (_isConnected) {
      _loadConnectedDevices();
      _startTrafficLightSimulation();
    }
  }

  void _optimizeRoute() {
    setState(() {
      _greenWaveActive = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.waves, color: Colors.white),
            SizedBox(width: 8),
            Text("Green Wave Activated! Optimizing traffic light timing..."),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isConnected 
              ? [Colors.green, Colors.green[700]!]
              : [Colors.red, Colors.red[700]!],
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
              child: Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isConnected ? "SMART CITY CONNECTED" : "DISCONNECTED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _isConnected 
                      ? "${_connectedDevices.length} devices connected"
                      : "No V2X connection",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isConnected,
            onChanged: (value) => _toggleConnection(),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficLightInfo() {
    if (_nextTrafficLight == null) return SizedBox.shrink();

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.traffic, color: _getLightColor(_nextTrafficLight!.currentState)),
                SizedBox(width: 8),
                Text(
                  "Next Traffic Light",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              _nextTrafficLight!.location,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLightColor(_nextTrafficLight!.currentState).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLightStateText(_nextTrafficLight!.currentState),
                    style: TextStyle(
                      color: _getLightColor(_nextTrafficLight!.currentState),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text("•"),
                SizedBox(width: 8),
                Text("${_nextTrafficLight!.distance}km away"),
                SizedBox(width: 8),
                Text("•"),
                SizedBox(width: 8),
                Text("Changes in ${_nextTrafficLight!.timeToChange}s"),
              ],
            ),
            SizedBox(height: 12),
            if (_nextTrafficLight!.canOptimize && !_greenWaveActive)
              ElevatedButton(
                onPressed: _optimizeRoute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text("Activate Green Wave"),
              ),
            if (_greenWaveActive)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Green Wave Active - You'll hit consecutive green lights",
                        style: TextStyle(color: Colors.green),
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

  Widget _buildConnectedDevices() {
    return ExpansionTile(
      title: Text(
        "Connected Devices (${_connectedDevices.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        ..._connectedDevices.map((device) => DeviceCard(device: device)),
      ],
    );
  }

  Widget _buildSmartFeatures() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Smart City Features",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FeatureChip(
                icon: Icons.emergency,
                label: "Emergency Priority",
                onTap: () => _activateEmergencyPriority(),
              ),
              FeatureChip(
                icon: Icons.park,
                label: "Smart Parking",
                onTap: () => _findSmartParking(),
              ),
              FeatureChip(
                icon: Icons.construction,
                label: "Road Work Alerts",
                onTap: () => _checkRoadWork(),
              ),
              FeatureChip(
                icon: Icons.electric_car,
                label: "EV Charging",
                onTap: () => _findEVCharging(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _activateEmergencyPriority() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚑 Emergency vehicle priority activated"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _findSmartParking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🅿️ Searching for smart parking spots..."),
      ),
    );
  }

  void _checkRoadWork() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚧 Checking for road work alerts..."),
      ),
    );
  }

  void _findEVCharging() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🔌 Finding EV charging stations..."),
      ),
    );
  }

  Color _getLightColor(LightState state) {
    switch (state) {
      case LightState.green:
        return Colors.green;
      case LightState.yellow:
        return Colors.orange;
      case LightState.red:
        return Colors.red;
    }
  }

  String _getLightStateText(LightState state) {
    switch (state) {
      case LightState.green:
        return "GREEN";
      case LightState.yellow:
        return "YELLOW";
      case LightState.red:
        return "RED";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart City Integration"),
        backgroundColor: Colors.cyan,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildConnectionStatus(),
          Expanded(
            child: ListView(
              children: [
                _buildTrafficLightInfo(),
                _buildSmartFeatures(),
                _buildConnectedDevices(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _integrationController.dispose();
    super.dispose();
  }
}

class DeviceCard extends StatelessWidget {
  final SmartDevice device;

  const DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getDeviceColor(device.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getDeviceIcon(device.type),
            color: _getDeviceColor(device.type),
          ),
        ),
        title: Text(device.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.location),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: device.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    device.status,
                    style: TextStyle(
                      color: device.isActive ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.signal_cellular_alt, size: 12, color: Colors.blue),
                SizedBox(width: 4),
                Text("${device.signal}%", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: device.isActive
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.error, color: Colors.orange),
      ),
    );
  }

  Color _getDeviceColor(DeviceType type) {
    switch (type) {
      case DeviceType.trafficLight:
        return Colors.blue;
      case DeviceType.roadSensor:
        return Colors.green;
      case DeviceType.emergency:
        return Colors.red;
      case DeviceType.parking:
        return Colors.purple;
    }
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.trafficLight:
        return Icons.traffic;
      case DeviceType.roadSensor:
        return Icons.sensors;
      case DeviceType.emergency:
        return Icons.emergency;
      case DeviceType.parking:
        return Icons.local_parking;
    }
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FeatureChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.blue[50],
    );
  }
}

enum DeviceType { trafficLight, roadSensor, emergency, parking }
enum LightState { green, yellow, red }

class SmartDevice {
  final String id;
  final DeviceType type;
  final String name;
  final String status;
  final int signal;
  final String location;
  final bool isActive;

  SmartDevice({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.signal,
    required this.location,
    required this.isActive,
  });
}

class TrafficLight {
  final String id;
  final String location;
  final double distance;
  final LightState currentState;
  final int timeToChange;
  final bool canOptimize;

  TrafficLight({
    required this.id,
    required this.location,
    required this.distance,
    required this.currentState,
    required this.timeToChange,
    required this.canOptimize,
  });
}