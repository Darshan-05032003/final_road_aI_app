import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDataFetcher {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch user profile data from Firestore
  Future<Map<String, dynamic>> fetchUserProfileData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      String userEmail = currentUser.email!;
      
      DocumentSnapshot profileSnapshot = await _firestore
          .collection('owner')
          .doc(userEmail)
          .collection('profile')
          .doc('user_details')
          .get();

      if (!profileSnapshot.exists) {
        // Return default data if profile doesn't exist
        return _getDefaultUserData(currentUser);
      }

      Map<String, dynamic> userData = profileSnapshot.data() as Map<String, dynamic>;
      
      // Enhance with additional calculated fields
      return _enhanceUserData(userData, currentUser);
      
    } catch (e) {
      print('Error fetching profile data: $e');
      // Return default data in case of error
      User? currentUser = _auth.currentUser;
      return _getDefaultUserData(currentUser);
    }
  }

  // Update user profile data in Firestore
  Future<void> updateUserProfileData(Map<String, dynamic> updatedData) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      String userEmail = currentUser.email!;
      
      await _firestore
          .collection('owner')
          .doc(userEmail)
          .collection('profile')
          .doc('user_details')
          .update({
            ...updatedData,
            'updatedAt': FieldValue.serverTimestamp(),
          });

    } catch (e) {
      print('Error updating profile data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _getDefaultUserData(User? user) {
    return {
      'name': user?.displayName ?? 'User',
      'email': user?.email ?? 'No email',
      'vehicleType': 'Not specified',
      'phone': 'Not provided',
      'licenseNumber': 'Not provided',
      'location': 'Not specified',
      'plan': 'Basic Plan',
      'memberSince': _formatDate(DateTime.now()),
      'points': '0',
      'nextService': 'Not scheduled',
      'vehicle': 'Not specified',
    };
  }

  Map<String, dynamic> _enhanceUserData(Map<String, dynamic> userData, User user) {
    // Calculate additional fields for the profile screen
    DateTime memberSince = (userData['createdAt'] as Timestamp?)?.toDate() ?? user.metadata.creationTime ?? DateTime.now();
    int points = _calculateRewardPoints(memberSince);
    
    return {
      'name': userData['name'] ?? user.displayName ?? 'User',
      'email': userData['email'] ?? user.email ?? 'No email',
      'vehicleType': userData['vehicleType'] ?? 'Not specified',
      'phone': userData['phone'] ?? 'Not provided',
      'licenseNumber': userData['licenseNumber'] ?? 'Not provided',
      'location': userData['location'] ?? 'Not specified',
      'plan': _getUserPlan(points),
      'memberSince': _formatDate(memberSince),
      'points': points.toString(),
      'nextService': _calculateNextService(memberSince),
      'vehicle': userData['vehicleType'] ?? 'Not specified',
      'userId': userData['userId'] ?? user.uid,
    };
  }

  int _calculateRewardPoints(DateTime memberSince) {
    int monthsSinceJoin = DateTime.now().difference(memberSince).inDays ~/ 30;
    return monthsSinceJoin * 10 + 50; // Base 50 points + 10 per month
  }

  String _getUserPlan(int points) {
    if (points >= 200) return 'Premium Plan';
    if (points >= 100) return 'Gold Plan';
    return 'Basic Plan';
  }

  String _calculateNextService(DateTime memberSince) {
    DateTime nextService = memberSince.add(const Duration(days: 180));
    return _formatDate(nextService);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Enhanced Profile Screen
class EnhancedProfileScreen extends StatefulWidget {
  final String userEmail;

  const EnhancedProfileScreen({super.key, required this.userEmail, required List serviceHistory});

  @override
  _EnhancedProfileScreenState createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  final ProfileDataFetcher _dataFetcher = ProfileDataFetcher();
  final List<String> _emergencyContacts = [];
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _vehicleController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _licenseController;

  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _vehicleController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _licenseController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> userData = await _dataFetcher.fetchUserProfileData();
      
      setState(() {
        _userData = userData;
        _updateControllersWithUserData();
        _isLoading = false;
      });
      
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load profile data');
    }
  }

  void _updateControllersWithUserData() {
    _nameController.text = _userData['name'] ?? '';
    _emailController.text = _userData['email'] ?? '';
    _vehicleController.text = _userData['vehicle'] ?? '';
    _phoneController.text = _userData['phone'] ?? '';
    _locationController.text = _userData['location'] ?? '';
    _licenseController.text = _userData['licenseNumber'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : CustomScrollView(
              slivers: [
               
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileHeader(),
                    _buildEditProfileSection(),
                    _buildAccountInfoSection(),
                    const SizedBox(height: 20),
                  ]),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading Profile...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6D28D9),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Color(0xFF6D28D9)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _userData['name'] ?? 'User',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(_userData['email'] ?? 'No email'),
          const SizedBox(height: 8),
          Chip(
            label: Text(_userData['plan'] ?? 'Basic Plan'),
            backgroundColor: Colors.amber[100],
            labelStyle: TextStyle(color: Colors.amber[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProfileField('Full Name', _nameController, Icons.person_rounded, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildProfileField('Email', _emailController, Icons.email_rounded, enabled: false),
            const SizedBox(height: 12),
            _buildProfileField('Phone', _phoneController, Icons.phone_rounded, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildProfileField('Vehicle Info', _vehicleController, Icons.directions_car_rounded, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildProfileField('Location', _locationController, Icons.location_on_rounded, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildProfileField('License Number', _licenseController, Icons.card_membership_rounded, enabled: _isEditing),
            const SizedBox(height: 20),
            if (_isEditing) ...[
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D28D9),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _toggleEditing,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _toggleEditing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D28D9),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6D28D9)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF6D28D9)),
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(Icons.people_rounded, 'Member Since', _userData['memberSince'] ?? 'Not available'),
            _buildInfoItem(Icons.auto_awesome_rounded, 'Reward Points', '${_userData['points'] ?? '0'} points'),
            _buildInfoItem(Icons.calendar_today_rounded, 'Next Service', _userData['nextService'] ?? 'Not scheduled'),
            _buildInfoItem(Icons.verified_rounded, 'Account Status', 'Verified'),
            _buildInfoItem(Icons.phone_rounded, 'Phone Number', _userData['phone'] ?? 'Not provided'),
            _buildInfoItem(Icons.location_on_rounded, 'Location', _userData['location'] ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF6D28D9).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF6D28D9), size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers to original values when canceling edit
        _updateControllersWithUserData();
      }
    });
  }

  Future<void> _saveProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> updatedData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'vehicleType': _vehicleController.text.trim(),
        'location': _locationController.text.trim(),
        'licenseNumber': _licenseController.text.trim(),
      };

      await _dataFetcher.updateUserProfileData(updatedData);
      
      // Reload data to get updated information
      await _loadUserData();
      
      setState(() {
        _isEditing = false;
      });

      _showSuccessSnackBar('Profile updated successfully!');
      
    } catch (e) {
      _showErrorSnackBar('Failed to update profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _vehicleController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _licenseController.dispose();
    super.dispose();
  }
}

// SOS Emergency Screen (unchanged from your original code)
class SOSEmergencyScreen extends StatelessWidget {
  final List<String> emergencyContacts;

  const SOSEmergencyScreen({super.key, required this.emergencyContacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emergency_rounded,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'EMERGENCY SOS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Emergency alert will be sent to nearby service providers and your emergency contacts',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      _sendSOSAlert(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emergency_rounded),
                        SizedBox(width: 8),
                        Text('SEND ALERT NOW'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (emergencyContacts.isNotEmpty) ...[
                  const Text(
                    'Emergency Contacts:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...emergencyContacts.map((contact) => Text(contact)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendSOSAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency SOS alert sent! Help is on the way.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
    Navigator.pop(context);
  }
}