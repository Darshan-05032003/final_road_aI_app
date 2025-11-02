// import 'package:flutter/material.dart';

// class LiveMonitoringPage extends StatefulWidget {
//   const LiveMonitoringPage({super.key});

//   @override
//   State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
// }

// class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
//   String _selectedFilter = 'All';
//   final String _mapView = 'Standard';
//   bool _showHeatmap = false;
//   int _selectedService = -1;

//   final List<Map<String, dynamic>> _activeServices = [
//     {
//       'id': '1',
//       'type': 'Tow Service',
//       'customer': 'John Doe',
//       'status': 'On the way',
//       'duration': '12 mins ago',
//       'location': 'Downtown, Manhattan',
//       'provider': 'City Tow Services',
//       'eta': '8 min',
//       'distance': '2.3 km',
//       'priority': 'High',
//       'coordinates': {'x': 120, 'y': 180},
//       'vehicle': 'Toyota Camry 2020',
//       'issue': 'Flat tire',
//     },
//     {
//       'id': '2',
//       'type': 'Emergency',
//       'customer': 'Sarah Wilson',
//       'status': 'SOS Active',
//       'duration': '2 mins ago',
//       'location': 'Highway I-95',
//       'provider': 'Emergency Response',
//       'eta': '5 min',
//       'distance': '1.2 km',
//       'priority': 'Critical',
//       'coordinates': {'x': 200, 'y': 250},
//       'vehicle': 'Honda Civic 2019',
//       'issue': 'Accident - Minor injuries',
//     },
//     {
//       'id': '3',
//       'type': 'Mechanic',
//       'customer': 'Mike Johnson',
//       'status': 'At location',
//       'duration': '25 mins ago',
//       'location': 'Central Park Area',
//       'provider': 'Mobile Mechanics Inc',
//       'eta': '0 min',
//       'distance': '0 km',
//       'priority': 'Medium',
//       'coordinates': {'x': 150, 'y': 120},
//       'vehicle': 'Ford F-150 2021',
//       'issue': 'Engine overheating',
//     },
//     {
//       'id': '4',
//       'type': 'Fuel Delivery',
//       'customer': 'Emily Davis',
//       'status': 'In progress',
//       'duration': '18 mins ago',
//       'location': 'Business District',
//       'provider': 'Quick Fuel Services',
//       'eta': '3 min',
//       'distance': '0.8 km',
//       'priority': 'Medium',
//       'coordinates': {'x': 280, 'y': 150},
//       'vehicle': 'BMW X5 2022',
//       'issue': 'Out of fuel',
//     },
//     {
//       'id': '5',
//       'type': 'Insurance',
//       'customer': 'Robert Brown',
//       'status': 'Pending',
//       'duration': '35 mins ago',
//       'location': 'Suburban Area',
//       'provider': 'Insurance Assessors',
//       'eta': '15 min',
//       'distance': '5.7 km',
//       'priority': 'Low',
//       'coordinates': {'x': 80, 'y': 300},
//       'vehicle': 'Mercedes C-Class 2020',
//       'issue': 'Claim assessment',
//     },
//   ];

//   List<Map<String, dynamic>> get _filteredServices {
//     if (_selectedFilter == 'All') return _activeServices;
//     return _activeServices.where((service) => service['type'] == _selectedFilter).toList();
//   }

//   void _showServiceDetails(Map<String, dynamic> service) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => ServiceDetailsSheet(service: service),
//     );
//   }

//   void _showEmergencyAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.warning, color: Colors.red, size: 30),
//             SizedBox(width: 12),
//             Text('EMERGENCY ALERT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('SOS Triggered - Immediate Assistance Required', style: TextStyle(fontWeight: FontWeight.w600)),
//             SizedBox(height: 12),
//             Text('Customer: Sarah Wilson'),
//             Text('Location: Highway I-95, Exit 45'),
//             Text('Vehicle: Honda Civic 2019'),
//             Text('Issue: Accident with minor injuries'),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.local_shipping, color: Colors.red),
//                   SizedBox(width: 8),
//                   Expanded(child: Text('Nearest tow: 5 mins away')),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Dismiss'),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Dispatch Help'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Control Panel
//         Container(
//           padding: EdgeInsets.all(16),
//           color: Colors.white,
//           child: Column(
//             children: [
//               // Quick Stats
//               Row(
//                 children: [
//                   _buildStatItem('Active', '${_activeServices.length}', Colors.blue, Icons.directions_car),
//                   _buildStatItem('SOS', '${_activeServices.where((s) => s['type'] == 'Emergency').length}', Colors.red, Icons.warning),
//                   _buildStatItem('Completed', '23', Colors.green, Icons.check_circle),
//                   _buildStatItem('Avg ETA', '8 min', Colors.orange, Icons.timer),
//                 ],
//               ),
//               SizedBox(height: 12),
//               // Controls
//               Row(
//                 children: [
//                   Expanded(
//                     child: Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         FilterChip(
//                           label: Text('All'),
//                           selected: _selectedFilter == 'All',
//                           onSelected: (selected) => setState(() => _selectedFilter = 'All'),
//                         ),
//                         FilterChip(
//                           label: Text('Emergency'),
//                           selected: _selectedFilter == 'Emergency',
//                           onSelected: (selected) => setState(() => _selectedFilter = 'Emergency'),
//                         ),
//                         FilterChip(
//                           label: Text('Tow'),
//                           selected: _selectedFilter == 'Tow Service',
//                           onSelected: (selected) => setState(() => _selectedFilter = 'Tow Service'),
//                         ),
//                         FilterChip(
//                           label: Text('Mechanic'),
//                           selected: _selectedFilter == 'Mechanic',
//                           onSelected: (selected) => setState(() => _selectedFilter = 'Mechanic'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.refresh),
//                     onPressed: () {},
//                     tooltip: 'Refresh Map',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // Map Section
//         Expanded(
//           flex: 2,
//           child: Container(
//             margin: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 // Map Background with Grid
//                 _buildMapBackground(),
                
//                 // Heatmap Overlay
//                 if (_showHeatmap) _buildHeatmapOverlay(),
                
//                 // Service Markers
//                 ..._filteredServices.map((service) => _buildServiceMarker(service)),
                
//                 // Map Controls
//                 Positioned(
//                   top: 16,
//                   right: 16,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _buildMapControlButton(Icons.zoom_in, 'Zoom In'),
//                         _buildMapControlButton(Icons.zoom_out, 'Zoom Out'),
//                         _buildMapControlButton(Icons.my_location, 'My Location'),
//                         _buildMapControlButton(
//                           _showHeatmap ? Icons.map : Icons.terrain,
//                           _showHeatmap ? 'Hide Heatmap' : 'Show Heatmap',
//                           onPressed: () => setState(() => _showHeatmap = !_showHeatmap),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Emergency Alert Button
//                 Positioned(
//                   bottom: 16,
//                   right: 16,
//                   child: FloatingActionButton(
//                     onPressed: _showEmergencyAlert,
//                     backgroundColor: Colors.red,
//                     child: Stack(
//                       children: [
//                         Icon(Icons.warning, color: Colors.white),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               '!',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Services List
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: Offset(0, -4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Active Services (${_filteredServices.length})', 
//                          style: Theme.of(context).textTheme.headlineSmall),
//                     Row(
//                       children: [
//                         Icon(Icons.sort, size: 20, color: Colors.grey[600]),
//                         SizedBox(width: 4),
//                         Text('Sort by: ETA', style: TextStyle(color: Colors.grey[600])),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Expanded(
//                   child: _filteredServices.isEmpty 
//                       ? _buildEmptyState()
//                       : ListView.builder(
//                           itemCount: _filteredServices.length,
//                           itemBuilder: (context, index) {
//                             return _buildServiceCard(_filteredServices[index], index);
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatItem(String title, String value, Color color, IconData icon) {
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.only(right: 8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 16, color: color),
//             ),
//             SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
//                 Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMapBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.blue[50]!, Colors.blue[100]!],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: CustomPaint(
//         painter: MapGridPainter(),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.map, size: 60, color: Colors.blue[300]),
//               SizedBox(height: 16),
//               Text(
//                 'Live Service Map',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue[700],
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Real-time tracking of ${_filteredServices.length} active services',
//                 style: TextStyle(color: Colors.grey[600]),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeatmapOverlay() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [
//             Colors.red.withOpacity(0.3),
//             Colors.orange.withOpacity(0.2),
//             Colors.yellow.withOpacity(0.1),
//             Colors.transparent,
//           ],
//           stops: [0.1, 0.3, 0.6, 1.0],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceMarker(Map<String, dynamic> service) {
//     final isSelected = _selectedService == _activeServices.indexOf(service);
//     return Positioned(
//       left: service['coordinates']['x'].toDouble(),
//       top: service['coordinates']['y'].toDouble(),
//       child: GestureDetector(
//         onTap: () => setState(() => _selectedService = _activeServices.indexOf(service)),
//         child: Column(
//           children: [
//             // Pulse Animation for Emergency
//             if (service['type'] == 'Emergency')
//               PulseAnimation(
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.red.withOpacity(0.3),
//                   ),
//                 ),
//               ),
            
//             // Main Marker
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: _getServiceColor(service['type']),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _getServiceColor(service['type']).withOpacity(0.5),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                   if (isSelected)
//                     BoxShadow(
//                       color: _getServiceColor(service['type']),
//                       blurRadius: 15,
//                       spreadRadius: 2,
//                     ),
//                 ],
//                 border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
//               ),
//               child: Icon(
//                 _getServiceIcon(service['type']),
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             SizedBox(height: 4),
            
//             // Marker Label
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 service['type'].toString().split(' ').first,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: _getServiceColor(service['type']),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMapControlButton(IconData icon, String tooltip, {VoidCallback? onPressed}) {
//     return Container(
//       width: 40,
//       height: 40,
//       margin: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 18),
//         onPressed: onPressed ?? () {},
//         tooltip: tooltip,
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildServiceCard(Map<String, dynamic> service, int index) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(16),
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: _getServiceColor(service['type']).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _getServiceColor(service['type']).withOpacity(0.3)),
//           ),
//           child: Icon(
//             _getServiceIcon(service['type']),
//             color: _getServiceColor(service['type']),
//             size: 24,
//           ),
//         ),
//         title: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 service['type'],
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: _getPriorityColor(service['priority']).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 service['priority'],
//                 style: TextStyle(
//                   color: _getPriorityColor(service['priority']),
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 4),
//             Text('Customer: ${service['customer']}'),
//             Text('Location: ${service['location']}'),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.timer, size: 12, color: Colors.grey[600]),
//                 SizedBox(width: 4),
//                 Text('ETA: ${service['eta']}', style: TextStyle(fontSize: 12)),
//                 SizedBox(width: 16),
//                 Icon(Icons.phone, size: 12, color: Colors.grey[600]),
//                 SizedBox(width: 4),
//                 Text('Call', style: TextStyle(fontSize: 12, color: Colors.blue)),
//               ],
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(service['status']).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 service['status'],
//                 style: TextStyle(
//                   color: _getStatusColor(service['status']),
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(service['duration'], style: TextStyle(color: Colors.grey[600], fontSize: 10)),
//           ],
//         ),
//         onTap: () => _showServiceDetails(service),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
//           SizedBox(height: 16),
//           Text(
//             'No Active Services',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'All services are completed or no matches found',
//             style: TextStyle(color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getServiceColor(String type) {
//     switch (type) {
//       case 'Emergency': return Colors.red;
//       case 'Tow Service': return Colors.orange;
//       case 'Mechanic': return Colors.green;
//       case 'Insurance': return Colors.blue;
//       case 'Fuel Delivery': return Colors.purple;
//       default: return Colors.grey;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Completed': return Colors.green;
//       case 'In progress': return Colors.blue;
//       case 'On the way': return Colors.orange;
//       case 'SOS Active': return Colors.red;
//       case 'Pending': return Colors.grey;
//       default: return Colors.purple;
//     }
//   }

//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case 'Critical': return Colors.red;
//       case 'High': return Colors.orange;
//       case 'Medium': return Colors.blue;
//       case 'Low': return Colors.green;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getServiceIcon(String type) {
//     switch (type) {
//       case 'Tow Service': return Icons.local_shipping;
//       case 'Mechanic': return Icons.handyman;
//       case 'Emergency': return Icons.warning;
//       case 'Insurance': return Icons.security;
//       case 'Fuel Delivery': return Icons.local_gas_station;
//       default: return Icons.help;
//     }
//   }
// }

// class MapGridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue[100]!
//       ..strokeWidth = 0.5
//       ..style = PaintingStyle.stroke;

//     // Draw grid lines
//     for (double i = 0; i < size.width; i += 30) {
//       canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
//     }
//     for (double i = 0; i < size.height; i += 30) {
//       canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
//     }

//     // Draw main roads
//     final roadPaint = Paint()
//       ..color = Colors.blue[200]!
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), roadPaint);
//     canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), roadPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class PulseAnimation extends StatefulWidget {
//   final Widget child;

//   const PulseAnimation({super.key, required this.child});

//   @override
//   State<PulseAnimation> createState() => _PulseAnimationState();
// }

// class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _animation.value,
//           child: Opacity(
//             opacity: 1.0 - _animation.value,
//             child: widget.child,
//           ),
//         );
//       },
//     );
//   }
// }

// class ServiceDetailsSheet extends StatelessWidget {
//   final Map<String, dynamic> service;

//   const ServiceDetailsSheet({super.key, required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: _getServiceColor(service['type']).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   _getServiceIcon(service['type']),
//                   color: _getServiceColor(service['type']),
//                   size: 30,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(service['type'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 4),
//                     Text('Service #${service['id']}', style: TextStyle(color: Colors.grey[600])),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(service['status']).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   service['status'],
//                   style: TextStyle(
//                     color: _getStatusColor(service['status']),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24),
//           _buildDetailRow('Customer', service['customer'], Icons.person),
//           _buildDetailRow('Vehicle', service['vehicle'], Icons.directions_car),
//           _buildDetailRow('Issue', service['issue'], Icons.info),
//           _buildDetailRow('Location', service['location'], Icons.location_on),
//           _buildDetailRow('Provider', service['provider'], Icons.business),
//           _buildDetailRow('ETA', service['eta'], Icons.timer),
//           _buildDetailRow('Distance', service['distance'], Icons.space_dashboard),
//           SizedBox(height: 24),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.phone),
//                   label: Text('Call Customer'),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.chat),
//                   label: Text('Message'),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.directions),
//                   label: Text('View Route'),
//                 ),
//               ),
//               SizedBox(width: 12),
//               if (service['type'] == 'Emergency')
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.warning),
//                     label: Text('Dispatch Help'),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[600]),
//           SizedBox(width: 12),
//           Expanded(flex: 2, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
//           Expanded(flex: 3, child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
//         ],
//       ),
//     );
//   }

//   Color _getServiceColor(String type) {
//     switch (type) {
//       case 'Emergency': return Colors.red;
//       case 'Tow Service': return Colors.orange;
//       case 'Mechanic': return Colors.green;
//       case 'Insurance': return Colors.blue;
//       case 'Fuel Delivery': return Colors.purple;
//       default: return Colors.grey;
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Completed': return Colors.green;
//       case 'In progress': return Colors.blue;
//       case 'On the way': return Colors.orange;
//       case 'SOS Active': return Colors.red;
//       case 'Pending': return Colors.grey;
//       default: return Colors.purple;
//     }
//   }

//   IconData _getServiceIcon(String type) {
//     switch (type) {
//       case 'Tow Service': return Icons.local_shipping;
//       case 'Mechanic': return Icons.handyman;
//       case 'Emergency': return Icons.warning;
//       case 'Insurance': return Icons.security;
//       case 'Fuel Delivery': return Icons.local_gas_station;
//       default: return Icons.help;
//     }
//   }
// }