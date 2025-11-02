import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMessagingHandler {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      print('Starting FCM initialization...');
      
      // Initialize local notifications first (fast operation)
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings iosSettings = 
          DarwinInitializationSettings();
      
      const InitializationSettings initializationSettings = 
          InitializationSettings(
            android: androidSettings,
            iOS: iosSettings,
          );
      
      await _notificationsPlugin.initialize(initializationSettings);
      print('Local notifications initialized');

      // Request permissions (non-blocking)
      _requestPermissions();
      
      // Get token in background
      _getAndSaveToken();
      
      // Set up message handlers
      _setupMessageHandlers();
      
      _isInitialized = true;
      print('FCM initialization completed');
      
    } catch (e) {
      print('FCM initialization error: $e');
    }
  }

  static void _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('Notification permission: ${settings.authorizationStatus}');
    } catch (e) {
      print('Permission request error: $e');
    }
  }

  static void _getAndSaveToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      print('Token error: $e');
    }
  }

  static void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    try {
      final String userEmail = "avi@gmail.com";
      
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(userEmail)
          .set({
            'fcmToken': token,
            'updatedAt': FieldValue.serverTimestamp(),
            'email': userEmail,
          }, SetOptions(merge: true));
          
      print('FCM token saved to Firestore');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
    await _showLocalNotification(message);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message: ${message.notification?.title}');
    await _showLocalNotification(message);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Background message opened: ${message.notification?.title}');
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
      'towing_channel_id',
      'Towing Notifications',
      channelDescription: 'Notifications for towing requests and updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosPlatformChannelSpecifics = 
        DarwinNotificationDetails();
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new update',
      platformChannelSpecifics,
      payload: message.data['type'] ?? 'general',
    );
  }

  // Fast notification method - doesn't wait for push notification
  static Future<void> createLocalNotification({
    required String userEmail,
    required String title,
    required String body,
    required String type,
    required String requestId,
  }) async {
    try {
      // First create notification in Firestore (fast operation)
      await _createNotificationInFirestore(
        userEmail: userEmail,
        title: title,
        body: body,
        type: type,
        requestId: requestId,
      );

      // Show local notification immediately
      await _showSimpleLocalNotification(title, body);
      
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  static Future<void> _createNotificationInFirestore({
    required String userEmail,
    required String title,
    required String body,
    required String type,
    required String requestId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(userEmail)
          .collection('notifications')
          .add({
            'title': title,
            'body': body,
            'type': type,
            'requestId': requestId,
            'isRead': false,
            'timestamp': FieldValue.serverTimestamp(),
            'createdAt': DateTime.now().toIso8601String(),
          });
      print('Notification created in Firestore');
    } catch (e) {
      print('Error creating notification in Firestore: $e');
      rethrow;
    }
  }

  static Future<void> _showSimpleLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
      'towing_channel_id',
      'Towing Notifications',
      channelDescription: 'Notifications for towing requests and updates',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
    );
  }
}