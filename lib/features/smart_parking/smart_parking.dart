// lib/features/smart_parking/smart_parking.dart
import 'package:flutter/material.dart';
import 'dart:math';

class SmartParkingOracle extends StatefulWidget {
  @override
  _SmartParkingOracleState createState() => _SmartParkingOracleState();
}

class _SmartParkingOracleState extends State<SmartParkingOracle> 
    with SingleTickerProviderStateMixin {
  late AnimationController _parkingController;
  late Animation<double> 
  
  
  _pulseAnimation;
  
  ParkingPrediction? _currentPrediction;
  List<ParkingSpot> _availableSpots = [];
  String _selectedDestination = "Downtown Mall";
  bool _isSearching = false;

  final List<String> _popularDestinations = [
    "Downtown Mall",
    "Central Station",
    "City Hospital",
    "Tech Park",
    "Sports Arena",
    "University Campus",
  ];

  @override
  void initState() {
    super.initState();
    _parkingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _parkingController, curve: Curves.easeInOut)
    );

    _predictParking(_selectedDestination);
  }

  void _predictParking(String destination) {
    setState(() {
      _isSearching = true;
      _selectedDestination = destination;
    });

    // Simulate AI prediction
    Future.delayed(Duration(seconds: 2), () {
      final random = Random();
      final confidence = random.nextInt(30) + 65; // 65-95% confidence
      final price = (random.nextDouble() * 5 + 8).toStringAsFixed(2); // $8-13

      setState(() {
        _currentPrediction = ParkingPrediction(
          destination: destination,
          confidence: confidence,
          availability: _getAvailabilityText(confidence),
          bestTime: _getBestTime(),
          price: double.parse(price),
          canReserve: random.nextBool(),
          estimatedSpots: random.nextInt(20) + 5,
        );

        _availableSpots = List.generate(3, (index) => ParkingSpot(
          id: '$index',
          location: "$destination - Lot ${index + 1}",
          distance: (random.nextDouble() * 0.5 + 0.1).toStringAsFixed(1),
          price: (random.nextDouble() * 3 + 8).toStringAsFixed(2),
          availability: random.nextInt(10) + 5,
          features: _getRandomFeatures(),
          isSmart: random.nextBool(),
        ));

        _isSearching = false;
      });
    });
  }

  String _getAvailabilityText(int confidence) {
    if (confidence >= 85) return "High Availability";
    if (confidence >= 75) return "Good Availability";
    if (confidence >= 65) return "Limited Availability";
    return "Low Availability";
  }

  String _getBestTime() {
    final times = ["Now", "In 15 mins", "In 30 mins", "After 6 PM"];
    return times[Random().nextInt(times.length)];
  }

  List<String> _getRandomFeatures() {
    final allFeatures = ["Covered", "EV Charging", "Security", "24/7 Access", "Valet"];
    final count = Random().nextInt(3) + 2;
    return allFeatures.sublist(0, count);
  }

  void _reserveSpot(ParkingSpot spot) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.local_parking, color: Colors.white),
            SizedBox(width: 8),
            Text("Reserved parking at ${spot.location}"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToSpot(ParkingSpot spot) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚗 Navigating to ${spot.location}..."),
      ),
    );
  }

  Widget _buildPredictionCard() {
    if (_currentPrediction == null) return SizedBox.shrink();

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
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_parking, color: Colors.amber),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentPrediction!.destination,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Parking Prediction",
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPredictionStat(
                  "${_currentPrediction!.confidence}%",
                  "Confidence",
                  Colors.green,
                ),
                _buildPredictionStat(
                  _currentPrediction!.availability,
                  "Availability",
                  Colors.blue,
                ),
                _buildPredictionStat(
                  _currentPrediction!.bestTime,
                  "Best Time",
                  Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_currentPrediction!.canReserve)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Smart Reservation Available",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "Reserve now for \$${_currentPrediction!.price}",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showReservationOptions(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Reserve"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionStat(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Destination",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularDestinations.map((destination) {
              final isSelected = _selectedDestination == destination;
              return ChoiceChip(
                label: Text(destination),
                selected: isSelected,
                onSelected: (selected) => _predictParking(destination),
                selectedColor: Colors.amber,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSpots() {
    return ExpansionTile(
      title: Text(
        "Available Spots (${_availableSpots.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        ..._availableSpots.map((spot) => ParkingSpotCard(
          spot: spot,
          onReserve: _reserveSpot,
          onNavigate: _navigateToSpot,
        )).toList(),
      ],
    );
  }

  void _showReservationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reserve Parking",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.timer, color: Colors.blue),
              title: Text("Reserve for 1 hour"),
              subtitle: Text("\$${_currentPrediction!.price}"),
              trailing: ElevatedButton(
                onPressed: () => _confirmReservation("1 hour"),
                child: Text("Reserve"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.timer, color: Colors.green),
              title: Text("Reserve for 2 hours"),
              subtitle: Text("\$${(_currentPrediction!.price * 1.8).toStringAsFixed(2)}"),
              trailing: ElevatedButton(
                onPressed: () => _confirmReservation("2 hours"),
                child: Text("Reserve"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.timer, color: Colors.orange),
              title: Text("Reserve for 4 hours"),
              subtitle: Text("\$${(_currentPrediction!.price * 3.2).toStringAsFixed(2)}"),
              trailing: ElevatedButton(
                onPressed: () => _confirmReservation("4 hours"),
                child: Text("Reserve"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReservation(String duration) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Reserved parking for $duration at \$${_currentPrediction!.price}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Parking Oracle"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.psychology, color: Colors.white, size: 30),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Parking Oracle",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "AI-powered parking predictions",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isSearching)
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("AI is predicting parking availability..."),
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  _buildDestinationSelector(),
                  _buildPredictionCard(),
                  _buildAvailableSpots(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _parkingController.dispose();
    super.dispose();
  }
}

class ParkingSpotCard extends StatelessWidget {
  final ParkingSpot spot;
  final Function(ParkingSpot) onReserve;
  final Function(ParkingSpot) onNavigate;

  const ParkingSpotCard({
    required this.spot,
    required this.onReserve,
    required this.onNavigate,
  });

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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: spot.isSmart ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    spot.isSmart ? Icons.smart_toy : Icons.local_parking,
                    color: spot.isSmart ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.location,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${spot.distance} km • \$${spot.price}/hour",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${spot.availability} spots",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: spot.features.map((feature) => Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  feature,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onNavigate(spot),
                    child: Text("Navigate"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onReserve(spot),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Reserve"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingPrediction {
  final String destination;
  final int confidence;
  final String availability;
  final String bestTime;
  final double price;
  final bool canReserve;
  final int estimatedSpots;

  ParkingPrediction({
    required this.destination,
    required this.confidence,
    required this.availability,
    required this.bestTime,
    required this.price,
    required this.canReserve,
    required this.estimatedSpots,
  });
}

class ParkingSpot {
  final String id;
  final String location;
  final String distance;
  final String price;
  final int availability;
  final List<String> features;
  final bool isSmart;

  ParkingSpot({
    required this.id,
    required this.location,
    required this.distance,
    required this.price,
    required this.availability,
    required this.features,
    required this.isSmart,
  });
}