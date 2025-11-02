// import 'package:flutter/material.dart';

// class DashboardHomePage extends StatelessWidget {
//   const DashboardHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Emergency Alert Banner
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.red[500]!, Colors.orange[500]!],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.warning, color: Colors.white, size: 30),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'EMERGENCY ALERT',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'SOS triggered by John Doe - Vehicle breakdown on Highway 401',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//                   child: Text('View Details', style: TextStyle(color: Colors.red)),
//                 ),
//               ],
//             ),
//           ),
          
//           const SizedBox(height: 20),
          
//           // Quick Stats
//           Text('Quick Overview', style: Theme.of(context).textTheme.headlineSmall),
//           const SizedBox(height: 16),
          
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             children: [
//               _buildStatCard(
//                 'Total Users',
//                 '1,247',
//                 Icons.people,
//                 Colors.blue,
//                 '+12% from last month',
//               ),
//               _buildStatCard(
//                 'Active Services',
//                 '23',
//                 Icons.directions_car,
//                 Colors.green,
//                 '5 pending approval',
//               ),
//               _buildStatCard(
//                 'Revenue Today',
//                 '\$2,847',
//                 Icons.attach_money,
//                 Colors.purple,
//                 '+8% from yesterday',
//               ),
//               _buildStatCard(
//                 'SOS Alerts',
//                 '3',
//                 Icons.warning,
//                 Colors.red,
//                 '1 requires attention',
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 20),
          
//           // Recent Activity
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Recent Activity', style: Theme.of(context).textTheme.headlineSmall),
//                 const SizedBox(height: 16),
//                 _buildActivityItem('New tow provider registered', '5 mins ago', Icons.person_add),
//                 _buildActivityItem('Service request completed', '12 mins ago', Icons.check_circle),
//                 _buildActivityItem('Emergency alert resolved', '25 mins ago', Icons.warning),
//                 _buildActivityItem('Monthly revenue report generated', '1 hour ago', Icons.analytics),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//           const SizedBox(height: 4),
//           Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityItem(String title, String time, IconData icon) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: Colors.blue, size: 20),
//       ),
//       title: Text(title),
//       subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//     );
//   }
// }

