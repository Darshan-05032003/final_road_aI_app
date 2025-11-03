// lib/features/safety_gamification/safety_gamification.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class SafetyGamification extends StatefulWidget {
  @override
  _SafetyGamificationState createState() => _SafetyGamificationState();
}

class _SafetyGamificationState extends State<SafetyGamification> 
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  double _safetyScore = 85.0;
  int _points = 1250;
  int _level = 3;
  int _streak = 7;
  List<SafetyChallenge> _challenges = [];
  List<SafetyAchievement> _achievements = [];
  List<DrivingSession> _recentSessions = [];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: _safetyScore / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    _progressController.forward();

    _loadChallenges();
    _loadAchievements();
    _loadRecentSessions();
    
    // Simulate real-time score updates
    _startScoreSimulation();
  }

  void _loadChallenges() {
    setState(() {
      _challenges = [
        SafetyChallenge(
          id: '1',
          title: "Speed Limit Champion",
          description: "Maintain speed limit for 50km",
          progress: 35,
          total: 50,
          points: 250,
          icon: Icons.speed,
          color: Colors.blue,
        ),
        SafetyChallenge(
          id: '2',
          title: "Smooth Braking Master",
          description: "10 consecutive smooth stops",
          progress: 8,
          total: 10,
          points: 150,
          icon: Icons.fitness_center,
          color: Colors.green,
        ),
        SafetyChallenge(
          id: '3',
          title: "Weekend Warrior",
          description: "Drive safely for 3 weekend trips",
          progress: 2,
          total: 3,
          points: 300,
          icon: Icons.weekend,
          color: Colors.orange,
        ),
        SafetyChallenge(
          id: '4',
          title: "Night Safety Pro",
          description: "Complete 5 safe night drives",
          progress: 3,
          total: 5,
          points: 200,
          icon: Icons.nightlight_round,
          color: Colors.purple,
        ),
      ];
    });
  }

  void _loadAchievements() {
    setState(() {
      _achievements = [
        SafetyAchievement(
          id: '1',
          title: "First Safe Drive",
          description: "Complete your first safe driving session",
          icon: Icons.emoji_events,
          color: Colors.amber,
          achieved: true,
          points: 100,
        ),
        SafetyAchievement(
          id: '2',
          title: "Speed Limit Hero",
          description: "Maintain perfect speed for 100km",
          icon: Icons.speed,
          color: Colors.blue,
          achieved: true,
          points: 200,
        ),
        SafetyAchievement(
          id: '3',
          title: "Eco Driver",
          description: "Achieve 90% fuel efficiency",
          icon: Icons.eco,
          color: Colors.green,
          achieved: false,
          points: 150,
        ),
        SafetyAchievement(
          id: '4',
          title: "Weekend Champion",
          description: "Complete all weekend challenges",
          icon: Icons.weekend,
          color: Colors.orange,
          achieved: false,
          points: 300,
        ),
        SafetyAchievement(
          id: '5',
          title: "Safety Streak",
          description: "7 days of safe driving",
          icon: Icons.local_fire_department,
          color: Colors.red,
          achieved: true,
          points: 250,
        ),
      ];
    });
  }

  void _loadRecentSessions() {
    setState(() {
      _recentSessions = [
        DrivingSession(
          id: '1',
          date: DateTime.now().subtract(Duration(hours: 2)),
          duration: 35,
          distance: 25.3,
          safetyScore: 92,
          pointsEarned: 45,
          route: "Home to Office",
        ),
        DrivingSession(
          id: '2',
          date: DateTime.now().subtract(Duration(days: 1)),
          duration: 48,
          distance: 32.1,
          safetyScore: 88,
          pointsEarned: 38,
          route: "Office to Gym",
        ),
        DrivingSession(
          id: '3',
          date: DateTime.now().subtract(Duration(days: 2)),
          duration: 25,
          distance: 18.7,
          safetyScore: 95,
          pointsEarned: 52,
          route: "Gym to Mall",
        ),
      ];
    });
  }

  void _startScoreSimulation() {
    // Simulate real-time score changes
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          // Small random fluctuations in score
          final change = (Random().nextDouble() - 0.5) * 2;
          _safetyScore = (_safetyScore + change).clamp(75.0, 98.0);
          
          // Update progress animation
          _progressAnimation = Tween<double>(
            begin: _progressAnimation.value,
            end: _safetyScore / 100,
          ).animate(CurvedAnimation(
            parent: _progressController,
            curve: Curves.easeOut,
          ));
          
          _progressController.forward(from: 0.0);
        });
      }
    });
  }

  void _completeChallenge(String challengeId) {
    setState(() {
      final challenge = _challenges.firstWhere((c) => c.id == challengeId);
      final pointsEarned = challenge.points;
      
      _points += pointsEarned;
      _safetyScore = (_safetyScore + 2).clamp(0.0, 100.0);
      _streak++;
      
      // Update progress animation
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: _safetyScore / 100,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ));
      _progressController.forward(from: 0.0);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🎉 Challenge completed! +$pointsEarned points"),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  Widget _buildSafetyScoreCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              "SAFETY SCORE",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _progressAnimation.value,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _safetyScore.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "/100",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("LEVEL", _level.toString(), Icons.star),
                _buildStatItem("POINTS", _points.toString(), Icons.emoji_events),
                _buildStatItem("STREAK", "$_streak days", Icons.local_fire_department),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
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

  Widget _buildChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Active Challenges",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ..._challenges.map((challenge) => ChallengeCard(
          challenge: challenge,
          onComplete: () => _completeChallenge(challenge.id),
        )).toList(),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Achievements",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _achievements.map((achievement) => AchievementBadge(
              achievement: achievement,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Recent Sessions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ..._recentSessions.map((session) => SessionCard(
          session: session,
        )).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safety Gamification"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSafetyScoreCard(),
            SizedBox(height: 24),
            _buildChallengesSection(),
            SizedBox(height: 24),
            _buildAchievementsSection(),
            SizedBox(height: 24),
            _buildRecentSessions(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }
}

class ChallengeCard extends StatelessWidget {
  final SafetyChallenge challenge;
  final VoidCallback onComplete;

  const ChallengeCard({
    required this.challenge,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = challenge.progress / challenge.total;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: challenge.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(challenge.icon, color: challenge.color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    challenge.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${challenge.progress}/${challenge.total} (${(progress * 100).toInt()}%)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: challenge.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "+${challenge.points}",
                    style: TextStyle(
                      color: challenge.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (progress < 1.0)
                  ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: challenge.color,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text("Complete"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final SafetyAchievement achievement;

  const AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: achievement.achieved ? 4 : 2,
        color: achievement.achieved 
            ? achievement.color.withOpacity(0.1)
            : Colors.grey[100],
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(
                achievement.icon,
                size: 32,
                color: achievement.achieved ? achievement.color : Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: achievement.achieved ? Colors.black87 : Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              if (achievement.achieved)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: achievement.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "+${achievement.points}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final DrivingSession session;

  const SessionCard({required this.session});

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
                color: _getScoreColor(session.safetyScore).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car,
                color: _getScoreColor(session.safetyScore),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.route,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${session.distance}km • ${session.duration}min",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(session.safetyScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${session.safetyScore}",
                    style: TextStyle(
                      color: _getScoreColor(session.safetyScore),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "+${session.pointsEarned} pts",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.orange;
    return Colors.red;
  }
}

class SafetyChallenge {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int total;
  final int points;
  final IconData icon;
  final Color color;

  SafetyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.total,
    required this.points,
    required this.icon,
    required this.color,
  });
}

class SafetyAchievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool achieved;
  final int points;

  SafetyAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.achieved,
    required this.points,
  });
}

class DrivingSession {
  final String id;
  final DateTime date;
  final int duration;
  final double distance;
  final int safetyScore;
  final int pointsEarned;
  final String route;

  DrivingSession({
    required this.id,
    required this.date,
    required this.duration,
    required this.distance,
    required this.safetyScore,
    required this.pointsEarned,
    required this.route,
  });
}