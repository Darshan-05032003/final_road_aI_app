import 'package:flutter/material.dart';

class ActiveJobsScreen extends StatefulWidget {
  const ActiveJobsScreen({super.key});

  @override
  _ActiveJobsScreenState createState() => _ActiveJobsScreenState();
}

class _ActiveJobsScreenState extends State<ActiveJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<ActiveJob> _activeJobs = [
    ActiveJob(
      id: '1',
      userName: 'Michael Smith',
      vehicleType: 'Toyota Camry',
      issueType: 'Flat Tire',
      status: 'en_route',
      location: '123 Main Street',
      estimatedFare: 85.00,
      startTime: '10:30 AM',
    ),
  ];

  final List<ActiveJob> _completedJobs = [
    ActiveJob(
      id: '2',
      userName: 'Sarah Johnson',
      vehicleType: 'Honda Civic',
      issueType: 'Battery Issue',
      status: 'completed',
      location: '456 Oak Avenue',
      estimatedFare: 65.00,
      startTime: 'Yesterday, 2:30 PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(isTablet),
          _buildTabBar(isTablet),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveJobsList(isTablet),
                _buildCompletedJobsList(isTablet),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.work, color: Color(0xFF7E57C2), size: isTablet ? 28 : 24),
          SizedBox(width: 12),
          Text(
            'My Jobs',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          Spacer(),
          if (_activeJobs.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF7E57C2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_activeJobs.length} Active',
                style: TextStyle(
                  color: Color(0xFF7E57C2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isTablet) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF7E57C2),
        unselectedLabelColor: Color(0xFF999999),
        indicatorColor: Color(0xFF7E57C2),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isTablet ? 16 : 14,
        ),
        tabs: [
          Tab(text: 'Active (${_activeJobs.length})'),
          Tab(text: 'Completed (${_completedJobs.length})'),
        ],
      ),
    );
  }

  Widget _buildActiveJobsList(bool isTablet) {
    return _activeJobs.isEmpty
        ? _buildEmptyState('No Active Jobs', 'You don\'t have any active jobs at the moment', isTablet)
        : ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            itemCount: _activeJobs.length,
            itemBuilder: (context, index) {
              return _buildActiveJobCard(_activeJobs[index], isTablet);
            },
          );
  }

  Widget _buildCompletedJobsList(bool isTablet) {
    return _completedJobs.isEmpty
        ? _buildEmptyState('No Completed Jobs', 'Your completed jobs will appear here', isTablet)
        : ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            itemCount: _completedJobs.length,
            itemBuilder: (context, index) {
              return _buildCompletedJobCard(_completedJobs[index], isTablet);
            },
          );
  }

  Widget _buildActiveJobCard(ActiveJob job, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF7E57C2).withOpacity(0.1),
                child: Icon(Icons.person, color: Color(0xFF7E57C2)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 18 : 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      job.startTime,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(job.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(job.status),
                  style: TextStyle(
                    color: _getStatusColor(job.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              _buildJobDetail(Icons.directions_car, job.vehicleType, isTablet),
              SizedBox(width: 16),
              _buildJobDetail(Icons.build, job.issueType, isTablet),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF7E57C2), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.location,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFF4CAF50), size: 16),
              SizedBox(width: 8),
              Text(
                '\$${job.estimatedFare.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
              Spacer(),
              if (job.status == 'en_route')
                ElevatedButton.icon(
                  icon: Icon(Icons.directions_car, size: 16),
                  label: Text('Update Status'),
                  onPressed: () => _updateJobStatus(job.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E57C2),
                    foregroundColor: Colors.white,
                  ),
                ),
              if (job.status == 'picked_up')
                ElevatedButton.icon(
                  icon: Icon(Icons.check_circle, size: 16),
                  label: Text('Complete Job'),
                  onPressed: () => _completeJob(job.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedJobCard(ActiveJob job, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF4CAF50).withOpacity(0.1),
                child: Icon(Icons.person, color: Color(0xFF4CAF50)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 18 : 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      job.startTime,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${job.estimatedFare.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                      fontSize: isTablet ? 18 : 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('5.0', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              _buildJobDetail(Icons.directions_car, job.vehicleType, isTablet),
              SizedBox(width: 16),
              _buildJobDetail(Icons.build, job.issueType, isTablet),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF7E57C2), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.location,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetail(IconData icon, String text, bool isTablet) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF7E57C2), size: 16),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            color: Color(0xFFE0E0E0),
            size: isTablet ? 80 : 60,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'en_route':
        return Color(0xFFFFA000);
      case 'picked_up':
        return Color(0xFF2196F3);
      case 'completed':
        return Color(0xFF4CAF50);
      default:
        return Color(0xFF666666);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'en_route':
        return 'En Route';
      case 'picked_up':
        return 'Vehicle Picked';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  void _updateJobStatus(String jobId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Job Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16),
            _buildStatusOption('En Route', 'Mark yourself as en route to location', Icons.directions_car, 'en_route'),
            _buildStatusOption('Vehicle Picked', 'Confirm you have picked up the vehicle', Icons.check_circle, 'picked_up'),
            _buildStatusOption('Add Photo', 'Upload proof of pickup', Icons.camera_alt, 'photo'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(String title, String subtitle, IconData icon, String status) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF7E57C2).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF7E57C2)),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
      onTap: () {
        Navigator.pop(context);
        _showStatusUpdateSuccess(title);
      },
    );
  }

  void _completeJob(String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
            SizedBox(width: 8),
            Text('Complete Job'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to mark this job as completed?'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Final Amount (\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            Text('Upload completion photo (optional)'),
            SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Color(0xFF999999)),
                    Text('Tap to add photo', style: TextStyle(color: Color(0xFF999999))),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showCompletionSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
            ),
            child: Text('Complete Job'),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateSuccess(String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Status updated to: $status'),
          ],
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCompletionSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Job completed successfully!'),
          ],
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class ActiveJob {
  final String id;
  final String userName;
  final String vehicleType;
  final String issueType;
  final String status;
  final String location;
  final double estimatedFare;
  final String startTime;

  ActiveJob({
    required this.id,
    required this.userName,
    required this.vehicleType,
    required this.issueType,
    required this.status,
    required this.location,
    required this.estimatedFare,
    required this.startTime,
  });
}