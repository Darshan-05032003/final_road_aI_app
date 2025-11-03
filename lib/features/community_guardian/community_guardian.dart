// lib/features/community_guardian/community_guardian.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class CommunityGuardian extends StatefulWidget {
  @override
  _CommunityGuardianState createState() => _CommunityGuardianState();
}

class _CommunityGuardianState extends State<CommunityGuardian> {
  List<RoadIssue> _reportedIssues = [];
  List<RoadIssue> _nearbyIssues = [];
  bool _isLoading = false;

  final List<RoadIssue> _sampleIssues = [
    RoadIssue(
      id: '1',
      type: IssueType.pothole,
      description: "Large pothole causing traffic issues",
      location: "Main Street & 5th Avenue",
      severity: Severity.high,
      reporter: "John D.",
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      upvotes: 12,
      status: IssueStatus.reported,
      coordinates: "37.7749,-122.4194",
    ),
    RoadIssue(
      id: '2',
      type: IssueType.trafficLight,
      description: "Malfunctioning traffic light",
      location: "Oak Street & Pine Road",
      severity: Severity.medium,
      reporter: "Sarah M.",
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      upvotes: 8,
      status: IssueStatus.inProgress,
      coordinates: "37.7849,-122.4094",
    ),
    RoadIssue(
      id: '3',
      type: IssueType.roadDamage,
      description: "Cracked road surface",
      location: "Highway 101, Exit 25",
      severity: Severity.low,
      reporter: "Mike R.",
      timestamp: DateTime.now().subtract(Duration(days: 3)),
      upvotes: 5,
      status: IssueStatus.reported,
      coordinates: "37.7949,-122.3994",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadNearbyIssues();
    _loadMyReports();
  }

  void _loadNearbyIssues() {
    setState(() {
      _nearbyIssues = _sampleIssues;
    });
  }

  void _loadMyReports() {
    setState(() {
      _reportedIssues = _sampleIssues.take(2).toList();
    });
  }

  void _reportNewIssue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => IssueReportSheet(
        onIssueReported: (issue) {
          setState(() {
            _reportedIssues.insert(0, issue);
            _nearbyIssues.insert(0, issue);
          });
          Navigator.pop(context);
          _showReportSuccess(issue);
        },
      ),
    );
  }

  void _showReportSuccess(RoadIssue issue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text("Issue reported successfully! +10 Community Points"),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _upvoteIssue(String issueId) {
    setState(() {
      final issue = _nearbyIssues.firstWhere((issue) => issue.id == issueId);
      final index = _nearbyIssues.indexOf(issue);
      _nearbyIssues[index] = issue.copyWith(upvotes: issue.upvotes + 1);
    });
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.people, color: Colors.white, size: 30),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Community Guardian",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${_nearbyIssues.length} issues reported nearby",
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
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "125 pts",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReportButtons() {
    final quickIssues = [
      QuickIssue(type: IssueType.pothole, label: "Pothole"),
      QuickIssue(type: IssueType.trafficLight, label: "Broken Light"),
      QuickIssue(type: IssueType.roadDamage, label: "Road Damage"),
      QuickIssue(type: IssueType.obstruction, label: "Obstruction"),
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Report",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickIssues.map((quickIssue) {
              return ActionChip(
                avatar: Icon(_getIssueIcon(quickIssue.type), size: 18),
                label: Text(quickIssue.label),
                onPressed: () => _quickReport(quickIssue.type),
                backgroundColor: Colors.blue[50],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _quickReport(IssueType type) {
    final issue = RoadIssue(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      description: _getDefaultDescription(type),
      location: "Current Location",
      severity: Severity.medium,
      reporter: "You",
      timestamp: DateTime.now(),
      upvotes: 0,
      status: IssueStatus.reported,
      coordinates: "37.7749,-122.4194",
    );

    setState(() {
      _reportedIssues.insert(0, issue);
      _nearbyIssues.insert(0, issue);
    });

    _showReportSuccess(issue);
  }

  String _getDefaultDescription(IssueType type) {
    switch (type) {
      case IssueType.pothole:
        return "Pothole detected on road surface";
      case IssueType.trafficLight:
        return "Traffic light not working properly";
      case IssueType.roadDamage:
        return "Road surface damage observed";
      case IssueType.obstruction:
        return "Obstruction blocking traffic";
      case IssueType.other:
        return "Other road issue reported";
    }
  }

  Widget _buildNearbyIssues() {
    return ExpansionTile(
      title: Text(
        "Nearby Issues (${_nearbyIssues.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        ..._nearbyIssues.map((issue) => IssueCard(
          issue: issue,
          onUpvote: _upvoteIssue,
          showActions: true,
        )).toList(),
      ],
    );
  }

  Widget _buildMyReports() {
    return ExpansionTile(
      title: Text(
        "My Reports (${_reportedIssues.length})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        ..._reportedIssues.map((issue) => IssueCard(
          issue: issue,
          onUpvote: _upvoteIssue,
          showActions: false,
        )).toList(),
      ],
    );
  }

  IconData _getIssueIcon(IssueType type) {
    switch (type) {
      case IssueType.pothole:
        return Icons.report_problem;
      case IssueType.trafficLight:
        return Icons.traffic;
      case IssueType.roadDamage:
        return Icons.construction;
      case IssueType.obstruction:
        return Icons.block;
      case IssueType.other:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Guardian"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildQuickReportButtons(),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                _buildNearbyIssues(),
                _buildMyReports(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reportNewIssue,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}

class IssueReportSheet extends StatefulWidget {
  final Function(RoadIssue) onIssueReported;

  const IssueReportSheet({required this.onIssueReported});

  @override
  _IssueReportSheetState createState() => _IssueReportSheetState();
}

class _IssueReportSheetState extends State<IssueReportSheet> {
  IssueType _selectedType = IssueType.pothole;
  Severity _selectedSeverity = Severity.medium;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = "Current Location";
  }

  void _submitReport() {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    final issue = RoadIssue(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      description: _descriptionController.text,
      location: _locationController.text,
      severity: _selectedSeverity,
      reporter: "You",
      timestamp: DateTime.now(),
      upvotes: 0,
      status: IssueStatus.reported,
      coordinates: "37.7749,-122.4194",
    );

    widget.onIssueReported(issue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Report Road Issue",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text("Issue Type", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: IssueType.values.map((type) {
              return ChoiceChip(
                label: Text(_getIssueTypeLabel(type)),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = type;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text("Severity", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: Severity.values.map((severity) {
              return ChoiceChip(
                label: Text(_getSeverityLabel(severity)),
                selected: _selectedSeverity == severity,
                onSelected: (selected) {
                  setState(() {
                    _selectedSeverity = severity;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
              hintText: "Describe the issue in detail...",
            ),
            maxLines: 3,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Submit Report"),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  String _getIssueTypeLabel(IssueType type) {
    switch (type) {
      case IssueType.pothole:
        return "Pothole";
      case IssueType.trafficLight:
        return "Traffic Light";
      case IssueType.roadDamage:
        return "Road Damage";
      case IssueType.obstruction:
        return "Obstruction";
      case IssueType.other:
        return "Other";
    }
  }

  String _getSeverityLabel(Severity severity) {
    switch (severity) {
      case Severity.low:
        return "Low";
      case Severity.medium:
        return "Medium";
      case Severity.high:
        return "High";
    }
  }
}

class IssueCard extends StatelessWidget {
  final RoadIssue issue;
  final Function(String) onUpvote;
  final bool showActions;

  const IssueCard({
    required this.issue,
    required this.onUpvote,
    required this.showActions,
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
                    color: _getSeverityColor(issue.severity).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIssueIcon(issue.type),
                    color: _getSeverityColor(issue.severity),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getIssueTypeLabel(issue.type),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        issue.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showActions)
                  InkWell(
                    onTap: () => onUpvote(issue.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                          SizedBox(width: 4),
                          Text("${issue.upvotes}"),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              issue.description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(issue.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusLabel(issue.status),
                    style: TextStyle(
                      color: _getStatusColor(issue.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(issue.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getSeverityLabel(issue.severity),
                    style: TextStyle(
                      color: _getSeverityColor(issue.severity),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  _formatTimeAgo(issue.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
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
        return Colors.green;
    }
  }

  Color _getStatusColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.reported:
        return Colors.orange;
      case IssueStatus.inProgress:
        return Colors.blue;
      case IssueStatus.resolved:
        return Colors.green;
    }
  }

  String _getStatusLabel(IssueStatus status) {
    switch (status) {
      case IssueStatus.reported:
        return "Reported";
      case IssueStatus.inProgress:
        return "In Progress";
      case IssueStatus.resolved:
        return "Resolved";
    }
  }

  String _getIssueTypeLabel(IssueType type) {
    switch (type) {
      case IssueType.pothole:
        return "Pothole";
      case IssueType.trafficLight:
        return "Traffic Light Issue";
      case IssueType.roadDamage:
        return "Road Damage";
      case IssueType.obstruction:
        return "Road Obstruction";
      case IssueType.other:
        return "Other Issue";
    }
  }

  IconData _getIssueIcon(IssueType type) {
    switch (type) {
      case IssueType.pothole:
        return Icons.report_problem;
      case IssueType.trafficLight:
        return Icons.traffic;
      case IssueType.roadDamage:
        return Icons.construction;
      case IssueType.obstruction:
        return Icons.block;
      case IssueType.other:
        return Icons.warning;
    }
  }

  String _getSeverityLabel(Severity severity) {
    switch (severity) {
      case Severity.low:
        return "Low";
      case Severity.medium:
        return "Medium";
      case Severity.high:
        return "High";
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes}m ago";
    if (difference.inDays < 1) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }
}

enum IssueType { pothole, trafficLight, roadDamage, obstruction, other }
enum Severity { low, medium, high }
enum IssueStatus { reported, inProgress, resolved }

class RoadIssue {
  final String id;
  final IssueType type;
  final String description;
  final String location;
  final Severity severity;
  final String reporter;
  final DateTime timestamp;
  final int upvotes;
  final IssueStatus status;
  final String coordinates;

  RoadIssue({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.severity,
    required this.reporter,
    required this.timestamp,
    required this.upvotes,
    required this.status,
    required this.coordinates,
  });

  RoadIssue copyWith({
    int? upvotes,
    IssueStatus? status,
  }) {
    return RoadIssue(
      id: id,
      type: type,
      description: description,
      location: location,
      severity: severity,
      reporter: reporter,
      timestamp: timestamp,
      upvotes: upvotes ?? this.upvotes,
      status: status ?? this.status,
      coordinates: coordinates,
    );
  }
}

class QuickIssue {
  final IssueType type;
  final String label;

  QuickIssue({required this.type, required this.label});
}