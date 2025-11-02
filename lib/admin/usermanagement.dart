// import 'package:flutter/material.dart';

// class UserManagementPage extends StatefulWidget {
//   const UserManagementPage({super.key});

//   @override
//   State<UserManagementPage> createState() => _UserManagementPageState();
// }

// class _UserManagementPageState extends State<UserManagementPage> {
//   int _selectedTab = 0;
//   String _selectedFilter = 'All Status';
//   String _searchQuery = '';
//   final List<String> _tabs = ['All Users', 'Pending Approval', 'Vehicle Owners', 'Tow Providers', 'Mechanics'];
  
//   // Sample user data
//   final List<Map<String, dynamic>> _users = [
//     {
//       'id': '1',
//       'name': 'John Doe',
//       'email': 'john.doe@email.com',
//       'phone': '+1 234 567 8900',
//       'type': 'Vehicle Owner',
//       'status': 'Pending',
//       'registrationDate': '2024-01-15',
//       'region': 'New York',
//       'avatarColor': Colors.blue,
//       'documents': ['ID Card', 'Driving License'],
//     },
//     {
//       'id': '2',
//       'name': 'Sarah Wilson',
//       'email': 'sarah.w@email.com',
//       'phone': '+1 234 567 8901',
//       'type': 'Tow Provider',
//       'status': 'Active',
//       'registrationDate': '2024-01-10',
//       'region': 'California',
//       'avatarColor': Colors.green,
//       'documents': ['Business License', 'Insurance'],
//     },
//     {
//       'id': '3',
//       'name': 'Mike Johnson',
//       'email': 'mike.j@email.com',
//       'phone': '+1 234 567 8902',
//       'type': 'Mechanic',
//       'status': 'Pending',
//       'registrationDate': '2024-01-18',
//       'region': 'Texas',
//       'avatarColor': Colors.orange,
//       'documents': ['Certification', 'ID Card'],
//     },
//     {
//       'id': '4',
//       'name': 'Emily Davis',
//       'email': 'emily.d@email.com',
//       'phone': '+1 234 567 8903',
//       'type': 'Vehicle Owner',
//       'status': 'Active',
//       'registrationDate': '2024-01-05',
//       'region': 'Florida',
//       'avatarColor': Colors.purple,
//       'documents': ['ID Card', 'Vehicle RC'],
//     },
//     {
//       'id': '5',
//       'name': 'Robert Brown',
//       'email': 'robert.b@email.com',
//       'phone': '+1 234 567 8904',
//       'type': 'Tow Provider',
//       'status': 'Rejected',
//       'registrationDate': '2024-01-20',
//       'region': 'Illinois',
//       'avatarColor': Colors.red,
//       'documents': ['Business License'],
//     },
//   ];

//   List<Map<String, dynamic>> get _filteredUsers {
//     List<Map<String, dynamic>> filtered = List.from(_users);
    
//     // Apply search filter
//     if (_searchQuery.isNotEmpty) {
//       filtered = filtered.where((user) =>
//         user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//         user['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//         user['phone'].contains(_searchQuery)
//       ).toList();
//     }
    
//     // Apply status filter
//     if (_selectedFilter != 'All Status') {
//       filtered = filtered.where((user) => user['status'] == _selectedFilter).toList();
//     }
    
//     // Apply tab filter
//     if (_selectedTab == 1) { // Pending Approval
//       filtered = filtered.where((user) => user['status'] == 'Pending').toList();
//     } else if (_selectedTab == 2) { // Vehicle Owners
//       filtered = filtered.where((user) => user['type'] == 'Vehicle Owner').toList();
//     } else if (_selectedTab == 3) { // Tow Providers
//       filtered = filtered.where((user) => user['type'] == 'Tow Provider').toList();
//     } else if (_selectedTab == 4) { // Mechanics
//       filtered = filtered.where((user) => user['type'] == 'Mechanic').toList();
//     }
    
//     return filtered;
//   }

//   void _showUserDetails(Map<String, dynamic> user) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => UserDetailsSheet(user: user),
//     );
//   }

//   void _showBulkActions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Bulk Actions', style: Theme.of(context).textTheme.headlineSmall),
//             const SizedBox(height: 20),
//             _buildBulkActionButton('Approve All Selected', Icons.check, Colors.green, () {}),
//             _buildBulkActionButton('Reject All Selected', Icons.close, Colors.red, () {}),
//             _buildBulkActionButton('Export Selected', Icons.download, Colors.blue, () {}),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBulkActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(text),
//       onTap: onTap,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Header with Stats
//         Container(
//           padding: const EdgeInsets.all(16),
//           color: Colors.white,
//           child: Row(
//             children: [
//               _buildStatItem('Total Users', _users.length.toString(), Colors.blue),
//               _buildStatItem('Pending', _users.where((u) => u['status'] == 'Pending').length.toString(), Colors.orange),
//               _buildStatItem('Active', _users.where((u) => u['status'] == 'Active').length.toString(), Colors.green),
//               _buildStatItem('Rejected', _users.where((u) => u['status'] == 'Rejected').length.toString(), Colors.red),
//             ],
//           ),
//         ),

//         // Filter and Search Bar
//         Container(
//           padding: const EdgeInsets.all(16),
//           color: Colors.white,
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) => setState(() => _searchQuery = value),
//                       decoration: InputDecoration(
//                         hintText: 'Search users by name, email, or phone...',
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Bulk Actions Button
//                   if (_selectedTab == 1) // Show only for pending approval
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.blue[100]!),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.playlist_add_check, color: Colors.blue),
//                         onPressed: _showBulkActions,
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   // Status Filter
//                   FilterChip(
//                     label: Text(_selectedFilter),
//                     selected: _selectedFilter != 'All Status',
//                     onSelected: (selected) {
//                       if (!selected) {
//                         setState(() => _selectedFilter = 'All Status');
//                       }
//                     },
//                     avatar: const Icon(Icons.filter_list, size: 16),
//                   ),
//                   const SizedBox(width: 8),
//                   // Region Filter
//                   FilterChip(
//                     label: const Text('All Regions'),
//                     onSelected: (selected) {},
//                   ),
//                   const SizedBox(width: 8),
//                   // Date Filter
//                   FilterChip(
//                     label: const Text('All Time'),
//                     onSelected: (selected) {},
//                   ),
//                   const Spacer(),
//                   // Export Button
//                   IconButton(
//                     icon: const Icon(Icons.download),
//                     onPressed: () {},
//                     tooltip: 'Export Users',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // Tabs
//         Container(
//           height: 50,
//           color: Colors.white,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _tabs.length,
//             itemBuilder: (context, index) {
//               final count = _getTabCount(index);
//               return GestureDetector(
//                 onTap: () => setState(() => _selectedTab = index),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: _selectedTab == index ? Colors.blue : Colors.transparent,
//                         width: 3,
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         _tabs[index],
//                         style: TextStyle(
//                           color: _selectedTab == index ? Colors.blue : Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       if (count > 0) ...[
//                         const SizedBox(width: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: _selectedTab == index ? Colors.blue : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             count.toString(),
//                             style: TextStyle(
//                               color: _selectedTab == index ? Colors.white : Colors.grey[700],
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),

//         // User List
//         Expanded(
//           child: _filteredUsers.isEmpty
//               ? _buildEmptyState()
//               : ListView.builder(
//                   itemCount: _filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     return _buildUserCard(_filteredUsers[index]);
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatItem(String title, String value, Color color) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.only(right: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserCard(Map<String, dynamic> user) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // User Avatar with Status
//             Stack(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: user['avatarColor'].withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Icon(Icons.person, color: user['avatarColor']),
//                 ),
//                 Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(user['status']),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 16),

//             // User Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: _getTypeColor(user['type']).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           user['type'],
//                           style: TextStyle(
//                             color: _getTypeColor(user['type']),
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(user['email'], style: TextStyle(color: Colors.grey[600])),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.phone, size: 14, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(user['phone'], style: TextStyle(color: Colors.grey[600])),
//                       const SizedBox(width: 16),
//                       Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(user['region'], style: TextStyle(color: Colors.grey[600])),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Registered: ${user['registrationDate']}',
//                     style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),

//             // Status and Actions
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(user['status']).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     user['status'],
//                     style: TextStyle(
//                       color: _getStatusColor(user['status']),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     if (user['status'] == 'Pending') ...[
//                       _buildActionButton(Icons.check, Colors.green, 'Approve', () {}),
//                       _buildActionButton(Icons.close, Colors.red, 'Reject', () {}),
//                     ],
//                     _buildActionButton(Icons.visibility, Colors.blue, 'View Details', 
//                       () => _showUserDetails(user)),
//                     _buildActionButton(Icons.more_vert, Colors.grey, 'More', () {}),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(IconData icon, Color color, String tooltip, VoidCallback onPressed) {
//     return Container(
//       margin: const EdgeInsets.only(left: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 18, color: color),
//         onPressed: onPressed,
//         tooltip: tooltip,
//         padding: const EdgeInsets.all(6),
//         constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           Text(
//             'No users found',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try adjusting your search or filters',
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () {
//               setState(() {
//                 _searchQuery = '';
//                 _selectedFilter = 'All Status';
//               });
//             },
//             icon: const Icon(Icons.refresh),
//             label: const Text('Reset Filters'),
//           ),
//         ],
//       ),
//     );
//   }

//   int _getTabCount(int tabIndex) {
//     switch (tabIndex) {
//       case 1: return _users.where((u) => u['status'] == 'Pending').length;
//       case 2: return _users.where((u) => u['type'] == 'Vehicle Owner').length;
//       case 3: return _users.where((u) => u['type'] == 'Tow Provider').length;
//       case 4: return _users.where((u) => u['type'] == 'Mechanic').length;
//       default: return 0;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Active': return Colors.green;
//       case 'Pending': return Colors.orange;
//       case 'Rejected': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   Color _getTypeColor(String type) {
//     switch (type) {
//       case 'Vehicle Owner': return Colors.blue;
//       case 'Tow Provider': return Colors.green;
//       case 'Mechanic': return Colors.orange;
//       default: return Colors.purple;
//     }
//   }
// }

// class UserDetailsSheet extends StatelessWidget {
//   final Map<String, dynamic> user;

//   const UserDetailsSheet({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 60,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: user['avatarColor'].withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Icon(Icons.person, color: user['avatarColor'], size: 30),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(user['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 4),
//                     Text(user['type'], style: TextStyle(color: Colors.grey[600])),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(user['status']).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   user['status'],
//                   style: TextStyle(
//                     color: _getStatusColor(user['status']),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           _buildDetailRow('Email', user['email'], Icons.email),
//           _buildDetailRow('Phone', user['phone'], Icons.phone),
//           _buildDetailRow('Region', user['region'], Icons.location_on),
//           _buildDetailRow('Registration Date', user['registrationDate'], Icons.calendar_today),
//           const SizedBox(height: 16),
//           const Text('Verification Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             children: (user['documents'] as List<String>).map((doc) => Chip(
//               label: Text(doc),
//               backgroundColor: Colors.blue[50],
//             )).toList(),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.chat),
//                   label: const Text('Send Message'),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.edit),
//                   label: const Text('Edit Profile'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[600]),
//           const SizedBox(width: 12),
//           Expanded(
//             flex: 2,
//             child: Text(label, style: TextStyle(color: Colors.grey[600])),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Active': return Colors.green;
//       case 'Pending': return Colors.orange;
//       case 'Rejected': return Colors.red;
//       default: return Colors.grey;
//     }
//   }
// }