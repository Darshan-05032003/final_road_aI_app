// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // void main() {
// //   runApp(const VehicleAssistAdminApp());
// // }

// // class VehicleAssistAdminApp extends StatelessWidget {
// //   const VehicleAssistAdminApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Vehicle Assist Admin',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         fontFamily: GoogleFonts.poppins().fontFamily,
// //         useMaterial3: true,
// //       ),
// //       home: const AdminDashboard(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // class AdminDashboard extends StatefulWidget {
// //   const AdminDashboard({super.key});

// //   @override
// //   State<AdminDashboard> createState() => _AdminDashboardState();
// // }

// // class _AdminDashboardState extends State<AdminDashboard> {
// //   int _currentIndex = 0;
// //   final List<Widget> _pages = [
// //     const DashboardHomePage(),
// //     const UserManagementPage(),
// //     const LiveMonitoringPage(),
// //     const AnalyticsPage(),
// //     const RevenuePage(),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: AppBar(
// //         title: const Text('Vehicle Assist Admin'),
// //         backgroundColor: Colors.blue[700],
// //         foregroundColor: Colors.white,
// //         elevation: 0,
// //         actions: [
// //           IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
// //           IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
// //         ],
// //       ),
// //       body: _pages[_currentIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _currentIndex,
// //         onTap: (index) => setState(() => _currentIndex = index),
// //         type: BottomNavigationBarType.fixed,
// //         selectedItemColor: Colors.blue[700],
// //         unselectedItemColor: Colors.grey[600],
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
// //           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
// //           BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Live Map'),
// //           BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
// //           BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Revenue'),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class DashboardHomePage extends StatelessWidget {
// //   const DashboardHomePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Emergency Alert Banner
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Colors.red[500]!, Colors.orange[500]!],
// //               ),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.warning, color: Colors.white, size: 30),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'EMERGENCY ALERT',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       Text(
// //                         'SOS triggered by John Doe - Vehicle breakdown on Highway 401',
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {},
// //                   style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
// //                   child: Text('View Details', style: TextStyle(color: Colors.red)),
// //                 ),
// //               ],
// //             ),
// //           ),
          
// //           const SizedBox(height: 20),
          
// //           // Quick Stats
// //           Text('Quick Overview', style: Theme.of(context).textTheme.headlineSmall),
// //           const SizedBox(height: 16),
          
// //           GridView.count(
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             crossAxisCount: 2,
// //             crossAxisSpacing: 16,
// //             mainAxisSpacing: 16,
// //             children: [
// //               _buildStatCard(
// //                 'Total Users',
// //                 '1,247',
// //                 Icons.people,
// //                 Colors.blue,
// //                 '+12% from last month',
// //               ),
// //               _buildStatCard(
// //                 'Active Services',
// //                 '23',
// //                 Icons.directions_car,
// //                 Colors.green,
// //                 '5 pending approval',
// //               ),
// //               _buildStatCard(
// //                 'Revenue Today',
// //                 '\$2,847',
// //                 Icons.attach_money,
// //                 Colors.purple,
// //                 '+8% from yesterday',
// //               ),
// //               _buildStatCard(
// //                 'SOS Alerts',
// //                 '3',
// //                 Icons.warning,
// //                 Colors.red,
// //                 '1 requires attention',
// //               ),
// //             ],
// //           ),
          
// //           const SizedBox(height: 20),
          
// //           // Recent Activity
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.2),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Recent Activity', style: Theme.of(context).textTheme.headlineSmall),
// //                 const SizedBox(height: 16),
// //                 _buildActivityItem('New tow provider registered', '5 mins ago', Icons.person_add),
// //                 _buildActivityItem('Service request completed', '12 mins ago', Icons.check_circle),
// //                 _buildActivityItem('Emergency alert resolved', '25 mins ago', Icons.warning),
// //                 _buildActivityItem('Monthly revenue report generated', '1 hour ago', Icons.analytics),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.2),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(icon, color: color, size: 24),
// //               ),
// //               Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
// //           const SizedBox(height: 4),
// //           Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildActivityItem(String title, String time, IconData icon) {
// //     return ListTile(
// //       leading: Container(
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: Colors.blue.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: Icon(icon, color: Colors.blue, size: 20),
// //       ),
// //       title: Text(title),
// //       subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
// //       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
// //     );
// //   }
// // }

// // class AnalyticsPage extends StatefulWidget {
// //   const AnalyticsPage({super.key});

// //   @override
// //   State<AnalyticsPage> createState() => _AnalyticsPageState();
// // }

// // class _AnalyticsPageState extends State<AnalyticsPage> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   String _timeRange = 'Monthly';
// //   String _selectedMetric = 'All Services';
// //   bool _showDetailedView = false;
// //   bool _isLoading = false;

// //   final List<String> _timeRanges = ['Daily', 'Weekly', 'Monthly', 'Quarterly'];
// //   final List<String> _metrics = ['All Services', 'Tow', 'Mechanic', 'Emergency', 'Fuel'];

// //   // Enhanced sample data with explicit types
// //   final Map<String, dynamic> _analyticsData = {
// //     'kpis': {
// //       'totalServices': 1847,
// //       'responseTime': 12.4,
// //       'satisfactionRate': 94.2,
// //       'revenue': 45200,
// //       'activeUsers': 1247,
// //       'completionRate': 92.5,
// //       'emergencyResponse': 6.5,
// //       'revenueGrowth': 12,
// //       'newCustomers': 156,
// //       'repeatCustomers': 892,
// //     },
// //     'serviceDistribution': {
// //       'Tow Service': 45,
// //       'Mechanic': 30,
// //       'Emergency': 15,
// //       'Fuel Delivery': 8,
// //       'Insurance': 2,
// //     },
// //     'topProviders': [
// //       {'name': 'City Tow Services', 'rating': 4.9, 'services': 247, 'revenue': 12500, 'responseTime': 8.2},
// //       {'name': 'Mobile Mechanics', 'rating': 4.8, 'services': 198, 'revenue': 9800, 'responseTime': 12.5},
// //       {'name': 'Quick Fuel Co.', 'rating': 4.7, 'services': 156, 'revenue': 6200, 'responseTime': 15.3},
// //       {'name': 'Emergency Assist', 'rating': 4.9, 'services': 132, 'revenue': 8500, 'responseTime': 6.5},
// //       {'name': 'Pro Auto Care', 'rating': 4.6, 'services': 121, 'revenue': 5800, 'responseTime': 14.2},
// //     ],
// //     'performanceTrends': [
// //       {'month': 'Jan', 'services': 420, 'revenue': 9800, 'satisfaction': 92, 'responseTime': 14.2},
// //       {'month': 'Feb', 'services': 380, 'revenue': 8900, 'satisfaction': 91, 'responseTime': 13.8},
// //       {'month': 'Mar', 'services': 450, 'revenue': 10500, 'satisfaction': 93, 'responseTime': 12.5},
// //       {'month': 'Apr', 'services': 520, 'revenue': 12200, 'satisfaction': 94, 'responseTime': 11.2},
// //       {'month': 'May', 'services': 580, 'revenue': 13500, 'satisfaction': 95, 'responseTime': 10.8},
// //     ],
// //     'regionalData': {
// //       'Downtown': {'services': 456, 'revenue': 12500, 'satisfaction': 94},
// //       'Suburbs': {'services': 389, 'revenue': 9800, 'satisfaction': 92},
// //       'Highway': {'services': 267, 'revenue': 7200, 'satisfaction': 89},
// //       'Industrial': {'services': 198, 'revenue': 5600, 'satisfaction': 91},
// //       'Rural': {'services': 145, 'revenue': 4200, 'satisfaction': 88},
// //     },
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 4, vsync: this);
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     setState(() => _isLoading = true);
// //     // Simulate API call
// //     await Future.delayed(const Duration(seconds: 1));
// //     setState(() => _isLoading = false);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final isMobile = screenWidth < 600;
// //     final isTablet = screenWidth >= 600 && screenWidth < 1200;
// //     final isDesktop = screenWidth >= 1200;

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F9FD),
// //       body: _isLoading 
// //           ? _buildLoadingState()
// //           : Column(
// //               children: [
// //                 // Enhanced Header
// //                 _buildHeader(isMobile, isTablet),
                
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     padding: EdgeInsets.all(isMobile ? 12 : 16),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // KPI Cards Grid
// //                         _buildKPISection(isMobile, isTablet),
                        
// //                         SizedBox(height: isMobile ? 16 : 24),
                        
// //                         // Metric Filter
// //                         _buildMetricFilter(isMobile),
                        
// //                         SizedBox(height: isMobile ? 12 : 16),
                        
// //                         // Main Analytics Tabs
// //                         _buildAnalyticsTabs(isMobile, isTablet, isDesktop),
                        
// //                         SizedBox(height: isMobile ? 16 : 24),
                        
// //                         // Additional Insights
// //                         if (isDesktop) _buildAdditionalInsights(),
                        
// //                         SizedBox(height: isMobile ? 16 : 24),
                        
// //                         // Export Section
// //                         _buildExportSection(isMobile),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //     );
// //   }

// //   Widget _buildLoadingState() {
// //     return const Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(
// //             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
// //           ),
// //           SizedBox(height: 16),
// //           Text(
// //             'Loading Analytics...',
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Color(0xFF666666),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildHeader(bool isMobile, bool isTablet) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: isMobile ? 16 : 20, 
// //         vertical: isMobile ? 12 : 16,
// //       ),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFF7E57C2).withOpacity(0.3),
// //             blurRadius: 20,
// //             offset: const Offset(0, 6),
// //           ),
// //         ],
// //       ),
// //       child: SafeArea(
// //         child: isMobile 
// //             ? _buildMobileHeader()
// //             : _buildDesktopHeader(isTablet),
// //       ),
// //     );
// //   }

// //   Widget _buildDesktopHeader(bool isTablet) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Analytics Dashboard',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: isTablet ? 20 : 24,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             if (!isTablet) ...[
// //               const SizedBox(height: 4),
// //               const Text(
// //                 'Comprehensive insights and performance metrics',
// //                 style: TextStyle(
// //                   color: Colors.white70,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //         Row(
// //           children: [
// //             _buildTimeRangeDropdown(),
// //             const SizedBox(width: 12),
// //             _buildViewToggle(),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildMobileHeader() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             const Text(
// //               'Analytics',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             _buildViewToggle(),
// //           ],
// //         ),
// //         const SizedBox(height: 12),
// //         _buildTimeRangeDropdown(),
// //       ],
// //     );
// //   }

// //   Widget _buildTimeRangeDropdown() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.2),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: _timeRange,
// //           dropdownColor: const Color(0xFF5E35B1),
// //           icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
// //           style: const TextStyle(color: Colors.white, fontSize: 14),
// //           onChanged: (value) {
// //             if (value != null) {
// //               setState(() => _timeRange = value);
// //             }
// //           },
// //           items: _timeRanges.map((range) {
// //             return DropdownMenuItem(
// //               value: range,
// //               child: Text(range),
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildViewToggle() {
// //     return IconButton(
// //       icon: Icon(
// //         _showDetailedView ? Icons.grid_view : Icons.list, 
// //         color: Colors.white,
// //       ),
// //       onPressed: () => setState(() => _showDetailedView = !_showDetailedView),
// //     );
// //   }

// //   Widget _buildMetricFilter(bool isMobile) {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Row(
// //         children: _metrics.map((metric) {
// //           return Padding(
// //             padding: EdgeInsets.only(right: isMobile ? 6 : 8),
// //             child: FilterChip(
// //               label: Text(
// //                 metric,
// //                 style: TextStyle(fontSize: isMobile ? 12 : 14),
// //               ),
// //               selected: _selectedMetric == metric,
// //               onSelected: (selected) {
// //                 setState(() => _selectedMetric = selected ? metric : 'All Services');
// //               },
// //               backgroundColor: Colors.white,
// //               selectedColor: const Color(0xFF7E57C2),
// //               labelStyle: TextStyle(
// //                 color: _selectedMetric == metric ? Colors.white : const Color(0xFF666666),
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildKPISection(bool isMobile, bool isTablet) {
// //     final crossAxisCount = _getCrossAxisCount(isMobile, isTablet);
    
// //     return GridView.count(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       crossAxisCount: crossAxisCount,
// //       crossAxisSpacing: isMobile ? 12 : 16,
// //       mainAxisSpacing: isMobile ? 12 : 16,
// //       childAspectRatio: _getChildAspectRatio(isMobile, isTablet),
// //       children: [
// //         _buildKPICard(
// //           'Total Services',
// //           '${_analyticsData['kpis']?['totalServices'] ?? 0}',
// //           Icons.assignment_turned_in,
// //           const Color(0xFF7E57C2),
// //           '+15%',
// //           'vs last month',
// //           isMobile,
// //         ),
// //         _buildKPICard(
// //           'Avg Response Time',
// //           '${_analyticsData['kpis']?['responseTime'] ?? 0} min',
// //           Icons.timer,
// //           const Color(0xFF4CAF50),
// //           '-8%',
// //           'faster response',
// //           isMobile,
// //         ),
// //         _buildKPICard(
// //           'Satisfaction Rate',
// //           '${_analyticsData['kpis']?['satisfactionRate'] ?? 0}%',
// //           Icons.thumb_up,
// //           const Color(0xFFFFA000),
// //           '+2%',
// //           'improvement',
// //           isMobile,
// //         ),
// //         _buildKPICard(
// //           'Revenue',
// //           '\$${((_analyticsData['kpis']?['revenue'] ?? 0) / 1000).toStringAsFixed(1)}K',
// //           Icons.attach_money,
// //           const Color(0xFF9C27B0),
// //           '+${_analyticsData['kpis']?['revenueGrowth'] ?? 0}%',
// //           'growth',
// //           isMobile,
// //         ),
// //         if (crossAxisCount >= 3) ...[
// //           _buildKPICard(
// //             'Active Users',
// //             '${_analyticsData['kpis']?['activeUsers'] ?? 0}',
// //             Icons.people,
// //             const Color(0xFF2196F3),
// //             '+12%',
// //             'more users',
// //             isMobile,
// //           ),
// //           _buildKPICard(
// //             'Completion Rate',
// //             '${_analyticsData['kpis']?['completionRate'] ?? 0}%',
// //             Icons.check_circle,
// //             const Color(0xFFE91E63),
// //             '+5%',
// //             'better completion',
// //             isMobile,
// //           ),
// //         ],
// //         if (crossAxisCount >= 4) ...[
// //           _buildKPICard(
// //             'New Customers',
// //             '${_analyticsData['kpis']?['newCustomers'] ?? 0}',
// //             Icons.person_add,
// //             const Color(0xFF00BCD4),
// //             '+8%',
// //             'this month',
// //             isMobile,
// //           ),
// //           _buildKPICard(
// //             'Repeat Customers',
// //             '${_analyticsData['kpis']?['repeatCustomers'] ?? 0}',
// //             Icons.repeat,
// //             const Color(0xFF8BC34A),
// //             '+18%',
// //             'loyalty rate',
// //             isMobile,
// //           ),
// //         ],
// //       ],
// //     );
// //   }

// //   Widget _buildKPICard(String title, String value, IconData icon, Color color, String change, String changeLabel, bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: isMobile ? 8 : 15,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(isMobile ? 8 : 12),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //                 ),
// //                 child: Icon(icon, color: color, size: isMobile ? 18 : 24),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
// //                 decoration: BoxDecoration(
// //                   color: change.contains('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(
// //                       change.contains('+') ? Icons.trending_up : Icons.trending_down,
// //                       size: isMobile ? 12 : 14,
// //                       color: change.contains('+') ? Colors.green : Colors.red,
// //                     ),
// //                     SizedBox(width: isMobile ? 2 : 4),
// //                     Text(
// //                       change,
// //                       style: TextStyle(
// //                         color: change.contains('+') ? Colors.green : Colors.red,
// //                         fontSize: isMobile ? 10 : 12,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: isMobile ? 8 : 16),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: isMobile ? 16 : 24,
// //               fontWeight: FontWeight.bold,
// //               height: 1.2,
// //               color: const Color(0xFF333333),
// //             ),
// //           ),
// //           SizedBox(height: isMobile ? 2 : 4),
// //           Text(
// //             title,
// //             style: TextStyle(
// //               color: const Color(0xFF666666),
// //               fontSize: isMobile ? 12 : 14,
// //             ),
// //           ),
// //           SizedBox(height: isMobile ? 2 : 4),
// //           Text(
// //             changeLabel,
// //             style: TextStyle(
// //               color: const Color(0xFF999999),
// //               fontSize: isMobile ? 10 : 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAnalyticsTabs(bool isMobile, bool isTablet, bool isDesktop) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: isMobile ? 6 : 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           SizedBox(
// //             height: isMobile ? 40 : 48,
// //             child: TabBar(
// //               controller: _tabController,
// //               labelColor: const Color(0xFF7E57C2),
// //               unselectedLabelColor: const Color(0xFF666666),
// //               indicatorColor: const Color(0xFF7E57C2),
// //               indicatorSize: TabBarIndicatorSize.tab,
// //               labelStyle: TextStyle(
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: isMobile ? 12 : 14,
// //               ),
// //               isScrollable: isMobile,
// //               tabs: const [
// //                 Tab(text: 'Overview'),
// //                 Tab(text: 'Performance'),
// //                 Tab(text: 'Providers'),
// //                 Tab(text: 'Regional'),
// //               ],
// //             ),
// //           ),
// //           SizedBox(
// //             height: isMobile ? 400 : (isTablet ? 450 : 500),
// //             child: TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 _buildOverviewTab(isMobile, isTablet, isDesktop),
// //                 _buildPerformanceTab(isMobile),
// //                 _buildProvidersTab(isMobile),
// //                 _buildRegionalTab(isMobile),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildOverviewTab(bool isMobile, bool isTablet, bool isDesktop) {
// //     if (isMobile) {
// //       return SingleChildScrollView(
// //         padding: const EdgeInsets.all(12),
// //         child: Column(
// //           children: [
// //             _buildServiceDistribution(isMobile),
// //             const SizedBox(height: 16),
// //             _buildTrendChart(isMobile),
// //             const SizedBox(height: 16),
// //             _buildQuickInsights(isMobile),
// //           ],
// //         ),
// //       );
// //     } else if (isTablet) {
// //       return SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                   flex: 5,
// //                   child: _buildServiceDistribution(isMobile),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   flex: 5,
// //                   child: _buildTrendChart(isMobile),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             _buildQuickInsights(isMobile),
// //           ],
// //         ),
// //       );
// //     } else {
// //       return Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                   flex: 4,
// //                   child: _buildServiceDistribution(isMobile),
// //                 ),
// //                 const SizedBox(width: 20),
// //                 Expanded(
// //                   flex: 6,
// //                   child: _buildTrendChart(isMobile),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             _buildQuickInsights(isMobile),
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   Widget _buildServiceDistribution(bool isMobile) {
// //     final distribution = _analyticsData['serviceDistribution'] as Map<String, dynamic>? ?? {};
    
// //     int calculateTotal(Map<String, dynamic> data) {
// //       if (data.isEmpty) return 1;
// //       int total = 0;
// //       for (var value in data.values) {
// //         total += (value as num).toInt();
// //       }
// //       return total;
// //     }
    
// //     final total = calculateTotal(distribution);
    
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF8F9FD),
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Service Distribution',
// //             style: TextStyle(
// //               fontSize: isMobile ? 16 : 18,
// //               fontWeight: FontWeight.bold,
// //               color: const Color(0xFF333333),
// //             ),
// //           ),
// //           SizedBox(height: isMobile ? 12 : 16),
// //           ...distribution.entries.map((entry) {
// //             final percentage = (entry.value / total * 100).round();
// //             return _buildDistributionItem(entry.key, percentage, entry.value, isMobile);
// //           }),
// //           SizedBox(height: isMobile ? 12 : 16),
// //           Container(
// //             height: 6,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(3),
// //               gradient: const LinearGradient(
// //                 colors: [
// //                   Color(0xFFFFA000),
// //                   Color(0xFF4CAF50),
// //                   Color(0xFFF44336),
// //                   Color(0xFF9C27B0),
// //                   Color(0xFF2196F3),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDistributionItem(String service, int percentage, dynamic count, bool isMobile) {
// //     Color getServiceColor(String service) {
// //       switch (service) {
// //         case 'Tow Service': return const Color(0xFFFFA000);
// //         case 'Mechanic': return const Color(0xFF4CAF50);
// //         case 'Emergency': return const Color(0xFFF44336);
// //         case 'Fuel Delivery': return const Color(0xFF9C27B0);
// //         case 'Insurance': return const Color(0xFF2196F3);
// //         default: return const Color(0xFF666666);
// //       }
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 6),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: isMobile ? 10 : 12,
// //             height: isMobile ? 10 : 12,
// //             decoration: BoxDecoration(
// //               color: getServiceColor(service),
// //               shape: BoxShape.circle,
// //             ),
// //           ),
// //           SizedBox(width: isMobile ? 8 : 12),
// //           Expanded(
// //             child: Text(
// //               service,
// //               style: TextStyle(
// //                 fontSize: isMobile ? 12 : 14, 
// //                 color: const Color(0xFF333333), 
// //                 fontWeight: FontWeight.w500
// //               ),
// //             ),
// //           ),
// //           Text(
// //             '$percentage%',
// //             style: TextStyle(
// //               fontSize: isMobile ? 12 : 14,
// //               fontWeight: FontWeight.bold,
// //               color: const Color(0xFF333333),
// //             ),
// //           ),
// //           SizedBox(width: isMobile ? 4 : 8),
// //           Text(
// //             '($count)',
// //             style: TextStyle(
// //               fontSize: isMobile ? 10 : 12,
// //               color: const Color(0xFF666666),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTrendChart(bool isMobile) {
// //     final trends = _analyticsData['performanceTrends'] as List<dynamic>? ?? [];
    
// //     int findMaxServices(List<dynamic> data) {
// //       if (data.isEmpty) return 1;
// //       int max = 0;
// //       for (var item in data) {
// //         final services = (item['services'] as num).toInt();
// //         if (services > max) max = services;
// //       }
// //       return max;
// //     }
    
// //     final maxServices = findMaxServices(trends);
    
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //         border: Border.all(color: const Color(0xFFE0E0E0)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Monthly Performance Trend',
// //             style: TextStyle(
// //               fontSize: isMobile ? 16 : 18,
// //               fontWeight: FontWeight.bold,
// //               color: const Color(0xFF333333),
// //             ),
// //           ),
// //           SizedBox(height: isMobile ? 12 : 20),
// //           SizedBox(
// //             height: isMobile ? 150 : 200,
// //             child: trends.isNotEmpty 
// //                 ? Row(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     children: trends.map((month) {
// //                       final height = ((month['services'] as num).toInt() / maxServices * (isMobile ? 100 : 150)).clamp(20.0, isMobile ? 100.0 : 150.0);
// //                       return Column(
// //                         children: [
// //                           Text(
// //                             month['services'].toString(),
// //                             style: TextStyle(
// //                               fontSize: isMobile ? 10 : 12, 
// //                               color: const Color(0xFF666666), 
// //                               fontWeight: FontWeight.w500
// //                             ),
// //                           ),
// //                           SizedBox(height: isMobile ? 2 : 4),
// //                           Container(
// //                             width: isMobile ? 20 : 30,
// //                             height: height,
// //                             decoration: BoxDecoration(
// //                               gradient: const LinearGradient(
// //                                 begin: Alignment.bottomCenter,
// //                                 end: Alignment.topCenter,
// //                                 colors: [Color(0xFF7E57C2), Color(0xFFB39DDB)],
// //                               ),
// //                               borderRadius: BorderRadius.circular(isMobile ? 4 : 6),
// //                             ),
// //                           ),
// //                           SizedBox(height: isMobile ? 4 : 8),
// //                           Text(
// //                             month['month'],
// //                             style: TextStyle(
// //                               fontSize: isMobile ? 10 : 12, 
// //                               color: const Color(0xFF666666), 
// //                               fontWeight: FontWeight.w500
// //                             ),
// //                           ),
// //                         ],
// //                       );
// //                     }).toList(),
// //                   )
// //                 : const Center(
// //                     child: Text('No data available'),
// //                   ),
// //           ),
// //           SizedBox(height: isMobile ? 12 : 20),
// //           trends.isNotEmpty 
// //               ? Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                   children: [
// //                     _buildTrendIndicator('Services', const Color(0xFF7E57C2), '+38%', isMobile),
// //                     _buildTrendIndicator('Revenue', const Color(0xFF4CAF50), '+27%', isMobile),
// //                     _buildTrendIndicator('Satisfaction', const Color(0xFFFFA000), '+3%', isMobile),
// //                     _buildTrendIndicator('Response Time', const Color(0xFF2196F3), '-12%', isMobile),
// //                   ],
// //                 )
// //               : const SizedBox(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTrendIndicator(String label, Color color, String change, bool isMobile) {
// //     return Column(
// //       children: [
// //         Container(
// //           width: isMobile ? 6 : 8,
// //           height: isMobile ? 6 : 8,
// //           decoration: BoxDecoration(
// //             color: color,
// //             shape: BoxShape.circle,
// //           ),
// //         ),
// //         SizedBox(height: isMobile ? 2 : 4),
// //         Text(
// //           label,
// //           style: TextStyle(fontSize: isMobile ? 10 : 12, color: const Color(0xFF666666)),
// //         ),
// //         SizedBox(height: isMobile ? 2 : 4),
// //         Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(
// //               change.contains('+') ? Icons.trending_up : Icons.trending_down,
// //               size: isMobile ? 12 : 14,
// //               color: change.contains('+') ? color : Colors.red,
// //             ),
// //             SizedBox(width: isMobile ? 1 : 2),
// //             Text(
// //               change,
// //               style: TextStyle(
// //                 fontSize: isMobile ? 10 : 12,
// //                 fontWeight: FontWeight.bold,
// //                 color: change.contains('+') ? color : Colors.red,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildQuickInsights(bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF8F9FD),
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Quick Insights',
// //             style: TextStyle(
// //               fontSize: isMobile ? 16 : 18,
// //               fontWeight: FontWeight.bold,
// //               color: const Color(0xFF333333),
// //             ),
// //           ),
// //           SizedBox(height: isMobile ? 12 : 16),
// //           Wrap(
// //             spacing: isMobile ? 8 : 12,
// //             runSpacing: isMobile ? 8 : 12,
// //             children: [
// //               _buildInsightChip('Peak Hours: 8-10 AM', Icons.access_time, const Color(0xFFFFA000), isMobile),
// //               _buildInsightChip('Top Region: Downtown', Icons.location_on, const Color(0xFF2196F3), isMobile),
// //               _buildInsightChip('Best Rating: 4.9/5', Icons.star, const Color(0xFFFFC107), isMobile),
// //               _buildInsightChip('Fastest: Emergency', Icons.flash_on, const Color(0xFF4CAF50), isMobile),
// //               _buildInsightChip('Growth: +38% MoM', Icons.trending_up, const Color(0xFF9C27B0), isMobile),
// //               _buildInsightChip('Revenue Up: +27%', Icons.attach_money, const Color(0xFF4CAF50), isMobile),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildInsightChip(String text, IconData icon, Color color, bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: isMobile ? 12 : 16, 
// //         vertical: isMobile ? 8 : 12,
// //       ),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(isMobile ? 20 : 25),
// //         border: Border.all(color: color.withOpacity(0.3)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: isMobile ? 14 : 16, color: color),
// //           SizedBox(width: isMobile ? 6 : 8),
// //           Text(
// //             text,
// //             style: TextStyle(
// //               fontSize: isMobile ? 12 : 14, 
// //               fontWeight: FontWeight.w500, 
// //               color: color
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPerformanceTab(bool isMobile) {
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 20),
// //       child: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             Text(
// //               'Performance Analytics',
// //               style: TextStyle(
// //                 fontSize: isMobile ? 16 : 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: const Color(0xFF333333),
// //               ),
// //             ),
// //             SizedBox(height: isMobile ? 12 : 16),
// //             Text(
// //               'Detailed performance metrics and analysis will be displayed here.',
// //               style: TextStyle(
// //                 color: const Color(0xFF666666),
// //                 fontSize: isMobile ? 14 : 16,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProvidersTab(bool isMobile) {
// //     final providers = _analyticsData['topProviders'] as List<dynamic>? ?? [];
    
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 20),
// //       child: providers.isNotEmpty
// //           ? Column(
// //               children: [
// //                 Text(
// //                   'Top Performing Providers',
// //                   style: TextStyle(
// //                     fontSize: isMobile ? 16 : 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: const Color(0xFF333333),
// //                   ),
// //                 ),
// //                 SizedBox(height: isMobile ? 12 : 20),
// //                 ...providers.map((provider) => _buildProviderCard(provider, isMobile)),
// //               ],
// //             )
// //           : const Center(
// //               child: Text('No provider data available'),
// //             ),
// //     );
// //   }

// //   Widget _buildProviderCard(Map<String, dynamic> provider, bool isMobile) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: isMobile ? 4 : 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: isMobile ? 40 : 50,
// //             height: isMobile ? 40 : 50,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF7E57C2).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(isMobile ? 20 : 25),
// //             ),
// //             child: Icon(Icons.business, color: const Color(0xFF7E57C2), size: isMobile ? 20 : 24),
// //           ),
// //           SizedBox(width: isMobile ? 12 : 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   provider['name']?.toString() ?? 'Unknown',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold, 
// //                     fontSize: isMobile ? 14 : 16, 
// //                     color: const Color(0xFF333333)
// //                   ),
// //                 ),
// //                 SizedBox(height: isMobile ? 2 : 4),
// //                 Wrap(
// //                   spacing: isMobile ? 8 : 12,
// //                   runSpacing: isMobile ? 4 : 6,
// //                   children: [
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.star, size: 14, color: Colors.amber),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('${provider['rating'] ?? 0}', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.assignment, size: 14, color: Color(0xFF7E57C2)),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('${provider['services'] ?? 0} services', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.timer, size: 14, color: Color(0xFF4CAF50)),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('${provider['responseTime'] ?? 0}min', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '\$${provider['revenue'] ?? 0}',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 14 : 18, 
// //                   fontWeight: FontWeight.bold, 
// //                   color: const Color(0xFF4CAF50)
// //                 ),
// //               ),
// //               Text(
// //                 'revenue',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 10 : 12, 
// //                   color: const Color(0xFF666666)
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRegionalTab(bool isMobile) {
// //     final regionalData = _analyticsData['regionalData'] as Map<String, dynamic>? ?? {};
    
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 20),
// //       child: regionalData.isNotEmpty
// //           ? Column(
// //               children: [
// //                 Text(
// //                   'Regional Performance',
// //                   style: TextStyle(
// //                     fontSize: isMobile ? 16 : 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: const Color(0xFF333333),
// //                   ),
// //                 ),
// //                 SizedBox(height: isMobile ? 12 : 20),
// //                 ...regionalData.entries.map((entry) => _buildRegionalCard(entry.key, entry.value, isMobile)),
// //               ],
// //             )
// //           : const Center(
// //               child: Text('No regional data available'),
// //             ),
// //     );
// //   }

// //   Widget _buildRegionalCard(String region, Map<String, dynamic> data, bool isMobile) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: isMobile ? 4 : 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: isMobile ? 40 : 50,
// //             height: isMobile ? 40 : 50,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF2196F3).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(isMobile ? 20 : 25),
// //             ),
// //             child: Icon(Icons.location_on, color: const Color(0xFF2196F3), size: isMobile ? 20 : 24),
// //           ),
// //           SizedBox(width: isMobile ? 12 : 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   region,
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold, 
// //                     fontSize: isMobile ? 14 : 16, 
// //                     color: const Color(0xFF333333)
// //                   ),
// //                 ),
// //                 SizedBox(height: isMobile ? 2 : 4),
// //                 Wrap(
// //                   spacing: isMobile ? 8 : 12,
// //                   runSpacing: isMobile ? 4 : 6,
// //                   children: [
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.assignment, size: 14, color: Color(0xFF7E57C2)),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('${data['services'] ?? 0} services', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.attach_money, size: 14, color: Color(0xFF4CAF50)),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('\$${data['revenue'] ?? 0}', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Icon(Icons.thumb_up, size: 14, color: Color(0xFFFFA000)),
// //                         SizedBox(width: isMobile ? 2 : 4),
// //                         Text('${data['satisfaction'] ?? 0}%', style: const TextStyle(color: Color(0xFF666666))),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAdditionalInsights() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Additional Insights',
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF333333),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Expanded(child: _buildInsightMetric('Peak Service Hours', '8:00 - 10:00 AM', Icons.access_time)),
// //               const SizedBox(width: 16),
// //               Expanded(child: _buildInsightMetric('Busiest Day', 'Monday', Icons.calendar_today)),
// //               const SizedBox(width: 16),
// //               Expanded(child: _buildInsightMetric('Most Popular Service', 'Tow Service', Icons.local_shipping)),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildInsightMetric(String title, String value, IconData icon) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF8F9FD),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(icon, size: 24, color: const Color(0xFF7E57C2)),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             title,
// //             style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildExportSection(bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: isMobile ? 4 : 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: isMobile 
// //           ? Column(
// //               children: [
// //                 const Icon(Icons.analytics, size: 32, color: Color(0xFF7E57C2)),
// //                 const SizedBox(height: 8),
// //                 const Text(
// //                   'Export Analytics',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 const Text(
// //                   'Download detailed reports',
// //                   style: TextStyle(color: Color(0xFF666666), fontSize: 12),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: [
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.picture_as_pdf, size: 14),
// //                       label: const Text('PDF'),
// //                       style: OutlinedButton.styleFrom(
// //                         foregroundColor: const Color(0xFF7E57C2),
// //                       ),
// //                     ),
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.table_chart, size: 14),
// //                       label: const Text('CSV'),
// //                       style: OutlinedButton.styleFrom(
// //                         foregroundColor: const Color(0xFF7E57C2),
// //                       ),
// //                     ),
// //                     ElevatedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.share, size: 14),
// //                       label: const Text('Share'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF7E57C2),
// //                         foregroundColor: Colors.white,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             )
// //           : Row(
// //               children: [
// //                 const Icon(Icons.analytics, size: 40, color: Color(0xFF7E57C2)),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Export Analytics',
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Color(0xFF333333),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       const Text(
// //                         'Download detailed reports in multiple formats',
// //                         style: TextStyle(color: Color(0xFF666666)),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Wrap(
// //                   spacing: 8,
// //                   children: [
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.picture_as_pdf, size: 16),
// //                       label: const Text('PDF Report'),
// //                       style: OutlinedButton.styleFrom(
// //                         foregroundColor: const Color(0xFF7E57C2),
// //                       ),
// //                     ),
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.table_chart, size: 16),
// //                       label: const Text('CSV'),
// //                       style: OutlinedButton.styleFrom(
// //                         foregroundColor: const Color(0xFF7E57C2),
// //                       ),
// //                     ),
// //                     ElevatedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.share, size: 16),
// //                       label: const Text('Share'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF7E57C2),
// //                         foregroundColor: Colors.white,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //     );
// //   }

// //   int _getCrossAxisCount(bool isMobile, bool isTablet) {
// //     if (isMobile) return 2;
// //     if (isTablet) return 3;
// //     return 4;
// //   }

// //   double _getChildAspectRatio(bool isMobile, bool isTablet) {
// //     if (isMobile) return 1.0;
// //     if (isTablet) return 1.1;
// //     return 1.2;
// //   }
// // }



















// // class LiveMonitoringPage extends StatefulWidget {
// //   const LiveMonitoringPage({super.key});

// //   @override
// //   State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
// // }

// // class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
// //   String _selectedFilter = 'All';
// //   final String _mapView = 'Standard';
// //   bool _showHeatmap = false;
// //   int _selectedService = -1;

// //   final List<Map<String, dynamic>> _activeServices = [
// //     {
// //       'id': '1',
// //       'type': 'Tow Service',
// //       'customer': 'John Doe',
// //       'status': 'On the way',
// //       'duration': '12 mins ago',
// //       'location': 'Downtown, Manhattan',
// //       'provider': 'City Tow Services',
// //       'eta': '8 min',
// //       'distance': '2.3 km',
// //       'priority': 'High',
// //       'coordinates': {'x': 120, 'y': 180},
// //       'vehicle': 'Toyota Camry 2020',
// //       'issue': 'Flat tire',
// //     },
// //     {
// //       'id': '2',
// //       'type': 'Emergency',
// //       'customer': 'Sarah Wilson',
// //       'status': 'SOS Active',
// //       'duration': '2 mins ago',
// //       'location': 'Highway I-95',
// //       'provider': 'Emergency Response',
// //       'eta': '5 min',
// //       'distance': '1.2 km',
// //       'priority': 'Critical',
// //       'coordinates': {'x': 200, 'y': 250},
// //       'vehicle': 'Honda Civic 2019',
// //       'issue': 'Accident - Minor injuries',
// //     },
// //     {
// //       'id': '3',
// //       'type': 'Mechanic',
// //       'customer': 'Mike Johnson',
// //       'status': 'At location',
// //       'duration': '25 mins ago',
// //       'location': 'Central Park Area',
// //       'provider': 'Mobile Mechanics Inc',
// //       'eta': '0 min',
// //       'distance': '0 km',
// //       'priority': 'Medium',
// //       'coordinates': {'x': 150, 'y': 120},
// //       'vehicle': 'Ford F-150 2021',
// //       'issue': 'Engine overheating',
// //     },
// //     {
// //       'id': '4',
// //       'type': 'Fuel Delivery',
// //       'customer': 'Emily Davis',
// //       'status': 'In progress',
// //       'duration': '18 mins ago',
// //       'location': 'Business District',
// //       'provider': 'Quick Fuel Services',
// //       'eta': '3 min',
// //       'distance': '0.8 km',
// //       'priority': 'Medium',
// //       'coordinates': {'x': 280, 'y': 150},
// //       'vehicle': 'BMW X5 2022',
// //       'issue': 'Out of fuel',
// //     },
// //     {
// //       'id': '5',
// //       'type': 'Insurance',
// //       'customer': 'Robert Brown',
// //       'status': 'Pending',
// //       'duration': '35 mins ago',
// //       'location': 'Suburban Area',
// //       'provider': 'Insurance Assessors',
// //       'eta': '15 min',
// //       'distance': '5.7 km',
// //       'priority': 'Low',
// //       'coordinates': {'x': 80, 'y': 300},
// //       'vehicle': 'Mercedes C-Class 2020',
// //       'issue': 'Claim assessment',
// //     },
// //   ];

// //   List<Map<String, dynamic>> get _filteredServices {
// //     if (_selectedFilter == 'All') return _activeServices;
// //     return _activeServices.where((service) => service['type'] == _selectedFilter).toList();
// //   }

// //   void _showServiceDetails(Map<String, dynamic> service) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => ServiceDetailsSheet(service: service),
// //     );
// //   }

// //   void _showEmergencyAlert() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Row(
// //           children: [
// //             Icon(Icons.warning, color: Colors.red, size: 30),
// //             SizedBox(width: 12),
// //             Text('EMERGENCY ALERT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
// //           ],
// //         ),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('SOS Triggered - Immediate Assistance Required', style: TextStyle(fontWeight: FontWeight.w600)),
// //             SizedBox(height: 12),
// //             Text('Customer: Sarah Wilson'),
// //             Text('Location: Highway I-95, Exit 45'),
// //             Text('Vehicle: Honda Civic 2019'),
// //             Text('Issue: Accident with minor injuries'),
// //             SizedBox(height: 16),
// //             Container(
// //               padding: EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.red[50],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.local_shipping, color: Colors.red),
// //                   SizedBox(width: 8),
// //                   Expanded(child: Text('Nearest tow: 5 mins away')),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Dismiss'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {},
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //             child: Text('Dispatch Help'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         // Control Panel
// //         Container(
// //           padding: EdgeInsets.all(16),
// //           color: Colors.white,
// //           child: Column(
// //             children: [
// //               // Quick Stats
// //               Row(
// //                 children: [
// //                   _buildStatItem('Active', '${_activeServices.length}', Colors.blue, Icons.directions_car),
// //                   _buildStatItem('SOS', '${_activeServices.where((s) => s['type'] == 'Emergency').length}', Colors.red, Icons.warning),
// //                   _buildStatItem('Completed', '23', Colors.green, Icons.check_circle),
// //                   _buildStatItem('Avg ETA', '8 min', Colors.orange, Icons.timer),
// //                 ],
// //               ),
// //               SizedBox(height: 12),
// //               // Controls
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Wrap(
// //                       spacing: 8,
// //                       runSpacing: 8,
// //                       children: [
// //                         FilterChip(
// //                           label: Text('All'),
// //                           selected: _selectedFilter == 'All',
// //                           onSelected: (selected) => setState(() => _selectedFilter = 'All'),
// //                         ),
// //                         FilterChip(
// //                           label: Text('Emergency'),
// //                           selected: _selectedFilter == 'Emergency',
// //                           onSelected: (selected) => setState(() => _selectedFilter = 'Emergency'),
// //                         ),
// //                         FilterChip(
// //                           label: Text('Tow'),
// //                           selected: _selectedFilter == 'Tow Service',
// //                           onSelected: (selected) => setState(() => _selectedFilter = 'Tow Service'),
// //                         ),
// //                         FilterChip(
// //                           label: Text('Mechanic'),
// //                           selected: _selectedFilter == 'Mechanic',
// //                           onSelected: (selected) => setState(() => _selectedFilter = 'Mechanic'),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   IconButton(
// //                     icon: Icon(Icons.refresh),
// //                     onPressed: () {},
// //                     tooltip: 'Refresh Map',
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),

// //         // Map Section
// //         Expanded(
// //           flex: 2,
// //           child: Container(
// //             margin: EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: Colors.blue[50],
// //               borderRadius: BorderRadius.circular(16),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.3),
// //                   blurRadius: 15,
// //                   offset: Offset(0, 6),
// //                 ),
// //               ],
// //             ),
// //             child: Stack(
// //               children: [
// //                 // Map Background with Grid
// //                 _buildMapBackground(),
                
// //                 // Heatmap Overlay
// //                 if (_showHeatmap) _buildHeatmapOverlay(),
                
// //                 // Service Markers
// //                 ..._filteredServices.map((service) => _buildServiceMarker(service)),
                
// //                 // Map Controls
// //                 Positioned(
// //                   top: 16,
// //                   right: 16,
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(12),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.grey.withOpacity(0.2),
// //                           blurRadius: 8,
// //                           offset: Offset(0, 2),
// //                         ),
// //                       ],
// //                     ),
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         _buildMapControlButton(Icons.zoom_in, 'Zoom In'),
// //                         _buildMapControlButton(Icons.zoom_out, 'Zoom Out'),
// //                         _buildMapControlButton(Icons.my_location, 'My Location'),
// //                         _buildMapControlButton(
// //                           _showHeatmap ? Icons.map : Icons.terrain,
// //                           _showHeatmap ? 'Hide Heatmap' : 'Show Heatmap',
// //                           onPressed: () => setState(() => _showHeatmap = !_showHeatmap),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 // Emergency Alert Button
// //                 Positioned(
// //                   bottom: 16,
// //                   right: 16,
// //                   child: FloatingActionButton(
// //                     onPressed: _showEmergencyAlert,
// //                     backgroundColor: Colors.red,
// //                     child: Stack(
// //                       children: [
// //                         Icon(Icons.warning, color: Colors.white),
// //                         Positioned(
// //                           right: 0,
// //                           top: 0,
// //                           child: Container(
// //                             padding: EdgeInsets.all(2),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: Text(
// //                               '!',
// //                               style: TextStyle(
// //                                 color: Colors.red,
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),

// //         // Services List
// //         Expanded(
// //           child: Container(
// //             padding: EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.only(
// //                 topLeft: Radius.circular(24),
// //                 topRight: Radius.circular(24),
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.2),
// //                   blurRadius: 10,
// //                   offset: Offset(0, -4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text('Active Services (${_filteredServices.length})', 
// //                          style: Theme.of(context).textTheme.headlineSmall),
// //                     Row(
// //                       children: [
// //                         Icon(Icons.sort, size: 20, color: Colors.grey[600]),
// //                         SizedBox(width: 4),
// //                         Text('Sort by: ETA', style: TextStyle(color: Colors.grey[600])),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 16),
// //                 Expanded(
// //                   child: _filteredServices.isEmpty 
// //                       ? _buildEmptyState()
// //                       : ListView.builder(
// //                           itemCount: _filteredServices.length,
// //                           itemBuilder: (context, index) {
// //                             return _buildServiceCard(_filteredServices[index], index);
// //                           },
// //                         ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStatItem(String title, String value, Color color, IconData icon) {
// //     return Expanded(
// //       child: Container(
// //         margin: EdgeInsets.only(right: 3),
// //         padding: EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: color.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: color.withOpacity(0.2)),
// //         ),
// //         child: SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: Row(
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(6),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(icon, size: 16, color: color),
// //               ),
// //               SizedBox(width: 8),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
// //                   Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMapBackground() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [Colors.blue[50]!, Colors.blue[100]!],
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: CustomPaint(
// //         painter: MapGridPainter(),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.map, size: 60, color: Colors.blue[300]),
// //               SizedBox(height: 16),
// //               Text(
// //                 'Live Service Map',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.blue[700],
// //                 ),
// //               ),
// //               SizedBox(height: 8),
// //               Text(
// //                 'Real-time tracking of ${_filteredServices.length} active services',
// //                 style: TextStyle(color: Colors.grey[600]),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeatmapOverlay() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: RadialGradient(
// //           colors: [
// //             Colors.red.withOpacity(0.3),
// //             Colors.orange.withOpacity(0.2),
// //             Colors.yellow.withOpacity(0.1),
// //             Colors.transparent,
// //           ],
// //           stops: [0.1, 0.3, 0.6, 1.0],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildServiceMarker(Map<String, dynamic> service) {
// //     final isSelected = _selectedService == _activeServices.indexOf(service);
// //     return Positioned(
// //       left: service['coordinates']['x'].toDouble(),
// //       top: service['coordinates']['y'].toDouble(),
// //       child: GestureDetector(
// //         onTap: () => setState(() => _selectedService = _activeServices.indexOf(service)),
// //         child: Column(
// //           children: [
// //             // Pulse Animation for Emergency
// //             if (service['type'] == 'Emergency')
// //               PulseAnimation(
// //                 child: Container(
// //                   width: 40,
// //                   height: 40,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.red.withOpacity(0.3),
// //                   ),
// //                 ),
// //               ),
            
// //             // Main Marker
// //             Container(
// //               padding: EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: _getServiceColor(service['type']),
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: _getServiceColor(service['type']).withOpacity(0.5),
// //                     blurRadius: 10,
// //                     offset: Offset(0, 4),
// //                   ),
// //                   if (isSelected)
// //                     BoxShadow(
// //                       color: _getServiceColor(service['type']),
// //                       blurRadius: 15,
// //                       spreadRadius: 2,
// //                     ),
// //                 ],
// //                 border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
// //               ),
// //               child: Icon(
// //                 _getServiceIcon(service['type']),
// //                 color: Colors.white,
// //                 size: 20,
// //               ),
// //             ),
// //             SizedBox(height: 4),
            
// //             // Marker Label
// //             Container(
// //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(8),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.grey.withOpacity(0.3),
// //                     blurRadius: 5,
// //                   ),
// //                 ],
// //               ),
// //               child: Text(
// //                 service['type'].toString().split(' ').first,
// //                 style: TextStyle(
// //                   fontSize: 10,
// //                   fontWeight: FontWeight.bold,
// //                   color: _getServiceColor(service['type']),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMapControlButton(IconData icon, String tooltip, {VoidCallback? onPressed}) {
// //     return Container(
// //       width: 40,
// //       height: 40,
// //       margin: EdgeInsets.all(4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, size: 18),
// //         onPressed: onPressed ?? () {},
// //         tooltip: tooltip,
// //         padding: EdgeInsets.zero,
// //       ),
// //     );
// //   }

// //   Widget _buildServiceCard(Map<String, dynamic> service, int index) {
// //     return Card(
// //       margin: EdgeInsets.only(bottom: 12),
// //       elevation: 3,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: ListTile(
// //         contentPadding: EdgeInsets.all(16),
// //         leading: Container(
// //           width: 50,
// //           height: 50,
// //           decoration: BoxDecoration(
// //             color: _getServiceColor(service['type']).withOpacity(0.1),
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: _getServiceColor(service['type']).withOpacity(0.3)),
// //           ),
// //           child: Icon(
// //             _getServiceIcon(service['type']),
// //             color: _getServiceColor(service['type']),
// //             size: 24,
// //           ),
// //         ),
// //         title: Row(
// //           children: [
// //             Expanded(
// //               child: Text(
// //                 service['type'],
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //             ),
// //             Container(
// //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: _getPriorityColor(service['priority']).withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(6),
// //               ),
// //               child: Text(
// //                 service['priority'],
// //                 style: TextStyle(
// //                   color: _getPriorityColor(service['priority']),
// //                   fontSize: 10,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: 4),
// //             Text('Customer: ${service['customer']}'),
// //             Text('Location: ${service['location']}'),
// //             SizedBox(height: 8),
// //             Row(
// //               children: [
// //                 Icon(Icons.timer, size: 12, color: Colors.grey[600]),
// //                 SizedBox(width: 4),
// //                 Text('ETA: ${service['eta']}', style: TextStyle(fontSize: 12)),
// //                 SizedBox(width: 16),
// //                 Icon(Icons.phone, size: 12, color: Colors.grey[600]),
// //                 SizedBox(width: 4),
// //                 Text('Call', style: TextStyle(fontSize: 12, color: Colors.blue)),
// //               ],
// //             ),
// //           ],
// //         ),
// //         trailing: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Container(
// //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: _getStatusColor(service['status']).withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Text(
// //                 service['status'],
// //                 style: TextStyle(
// //                   color: _getStatusColor(service['status']),
// //                   fontSize: 10,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 4),
// //             Text(service['duration'], style: TextStyle(color: Colors.grey[600], fontSize: 10)),
// //           ],
// //         ),
// //         onTap: () => _showServiceDetails(service),
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
// //           SizedBox(height: 16),
// //           Text(
// //             'No Active Services',
// //             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             'All services are completed or no matches found',
// //             style: TextStyle(color: Colors.grey[500]),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Color _getServiceColor(String type) {
// //     switch (type) {
// //       case 'Emergency': return Colors.red;
// //       case 'Tow Service': return Colors.orange;
// //       case 'Mechanic': return Colors.green;
// //       case 'Insurance': return Colors.blue;
// //       case 'Fuel Delivery': return Colors.purple;
// //       default: return Colors.grey;
// //     }
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Completed': return Colors.green;
// //       case 'In progress': return Colors.blue;
// //       case 'On the way': return Colors.orange;
// //       case 'SOS Active': return Colors.red;
// //       case 'Pending': return Colors.grey;
// //       default: return Colors.purple;
// //     }
// //   }

// //   Color _getPriorityColor(String priority) {
// //     switch (priority) {
// //       case 'Critical': return Colors.red;
// //       case 'High': return Colors.orange;
// //       case 'Medium': return Colors.blue;
// //       case 'Low': return Colors.green;
// //       default: return Colors.grey;
// //     }
// //   }

// //   IconData _getServiceIcon(String type) {
// //     switch (type) {
// //       case 'Tow Service': return Icons.local_shipping;
// //       case 'Mechanic': return Icons.handyman;
// //       case 'Emergency': return Icons.warning;
// //       case 'Insurance': return Icons.security;
// //       case 'Fuel Delivery': return Icons.local_gas_station;
// //       default: return Icons.help;
// //     }
// //   }
// // }

// // class MapGridPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = Colors.blue[100]!
// //       ..strokeWidth = 0.5
// //       ..style = PaintingStyle.stroke;

// //     // Draw grid lines
// //     for (double i = 0; i < size.width; i += 30) {
// //       canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
// //     }
// //     for (double i = 0; i < size.height; i += 30) {
// //       canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
// //     }

// //     // Draw main roads
// //     final roadPaint = Paint()
// //       ..color = Colors.blue[200]!
// //       ..strokeWidth = 2
// //       ..style = PaintingStyle.stroke;

// //     canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), roadPaint);
// //     canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), roadPaint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // }

// // class PulseAnimation extends StatefulWidget {
// //   final Widget child;

// //   const PulseAnimation({super.key, required this.child});

// //   @override
// //   State<PulseAnimation> createState() => _PulseAnimationState();
// // }

// // class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       duration: Duration(seconds: 2),
// //       vsync: this,
// //     )..repeat(reverse: true);
// //     _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _animation,
// //       builder: (context, child) {
// //         return Transform.scale(
// //           scale: _animation.value,
// //           child: Opacity(
// //             opacity: 1.0 - _animation.value,
// //             child: widget.child,
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class ServiceDetailsSheet extends StatelessWidget {
// //   final Map<String, dynamic> service;

// //   const ServiceDetailsSheet({super.key, required this.service});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(24),
// //           topRight: Radius.circular(24),
// //         ),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Center(
// //             child: Container(
// //               width: 40,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300],
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 20),
// //           Row(
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: _getServiceColor(service['type']).withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Icon(
// //                   _getServiceIcon(service['type']),
// //                   color: _getServiceColor(service['type']),
// //                   size: 30,
// //                 ),
// //               ),
// //               SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(service['type'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                     SizedBox(height: 4),
// //                     Text('Service #${service['id']}', style: TextStyle(color: Colors.grey[600])),
// //                   ],
// //                 ),
// //               ),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   color: _getStatusColor(service['status']).withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   service['status'],
// //                   style: TextStyle(
// //                     color: _getStatusColor(service['status']),
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 24),
// //           _buildDetailRow('Customer', service['customer'], Icons.person),
// //           _buildDetailRow('Vehicle', service['vehicle'], Icons.directions_car),
// //           _buildDetailRow('Issue', service['issue'], Icons.info),
// //           _buildDetailRow('Location', service['location'], Icons.location_on),
// //           _buildDetailRow('Provider', service['provider'], Icons.business),
// //           _buildDetailRow('ETA', service['eta'], Icons.timer),
// //           _buildDetailRow('Distance', service['distance'], Icons.space_dashboard),
// //           SizedBox(height: 24),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: OutlinedButton.icon(
// //                   onPressed: () {},
// //                   icon: Icon(Icons.phone),
// //                   label: Text('Call Customer'),
// //                 ),
// //               ),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: OutlinedButton.icon(
// //                   onPressed: () {},
// //                   icon: Icon(Icons.chat),
// //                   label: Text('Message'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 12),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: ElevatedButton.icon(
// //                   onPressed: () {},
// //                   icon: Icon(Icons.directions),
// //                   label: Text('View Route'),
// //                 ),
// //               ),
// //               SizedBox(width: 12),
// //               if (service['type'] == 'Emergency')
// //                 Expanded(
// //                   child: ElevatedButton.icon(
// //                     onPressed: () {},
// //                     icon: Icon(Icons.warning),
// //                     label: Text('Dispatch Help'),
// //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDetailRow(String label, String value, IconData icon) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 20, color: Colors.grey[600]),
// //           SizedBox(width: 12),
// //           Expanded(flex: 2, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
// //           Expanded(flex: 3, child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
// //         ],
// //       ),
// //     );
// //   }

// //   Color _getServiceColor(String type) {
// //     switch (type) {
// //       case 'Emergency': return Colors.red;
// //       case 'Tow Service': return Colors.orange;
// //       case 'Mechanic': return Colors.green;
// //       case 'Insurance': return Colors.blue;
// //       case 'Fuel Delivery': return Colors.purple;
// //       default: return Colors.grey;
// //     }
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Completed': return Colors.green;
// //       case 'In progress': return Colors.blue;
// //       case 'On the way': return Colors.orange;
// //       case 'SOS Active': return Colors.red;
// //       case 'Pending': return Colors.grey;
// //       default: return Colors.purple;
// //     }
// //   }

// //   IconData _getServiceIcon(String type) {
// //     switch (type) {
// //       case 'Tow Service': return Icons.local_shipping;
// //       case 'Mechanic': return Icons.handyman;
// //       case 'Emergency': return Icons.warning;
// //       case 'Insurance': return Icons.security;
// //       case 'Fuel Delivery': return Icons.local_gas_station;
// //       default: return Icons.help;
// //     }
// //   }
// // }

// // class UserManagementPage extends StatefulWidget {
// //   const UserManagementPage({super.key});

// //   @override
// //   State<UserManagementPage> createState() => _UserManagementPageState();
// // }

// // class _UserManagementPageState extends State<UserManagementPage> {
// //   int _selectedTab = 0;
// //   String _selectedFilter = 'All Status';
// //   String _searchQuery = '';
// //   final List<String> _tabs = ['All Users', 'Pending Approval', 'Vehicle Owners', 'Tow Providers', 'Mechanics'];
  
// //   // Sample user data
// //   final List<Map<String, dynamic>> _users = [
// //     {
// //       'id': '1',
// //       'name': 'John Doe',
// //       'email': 'john.doe@email.com',
// //       'phone': '+1 234 567 8900',
// //       'type': 'Vehicle Owner',
// //       'status': 'Pending',
// //       'registrationDate': '2024-01-15',
// //       'region': 'New York',
// //       'avatarColor': Colors.blue,
// //       'documents': ['ID Card', 'Driving License'],
// //     },
// //     {
// //       'id': '2',
// //       'name': 'Sarah Wilson',
// //       'email': 'sarah.w@email.com',
// //       'phone': '+1 234 567 8901',
// //       'type': 'Tow Provider',
// //       'status': 'Active',
// //       'registrationDate': '2024-01-10',
// //       'region': 'California',
// //       'avatarColor': Colors.green,
// //       'documents': ['Business License', 'Insurance'],
// //     },
// //     {
// //       'id': '3',
// //       'name': 'Mike Johnson',
// //       'email': 'mike.j@email.com',
// //       'phone': '+1 234 567 8902',
// //       'type': 'Mechanic',
// //       'status': 'Pending',
// //       'registrationDate': '2024-01-18',
// //       'region': 'Texas',
// //       'avatarColor': Colors.orange,
// //       'documents': ['Certification', 'ID Card'],
// //     },
// //     {
// //       'id': '4',
// //       'name': 'Emily Davis',
// //       'email': 'emily.d@email.com',
// //       'phone': '+1 234 567 8903',
// //       'type': 'Vehicle Owner',
// //       'status': 'Active',
// //       'registrationDate': '2024-01-05',
// //       'region': 'Florida',
// //       'avatarColor': Colors.purple,
// //       'documents': ['ID Card', 'Vehicle RC'],
// //     },
// //     {
// //       'id': '5',
// //       'name': 'Robert Brown',
// //       'email': 'robert.b@email.com',
// //       'phone': '+1 234 567 8904',
// //       'type': 'Tow Provider',
// //       'status': 'Rejected',
// //       'registrationDate': '2024-01-20',
// //       'region': 'Illinois',
// //       'avatarColor': Colors.red,
// //       'documents': ['Business License'],
// //     },
// //   ];

// //   List<Map<String, dynamic>> get _filteredUsers {
// //     List<Map<String, dynamic>> filtered = List.from(_users);
    
// //     // Apply search filter
// //     if (_searchQuery.isNotEmpty) {
// //       filtered = filtered.where((user) =>
// //         user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
// //         user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
// //         user['phone'].toString().contains(_searchQuery)
// //       ).toList();
// //     }
    
// //     // Apply status filter
// //     if (_selectedFilter != 'All Status') {
// //       filtered = filtered.where((user) => user['status'] == _selectedFilter).toList();
// //     }
    
// //     // Apply tab filter
// //     if (_selectedTab == 1) { // Pending Approval
// //       filtered = filtered.where((user) => user['status'] == 'Pending').toList();
// //     } else if (_selectedTab == 2) { // Vehicle Owners
// //       filtered = filtered.where((user) => user['type'] == 'Vehicle Owner').toList();
// //     } else if (_selectedTab == 3) { // Tow Providers
// //       filtered = filtered.where((user) => user['type'] == 'Tow Provider').toList();
// //     } else if (_selectedTab == 4) { // Mechanics
// //       filtered = filtered.where((user) => user['type'] == 'Mechanic').toList();
// //     }
    
// //     return filtered;
// //   }

// //   void _showUserDetails(Map<String, dynamic> user) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       builder: (context) => UserDetailsSheet(
// //         user: user,
// //         onStatusUpdate: (newStatus) {
// //           setState(() {
// //             user['status'] = newStatus;
// //           });
// //         },
// //       ),
// //     );
// //   }

// //   void _showBulkActions() {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) => Container(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Bulk Actions',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 20),
// //             _buildBulkActionButton('Approve All Selected', Icons.check, Colors.green, () {
// //               _bulkUpdateStatus('Active');
// //               Navigator.pop(context);
// //             }),
// //             _buildBulkActionButton('Reject All Selected', Icons.close, Colors.red, () {
// //               _bulkUpdateStatus('Rejected');
// //               Navigator.pop(context);
// //             }),
// //             _buildBulkActionButton('Export Selected', Icons.download, Colors.blue, () {
// //               _exportUsers();
// //               Navigator.pop(context);
// //             }),
// //             const SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _bulkUpdateStatus(String status) {
// //     setState(() {
// //       for (var user in _filteredUsers) {
// //         user['status'] = status;
// //       }
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Users status updated to $status')),
// //     );
// //   }

// //   void _exportUsers() {
// //     // Simulate export functionality
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Users data exported successfully')),
// //     );
// //   }

// //   void _updateUserStatus(String userId, String newStatus) {
// //     setState(() {
// //       final user = _users.firstWhere((u) => u['id'] == userId);
// //       user['status'] = newStatus;
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('User status updated to $newStatus')),
// //     );
// //   }

// //   Widget _buildBulkActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
// //     return ListTile(
// //       leading: Icon(icon, color: color),
// //       title: Text(text),
// //       onTap: onTap,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 768;
// //     final isTablet = MediaQuery.of(context).size.width < 1024;

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F9FD),
// //       body: Column(
// //         children: [
// //           // Header with Stats
// //           Container(
// //             padding: EdgeInsets.all(isMobile ? 12 : 16),
// //             color: Colors.white,
// //             child: isMobile ? _buildMobileStats() : _buildDesktopStats(),
// //           ),

// //           // Filter and Search Bar
// //           Container(
// //             padding: EdgeInsets.all(isMobile ? 12 : 16),
// //             color: Colors.white,
// //             child: Column(
// //               children: [
// //                 _buildSearchBar(isMobile),
// //                 const SizedBox(height: 12),
// //                 _buildFilterChips(isMobile),
// //               ],
// //             ),
// //           ),

// //           // Tabs
// //           Container(
// //             height: isMobile ? 45 : 50,
// //             color: Colors.white,
// //             child: _buildTabBar(isMobile),
// //           ),

// //           // User List
// //           Expanded(
// //             child: _filteredUsers.isEmpty
// //                 ? _buildEmptyState()
// //                 : _buildUserList(isMobile, isTablet),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMobileStats() {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Row(
// //         children: [
// //           _buildStatItem('Total Users', _users.length.toString(), Colors.blue, true),
// //           _buildStatItem('Pending', _users.where((u) => u['status'] == 'Pending').length.toString(), Colors.orange, true),
// //           _buildStatItem('Active', _users.where((u) => u['status'] == 'Active').length.toString(), Colors.green, true),
// //           _buildStatItem('Rejected', _users.where((u) => u['status'] == 'Rejected').length.toString(), Colors.red, true),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDesktopStats() {
// //     return Row(
// //       children: [
// //         _buildStatItem('Total Users', _users.length.toString(), Colors.blue, false),
// //         _buildStatItem('Pending', _users.where((u) => u['status'] == 'Pending').length.toString(), Colors.orange, false),
// //         _buildStatItem('Active', _users.where((u) => u['status'] == 'Active').length.toString(), Colors.green, false),
// //         _buildStatItem('Rejected', _users.where((u) => u['status'] == 'Rejected').length.toString(), Colors.red, false),
// //       ],
// //     );
// //   }

// //   Widget _buildSearchBar(bool isMobile) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: TextField(
// //             onChanged: (value) => setState(() => _searchQuery = value),
// //             decoration: InputDecoration(
// //               hintText: 'Search users by name, email, or phone...',
// //               prefixIcon: const Icon(Icons.search),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 12 : 16),
// //             ),
// //           ),
// //         ),
// //         if (!isMobile) const SizedBox(width: 12),
// //         if (!isMobile && _selectedTab == 1) // Show only for pending approval
// //           Container(
// //             decoration: BoxDecoration(
// //               color: Colors.blue[50],
// //               borderRadius: BorderRadius.circular(8),
// //               border: Border.all(color: Colors.blue[100]!),
// //             ),
// //             child: IconButton(
// //               icon: const Icon(Icons.playlist_add_check, color: Colors.blue),
// //               onPressed: _showBulkActions,
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildFilterChips(bool isMobile) {
// //     return SingleChildScrollView(
// //       scrollDirection: isMobile ? Axis.horizontal : Axis.vertical,
// //       child: Row(
// //         children: [
// //           // Status Filter
// //           FilterChip(
// //             label: Text(_selectedFilter),
// //             selected: _selectedFilter != 'All Status',
// //             onSelected: (selected) {
// //               setState(() {
// //                 _selectedFilter = selected ? _selectedFilter : 'All Status';
// //               });
// //             },
// //             selectedColor: Colors.blue.withOpacity(0.1),
// //             checkmarkColor: Colors.blue,
// //             avatar: const Icon(Icons.filter_list, size: 16),
// //           ),
// //           const SizedBox(width: 8),
// //           // Region Filter
// //           FilterChip(
// //             label: const Text('All Regions'),
// //             onSelected: (selected) {},
// //           ),
// //           const SizedBox(width: 8),
// //           // Date Filter
// //           FilterChip(
// //             label: const Text('All Time'),
// //             onSelected: (selected) {},
// //           ),
// //           const Spacer(),
// //           if (isMobile && _selectedTab == 1)
// //             IconButton(
// //               icon: const Icon(Icons.playlist_add_check),
// //               onPressed: _showBulkActions,
// //               tooltip: 'Bulk Actions',
// //             ),
// //           IconButton(
// //             icon: const Icon(Icons.download),
// //             onPressed: _exportUsers,
// //             tooltip: 'Export Users',
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTabBar(bool isMobile) {
// //     return ListView.builder(
// //       scrollDirection: Axis.horizontal,
// //       itemCount: _tabs.length,
// //       itemBuilder: (context, index) {
// //         final count = _getTabCount(index);
// //         return GestureDetector(
// //           onTap: () => setState(() => _selectedTab = index),
// //           child: Container(
// //             padding: EdgeInsets.symmetric(
// //               horizontal: isMobile ? 16 : 20,
// //               vertical: isMobile ? 10 : 12,
// //             ),
// //             decoration: BoxDecoration(
// //               border: Border(
// //                 bottom: BorderSide(
// //                   color: _selectedTab == index ? Colors.blue : Colors.transparent,
// //                   width: 3,
// //                 ),
// //               ),
// //             ),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   _tabs[index],
// //                   style: TextStyle(
// //                     color: _selectedTab == index ? Colors.blue : Colors.grey[600],
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: isMobile ? 14 : 16,
// //                   ),
// //                 ),
// //                 if (count > 0) ...[
// //                   const SizedBox(width: 6),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                     decoration: BoxDecoration(
// //                       color: _selectedTab == index ? Colors.blue : Colors.grey[300],
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Text(
// //                       count.toString(),
// //                       style: TextStyle(
// //                         color: _selectedTab == index ? Colors.white : Colors.grey[700],
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildUserList(bool isMobile, bool isTablet) {
// //     if (isMobile) {
// //       return ListView.builder(
// //         itemCount: _filteredUsers.length,
// //         itemBuilder: (context, index) {
// //           return _buildMobileUserCard(_filteredUsers[index]);
// //         },
// //       );
// //     } else if (isTablet) {
// //       return GridView.builder(
// //         padding: const EdgeInsets.all(16),
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 16,
// //           mainAxisSpacing: 16,
// //           childAspectRatio: 2.0,
// //         ),
// //         itemCount: _filteredUsers.length,
// //         itemBuilder: (context, index) {
// //           return _buildTabletUserCard(_filteredUsers[index]);
// //         },
// //       );
// //     } else {
// //       return ListView.builder(
// //         padding: const EdgeInsets.all(16),
// //         itemCount: _filteredUsers.length,
// //         itemBuilder: (context, index) {
// //           return _buildDesktopUserCard(_filteredUsers[index]);
// //         },
// //       );
// //     }
// //   }

// //   Widget _buildMobileUserCard(Map<String, dynamic> user) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Header with Avatar and Status
// //             Row(
// //               children: [
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         color: (user['avatarColor'] as Color).withOpacity(0.2),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Icon(Icons.person, color: user['avatarColor'] as Color, size: 20),
// //                     ),
// //                     Positioned(
// //                       right: 0,
// //                       bottom: 0,
// //                       child: Container(
// //                         width: 10,
// //                         height: 10,
// //                         decoration: BoxDecoration(
// //                           color: _getStatusColor(user['status'].toString()),
// //                           shape: BoxShape.circle,
// //                           border: Border.all(color: Colors.white, width: 1.5),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(user['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       const SizedBox(height: 2),
// //                       Text(user['type'].toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: _getStatusColor(user['status'].toString()).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     user['status'].toString(),
// //                     style: TextStyle(
// //                       color: _getStatusColor(user['status'].toString()),
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             // User Details
// //             _buildMobileDetailRow(Icons.email, user['email'].toString()),
// //             _buildMobileDetailRow(Icons.phone, user['phone'].toString()),
// //             _buildMobileDetailRow(Icons.location_on, user['region'].toString()),
// //             _buildMobileDetailRow(Icons.calendar_today, 'Registered: ${user['registrationDate']}'),
// //             const SizedBox(height: 12),
// //             // Action Buttons
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 if (user['status'] == 'Pending') ...[
// //                   _buildMobileActionButton('Approve', Icons.check, Colors.green, () {
// //                     _updateUserStatus(user['id'].toString(), 'Active');
// //                   }),
// //                   _buildMobileActionButton('Reject', Icons.close, Colors.red, () {
// //                     _updateUserStatus(user['id'].toString(), 'Rejected');
// //                   }),
// //                 ],
// //                 _buildMobileActionButton('Details', Icons.visibility, Colors.blue, 
// //                   () => _showUserDetails(user)),
// //                 _buildMobileActionButton('More', Icons.more_vert, Colors.grey, () {}),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTabletUserCard(Map<String, dynamic> user) {
// //     return Card(
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Header
// //             Row(
// //               children: [
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       width: 45,
// //                       height: 45,
// //                       decoration: BoxDecoration(
// //                         color: (user['avatarColor'] as Color).withOpacity(0.2),
// //                         borderRadius: BorderRadius.circular(22.5),
// //                       ),
// //                       child: Icon(Icons.person, color: user['avatarColor'] as Color, size: 22),
// //                     ),
// //                     Positioned(
// //                       right: 0,
// //                       bottom: 0,
// //                       child: Container(
// //                         width: 12,
// //                         height: 12,
// //                         decoration: BoxDecoration(
// //                           color: _getStatusColor(user['status'].toString()),
// //                           shape: BoxShape.circle,
// //                           border: Border.all(color: Colors.white, width: 2),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(user['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       Text(user['email'].toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                   decoration: BoxDecoration(
// //                     color: _getStatusColor(user['status'].toString()).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Text(
// //                     user['status'].toString(),
// //                     style: TextStyle(
// //                       color: _getStatusColor(user['status'].toString()),
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             // Details
// //             Wrap(
// //               spacing: 12,
// //               runSpacing: 6,
// //               children: [
// //                 Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(Icons.phone, size: 14, color: Colors.grey[600]),
// //                     const SizedBox(width: 4),
// //                     Text(user['phone'].toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
// //                   ],
// //                 ),
// //                 Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
// //                     const SizedBox(width: 4),
// //                     Text(user['region'].toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Registered: ${user['registrationDate']}',
// //               style: TextStyle(color: Colors.grey[500], fontSize: 11),
// //             ),
// //             const SizedBox(height: 12),
// //             // Actions
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: [
// //                 if (user['status'] == 'Pending') ...[
// //                   _buildActionButton(Icons.check, Colors.green, 'Approve', () {
// //                     _updateUserStatus(user['id'].toString(), 'Active');
// //                   }),
// //                   _buildActionButton(Icons.close, Colors.red, 'Reject', () {
// //                     _updateUserStatus(user['id'].toString(), 'Rejected');
// //                   }),
// //                 ],
// //                 _buildActionButton(Icons.visibility, Colors.blue, 'View Details', 
// //                   () => _showUserDetails(user)),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDesktopUserCard(Map<String, dynamic> user) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(vertical: 8),
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Row(
// //           children: [
// //             // User Avatar with Status
// //             Stack(
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: (user['avatarColor'] as Color).withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(25),
// //                   ),
// //                   child: Icon(Icons.person, color: user['avatarColor'] as Color),
// //                 ),
// //                 Positioned(
// //                   right: 0,
// //                   bottom: 0,
// //                   child: Container(
// //                     width: 12,
// //                     height: 12,
// //                     decoration: BoxDecoration(
// //                       color: _getStatusColor(user['status'].toString()),
// //                       shape: BoxShape.circle,
// //                       border: Border.all(color: Colors.white, width: 2),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(width: 16),

// //             // User Info
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Text(user['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       const SizedBox(width: 8),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// //                         decoration: BoxDecoration(
// //                           color: _getTypeColor(user['type'].toString()).withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(4),
// //                         ),
// //                         child: Text(
// //                           user['type'].toString(),
// //                           style: TextStyle(
// //                             color: _getTypeColor(user['type'].toString()),
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(user['email'].toString(), style: TextStyle(color: Colors.grey[600])),
// //                   const SizedBox(height: 4),
// //                   Row(
// //                     children: [
// //                       Icon(Icons.phone, size: 14, color: Colors.grey[600]),
// //                       const SizedBox(width: 4),
// //                       Text(user['phone'].toString(), style: TextStyle(color: Colors.grey[600])),
// //                       const SizedBox(width: 16),
// //                       Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
// //                       const SizedBox(width: 4),
// //                       Text(user['region'].toString(), style: TextStyle(color: Colors.grey[600])),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     'Registered: ${user['registrationDate']}',
// //                     style: TextStyle(color: Colors.grey[500], fontSize: 12),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // Status and Actions
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   decoration: BoxDecoration(
// //                     color: _getStatusColor(user['status'].toString()).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(
// //                     user['status'].toString(),
// //                     style: TextStyle(
// //                       color: _getStatusColor(user['status'].toString()),
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Row(
// //                   children: [
// //                     if (user['status'] == 'Pending') ...[
// //                       _buildActionButton(Icons.check, Colors.green, 'Approve', () {
// //                         _updateUserStatus(user['id'].toString(), 'Active');
// //                       }),
// //                       _buildActionButton(Icons.close, Colors.red, 'Reject', () {
// //                         _updateUserStatus(user['id'].toString(), 'Rejected');
// //                       }),
// //                     ],
// //                     _buildActionButton(Icons.visibility, Colors.blue, 'View Details', 
// //                       () => _showUserDetails(user)),
// //                     _buildActionButton(Icons.more_vert, Colors.grey, 'More', () {}),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMobileDetailRow(IconData icon, String text) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 2),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 14, color: Colors.grey[600]),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               text,
// //               style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMobileActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
// //     return Expanded(
// //       child: TextButton.icon(
// //         onPressed: onPressed,
// //         icon: Icon(icon, size: 16, color: color),
// //         label: Text(
// //           label,
// //           style: TextStyle(color: color, fontSize: 12),
// //         ),
// //         style: TextButton.styleFrom(
// //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton(IconData icon, Color color, String tooltip, VoidCallback onPressed) {
// //     return Container(
// //       margin: const EdgeInsets.only(left: 4),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, size: 18, color: color),
// //         onPressed: onPressed,
// //         tooltip: tooltip,
// //         padding: const EdgeInsets.all(6),
// //         constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
// //       ),
// //     );
// //   }

// //   Widget _buildStatItem(String title, String value, Color color, bool isMobile) {
// //     return Container(
// //       margin: EdgeInsets.only(right: isMobile ? 8 : 0),
// //       padding: EdgeInsets.all(isMobile ? 10 : 12),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: isMobile ? 16 : 18,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: isMobile ? 10 : 12,
// //               color: Colors.grey[600],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No users found',
// //             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Try adjusting your search or filters',
// //             style: TextStyle(color: Colors.grey[500]),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton.icon(
// //             onPressed: () {
// //               setState(() {
// //                 _searchQuery = '';
// //                 _selectedFilter = 'All Status';
// //               });
// //             },
// //             icon: const Icon(Icons.refresh),
// //             label: const Text('Reset Filters'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   int _getTabCount(int tabIndex) {
// //     switch (tabIndex) {
// //       case 1: return _users.where((u) => u['status'] == 'Pending').length;
// //       case 2: return _users.where((u) => u['type'] == 'Vehicle Owner').length;
// //       case 3: return _users.where((u) => u['type'] == 'Tow Provider').length;
// //       case 4: return _users.where((u) => u['type'] == 'Mechanic').length;
// //       default: return 0;
// //     }
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Active': return Colors.green;
// //       case 'Pending': return Colors.orange;
// //       case 'Rejected': return Colors.red;
// //       default: return Colors.grey;
// //     }
// //   }

// //   Color _getTypeColor(String type) {
// //     switch (type) {
// //       case 'Vehicle Owner': return Colors.blue;
// //       case 'Tow Provider': return Colors.green;
// //       case 'Mechanic': return Colors.orange;
// //       default: return Colors.purple;
// //     }
// //   }
// // }

// // class UserDetailsSheet extends StatelessWidget {
// //   final Map<String, dynamic> user;
// //   final Function(String) onStatusUpdate;

// //   const UserDetailsSheet({
// //     super.key,
// //     required this.user,
// //     required this.onStatusUpdate,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 768;

// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 16 : 24),
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(20),
// //           topRight: Radius.circular(20),
// //         ),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Center(
// //             child: Container(
// //               width: 60,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300],
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           Row(
// //             children: [
// //               Container(
// //                 width: isMobile ? 50 : 60,
// //                 height: isMobile ? 50 : 60,
// //                 decoration: BoxDecoration(
// //                   color: (user['avatarColor'] as Color).withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(isMobile ? 25 : 30),
// //                 ),
// //                 child: Icon(Icons.person, color: user['avatarColor'] as Color, size: isMobile ? 25 : 30),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       user['name'].toString(),
// //                       style: TextStyle(
// //                         fontSize: isMobile ? 18 : 20,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(user['type'].toString(), style: TextStyle(color: Colors.grey[600])),
// //                   ],
// //                 ),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   color: _getStatusColor(user['status'].toString()).withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   user['status'].toString(),
// //                   style: TextStyle(
// //                     color: _getStatusColor(user['status'].toString()),
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 24),
// //           _buildDetailRow('Email', user['email'].toString(), Icons.email, isMobile),
// //           _buildDetailRow('Phone', user['phone'].toString(), Icons.phone, isMobile),
// //           _buildDetailRow('Region', user['region'].toString(), Icons.location_on, isMobile),
// //           _buildDetailRow('Registration Date', user['registrationDate'].toString(), Icons.calendar_today, isMobile),
// //           const SizedBox(height: 16),
// //           const Text('Verification Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 8),
// //           Wrap(
// //             spacing: 8,
// //             children: (user['documents'] as List<dynamic>).map((doc) => Chip(
// //               label: Text(doc.toString()),
// //               backgroundColor: Colors.blue[50],
// //             )).toList(),
// //           ),
// //           const SizedBox(height: 24),
// //           if (user['status'] == 'Pending')
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: ElevatedButton.icon(
// //                     onPressed: () {
// //                       onStatusUpdate('Active');
// //                       Navigator.pop(context);
// //                     },
// //                     icon: const Icon(Icons.check, size: 20),
// //                     label: const Text('Approve User'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.green,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: OutlinedButton.icon(
// //                     onPressed: () {
// //                       onStatusUpdate('Rejected');
// //                       Navigator.pop(context);
// //                     },
// //                     icon: const Icon(Icons.close, size: 20),
// //                     label: const Text('Reject User'),
// //                     style: OutlinedButton.styleFrom(
// //                       foregroundColor: Colors.red,
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             )
// //           else
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: OutlinedButton.icon(
// //                     onPressed: () {},
// //                     icon: const Icon(Icons.chat),
// //                     label: const Text('Send Message'),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton.icon(
// //                     onPressed: () {},
// //                     icon: const Icon(Icons.edit),
// //                     label: const Text('Edit Profile'),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDetailRow(String label, String value, IconData icon, bool isMobile) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: isMobile
// //           ? Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Icon(icon, size: 16, color: Colors.grey[600]),
// //                     const SizedBox(width: 8),
// //                     Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Padding(
// //                   padding: const EdgeInsets.only(left: 24),
// //                   child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
// //                 ),
// //               ],
// //             )
// //           : Row(
// //               children: [
// //                 Icon(icon, size: 20, color: Colors.grey[600]),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text(label, style: TextStyle(color: Colors.grey[600])),
// //                 ),
// //                 Expanded(
// //                   flex: 3,
// //                   child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
// //                 ),
// //               ],
// //             ),
// //     );
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Active': return Colors.green;
// //       case 'Pending': return Colors.orange;
// //       case 'Rejected': return Colors.red;
// //       default: return Colors.grey;
// //     }
// //   }
// // }


// // class RevenuePage extends StatefulWidget {
// //   const RevenuePage({super.key});

// //   @override
// //   State<RevenuePage> createState() => _RevenuePageState();
// // }

// // class _RevenuePageState extends State<RevenuePage> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   String _selectedPeriod = 'Monthly';
// //   String _selectedView = 'Overview';
// //   bool _showForecast = true;

// //   final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];
// //   final List<String> _views = ['Overview', 'Detailed', 'Comparison'];

// //   // Sample revenue data
// //   final Map<String, dynamic> _revenueData = {
// //     'summary': {
// //       'totalRevenue': 45287,
// //       'subscription': 12450,
// //       'commission': 28637,
// //       'transactionFees': 4200,
// //       'growthRate': 12.5,
// //       'previousPeriod': 40250,
// //     },
// //     'sources': [
// //       {'name': 'Service Commission', 'percentage': 63, 'amount': 28637, 'growth': 8.2, 'color': Colors.blue},
// //       {'name': 'Provider Subscriptions', 'percentage': 27, 'amount': 12450, 'growth': 15.7, 'color': Colors.green},
// //       {'name': 'Transaction Fees', 'percentage': 9, 'amount': 4200, 'growth': 5.3, 'color': Colors.orange},
// //       {'name': 'Premium Features', 'percentage': 1, 'amount': 500, 'growth': 22.1, 'color': Colors.purple},
// //     ],
// //     'transactions': [
// //       {'id': 'TX001', 'type': 'Service Fee', 'amount': 150.00, 'status': 'Completed', 'date': '2024-01-15', 'customer': 'John Doe', 'provider': 'City Tow'},
// //       {'id': 'TX002', 'type': 'Subscription', 'amount': 49.99, 'status': 'Completed', 'date': '2024-01-15', 'customer': 'Sarah Wilson', 'provider': 'Monthly Plan'},
// //       {'id': 'TX003', 'type': 'Commission', 'amount': 75.50, 'status': 'Pending', 'date': '2024-01-14', 'customer': 'Mike Johnson', 'provider': 'Mobile Mechanics'},
// //       {'id': 'TX004', 'type': 'Refund', 'amount': -25.00, 'status': 'Completed', 'date': '2024-01-14', 'customer': 'Emily Davis', 'provider': 'Quick Fuel'},
// //       {'id': 'TX005', 'type': 'Service Fee', 'amount': 120.00, 'status': 'Completed', 'date': '2024-01-13', 'customer': 'Robert Brown', 'provider': 'Pro Auto Care'},
// //     ],
// //     'monthlyTrend': [
// //       {'month': 'Jan', 'revenue': 12500, 'target': 12000},
// //       {'month': 'Feb', 'revenue': 11800, 'target': 12500},
// //       {'month': 'Mar', 'revenue': 14200, 'target': 13000},
// //       {'month': 'Apr', 'revenue': 15600, 'target': 14000},
// //       {'month': 'May', 'revenue': 16800, 'target': 15000},
// //       {'month': 'Jun', 'revenue': 18900, 'target': 16000},
// //     ],
// //     'topEarners': [
// //       {'name': 'City Tow Services', 'revenue': 12500, 'services': 247, 'growth': 15.2},
// //       {'name': 'Mobile Mechanics', 'revenue': 9800, 'services': 198, 'growth': 8.7},
// //       {'name': 'Emergency Assist', 'revenue': 8500, 'services': 132, 'growth': 22.4},
// //       {'name': 'Quick Fuel Co.', 'revenue': 6200, 'services': 156, 'growth': 12.1},
// //       {'name': 'Pro Auto Care', 'revenue': 5800, 'services': 121, 'growth': 5.8},
// //     ],
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final isMobile = screenWidth < 600;
// //     final isTablet = screenWidth >= 600 && screenWidth < 1200;

// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       body: Column(
// //         children: [
// //           // Header with Controls
// //           _buildHeader(isMobile),
          
// //           Expanded(
// //             child: SingleChildScrollView(
// //               padding: EdgeInsets.all(isMobile ? 12 : 16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Revenue Overview Cards
// //                   _buildRevenueOverview(isMobile, isTablet),

// //                   const SizedBox(height: 24),

// //                   // Tabs for Detailed Views
// //                   _buildTabSection(isMobile),

// //                   const SizedBox(height: 24),

// //                   // Recent Transactions & Forecast
// //                   _buildBottomSection(isMobile, isTablet),

// //                   const SizedBox(height: 24),

// //                   // Export Section
// //                   _buildExportSection(isMobile),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildHeader(bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       color: Colors.white,
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 'Revenue Analytics',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 18 : 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.grey[800],
// //                 ),
// //               ),
// //               if (!isMobile)
// //                 Row(
// //                   children: [
// //                     _buildDropdown(_selectedView, _views, (value) {
// //                       setState(() => _selectedView = value!);
// //                     }),
// //                     const SizedBox(width: 12),
// //                     _buildDropdown(_selectedPeriod, _periods, (value) {
// //                       setState(() => _selectedPeriod = value!);
// //                     }),
// //                   ],
// //                 )
// //               else
// //                 _buildDropdown(_selectedPeriod, _periods, (value) {
// //                   setState(() => _selectedPeriod = value!);
// //                 }),
// //             ],
// //           ),
// //           if (isMobile) ...[
// //             const SizedBox(height: 12),
// //             _buildDropdown(_selectedView, _views, (value) {
// //               setState(() => _selectedView = value!);
// //             }),
// //           ],
// //           const SizedBox(height: 12),
// //           _buildQuickStats(isMobile),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey[50],
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey[300]!),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: value,
// //           onChanged: onChanged,
// //           items: items.map((item) {
// //             return DropdownMenuItem(
// //               value: item,
// //               child: Text(item, style: const TextStyle(fontSize: 14)),
// //             );
// //           }).toList(),
// //           icon: const Icon(Icons.arrow_drop_down, size: 20),
// //           isDense: true,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildQuickStats(bool isMobile) {
// //     final summary = _revenueData['summary'] as Map<String, dynamic>;
// //     final growth = summary['growthRate'];
    
// //     return SizedBox(
// //       height: isMobile ? 80 : 70,
// //       child: ListView(
// //         scrollDirection: Axis.horizontal,
// //         children: [
// //           _buildQuickStatItem('Total Revenue', '\$${summary['totalRevenue']}', Colors.purple, growth, isMobile),
// //           const SizedBox(width: 8),
// //           _buildQuickStatItem('Monthly Growth', '$growth%', Colors.green, growth, isMobile),
// //           const SizedBox(width: 8),
// //           _buildQuickStatItem('Active Subs', '1,247', Colors.blue, 12.0, isMobile),
// //           const SizedBox(width: 8),
// //           _buildQuickStatItem('Avg Transaction', '\$68.50', Colors.orange, 5.2, isMobile),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildQuickStatItem(String title, String value, Color color, double growth, bool isMobile) {
// //     return Container(
// //       width: isMobile ? 140 : 160,
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.05),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: color.withOpacity(0.1)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: isMobile ? 14 : 16,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: isMobile ? 10 : 12,
// //               color: Colors.grey[600],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRevenueOverview(bool isMobile, bool isTablet) {
// //     final crossAxisCount = _getCrossAxisCount(isMobile, isTablet);
    
// //     return GridView.count(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       crossAxisCount: crossAxisCount,
// //       crossAxisSpacing: 16,
// //       mainAxisSpacing: 16,
// //       childAspectRatio: _getChildAspectRatio(isMobile, isTablet),
// //       children: [
// //         _buildRevenueCard(
// //           'Total Revenue',
// //           '\$${_revenueData['summary']['totalRevenue']}',
// //           Icons.attach_money,
// //           Colors.purple,
// //           '+${_revenueData['summary']['growthRate']}%',
// //           'vs last period',
// //           true,
// //           isMobile,
// //         ),
// //         _buildRevenueCard(
// //           'Subscription',
// //           '\$${_revenueData['summary']['subscription']}',
// //           Icons.subscriptions,
// //           Colors.blue,
// //           '+15.7%',
// //           'recurring income',
// //           false,
// //           isMobile,
// //         ),
// //         _buildRevenueCard(
// //           'Commission',
// //           '\$${_revenueData['summary']['commission']}',
// //           Icons.percent,
// //           Colors.green,
// //           '+8.2%',
// //           'service fees',
// //           false,
// //           isMobile,
// //         ),
// //         _buildRevenueCard(
// //           'Transaction Fees',
// //           '\$${_revenueData['summary']['transactionFees']}',
// //           Icons.payment,
// //           Colors.orange,
// //           '+5.3%',
// //           'processing fees',
// //           false,
// //           isMobile,
// //         ),
// //         if (!isMobile) ...[
// //           _buildRevenueCard(
// //             'Net Profit',
// //             '\$38,994',
// //             Icons.account_balance_wallet,
// //             Colors.teal,
// //             '+14.2%',
// //             'after expenses',
// //             false,
// //             isMobile,
// //           ),
// //           if (isTablet || crossAxisCount > 3)
// //             _buildRevenueCard(
// //               'Forecast',
// //               '\$49,200',
// //               Icons.trending_up,
// //               Colors.pink,
// //               '+8.7%',
// //               'next month',
// //               false,
// //               isMobile,
// //             ),
// //         ],
// //       ],
// //     );
// //   }

// //   Widget _buildRevenueCard(String title, String value, IconData icon, Color color, 
// //                           String change, String subtitle, bool isMain, bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //         border: isMain ? Border.all(color: color.withOpacity(0.3), width: 2) : null,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(icon, color: color, size: isMobile ? 18 : 20),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                 decoration: BoxDecoration(
// //                   color: change.contains('+') ? Colors.green[50] : Colors.red[50],
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(
// //                       change.contains('+') ? Icons.trending_up : Icons.trending_down,
// //                       size: 12,
// //                       color: change.contains('+') ? Colors.green : Colors.red,
// //                     ),
// //                     const SizedBox(width: 2),
// //                     Text(
// //                       change,
// //                       style: TextStyle(
// //                         color: change.contains('+') ? Colors.green : Colors.red,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: isMain ? (isMobile ? 18 : 20) : (isMobile ? 16 : 18),
// //               fontWeight: FontWeight.bold,
// //               color: isMain ? color : Colors.grey[800],
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             title,
// //             style: TextStyle(
// //               color: Colors.grey[600],
// //               fontSize: isMobile ? 12 : 14,
// //             ),
// //           ),
// //           if (subtitle.isNotEmpty) ...[
// //             const SizedBox(height: 2),
// //             Text(
// //               subtitle,
// //               style: TextStyle(
// //                 color: Colors.grey[500],
// //                 fontSize: 10,
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTabSection(bool isMobile) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           SizedBox(
// //             height: isMobile ? 40 : 48,
// //             child: TabBar(
// //               controller: _tabController,
// //               labelColor: Colors.blue,
// //               unselectedLabelColor: Colors.grey[600],
// //               indicatorColor: Colors.blue,
// //               indicatorSize: TabBarIndicatorSize.tab,
// //               labelStyle: TextStyle(fontSize: isMobile ? 12 : 14),
// //               tabs: const [
// //                 Tab(text: 'Revenue Trend'),
// //                 Tab(text: 'Sources'),
// //                 Tab(text: 'Top Earners'),
// //               ],
// //             ),
// //           ),
// //           SizedBox(
// //             height: isMobile ? 300 : 350,
// //             child: TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 _buildRevenueTrendTab(isMobile),
// //                 _buildSourcesTab(isMobile),
// //                 _buildTopEarnersTab(isMobile),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRevenueTrendTab(bool isMobile) {
// //     final trends = _revenueData['monthlyTrend'] as List<dynamic>;
// //     final maxRevenue = trends.map((e) => e['revenue']).reduce((a, b) => a > b ? a : b);
    
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       child: Column(
// //         children: [
// //           Text(
// //             'Revenue Trend - $_selectedPeriod',
// //             style: TextStyle(
// //               fontSize: isMobile ? 14 : 16,
// //               fontWeight: FontWeight.bold,
// //             ),
// //             textAlign: TextAlign.center,
// //           ),
// //           const SizedBox(height: 16),
// //           Expanded(
// //             child: ListView(
// //               scrollDirection: Axis.horizontal,
// //               children: trends.asMap().entries.map((entry) {
// //                 final month = entry.value;
// //                 final revenueHeight = (month['revenue'] / maxRevenue * 150).clamp(20.0, 150.0);
// //                 final targetHeight = (month['target'] / maxRevenue * 150).clamp(20.0, 150.0);
// //                 final isAboveTarget = month['revenue'] >= month['target'];
                
// //                 return Container(
// //                   width: isMobile ? 60 : 80,
// //                   margin: const EdgeInsets.symmetric(horizontal: 4),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         '\$${(month['revenue'] / 1000).toStringAsFixed(0)}K',
// //                         style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Expanded(
// //                         child: Row(
// //                           crossAxisAlignment: CrossAxisAlignment.end,
// //                           children: [
// //                             Expanded(
// //                               child: Container(
// //                                 margin: const EdgeInsets.only(right: 2),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.blue,
// //                                   borderRadius: BorderRadius.circular(4),
// //                                 ),
// //                                 height: revenueHeight.toDouble(),
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: Container(
// //                                 margin: const EdgeInsets.only(left: 2),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.grey[300],
// //                                   borderRadius: BorderRadius.circular(4),
// //                                 ),
// //                                 height: targetHeight.toDouble(),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         month['month'],
// //                         style: const TextStyle(fontSize: 12, color: Colors.grey),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
// //                         decoration: BoxDecoration(
// //                           color: isAboveTarget ? Colors.green[50] : Colors.orange[50],
// //                           borderRadius: BorderRadius.circular(6),
// //                         ),
// //                         child: Text(
// //                           '${((month['revenue'] - month['target']) / month['target'] * 100).toStringAsFixed(1)}%',
// //                           style: TextStyle(
// //                             fontSize: 8,
// //                             color: isAboveTarget ? Colors.green : Colors.orange,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSourcesTab(bool isMobile) {
// //     final sources = _revenueData['sources'] as List<dynamic>;
    
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       child: Column(
// //         children: [
// //           Text(
// //             'Revenue Sources',
// //             style: TextStyle(
// //               fontSize: isMobile ? 14 : 16,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Expanded(
// //             child: ListView(
// //               children: sources.map((source) => _buildSourceItem(source, isMobile)).toList(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSourceItem(Map<String, dynamic> source, bool isMobile) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey[200]!),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 12,
// //             height: 12,
// //             decoration: BoxDecoration(
// //               color: source['color'],
// //               shape: BoxShape.circle,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   source['name'],
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: isMobile ? 12 : 14,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 LinearProgressIndicator(
// //                   value: source['percentage'] / 100,
// //                   backgroundColor: Colors.grey[200],
// //                   color: source['color'],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '\$${source['amount']}',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: isMobile ? 12 : 14,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               Row(
// //                 children: [
// //                   Icon(Icons.trending_up, size: 12, color: Colors.green),
// //                   const SizedBox(width: 2),
// //                   Text(
// //                     '+${source['growth']}%',
// //                     style: const TextStyle(fontSize: 10, color: Colors.green),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTopEarnersTab(bool isMobile) {
// //     final earners = _revenueData['topEarners'] as List<dynamic>;
    
// //     return Padding(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       child: Column(
// //         children: [
// //           Text(
// //             'Top Performing Providers',
// //             style: TextStyle(
// //               fontSize: isMobile ? 14 : 16,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Expanded(
// //             child: ListView(
// //               children: earners.map((earner) => _buildEarnerItem(earner, isMobile)).toList(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEarnerItem(Map<String, dynamic> earner, bool isMobile) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey[200]!),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 40,
// //             decoration: BoxDecoration(
// //               color: Colors.blue.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: const Icon(Icons.business, color: Colors.blue, size: 20),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   earner['name'],
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: isMobile ? 12 : 14,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   '${earner['services']} services',
// //                   style: TextStyle(
// //                     fontSize: isMobile ? 10 : 12,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '\$${earner['revenue']}',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 14 : 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.green,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               Row(
// //                 children: [
// //                   const Icon(Icons.trending_up, size: 12, color: Colors.green),
// //                   const SizedBox(width: 2),
// //                   Text(
// //                     '+${earner['growth']}%',
// //                     style: const TextStyle(fontSize: 10, color: Colors.green),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildBottomSection(bool isMobile, bool isTablet) {
// //     if (isMobile) {
// //       return Column(
// //         children: [
// //           _buildRecentTransactions(isMobile),
// //           const SizedBox(height: 16),
// //           _buildRevenueForecast(isMobile),
// //         ],
// //       );
// //     } else {
// //       return Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Expanded(
// //             flex: 2,
// //             child: _buildRecentTransactions(isMobile),
// //           ),
// //           SizedBox(width: isTablet ? 12 : 16),
// //           Expanded(
// //             flex: 1,
// //             child: _buildRevenueForecast(isMobile),
// //           ),
// //         ],
// //       );
// //     }
// //   }

// //   Widget _buildRecentTransactions(bool isMobile) {
// //     final transactions = _revenueData['transactions'] as List<dynamic>;
    
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.all(isMobile ? 12 : 16),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   'Recent Transactions',
// //                   style: TextStyle(
// //                     fontSize: isMobile ? 14 : 16,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 ElevatedButton.icon(
// //                   onPressed: () {},
// //                   icon: const Icon(Icons.download, size: 16),
// //                   label: Text(isMobile ? 'Export' : 'Export CSV'),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.blue,
// //                     foregroundColor: Colors.white,
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: isMobile ? 12 : 16,
// //                       vertical: 8,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           ...transactions.map((transaction) => _buildTransactionItem(transaction, isMobile)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTransactionItem(Map<String, dynamic> transaction, bool isMobile) {
// //     Color getStatusColor(String status) {
// //       switch (status) {
// //         case 'Completed': return Colors.green;
// //         case 'Pending': return Colors.orange;
// //         case 'Failed': return Colors.red;
// //         default: return Colors.grey;
// //       }
// //     }

// //     IconData getTypeIcon(String type) {
// //       switch (type) {
// //         case 'Service Fee': return Icons.assignment;
// //         case 'Subscription': return Icons.subscriptions;
// //         case 'Commission': return Icons.percent;
// //         case 'Refund': return Icons.arrow_back;
// //         default: return Icons.receipt;
// //       }
// //     }

// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         border: Border(
// //           top: BorderSide(color: Colors.grey[200]!),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: isMobile ? 32 : 40,
// //             height: isMobile ? 32 : 40,
// //             decoration: BoxDecoration(
// //               color: getStatusColor(transaction['status']).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Icon(
// //               getTypeIcon(transaction['type']),
// //               color: getStatusColor(transaction['status']),
// //               size: isMobile ? 16 : 20,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   transaction['type'],
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: isMobile ? 12 : 14,
// //                   ),
// //                 ),
// //                 if (!isMobile) ...[
// //                   const SizedBox(height: 2),
// //                   Text(
// //                     '${transaction['customer']} • ${transaction['provider']}',
// //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                   ),
// //                 ],
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   transaction['date'],
// //                   style: TextStyle(fontSize: 10, color: Colors.grey[500]),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '\$${transaction['amount'].abs().toStringAsFixed(2)}',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 14 : 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: transaction['amount'] >= 0 ? Colors.green : Colors.red,
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                 decoration: BoxDecoration(
// //                   color: getStatusColor(transaction['status']).withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Text(
// //                   transaction['status'],
// //                   style: TextStyle(
// //                     color: getStatusColor(transaction['status']),
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRevenueForecast(bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 'Revenue Forecast',
// //                 style: TextStyle(
// //                   fontSize: isMobile ? 14 : 16,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               Switch(
// //                 value: _showForecast,
// //                 onChanged: (value) => setState(() => _showForecast = value),
// //                 activeThumbColor: Colors.blue,
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 12),
// //           if (_showForecast) ...[
// //             _buildForecastItem('Next Month', '\$49,200', '+8.7%', Colors.green, isMobile),
// //             const SizedBox(height: 8),
// //             _buildForecastItem('Next Quarter', '\$152,000', '+12.3%', Colors.blue, isMobile),
// //             const SizedBox(height: 8),
// //             _buildForecastItem('Next Year', '\$598,000', '+15.8%', Colors.purple, isMobile),
// //           ] else ...[
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 children: [
// //                   Icon(Icons.visibility_off, size: 40, color: Colors.grey[300]),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     'Forecast Hidden',
// //                     style: TextStyle(color: Colors.grey[500]),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildForecastItem(String period, String amount, String growth, Color color, bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.05),
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: color.withOpacity(0.1)),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   period,
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: isMobile ? 12 : 14,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   amount,
// //                   style: TextStyle(
// //                     fontSize: isMobile ? 14 : 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: color,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(6),
// //             ),
// //             child: Text(
// //               growth,
// //               style: TextStyle(
// //                 color: color,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: isMobile ? 10 : 12,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildExportSection(bool isMobile) {
// //     return Container(
// //       padding: EdgeInsets.all(isMobile ? 12 : 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: isMobile 
// //           ? Column(
// //               children: [
// //                 const Icon(Icons.analytics, size: 32, color: Colors.blue),
// //                 const SizedBox(height: 12),
// //                 const Text(
// //                   'Advanced Revenue Reports',
// //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Generate detailed financial reports',
// //                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: [
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.picture_as_pdf, size: 14),
// //                       label: const Text('PDF'),
// //                     ),
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.table_chart, size: 14),
// //                       label: const Text('Excel'),
// //                     ),
// //                     ElevatedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.share, size: 14),
// //                       label: const Text('Share'),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             )
// //           : Row(
// //               children: [
// //                 const Icon(Icons.analytics, size: 40, color: Colors.blue),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Advanced Revenue Reports',
// //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         'Generate detailed financial reports and export in multiple formats',
// //                         style: TextStyle(color: Colors.grey[600], fontSize: 14),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Wrap(
// //                   spacing: 8,
// //                   children: [
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.picture_as_pdf, size: 16),
// //                       label: const Text('PDF Report'),
// //                     ),
// //                     OutlinedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.table_chart, size: 16),
// //                       label: const Text('Excel'),
// //                     ),
// //                     ElevatedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.share, size: 16),
// //                       label: const Text('Share'),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //     );
// //   }

// //   int _getCrossAxisCount(bool isMobile, bool isTablet) {
// //     if (isMobile) return 2;
// //     if (isTablet) return 3;
// //     return 4;
// //   }

// //   double _getChildAspectRatio(bool isMobile, bool isTablet) {
// //     if (isMobile) return 1.0;
// //     if (isTablet) return 1.1;
// //     return 1.2;
// //   }
// // }


// // admin_dashboard.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart_road_app/admin/analytics.dart';
// import 'package:smart_road_app/admin/home.dart';
// import 'package:smart_road_app/admin/livemonitoring.dart';
// import 'package:smart_road_app/admin/revenue.dart';
// import 'package:smart_road_app/admin/service_provider.dart';
// import 'package:smart_road_app/admin/usermanagement.dart';

// void main() {
//   runApp(const VehicleAssistAdminApp());
// }

// class VehicleAssistAdminApp extends StatelessWidget {
//   const VehicleAssistAdminApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Vehicle Assist Admin',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         useMaterial3: true,
//       ),
//       home: const AdminDashboard(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int _currentIndex = 0;
//   final List<Widget> _pages = [
//     const DashboardHomePage(),
//     const UserManagementPage(),
//     const LiveMonitoringPage(),
//     const AnalyticsPage(),
//     const RevenuePage(),
//     const ServiceProvidersPage(), // New page added
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text('Vehicle Assist Admin'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
//           IconButton(onPressed: (){}, icon: Icon(Icons.logout))
//         ],
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue[700],
//         unselectedItemColor: Colors.grey[600],
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
//           BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Live Map'),
//           BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
//           BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Revenue'),
//           BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Providers'),
//         ],
//       ),
//     );
//   }
// }  

import 'package:flutter/material.dart';
import 'package:smart_road_app/admin/analytics.dart';
import 'package:smart_road_app/admin/home.dart';
import 'package:smart_road_app/admin/livemonitoring.dart';
import 'package:smart_road_app/admin/revenue.dart';
import 'package:smart_road_app/admin/service_provider.dart';
import 'package:smart_road_app/admin/usermanagement.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/Login/adminLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehicleAssistAdminApp extends StatelessWidget {
  const VehicleAssistAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Road Admin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AdminDashboard(), // This will check auth and redirect if needed
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;
  
  final List<Widget> _pages = [
    const DashboardHomePage(),
    const UserManagementPage(),
    const LiveMonitoringPage(),
    const AnalyticsPage(),
    const RevenuePage(),
    const ServiceProvidersPage(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'User Management',
    'Live Monitoring',
    'Analytics',
    'Revenue',
    'Providers',
  ];

  // Logout function
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Perform logout
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('adminIsLoggedIn', false);
                await prefs.remove('adminUserEmail');
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  print('Error signing out from Firebase: $e');
                }

                // Close loading indicator
                if (mounted) {
                  Navigator.of(context).pop();
                }

                // Navigate to login page
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  Future<void> _checkAuthentication() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('adminIsLoggedIn') ?? false;
      final userEmail = prefs.getString('adminUserEmail');

      if (!isLoggedIn || userEmail == null) {
        // Not authenticated, redirect to login
        if (mounted) {
          setState(() {
            _isCheckingAuth = false;
            _isAuthenticated = false;
          });
          
          // Navigate to login screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                (route) => false,
              );
            }
          });
        }
      } else {
        // Authenticated, show dashboard
        if (mounted) {
          setState(() {
            _isCheckingAuth = false;
            _isAuthenticated = true;
          });
        }
      }
    } catch (e) {
      print('Error checking admin authentication: $e');
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
          _isAuthenticated = false;
        });
        
        // On error, redirect to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              (route) => false,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking authentication
    if (_isCheckingAuth) {
      return Scaffold(
        backgroundColor: AppTheme.lightBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
              ),
              const SizedBox(height: 16),
              Text(
                'Checking authentication...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // If not authenticated, show nothing (navigation will happen in initState)
    if (!_isAuthenticated) {
      return const SizedBox.shrink();
    }

    // Show dashboard if authenticated
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger refresh on current page
              setState(() {});
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) async {
              if (value == 'logout') {
                // Show confirmation dialog
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true && mounted) {
                  // Clear admin login state
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('adminIsLoggedIn', false);
                  await prefs.remove('adminUserEmail');
                  // Sign out from Firebase
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print('Error signing out from Firebase: $e');
                  }

                  // Navigate back to login
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                      (route) => false,
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _tabController.index = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryPurple,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 0
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 1
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 1 ? Icons.people : Icons.people_outline,
                ),
              ),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 2 ? Icons.map : Icons.map_outlined,
                ),
              ),
              label: 'Live',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 3
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 3 ? Icons.analytics : Icons.analytics_outlined,
                ),
              ),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 4
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 4 ? Icons.attach_money : Icons.attach_money_outlined,
                ),
              ),
              label: 'Revenue',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 5
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _currentIndex == 5 ? Icons.business : Icons.business_outlined,
                ),
              ),
              label: 'Providers',
            ),
          ],
        ),
      ),
    );
  }
}