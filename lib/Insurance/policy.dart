// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class InsuranceProfilePage extends StatefulWidget {
//   const InsuranceProfilePage({super.key});

//   @override
//   _InsuranceProfilePageState createState() => _InsuranceProfilePageState();
// }

// class _InsuranceProfilePageState extends State<InsuranceProfilePage> {
//   Map<String, dynamic>? _companyProfile;
//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchCompanyProfile();
//   }

//   // Method to fetch company profile from Firestore
//   Future<void> _fetchCompanyProfile() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
      
//       if (user == null) {
//         setState(() {
//           _errorMessage = 'No user logged in';
//           _isLoading = false;
//         });
//         return;
//       }

//       final DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
//           .collection('insurance')
//           .doc(user.email) // Using user's email as document ID
//           .collection('profile')
//           .doc('companyDetails')
//           .get();

//       if (profileSnapshot.exists) {
//         setState(() {
//           _companyProfile = profileSnapshot.data() as Map<String, dynamic>;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Company profile not found';
//           _isLoading = false;
//         });
//       }
//     } on FirebaseException catch (e) {
//       setState(() {
//         _errorMessage = 'Firestore error: ${e.message}';
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching profile: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   // Method to refresh profile data
//   Future<void> _refreshProfile() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//     await _fetchCompanyProfile();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Company Profile'),
//         backgroundColor: Colors.purple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _isLoading ? null : _refreshProfile,
//             tooltip: 'Refresh Profile',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildLoadingState()
//           : _errorMessage.isNotEmpty
//               ? _buildErrorState()
//               : _companyProfile != null
//                   ? _buildProfileContent()
//                   : _buildNoDataState(),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading company profile...',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 64,
//             color: Colors.red[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage,
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _refreshProfile,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoDataState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.business_center,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No company profile found',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _refreshProfile,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Refresh'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileContent() {
//     final profile = _companyProfile!;
    
//     return RefreshIndicator(
//       onRefresh: _refreshProfile,
//       backgroundColor: Colors.white,
//       color: Colors.purple,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile Header Card
//             Card(
//               elevation: 4,
//               margin: const EdgeInsets.only(bottom: 20),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple[800]!, Colors.purple[600]!],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.business,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                     const SizedBox(height: 15),
//                     Text(
//                       profile['companyName'] ?? 'No Company Name',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       profile['companyId'] ?? 'No Company ID',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white.withOpacity(0.9),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Company Details Card
//             Card(
//               elevation: 2,
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildProfileItem(
//                       icon: Icons.email,
//                       label: 'Email',
//                       value: profile['email'] ?? 'No Email',
//                     ),
//                     const Divider(height: 30),
//                     _buildProfileItem(
//                       icon: Icons.contact_phone,
//                       label: 'Contact Information',
//                       value: profile['contactInfo'] ?? 'No Contact Info',
//                       multiline: true,
//                     ),
//                     const Divider(height: 30),
//                     _buildProfileItem(
//                       icon: Icons.person,
//                       label: 'User ID',
//                       value: profile['userId'] ?? 'No User ID',
//                     ),
//                     const Divider(height: 30),
//                     _buildTimestampItem(
//                       icon: Icons.calendar_today,
//                       label: 'Registered Since',
//                       timestamp: profile['createdAt'],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Additional Info Card
//             Card(
//               elevation: 2,
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Account Status',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.purple,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.verified,
//                           color: Colors.green[600],
//                           size: 20,
//                         ),
//                         const SizedBox(width: 10),
//                         const Expanded(
//                           child: Text(
//                             'Active Insurance Partner',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.security,
//                           color: Colors.blue[600],
//                           size: 20,
//                         ),
//                         const SizedBox(width: 10),
//                         const Expanded(
//                           child: Text(
//                             'Verified Company Account',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Action Buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         // Add edit profile functionality
//                         _showEditDialog();
//                       },
//                       icon: const Icon(Icons.edit),
//                       label: const Text('Edit Profile'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.purple,
//                         side: const BorderSide(color: Colors.purple),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _refreshProfile,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Refresh'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     bool multiline = false,
//   }) {
//     return Row(
//       crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//       children: [
//         Icon(
//           icon,
//           color: Colors.purple,
//           size: 24,
//         ),
//         const SizedBox(width: 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[800],
//                   fontWeight: FontWeight.w400,
//                   height: multiline ? 1.3 : 1.0,
//                 ),
//                 maxLines: multiline ? 3 : 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimestampItem({
//     required IconData icon,
//     required String label,
//     required dynamic timestamp,
//   }) {
//     String timestampText = 'Not available';
    
//     if (timestamp != null) {
//       if (timestamp is Timestamp) {
//         final date = timestamp.toDate();
//         timestampText = '${date.day}/${date.month}/${date.year}';
//       } else if (timestamp is DateTime) {
//         timestampText = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//       }
//     }

//     return _buildProfileItem(
//       icon: icon,
//       label: label,
//       value: timestampText,
//     );
//   }

//   void _showEditDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Profile'),
//         content: const Text('Edit profile functionality will be implemented here.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsuranceProfilePage extends StatefulWidget {
  const InsuranceProfilePage({super.key});

  @override
  _InsuranceProfilePageState createState() => _InsuranceProfilePageState();
}

class _InsuranceProfilePageState extends State<InsuranceProfilePage> {
  Map<String, dynamic>? _companyProfile;
  bool _isLoading = true;
  String _errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchCompanyProfile();
  }

  Future<void> _fetchCompanyProfile() async {
    try {
      final User? user = _auth.currentUser;
      
      if (user == null) {
        setState(() {
          _errorMessage = 'No user logged in';
          _isLoading = false;
        });
        return;
      }

      // Try to get from vehicle_owners collection first
      final DocumentSnapshot profileSnapshot = await _firestore
          .collection('vehicle_owners')
          .doc(user.email)
          .collection('profile')
          .doc('user_details')
          .get();

      if (profileSnapshot.exists) {
        setState(() {
          _companyProfile = profileSnapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        // Create default profile if doesn't exist
        await _createDefaultProfile(user);
      }
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = 'Firestore error: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createDefaultProfile(User user) async {
    final defaultProfile = {
      'userId': user.uid,
      'email': user.email,
      'name': user.displayName ?? 'Insurance User',
      'phone': '',
      'address': '',
      'companyName': 'Personal Insurance Account',
      'companyId': 'USER_${user.uid.substring(0, 8)}',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('vehicle_owners')
        .doc(user.email)
        .collection('profile')
        .doc('user_details')
        .set(defaultProfile);

    setState(() {
      _companyProfile = defaultProfile;
      _isLoading = false;
    });
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await _fetchCompanyProfile();
  }

  Future<void> _updateProfile(Map<String, dynamic> updates) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('vehicle_owners')
          .doc(user.email)
          .collection('profile')
          .doc('user_details')
          .set({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update user display name in Firebase Auth
      if (updates.containsKey('name')) {
        await user.updateDisplayName(updates['name']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await _refreshProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Company Profile'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshProfile,
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _companyProfile != null
                  ? _buildProfileContent()
                  : _buildNoDataState(),
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
            'Loading company profile...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
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
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_center,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No company profile found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final profile = _companyProfile!;
    
    return RefreshIndicator(
      onRefresh: _refreshProfile,
      backgroundColor: Colors.white,
      color: const Color(0xFF6D28D9),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D28D9), Color(0xFF7E57C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.business,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      profile['companyName'] ?? 'Insurance Account',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile['companyId'] ?? 'Personal Account',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Company Details Card
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileItem(
                      icon: Icons.person,
                      label: 'Full Name',
                      value: profile['name'] ?? 'Not set',
                      editable: true,
                      field: 'name',
                    ),
                    const Divider(height: 30),
                    _buildProfileItem(
                      icon: Icons.email,
                      label: 'Email',
                      value: profile['email'] ?? 'No Email',
                    ),
                    const Divider(height: 30),
                    _buildProfileItem(
                      icon: Icons.phone,
                      label: 'Phone Number',
                      value: profile['phone']?.toString().isNotEmpty == true ? profile['phone'] : 'Not set',
                      editable: true,
                      field: 'phone',
                    ),
                    const Divider(height: 30),
                    _buildProfileItem(
                      icon: Icons.home,
                      label: 'Address',
                      value: profile['address']?.toString().isNotEmpty == true ? profile['address'] : 'Not set',
                      editable: true,
                      field: 'address',
                      multiline: true,
                    ),
                    const Divider(height: 30),
                    _buildTimestampItem(
                      icon: Icons.calendar_today,
                      label: 'Member Since',
                      timestamp: profile['createdAt'],
                    ),
                  ],
                ),
              ),
            ),

            // Account Status Card
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildStatusItem(
                      'Verified Insurance User',
                      'Your account is active and verified',
                      Icons.verified,
                      Colors.green,
                    ),
                    const SizedBox(height: 10),
                    _buildStatusItem(
                      'Policy Management',
                      'Manage your insurance policies efficiently',
                      Icons.policy,
                      Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    _buildStatusItem(
                      '24/7 Support',
                      'Get help anytime with our support team',
                      Icons.support_agent,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            // Statistics Card
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder<QuerySnapshot>(
                      future: _firestore
                          .collection('vehicle_owners')
                          .doc(_auth.currentUser!.email)
                          .collection('insurance_requests')
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final requests = snapshot.data!.docs;
                        final totalRequests = requests.length;
                        final activePolicies = requests.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['status'] == 'active' || data['status'] == 'completed';
                        }).length;
                        final pendingRequests = requests.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['status'] == 'pending_review' || data['status'] == 'under_review';
                        }).length;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Total Requests', totalRequests.toString()),
                            _buildStatItem('Active Policies', activePolicies.toString()),
                            _buildStatItem('Pending', pendingRequests.toString()),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showEditProfileDialog(),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6D28D9),
                        side: const BorderSide(color: Color(0xFF6D28D9)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _refreshProfile,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D28D9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    bool editable = false,
    String? field,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: const Color(0xFF6D28D9),
          size: 24,
        ),
        const SizedBox(width: 15),
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                  height: multiline ? 1.3 : 1.0,
                ),
                maxLines: multiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (editable)
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _showEditFieldDialog(field!, label, value),
          ),
      ],
    );
  }

  Widget _buildStatusItem(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF6D28D9).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF6D28D9).withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimestampItem({
    required IconData icon,
    required String label,
    required dynamic timestamp,
  }) {
    String timestampText = 'Not available';
    
    if (timestamp != null) {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        timestampText = DateFormat('dd MMM yyyy').format(date);
      } else if (timestamp is DateTime) {
        timestampText = DateFormat('dd MMM yyyy').format(timestamp);
      }
    }

    return _buildProfileItem(
      icon: icon,
      label: label,
      value: timestampText,
    );
  }

  void _showEditProfileDialog() {
    final profile = _companyProfile!;
    final nameController = TextEditingController(text: profile['name'] ?? '');
    final phoneController = TextEditingController(text: profile['phone'] ?? '');
    final addressController = TextEditingController(text: profile['address'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updates = {
                'name': nameController.text.trim(),
                'phone': phoneController.text.trim(),
                'address': addressController.text.trim(),
              };
              _updateProfile(updates);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showEditFieldDialog(String field, String label, String currentValue) {
    final controller = TextEditingController(text: currentValue == 'Not set' ? '' : currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          maxLines: field == 'address' ? 3 : 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _updateProfile({field: controller.text.trim()});
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}