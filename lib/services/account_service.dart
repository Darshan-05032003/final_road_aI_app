import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Change user password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  /// Delete user account and all associated data
  Future<void> deleteAccount(String userEmail, String userRole) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Determine collection paths based on user role
      List<String> collectionsToClean = [];
      
      switch (userRole.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          collectionsToClean = ['owner'];
          break;
        case 'garage':
          collectionsToClean = ['garages', 'garage'];
          break;
        case 'toe_provider':
        case 'tow_provider':
        case 'provider':
          collectionsToClean = ['providers'];
          break;
        case 'insurance':
          collectionsToClean = ['insurance_companies', 'vehicle_owners'];
          break;
        case 'admin':
          collectionsToClean = ['admins'];
          break;
      }

      // Delete Firestore data
      for (String collection in collectionsToClean) {
        try {
          if (collection == 'owner' || collection == 'garage') {
            // Subcollection structure - delete subcollections manually
            final batch = _firestore.batch();
            final docRef = _firestore.collection(collection).doc(userEmail);
            
            // Delete known subcollections
            final subcollections = ['profile', 'requests', 'payments'];
            for (String subcolName in subcollections) {
              final subcol = docRef.collection(subcolName);
              final docs = await subcol.get();
              for (var doc in docs.docs) {
                batch.delete(doc.reference);
              }
            }
            batch.delete(docRef);
            await batch.commit();
          } else {
            // Direct document
            await _firestore.collection(collection).doc(userEmail).delete();
          }
        } catch (e) {
          print('Error deleting from $collection: $e');
          // Continue even if one deletion fails
        }
      }

      // Delete profile pictures from Storage
      try {
        final ListResult result = await _storage.ref('profiles').listAll();
        for (var prefix in result.prefixes) {
          final files = await prefix.listAll();
          for (var file in files.items) {
            if (file.name.contains(user.uid)) {
              await file.delete();
            }
          }
        }
      } catch (e) {
        print('Error deleting profile pictures: $e');
        // Continue even if deletion fails
      }

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Delete Firebase Auth account
      await user.delete();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  /// Get current user role
  Future<String?> getUserRole() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return null;

      // Check in various collections
      final roles = ['owner', 'garages', 'providers', 'insurance_companies', 'admins'];
      
      for (String role in roles) {
        final doc = await _firestore.collection(role).doc(user.email).get();
        if (doc.exists) {
          return role;
        }
      }

      // Also check subcollection structure
      final ownerDoc = await _firestore
          .collection('owner')
          .doc(user.email)
          .collection('profile')
          .doc('user_details')
          .get();
      if (ownerDoc.exists) {
        return 'owner';
      }

      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}

