// lib/features/trip_memories/trip_memories.dart
import 'package:flutter/material.dart';
import 'dart:math';

class TripMemoryCreator extends StatefulWidget {
  @override
  _TripMemoryCreatorState createState() => _TripMemoryCreatorState();
}

class _TripMemoryCreatorState extends State<TripMemoryCreator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _memoryController;
  late Animation<double> _scaleAnimation;
  
  List<TripMemory> _tripMemories = [];
  bool _isCreatingStory = false;

  @override
  void initState() {
    super.initState();
    _memoryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _memoryController, curve: Curves.elasticOut)
    );

    _memoryController.forward();
    _loadSampleMemories();
  }

  void _loadSampleMemories() {
    setState(() {
      _tripMemories = [
        TripMemory(
          id: '1',
          title: "Coastal Highway Adventure",
          date: DateTime.now().subtract(Duration(days: 2)),
          duration: 145,
          distance: 120.5,
          safetyScore: 94,
          highlights: [
            "Beautiful ocean views",
            "Perfect weather conditions",
            "Smooth driving experience",
          ],
          route: "San Francisco to Santa Cruz",
          photos: 12,
          pointsEarned: 85,
        ),
        TripMemory(
          id: '2',
          title: "Weekend Mountain Trip",
          date: DateTime.now().subtract(Duration(days: 7)),
          duration: 89,
          distance: 65.2,
          safetyScore: 88,
          highlights: [
            "Scenic mountain roads",
            "Wildlife spotting",
            "Excellent fuel efficiency",
          ],
          route: "Lake Tahoe Loop",
          photos: 8,
          pointsEarned: 72,
        ),
        TripMemory(
          id: '3',
          title: "City Commute Excellence",
          date: DateTime.now().subtract(Duration(days: 1)),
          duration: 45,
          distance: 18.7,
          safetyScore: 96,
          highlights: [
            "Perfect traffic timing",
            "Optimal speed maintenance",
            "Smooth braking throughout",
          ],
          route: "Home to Downtown",
          photos: 3,
          pointsEarned: 92,
        ),
      ];
    });
  }

  void _createNewMemory() {
    setState(() {
      _isCreatingStory = true;
    });

    // Simulate AI story creation
    Future.delayed(Duration(seconds: 3), () {
      final newMemory = TripMemory(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        title: "Today's Journey",
        date: DateTime.now(),
        duration: Random().nextInt(120) + 30,
        distance: Random().nextDouble() * 100 + 20,
        safetyScore: Random().nextInt(20) + 80,
        highlights: [
          "AI-optimized route",
          "Excellent driving conditions",
          "Memorable scenery",
        ],
        route: "AI-Generated Adventure",
        photos: Random().nextInt(10) + 1,
        pointsEarned: Random().nextInt(50) + 50,
      );

      setState(() {
        _tripMemories.insert(0, newMemory);
        _isCreatingStory = false;
      });

      _showMemoryCreated(newMemory);
    });
  }

  void _showMemoryCreated(TripMemory memory) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text("New trip memory created!")),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewMemory(TripMemory memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryDetailPage(memory: memory),
      ),
    );
  }

  void _shareMemory(TripMemory memory) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📤 Sharing trip memory..."),
      ),
    );
  }

  Widget _buildMemoryCard(TripMemory memory, int index) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () => _viewMemory(memory),
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
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.directions_car, color: Colors.blue),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_formatDate(memory.date)} • ${memory.route}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () => _shareMemory(memory),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatItem(Icons.timer, "${memory.duration} min"),
                    _buildStatItem(Icons.alt_route, "${memory.distance} km"),
                    _buildStatItem(Icons.photo_library, "${memory.photos} photos"),
                    _buildStatItem(Icons.emoji_events, "+${memory.pointsEarned} pts"),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: memory.safetyScore / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(memory.safetyScore)),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Safety Score: ${memory.safetyScore}%",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getScoreColor(memory.safetyScore).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getScoreText(memory.safetyScore),
                        style: TextStyle(
                          color: _getScoreColor(memory.safetyScore),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey),
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

  String _getScoreText(int score) {
    if (score >= 90) return "EXCELLENT";
    if (score >= 80) return "GOOD";
    return "NEEDS IMPROVEMENT";
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isCreatingStory ? null : _createNewMemory,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isCreatingStory
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text("AI is creating your story..."),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome),
                  SizedBox(width: 8),
                  Text("Create New Trip Memory"),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Memories"),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.purple],
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
                  child: Icon(Icons.photo_library, color: Colors.white, size: 30),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trip Memories",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_tripMemories.length} journeys captured",
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
          _buildCreateButton(),
          Expanded(
            child: _tripMemories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No Trip Memories Yet",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Create your first AI-powered trip story!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tripMemories.length,
                    itemBuilder: (context, index) {
                      return _buildMemoryCard(_tripMemories[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }
}

class MemoryDetailPage extends StatelessWidget {
  final TripMemory memory;

  const MemoryDetailPage({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Story"),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${_formatDate(memory.date)} • ${memory.route}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard("Duration", "${memory.duration} min", Icons.timer),
                _buildStatCard("Distance", "${memory.distance} km", Icons.alt_route),
                _buildStatCard("Safety Score", "${memory.safetyScore}%", Icons.security),
                _buildStatCard("Points Earned", "+${memory.pointsEarned}", Icons.emoji_events),
              ],
            ),
            SizedBox(height: 20),

            // AI-Generated Story
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "AI-Generated Story",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      _generateStory(memory),
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Highlights
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trip Highlights",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...memory.highlights.map((highlight) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Expanded(child: Text(highlight)),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateStory(TripMemory memory) {
    return """
On ${_formatDate(memory.date)}, you embarked on a ${memory.duration}-minute journey along ${memory.route}. 
Covering ${memory.distance} kilometers, this trip showcased your excellent driving skills with a safety score of ${memory.safetyScore}%.

${memory.highlights.join(' ')} The AI navigation system helped optimize your route for both safety and enjoyment, earning you ${memory.pointsEarned} points for your responsible driving.

This memory has been automatically created and analyzed by our AI to help you reflect on your journey and continue improving your driving habits.
""";
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}

class TripMemory {
  final String id;
  final String title;
  final DateTime date;
  final int duration;
  final double distance;
  final int safetyScore;
  final List<String> highlights;
  final String route;
  final int photos;
  final int pointsEarned;

  TripMemory({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.distance,
    required this.safetyScore,
    required this.highlights,
    required this.route,
    required this.photos,
    required this.pointsEarned,
  });
}