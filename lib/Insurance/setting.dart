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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/services/account_service.dart';
import 'package:smart_road_app/services/theme_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = true;

  // Settings states
  bool _notificationsEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  bool _orderNotificationsEnabled = true;
  bool _promotionalNotificationsEnabled = false;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  String _language = 'English';
  String _currency = 'INR - Indian Rupee';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇬🇧'},
    {'name': 'Hindi', 'code': 'hi', 'flag': '🇮🇳'},
    {'name': 'Spanish', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'French', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'German', 'code': 'de', 'flag': '🇩🇪'},
  ];
  final List<String> _currencies = ['INR - Indian Rupee', 'USD - US Dollar', 'EUR - Euro', 'GBP - British Pound'];
  
  final AccountService _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSettings();
  }

  Future<void> _loadUserData() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        final doc = await _firestore
            .collection('vehicle_owners')
            .doc(_user!.email)
            .collection('profile')
            .doc('user_details')
            .get();

        if (doc.exists) {
          setState(() {
            _userProfile = doc.data()!;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _pushNotificationsEnabled = prefs.getBool('push_notifications_enabled') ?? true;
      _emailNotificationsEnabled = prefs.getBool('email_notifications_enabled') ?? true;
      _smsNotificationsEnabled = prefs.getBool('sms_notifications_enabled') ?? false;
      _orderNotificationsEnabled = prefs.getBool('order_notifications_enabled') ?? true;
      _promotionalNotificationsEnabled = prefs.getBool('promotional_notifications_enabled') ?? false;
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _currency = prefs.getString('currency') ?? 'INR - Indian Rupee';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6D28D9),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              final isSelected = _language == language['name'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _language = language['name']!;
                  });
                  _saveSetting('language', language['name']);
                  Navigator.pop(context);
                  _showSnackBar('Language changed to ${language['name']}');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6D28D9).withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          language['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF6D28D9) : null,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xFF6D28D9)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _currencies.length,
            itemBuilder: (context, index) {
              final currency = _currencies[index];
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: _currency,
                onChanged: (value) {
                  setState(() {
                    _currency = value!;
                  });
                  _saveSetting('currency', value);
                  Navigator.pop(context);
                  _showSnackBar('Currency changed to $value');
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              _loadSettings();
              Navigator.pop(context);
              _showSnackBar('Settings reset successfully');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isObscuredCurrent = true;
    bool isObscuredNew = true;
    bool isObscuredConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: isObscuredCurrent,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isObscuredCurrent ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setDialogState(() {
                          isObscuredCurrent = !isObscuredCurrent;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: isObscuredNew,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(isObscuredNew ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setDialogState(() {
                          isObscuredNew = !isObscuredNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: isObscuredConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(isObscuredConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setDialogState(() {
                          isObscuredConfirm = !isObscuredConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                currentPasswordController.dispose();
                newPasswordController.dispose();
                confirmPasswordController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newPasswordController.text != confirmPasswordController.text) {
                  _showSnackBar('New passwords do not match');
                  return;
                }
                if (newPasswordController.text.length < 6) {
                  _showSnackBar('Password must be at least 6 characters');
                  return;
                }

                try {
                  await _accountService.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                  currentPasswordController.dispose();
                  newPasswordController.dispose();
                  confirmPasswordController.dispose();
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showSnackBar('Password changed successfully');
                  }
                } catch (e) {
                  _showSnackBar('Failed to change password: ${e.toString()}');
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final confirmTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Type "DELETE" to confirm:'),
            const SizedBox(height: 8),
            TextField(
              controller: confirmTextController,
              decoration: const InputDecoration(
                hintText: 'DELETE',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmTextController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (confirmTextController.text != 'DELETE') {
                _showSnackBar('Please type DELETE to confirm');
                return;
              }

              try {
                final userRole = await _accountService.getUserRole() ?? 'user';
                await _accountService.deleteAccount(_user?.email ?? '', userRole);
                confirmTextController.dispose();
                
                if (context.mounted) {
                  Navigator.pop(context);
                  // Navigate to login screen or show success message
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  _showSnackBar('Account deleted successfully');
                }
              } catch (e) {
                _showSnackBar('Failed to delete account: ${e.toString()}');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 20),
                  _buildNotificationSection(),
                  const SizedBox(height: 20),
                  _buildPreferencesSection(),
                  const SizedBox(height: 20),
                  _buildSecuritySection(),
                  const SizedBox(height: 20),
                  _buildSupportSection(),
                  const SizedBox(height: 20),
                  _buildAppInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF6D28D9),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                _userProfile['name'] ?? _user?.displayName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(_user?.email ?? 'No email'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF6D28D9)),
                onPressed: () {
                  // Navigate to profile edit
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable All Notifications'),
              subtitle: const Text('Master switch for all notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (!value) {
                    _pushNotificationsEnabled = false;
                    _emailNotificationsEnabled = false;
                    _smsNotificationsEnabled = false;
                    _orderNotificationsEnabled = false;
                    _promotionalNotificationsEnabled = false;
                  }
                });
                _saveSetting('notifications_enabled', value);
              },
              activeThumbColor: const Color(0xFF6D28D9),
            ),
            if (_notificationsEnabled) ...[
              const Divider(),
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive alerts and updates'),
                value: _pushNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _pushNotificationsEnabled = value;
                  });
                  _saveSetting('push_notifications_enabled', value);
              },
              activeThumbColor: const Color(0xFF6D28D9),
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive policy updates via email'),
                value: _emailNotificationsEnabled,
              onChanged: (value) {
                  setState(() {
                    _emailNotificationsEnabled = value;
                  });
                  _saveSetting('email_notifications_enabled', value);
              },
              activeThumbColor: const Color(0xFF6D28D9),
            ),
            SwitchListTile(
              title: const Text('SMS Notifications'),
              subtitle: const Text('Receive important alerts via SMS'),
                value: _smsNotificationsEnabled,
              onChanged: (value) {
                  setState(() {
                    _smsNotificationsEnabled = value;
                  });
                  _saveSetting('sms_notifications_enabled', value);
                },
                activeThumbColor: const Color(0xFF6D28D9),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Order Notifications'),
                subtitle: const Text('Get notified about your orders'),
                value: _orderNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _orderNotificationsEnabled = value;
                  });
                  _saveSetting('order_notifications_enabled', value);
                },
                activeThumbColor: const Color(0xFF6D28D9),
              ),
              SwitchListTile(
                title: const Text('Promotional Notifications'),
                subtitle: const Text('Receive offers and promotions'),
                value: _promotionalNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _promotionalNotificationsEnabled = value;
                  });
                  _saveSetting('promotional_notifications_enabled', value);
              },
              activeThumbColor: const Color(0xFF6D28D9),
            ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF6D28D9)),
              title: const Text('Language'),
              subtitle: Text(_language),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showLanguageDialog,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.currency_rupee, color: Color(0xFF6D28D9)),
              title: const Text('Currency'),
              subtitle: Text(_currency),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showCurrencyDialog,
            ),
            const Divider(),
            // Theme Toggle with Provider integration
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Color(0xFF6D28D9)),
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  _saveSetting('dark_mode_enabled', value);
                  // Update ThemeService
                  final themeService = Provider.of<ThemeService>(context, listen: false);
                  themeService.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  _showSnackBar('Dark mode ${value ? 'enabled' : 'disabled'}');
                },
                activeThumbColor: const Color(0xFF6D28D9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // FIXED: Use ListTile with custom trailing switch for Biometric Authentication
            ListTile(
              leading: const Icon(Icons.fingerprint, color: Color(0xFF6D28D9)),
              title: const Text('Biometric Authentication'),
              subtitle: const Text('Use fingerprint or face ID to login'),
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                  _saveSetting('biometric_enabled', value);
                  _showSnackBar('Biometric authentication ${value ? 'enabled' : 'disabled'}');
                },
                activeThumbColor: const Color(0xFF6D28D9),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF6D28D9)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showChangePasswordDialog,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Permanently delete your account and all data'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showDeleteAccountDialog,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security, color: Color(0xFF6D28D9)),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Add an extra layer of security'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('2FA feature coming soon');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help, color: Color(0xFF6D28D9)),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('Opening help center');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF6D28D9)),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('Opening privacy policy');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF6D28D9)),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('Opening terms of service');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bug_report, color: Color(0xFF6D28D9)),
              title: const Text('Report a Problem'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('Opening problem report form');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF6D28D9)),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.update, color: Color(0xFF6D28D9)),
              title: const Text('Check for Updates'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSnackBar('Checking for updates...');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: const Text('Reset Settings'),
              subtitle: const Text('Reset all settings to default'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showResetDialog,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out'),
              subtitle: const Text('Sign out of your account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _auth.signOut();
                _showSnackBar('Signed out successfully');
                // Navigate to login screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
