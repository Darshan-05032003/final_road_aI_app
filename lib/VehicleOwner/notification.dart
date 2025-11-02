import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with stats
          _buildHeaderStats(),
          SizedBox(height: 8),
          
          // Notification List
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return StreamBuilder(
      stream: dbRef.child('notifications').child(currentUserId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        int totalNotifications = 0;
        int unreadCount = 0;

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          totalNotifications = data.length;
          
          data.forEach((key, value) {
            if (value is Map && value['read'] == false) {
              unreadCount++;
            }
          });
        }

        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                count: totalNotifications,
                label: 'Total',
                icon: Icons.notifications_outlined,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItem(
                count: unreadCount,
                label: 'Unread',
                icon: Icons.mark_email_unread_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({required int count, required String label, required IconData icon}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    return StreamBuilder(
      stream: dbRef.child('notifications').child(currentUserId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return _buildEmptyState();
        }

        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        
        if (data.isEmpty) {
          return _buildEmptyState();
        }

        // Convert to list and sort by timestamp (newest first)
        List<MapEntry<dynamic, dynamic>> notificationsList = data.entries.toList();
        notificationsList.sort((a, b) {
          final timestampA = a.value['timestamp'] ?? 0;
          final timestampB = b.value['timestamp'] ?? 0;
          return timestampB.compareTo(timestampA);
        });

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: notificationsList.length,
          itemBuilder: (context, index) {
            final key = notificationsList[index].key;
            final notification = notificationsList[index].value as Map<dynamic, dynamic>;
            return _buildNotificationCard(key.toString(), notification);
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(String notificationId, Map<dynamic, dynamic> notification) {
    final bool isRead = notification['read'] == true;
    final String title = notification['title'] ?? 'Notification';
    final String message = notification['message'] ?? '';
    final String type = notification['type'] ?? 'general';
    final int timestamp = notification['timestamp'] ?? DateTime.now().millisecondsSinceEpoch;
    final String requestId = notification['requestId'] ?? '';
    final String vehicleNumber = notification['vehicleNumber'] ?? '';

    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final String timeAgo = _getTimeAgo(date);
    final String formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

    Color? typeColor;
    IconData typeIcon;

    // Set color and icon based on notification type
    switch (type) {
      case 'tow_request_submitted':
        typeColor = Colors.blue;
        typeIcon = Icons.local_shipping;
        break;
      case 'tow_request_accepted':
        typeColor = Colors.green;
        typeIcon = Icons.check_circle;
        break;
      case 'driver_assigned':
        typeColor = Colors.orange;
        typeIcon = Icons.person_pin;
        break;
      case 'tow_request_completed':
        typeColor = Colors.purple;
        typeIcon = Icons.verified;
        break;
      case 'rsvp_confirm':
        typeColor = Colors.teal;
        typeIcon = Icons.confirmation_number;
        break;
      case 'rsvp_cancel':
        typeColor = Colors.grey;
        typeIcon = Icons.cancel;
        break;
      default:
        typeColor = Color(0xFF6D28D9);
        typeIcon = Icons.notifications;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? Colors.transparent : typeColor.withOpacity(0.3),
          width: isRead ? 0 : 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isRead ? Colors.white : typeColor.withOpacity(0.05),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Additional info based on type
                    if (vehicleNumber.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.directions_car, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Vehicle: $vehicleNumber',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    
                    if (requestId.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.confirmation_number, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Request ID: $requestId',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        if (!isRead)
                          TextButton(
                            onPressed: () => _markAsRead(notificationId),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              'Mark as read',
                              style: TextStyle(
                                fontSize: 12,
                                color: typeColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsRead(String notificationId) {
    dbRef
        .child('notifications')
        .child(currentUserId)
        .child(notificationId)
        .update({'read': true});
  }

  void _markAllAsRead() {
    dbRef
        .child('notifications')
        .child(currentUserId)
        .once()
        .then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            dbRef
                .child('notifications')
                .child(currentUserId)
                .child(key.toString())
                .update({'read': true});
          }
        });
      }
    });
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  // Add this method to show options in AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Notifications',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF6D28D9),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'mark_all_read') {
              _markAllAsRead();
            } else if (value == 'clear_all') {
              _clearAllNotifications();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'mark_all_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Mark all as read'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Clear all notifications'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              dbRef
                  .child('notifications')
                  .child(currentUserId)
                  .remove()
                  .then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All notifications cleared')),
                );
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}