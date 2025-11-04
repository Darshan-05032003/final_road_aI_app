import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get chat collection reference
  CollectionReference _getChatCollection(String requestId) {
    return _firestore.collection('chats').doc(requestId).collection('messages');
  }

  /// Send a message
  Future<void> sendMessage({
    required String requestId,
    required String message,
    required String senderEmail,
    required String senderName,
    required String receiverEmail,
  }) async {
    try {
      final chatCollection = _getChatCollection(requestId);
      
      await chatCollection.add({
        'message': message,
        'senderEmail': senderEmail,
        'senderName': senderName,
        'receiverEmail': receiverEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      // Update chat metadata
      await _firestore.collection('chats').doc(requestId).set({
        'requestId': requestId,
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [senderEmail, receiverEmail],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Get messages stream for a request
  Stream<QuerySnapshot> getMessagesStream(String requestId) {
    return _getChatCollection(requestId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String requestId, String userEmail) async {
    try {
      final messagesSnapshot = await _getChatCollection(requestId)
          .where('receiverEmail', isEqualTo: userEmail)
          .where('read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }
      await batch.commit();
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  /// Get unread message count
  Future<int> getUnreadCount(String requestId, String userEmail) async {
    try {
      final snapshot = await _getChatCollection(requestId)
          .where('receiverEmail', isEqualTo: userEmail)
          .where('read', isEqualTo: false)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }
}

