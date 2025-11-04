import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key, this.userEmail});
  final String? userEmail;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  bool _isEditing = false;
  String? _errorMessage;

  // Controllers for editing
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final String userEmail =
          widget.userEmail ?? _auth.currentUser?.email ?? '';

      if (userEmail.isEmpty) {
        throw Exception('No user email available');
      }

      print('Loading profile data for: $userEmail');

      // Try to fetch from garages collection first (new structure)
      DocumentSnapshot? profileSnapshot = await _firestore
          .collection('garages')
          .doc(userEmail)
          .get();

      String? loadedFrom = 'garages'; // Track where profile was loaded from

      // If not found, try old structure (garage/{email}/profile/companyDetails)
      if (!profileSnapshot.exists) {
        profileSnapshot = await _firestore
            .collection('garage')
            .doc(userEmail)
            .collection('profile')
            .doc('companyDetails')
            .get();
        loadedFrom = 'garage/profile/companyDetails';
      }

      if (profileSnapshot.exists) {
        setState(() {
          _profileData = profileSnapshot!.data() as Map<String, dynamic>;
          _initializeControllers();
        });
        print('Profile data loaded successfully from: $loadedFrom');
      } else {
        throw Exception('Profile data not found');
      }
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = 'Firestore error: ${e.message}';
      });
      print('Firestore error: ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
      });
      print('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _initializeControllers() {
    if (_profileData != null) {
      _companyNameController.text =
          _profileData!['companyName']?.toString() ??
          _profileData!['garageName']?.toString() ??
          '';
      _companyIdController.text = _profileData!['companyId']?.toString() ?? '';
      _contactInfoController.text =
          _profileData!['contactInfo']?.toString() ??
          _profileData!['shopAddress']?.toString() ??
          '';
      _emailController.text = _profileData!['email']?.toString() ?? '';
      _upiIdController.text = _profileData!['upiId']?.toString() ?? '';
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final String userEmail =
          widget.userEmail ?? _auth.currentUser?.email ?? '';

      if (userEmail.isEmpty) {
        throw Exception('No user email available');
      }

      // Validate UPI ID format if provided
      final upiId = _upiIdController.text.trim();
      if (upiId.isNotEmpty) {
        final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
        if (!upiRegex.hasMatch(upiId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please enter a valid UPI ID format (e.g., yourname@paytm)',
              ),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final updatedData = {
        'companyName': _companyNameController.text.trim(),
        'garageName': _companyNameController.text
            .trim(), // Also update new structure
        'companyId': _companyIdController.text.trim(),
        'contactInfo': _contactInfoController.text.trim(),
        'shopAddress': _contactInfoController.text
            .trim(), // Also update new structure
        'email': _emailController.text.trim(),
        'upiId': upiId,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update both old and new structures for compatibility
      // Use set with merge instead of update to handle missing documents
      final batch = _firestore.batch();

      // Check if old structure exists before updating
      final oldProfileRef = _firestore
          .collection('garage')
          .doc(userEmail)
          .collection('profile')
          .doc('companyDetails');
      
      // Check if document exists
      final oldProfileSnapshot = await oldProfileRef.get();
      if (oldProfileSnapshot.exists) {
        // Document exists, use update
        batch.update(oldProfileRef, updatedData);
      } else {
        // Document doesn't exist, use set with merge to create it
        batch.set(oldProfileRef, updatedData, SetOptions(merge: true));
      }

      // Always update new structure using set with merge (works for both create and update)
      final newProfileRef = _firestore.collection('garages').doc(userEmail);
      batch.set(newProfileRef, updatedData, SetOptions(merge: true));

      await batch.commit();

      // Reload profile data
      await _loadProfileData();

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = 'Update failed: ${e.message}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Update failed: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers when canceling edit
        _initializeControllers();
      }
    });
  }

  Widget _buildProfileInfoCard() {
    if (_profileData == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No profile data available'),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Company Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                IconButton(
                  onPressed: _toggleEditMode,
                  icon: Icon(
                    _isEditing ? Icons.close : Icons.edit,
                    color: Colors.purple,
                  ),
                  tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Company Name
            _buildInfoRow(
              'Company Name',
              _isEditing
                  ? TextFormField(
                      controller: _companyNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter company name',
                      ),
                    )
                  : Text(
                      _profileData!['companyName']?.toString() ?? 'Not set',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Icons.business,
            ),

            const SizedBox(height: 16),

            // Company ID
            _buildInfoRow(
              'Company ID',
              _isEditing
                  ? TextFormField(
                      controller: _companyIdController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter company ID',
                      ),
                    )
                  : Text(
                      _profileData!['companyId']?.toString() ?? 'Not set',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Icons.badge,
            ),

            const SizedBox(height: 16),

            // Email
            _buildInfoRow(
              'Email',
              _isEditing
                  ? TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter email address',
                      ),
                    )
                  : Text(
                      _profileData!['email']?.toString() ?? 'Not set',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Icons.email,
            ),

            const SizedBox(height: 16),

            // Contact Information
            _buildInfoRow(
              'Contact Information',
              _isEditing
                  ? TextFormField(
                      controller: _contactInfoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter contact information',
                      ),
                    )
                  : Text(
                      _profileData!['contactInfo']?.toString() ??
                          _profileData!['shopAddress']?.toString() ??
                          'Not set',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Icons.contact_phone,
            ),

            const SizedBox(height: 16),

            // UPI ID
            _buildInfoRow(
              'UPI ID',
              _isEditing
                  ? TextFormField(
                      controller: _upiIdController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'yourname@paytm',
                        helperText: 'Used for receiving payments',
                        prefixIcon: Icon(Icons.payment),
                      ),
                    )
                  : Text(
                      _profileData!['upiId']?.toString() ?? 'Not set',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _profileData!['upiId']?.toString() != null
                            ? Colors.green[700]
                            : Colors.grey,
                      ),
                    ),
              Icons.payment,
            ),

            const SizedBox(height: 16),

            // User ID (Read-only)
            _buildInfoRow(
              'User ID',
              Text(
                _profileData!['userId']?.toString() ?? 'Not available',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Icons.person,
            ),

            const SizedBox(height: 16),

            // Registration Date
            if (_profileData!['createdAt'] != null)
              _buildInfoRow(
                'Registered Since',
                Text(
                  _formatTimestamp(_profileData!['createdAt']),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icons.calendar_today,
              ),

            // Update Button when editing
            if (_isEditing) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'UPDATE PROFILE',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, Widget value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.purple, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              value,
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year}';
      }
      return 'Unknown';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading profile...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadProfileData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No profile data found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete your profile setup',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (!_isLoading && _profileData != null && !_isEditing)
            IconButton(
              onPressed: _loadProfileData,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
          ? _buildErrorState()
          : _profileData == null
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple[800]!, Colors.purple[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.business,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _profileData!['companyName']?.toString() ??
                              _profileData!['garageName']?.toString() ??
                              'Company Name',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _profileData!['userType']?.toString() == 'insurance'
                              ? 'Insurance Company'
                              : 'Service Provider',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Information
                  _buildProfileInfoCard(),

                  // Additional Info Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem('Document ID', 'companyDetails'),
                          _buildInfoItem(
                            'Collection',
                            'garage/${_profileData!['email']}/profile',
                          ),
                          _buildInfoItem(
                            'Last Updated',
                            _profileData!['updatedAt'] != null
                                ? _formatTimestamp(_profileData!['updatedAt'])
                                : 'Never',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyIdController.dispose();
    _contactInfoController.dispose();
    _emailController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }
}
