import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

/// Notification categories
enum NotificationCategory {
  request('requests', 'Service Requests', 'Notifications about service requests', Importance.max),
  payment('payments', 'Payments', 'Payment confirmations and updates', Importance.high),
  update('updates', 'Updates', 'General app updates and information', Importance.defaultImportance),
  promotion('promotions', 'Promotions', 'Offers and promotional messages', Importance.low);

  final String id;
  final String name;
  final String description;
  final Importance importance;

  const NotificationCategory(this.id, this.name, this.description, this.importance);
}

class EnhancedNotificationService {
  static FirebaseMessaging? _firebaseMessaging;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  // Background message handler must be top-level or static
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Background message received: ${message.messageId}");
    await _handleBackgroundNotification(message);
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      print('Starting Enhanced FCM initialization...');
      
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        print('Firebase not initialized yet, waiting...');
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Initialize FirebaseMessaging only if Firebase is ready
      if (Firebase.apps.isNotEmpty) {
        _firebaseMessaging = FirebaseMessaging.instance;
        
        // Set background message handler
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      } else {
        print('Firebase still not initialized, skipping FCM setup');
        return;
      }
      
      // Initialize local notifications
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const InitializationSettings initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize with callback
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      print('Local notifications initialized');

      // Create notification channels for Android
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();
      
      // Get and save token
      _getAndSaveToken();
      
      // Set up message handlers
      _setupMessageHandlers();
      
      _isInitialized = true;
      print('Enhanced FCM initialization completed');
      
    } catch (e) {
      print('Enhanced FCM initialization error: $e');
    }
  }

  /// Create Android notification channels for different categories
  static Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Create channels for each category
        for (NotificationCategory category in NotificationCategory.values) {
          await androidPlugin.createNotificationChannel(
            AndroidNotificationChannel(
              category.id,
              category.name,
              description: category.description,
              importance: category.importance,
              enableVibration: true,
              playSound: true,
            ),
          );
          print('Created notification channel: ${category.name}');
        }
      }
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      if (_firebaseMessaging == null) return;
      
      NotificationSettings settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      print('Notification permission status: ${settings.authorizationStatus}');
      
      if (Platform.isAndroid) {
        // Request Android 13+ notification permission
        final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          await androidPlugin.requestNotificationsPermission();
        }
      }
    } catch (e) {
      print('Permission request error: $e');
    }
  }

  static void _getAndSaveToken() async {
    try {
      if (_firebaseMessaging == null) return;
      
      String? token = await _firebaseMessaging!.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await _saveTokenToFirestore(token);
        
        // Listen for token refresh
        _firebaseMessaging!.onTokenRefresh.listen((newToken) {
          print('FCM Token refreshed: $newToken');
          _saveTokenToFirestore(newToken);
        });
      }
    } catch (e) {
      print('Token error: $e');
    }
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      
      // Save token to appropriate collection based on user role
      final collection = _getUserCollection(userRole);
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .set({
            'fcmToken': token,
            'tokenUpdatedAt': FieldValue.serverTimestamp(),
            'email': userEmail,
          }, SetOptions(merge: true));
          
      print('FCM token saved to Firestore for $userEmail');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  static Future<String> _getUserRole(String email) async {
    // Try to determine user role from Firestore
    final roles = ['owners', 'garages', 'providers', 'insurance_companies', 'admins'];
    for (String role in roles) {
      final doc = await FirebaseFirestore.instance.collection(role).doc(email).get();
      if (doc.exists) {
        return role;
      }
    }
    return 'owners'; // Default
  }

  static String _getUserCollection(String role) {
    if (role == 'owners') return 'owners';
    if (role == 'garages') return 'garages';
    if (role == 'providers') return 'providers';
    if (role == 'insurance_companies') return 'insurance_companies';
    if (role == 'admins') return 'admins';
    return 'owners'; // Default
  }

  static void _setupMessageHandlers() {
    if (_firebaseMessaging == null || Firebase.apps.isEmpty) return;
    
    // Foreground messages (when app is open)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Background messages (when app is in background and user taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageOpened);
    
    // Check if app was opened from a terminated state via notification
    _firebaseMessaging!.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state via notification');
        _handleNotificationNavigation(message);
      }
    });
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.notification?.title}');
    await _showLocalNotification(message);
    await _saveNotificationToHistory(message);
  }

  static Future<void> _handleBackgroundMessageOpened(RemoteMessage message) async {
    print('Background message opened: ${message.notification?.title}');
    await _markNotificationAsRead(message);
    _handleNotificationNavigation(message);
  }

  static Future<void> _handleBackgroundNotification(RemoteMessage message) async {
    print('Handling background notification: ${message.messageId}');
    await _showLocalNotification(message);
    await _saveNotificationToHistory(message);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle notification tap - can navigate to specific screen based on payload
  }

  /// Show local notification with proper channel based on category
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final category = _getCategoryFromMessage(message);
      final notification = message.notification;
      
      if (notification == null) return;

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        category.id,
        category.name,
        channelDescription: category.description,
        importance: category.importance,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );
      
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notificationsPlugin.show(
        message.hashCode,
        notification.title ?? 'New Notification',
        notification.body ?? 'You have a new update',
        platformDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  /// Create and show a categorized notification
  static Future<void> showNotification({
    required String title,
    required String body,
    required NotificationCategory category,
    Map<String, dynamic>? data,
    String? requestId,
  }) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      
      // Save to Firestore history
      await _saveNotificationToFirestore(
        userEmail: userEmail,
        title: title,
        body: body,
        category: category.id,
        data: data,
        requestId: requestId ?? '',
      );

      // Show local notification
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        category.id,
        category.name,
        channelDescription: category.description,
        importance: category.importance,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );
      
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformDetails,
        payload: data?.toString() ?? '',
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  static NotificationCategory _getCategoryFromMessage(RemoteMessage message) {
    final type = message.data['type'] ?? message.data['category'] ?? 'update';
    
    switch (type.toString().toLowerCase()) {
      case 'request':
      case 'requests':
        return NotificationCategory.request;
      case 'payment':
      case 'payments':
        return NotificationCategory.payment;
      case 'promotion':
      case 'promotions':
        return NotificationCategory.promotion;
      default:
        return NotificationCategory.update;
    }
  }

  static Future<void> _saveNotificationToHistory(RemoteMessage message) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final category = _getCategoryFromMessage(message);
      
      await _saveNotificationToFirestore(
        userEmail: userEmail,
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        category: category.id,
        data: message.data,
        requestId: message.data['requestId'] ?? '',
      );
    } catch (e) {
      print('Error saving notification to history: $e');
    }
  }

  static Future<void> _saveNotificationToFirestore({
    required String userEmail,
    required String title,
    required String body,
    required String category,
    Map<String, dynamic>? data,
    required String requestId,
  }) async {
    try {
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .add({
            'title': title,
            'body': body,
            'category': category,
            'type': category, // For backward compatibility
            'requestId': requestId,
            'data': data ?? {},
            'isRead': false,
            'timestamp': FieldValue.serverTimestamp(),
            'createdAt': DateTime.now().toIso8601String(),
            'messageId': DateTime.now().millisecondsSinceEpoch.toString(),
          });
      
      print('Notification saved to history');
    } catch (e) {
      print('Error saving notification to Firestore: $e');
    }
  }

  static Future<void> _markNotificationAsRead(RemoteMessage message) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      // Find and mark notification as read
      final notifications = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .where('messageId', isEqualTo: message.messageId)
          .limit(1)
          .get();

      for (var doc in notifications.docs) {
        await doc.reference.update({'isRead': true, 'readAt': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  static void _handleNotificationNavigation(RemoteMessage message) {
    // This would typically use a navigation service or callback
    // For now, we'll just log it
    final category = _getCategoryFromMessage(message);
    final requestId = message.data['requestId'];
    
    print('Navigate to: ${category.id}, requestId: $requestId');
    // Navigation logic can be implemented here based on app structure
  }

  /// Get all notifications for current user
  static Stream<QuerySnapshot> getNotificationsStream() {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      return FirebaseFirestore.instance
          .collection('owners')
          .doc(user.email ?? '')
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .snapshots();
    } catch (e) {
      print('Error getting notifications stream: $e');
      rethrow;
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .doc(notificationId)
          .update({
            'isRead': true,
            'readAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      final batch = FirebaseFirestore.instance.batch();
      final unreadNotifications = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadNotifications.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  /// Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  /// Delete all notifications
  static Future<void> deleteAllNotifications() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      final batch = FirebaseFirestore.instance.batch();
      final allNotifications = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .get();

      for (var doc in allNotifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting all notifications: $e');
    }
  }

  /// Get unread count
  static Future<int> getUnreadCount() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return 0;

      final userEmail = user.email ?? '';
      final userRole = await _getUserRole(userEmail);
      final collection = _getUserCollection(userRole);
      
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userEmail)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }
}

