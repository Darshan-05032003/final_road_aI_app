import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ProfilePictureService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery or camera
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Upload profile picture to Firebase Storage
  Future<String?> uploadProfilePicture(File imageFile, String userRole, String userEmail) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Create unique filename
      final String fileName = 'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Determine storage path based on user role
      String storagePath;
      
      switch (userRole.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          storagePath = 'profiles/vehicle_owners/$fileName';
          break;
        case 'garage':
          storagePath = 'profiles/garages/$fileName';
          break;
        case 'toe_provider':
        case 'tow_provider':
        case 'provider':
          storagePath = 'profiles/tow_providers/$fileName';
          break;
        case 'insurance':
          storagePath = 'profiles/insurance/$fileName';
          break;
        case 'admin':
          storagePath = 'profiles/admins/$fileName';
          break;
        default:
          storagePath = 'profiles/users/$fileName';
      }

      // Upload to Firebase Storage
      final Reference ref = _storage.ref().child(storagePath);
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Delete old profile picture if exists
      await _deleteOldProfilePicture(userRole, userEmail);

      // Save download URL to Firestore
      await _saveProfilePictureUrl(downloadUrl, userRole, userEmail);

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  /// Delete old profile picture from Storage
  Future<void> _deleteOldProfilePicture(String userRole, String userEmail) async {
    try {
      // Get current profile picture URL
      String? oldUrl = await getProfilePictureUrl(userRole, userEmail);
      
      if (oldUrl != null && oldUrl.isNotEmpty) {
        // Extract file path from URL
        try {
          final Reference ref = _storage.refFromURL(oldUrl);
          await ref.delete();
        } catch (e) {
          print('Error deleting old profile picture: $e');
          // Continue even if deletion fails
        }
      }
    } catch (e) {
      print('Error getting old profile picture: $e');
      // Continue even if error occurs
    }
  }

  /// Save profile picture URL to Firestore
  Future<void> _saveProfilePictureUrl(String url, String userRole, String userEmail) async {
    try {
      DocumentReference docRef;

      switch (userRole.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          docRef = _firestore
              .collection('owner')
              .doc(userEmail)
              .collection('profile')
              .doc('user_details');
          break;
        case 'garage':
          docRef = _firestore.collection('garages').doc(userEmail);
          break;
        case 'toe_provider':
        case 'tow_provider':
        case 'provider':
          docRef = _firestore.collection('providers').doc(userEmail);
          break;
        case 'insurance':
          docRef = _firestore.collection('insurance_companies').doc(userEmail);
          break;
        case 'admin':
          docRef = _firestore.collection('admins').doc(userEmail);
          break;
        default:
          docRef = _firestore.collection('users').doc(userEmail);
      }

      await docRef.set({'profilePictureUrl': url, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    } catch (e) {
      print('Error saving profile picture URL: $e');
      rethrow;
    }
  }

  /// Get profile picture URL from Firestore
  Future<String?> getProfilePictureUrl(String userRole, String userEmail) async {
    try {
      DocumentReference docRef;

      switch (userRole.toLowerCase()) {
        case 'vehicle_owner':
        case 'owner':
          final doc = await _firestore
              .collection('owner')
              .doc(userEmail)
              .collection('profile')
              .doc('user_details')
              .get();
          return doc.data()?['profilePictureUrl'] as String?;
        case 'garage':
          final doc = await _firestore.collection('garages').doc(userEmail).get();
          return doc.data()?['profilePictureUrl'] as String?;
        case 'toe_provider':
        case 'tow_provider':
        case 'provider':
          final doc = await _firestore.collection('providers').doc(userEmail).get();
          return doc.data()?['profilePictureUrl'] as String?;
        case 'insurance':
          final doc = await _firestore.collection('insurance_companies').doc(userEmail).get();
          return doc.data()?['profilePictureUrl'] as String?;
        case 'admin':
          final doc = await _firestore.collection('admins').doc(userEmail).get();
          return doc.data()?['profilePictureUrl'] as String?;
        default:
          final doc = await _firestore.collection('users').doc(userEmail).get();
          return doc.data()?['profilePictureUrl'] as String?;
      }
    } catch (e) {
      print('Error getting profile picture URL: $e');
      return null;
    }
  }

  /// Show image source selection dialog
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final File? image = await pickImage(source: ImageSource.gallery);
                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final File? image = await pickImage(source: ImageSource.camera);
                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

