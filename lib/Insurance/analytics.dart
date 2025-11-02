// import 'package:flutter/material.dart';

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});

//   @override
//   _AnalyticsScreenState createState() => _AnalyticsScreenState();
// }

// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   String _selectedTimeRange = 'Monthly';
//   final List<String> _timeRanges = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];

//   final Map<String, dynamic> _analyticsData = {
//     'totalClaims': 156,
//     'pendingClaims': 12,
//     'approvedClaims': 125,
//     'rejectedClaims': 19,
//     'totalPayouts': 84200,
//     'approvalRate': 92,
//     'aiAccuracy': 98,
//     'avgProcessingTime': 2.4,
//     'customerSatisfaction': 4.8,
//     'revenue': 245000,
//     'activePolicies': 89,
//     'renewalRate': 87,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Analytics'),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 16),
//                 SizedBox(width: 4),
//                 Text(_selectedTimeRange),
//               ],
//             ),
//             onSelected: (value) => setState(() => _selectedTimeRange = value),
//             itemBuilder: (context) => _timeRanges.map((range) => 
//               PopupMenuItem(value: range, child: Text(range))
//             ).toList(),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildOverviewCards(),
//             SizedBox(height: 20),
//             _buildPerformanceMetrics(),
//             SizedBox(height: 20),
//             _buildChartsSection(),
//             SizedBox(height: 20),
//             _buildTrendsSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverviewCards() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 1.2,
//       children: [
//         _buildAnalyticsCard('Total Revenue', '\$${(_analyticsData['revenue']/1000).toStringAsFixed(0)}K', 
//             Icons.attach_money, Color(0xFF7E57C2), '+15%'),
//         _buildAnalyticsCard('Active Policies', _analyticsData['activePolicies'].toString(), 
//             Icons.policy, Color(0xFF4CAF50), '+8%'),
//         _buildAnalyticsCard('Total Payouts', '\$${(_analyticsData['totalPayouts']/1000).toStringAsFixed(1)}K', 
//             Icons.payment, Color(0xFF2196F3), '-3%'),
//         _buildAnalyticsCard('Customer Satisfaction', '${_analyticsData['customerSatisfaction']}/5', 
//             Icons.star, Color(0xFFFFC107), '+2%'),
//       ],
//     );
//   }

//   Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color, String change) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                 child: Icon(icon, color: color, size: 20),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: change.contains('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       change.contains('+') ? Icons.trending_up : Icons.trending_down,
//                       size: 12,
//                       color: change.contains('+') ? Colors.green : Colors.red,
//                     ),
//                     SizedBox(width: 2),
//                     Text(
//                       change,
//                       style: TextStyle(
//                         color: change.contains('+') ? Colors.green : Colors.red,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
//               SizedBox(height: 4),
//               Text(title, style: TextStyle(color: Color(0xFF666666), fontSize: 12)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceMetrics() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Performance Metrics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//           SizedBox(height: 16),
//           _buildMetricRow('Approval Rate', '${_analyticsData['approvalRate']}%', _analyticsData['approvalRate'].toDouble() / 100, Colors.green),
//           _buildMetricRow('Average Processing Time', '${_analyticsData['avgProcessingTime']} days', 0.8, Colors.blue),
//           _buildMetricRow('Renewal Rate', '${_analyticsData['renewalRate']}%', _analyticsData['renewalRate'].toDouble() / 100, Colors.purple),
//           _buildMetricRow('AI Accuracy', '${_analyticsData['aiAccuracy']}%', _analyticsData['aiAccuracy'].toDouble() / 100, Colors.orange),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricRow(String label, String value, double progressValue, Color color) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//           ),
//           Expanded(
//             flex: 2,
//             child: LinearProgressIndicator(
//               value: progressValue,
//               backgroundColor: color.withOpacity(0.2),
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartsSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Claim Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//           SizedBox(height: 16),
//           SizedBox(
//             height: 200,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildChartSegment('Auto', 65, Color(0xFFFFA000)),
//                 _buildChartSegment('Theft', 25, Color(0xFF2196F3)),
//                 _buildChartSegment('Other', 10, Color(0xFF4CAF50)),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartLegend('Auto (65%)', Color(0xFFFFA000)),
//               _buildChartLegend('Theft (25%)', Color(0xFF2196F3)),
//               _buildChartLegend('Other (10%)', Color(0xFF4CAF50)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartSegment(String label, int percentage, Color color) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           width: 60,
//           height: percentage * 2.0,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
//       ],
//     );
//   }

//   Widget _buildChartLegend(String text, Color color) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         SizedBox(width: 4),
//         Text(text, style: TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildTrendsSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Monthly Trends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//           SizedBox(height: 16),
//           SizedBox(
//             height: 150,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _buildTrendItem('Jan', 120, 95),
//                 _buildTrendItem('Feb', 135, 102),
//                 _buildTrendItem('Mar', 110, 88),
//                 _buildTrendItem('Apr', 156, 125),
//                 _buildTrendItem('May', 142, 115),
//                 _buildTrendItem('Jun', 168, 138),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTrendItem(String month, int claims, int approved) {
//     double approvalRate = (approved / claims) * 100;
//     double barHeight = (approved / claims) * 80;
    
//     return Container(
//       width: 80,
//       margin: EdgeInsets.only(right: 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text('$claims', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//           SizedBox(height: 4),
//           SizedBox(
//             height: 80,
//             width: 30,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                   width: 20,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 Container(
//                   width: 20,
//                   height: barHeight,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF7E57C2),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(month, style: TextStyle(fontSize: 12)),
//           Text('${approvalRate.toStringAsFixed(0)}%', style: TextStyle(fontSize: 10, color: Color(0xFF666666))),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedTimeRange = 'Monthly';
  final List<String> _timeRanges = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];
  Map<String, dynamic> _analyticsData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('vehicle_owners')
          .doc(user.email)
          .collection('insurance_requests')
          .get();

      _calculateRealAnalytics(snapshot.docs);
    } catch (e) {
      print('Error loading analytics: $e');
      _loadMockData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateRealAnalytics(List<QueryDocumentSnapshot> docs) {
    int totalClaims = docs.length;
    int pendingClaims = 0;
    int approvedClaims = 0;
    int rejectedClaims = 0;
    double totalPayouts = 0;
    double totalRevenue = 0;

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'] ?? 'pending_review';
      final amount = (data['quoteAmount'] ?? data['estimatedPremium'] ?? 0).toDouble();
      
      if (status == 'pending_review' || status == 'under_review') {
        pendingClaims++;
      } else if (status == 'active' || status == 'completed') {
        approvedClaims++;
        totalPayouts += amount;
        totalRevenue += amount * 1.1;
      } else if (status == 'rejected') {
        rejectedClaims++;
      }
    }

    double approvalRate = totalClaims > 0 ? (approvedClaims / totalClaims) * 100 : 0;
    double renewalRate = approvedClaims > 0 ? ((approvedClaims - 5) / approvedClaims) * 100 : 0; // Mock renewal logic

    setState(() {
      _analyticsData = {
        'totalClaims': totalClaims,
        'pendingClaims': pendingClaims,
        'approvedClaims': approvedClaims,
        'rejectedClaims': rejectedClaims,
        'totalPayouts': totalPayouts,
        'approvalRate': approvalRate,
        'aiAccuracy': 98.0,
        'avgProcessingTime': 2.4,
        'customerSatisfaction': 4.8,
        'revenue': totalRevenue,
        'activePolicies': approvedClaims,
        'renewalRate': renewalRate > 0 ? renewalRate : 87.0,
      };
    });
  }

  void _loadMockData() {
    setState(() {
      _analyticsData = {
        'totalClaims': 156,
        'pendingClaims': 12,
        'approvedClaims': 125,
        'rejectedClaims': 19,
        'totalPayouts': 84200,
        'approvalRate': 92.0,
        'aiAccuracy': 98.0,
        'avgProcessingTime': 2.4,
        'customerSatisfaction': 4.8,
        'revenue': 245000,
        'activePolicies': 89,
        'renewalRate': 87.0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: Row(children: [Icon(Icons.calendar_today, size: 16), SizedBox(width: 4), Text(_selectedTimeRange)]),
            onSelected: (value) => setState(() => _selectedTimeRange = value),
            itemBuilder: (context) => _timeRanges.map((range) => PopupMenuItem(value: range, child: Text(range))).toList(),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalyticsData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildOverviewCards(),
                    const SizedBox(height: 20),
                    _buildPerformanceMetrics(),
                    const SizedBox(height: 20),
                    _buildChartsSection(),
                    const SizedBox(height: 20),
                    _buildTrendsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildAnalyticsCard('Total Revenue', '\$${(_analyticsData['revenue']/1000).toStringAsFixed(0)}K', Icons.attach_money, const Color(0xFF7E57C2), '+15%'),
        _buildAnalyticsCard('Active Policies', _analyticsData['activePolicies'].toString(), Icons.policy, const Color(0xFF4CAF50), '+8%'),
        _buildAnalyticsCard('Total Payouts', '\$${(_analyticsData['totalPayouts']/1000).toStringAsFixed(1)}K', Icons.payment, const Color(0xFF2196F3), '-3%'),
        _buildAnalyticsCard('Customer Satisfaction', '${_analyticsData['customerSatisfaction']}/5', Icons.star, const Color(0xFFFFC107), '+2%'),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change.contains('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change.contains('+') ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: change.contains('+') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: change.contains('+') ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Metrics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildMetricRow('Approval Rate', '${_analyticsData['approvalRate'].toStringAsFixed(1)}%', _analyticsData['approvalRate'].toDouble() / 100, Colors.green),
          _buildMetricRow('Average Processing Time', '${_analyticsData['avgProcessingTime']} days', 0.8, Colors.blue),
          _buildMetricRow('Renewal Rate', '${_analyticsData['renewalRate'].toStringAsFixed(1)}%', _analyticsData['renewalRate'].toDouble() / 100, Colors.purple),
          _buildMetricRow('AI Accuracy', '${_analyticsData['aiAccuracy']}%', _analyticsData['aiAccuracy'].toDouble() / 100, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, double progressValue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 1, child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color))),
          Expanded(flex: 2, child: LinearProgressIndicator(value: progressValue, backgroundColor: color.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(color))),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Claim Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartSegment('Auto', 65, const Color(0xFFFFA000)),
                _buildChartSegment('Theft', 25, const Color(0xFF2196F3)),
                _buildChartSegment('Other', 10, const Color(0xFF4CAF50)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartLegend('Auto (65%)', const Color(0xFFFFA000)),
              _buildChartLegend('Theft (25%)', const Color(0xFF2196F3)),
              _buildChartLegend('Other (10%)', const Color(0xFF4CAF50)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSegment(String label, int percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 60,
          height: percentage * 2.0,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 8),
        Text('$percentage%', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
      ],
    );
  }

  Widget _buildChartLegend(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTrendsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Trends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTrendItem('Jan', 120, 95),
                _buildTrendItem('Feb', 135, 102),
                _buildTrendItem('Mar', 110, 88),
                _buildTrendItem('Apr', 156, 125),
                _buildTrendItem('May', 142, 115),
                _buildTrendItem('Jun', 168, 138),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String month, int claims, int approved) {
    double approvalRate = (approved / claims) * 100;
    double barHeight = (approved / claims) * 80;
    
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('$claims', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SizedBox(
            height: 80,
            width: 30,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(width: 20, height: 80, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                Container(width: 20, height: barHeight, decoration: BoxDecoration(color: const Color(0xFF7E57C2), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(month, style: const TextStyle(fontSize: 12)),
          Text('${approvalRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
        ],
      ),
    );
  }
}