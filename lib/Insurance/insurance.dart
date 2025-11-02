// import 'package:smart_road_app/Insurance/analytics.dart';
// import 'package:smart_road_app/Insurance/claim.dart';
// import 'package:smart_road_app/Insurance/dashboard.dart';
// import 'package:smart_road_app/Insurance/policy.dart';
// import 'package:smart_road_app/Insurance/setting.dart';
// import 'package:flutter/material.dart';

// class InsuranceApp extends StatelessWidget {
//   const InsuranceApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Insurance Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Color(0xFFF8F9FD),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Color(0xFF666666)),
//         ),
//       ),
//       // darkTheme: ThemeData(
//       //   primarySwatch: Colors.deepPurple,
//       //   //scaffoldBackgroundColor: Color(0xFF121212),
//       //   appBarTheme: AppBarTheme(
//       //     backgroundColor: Color(0xFF1E1E1E),
//       //     elevation: 0,
//       //     iconTheme: IconThemeData(color: Colors.white70),
//       //   ),
//       // ),
//       home: InsuranceDashboardHome(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class InsuranceDashboardHome extends StatefulWidget {
//   const InsuranceDashboardHome({super.key});

//   @override
//   _InsuranceDashboardHomeState createState() => _InsuranceDashboardHomeState();
// }

// class _InsuranceDashboardHomeState extends State<InsuranceDashboardHome> {
//   int _currentIndex = 0;

// //  bool _darkMode = false;

//   final List<Widget> _screens = [
//     DashboardScreen(),
//     InsuranceRequestsListScreen(),
//     AnalyticsScreen(),
//     InsuranceProfilePage(),
//     SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: Color(0xFF7E57C2),
//         unselectedItemColor: Color(0xFF999999),
//         selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//         unselectedLabelStyle: TextStyle(fontSize: 12),
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
//           BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Claims'),
//           BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
//           BottomNavigationBarItem(icon: Icon(Icons.policy), label: 'Policies'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }

import 'package:smart_road_app/Insurance/analytics.dart';
import 'package:smart_road_app/Insurance/claim.dart';
import 'package:smart_road_app/Insurance/dashboard.dart';
import 'package:smart_road_app/Insurance/policy.dart';
import 'package:smart_road_app/Insurance/setting.dart';
import 'package:flutter/material.dart';

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF666666)),
        ),
        fontFamily: 'Inter',
      ),
      home: const InsuranceDashboardHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InsuranceDashboardHome extends StatefulWidget {
  const InsuranceDashboardHome({super.key});

  @override
  _InsuranceDashboardHomeState createState() => _InsuranceDashboardHomeState();
}

class _InsuranceDashboardHomeState extends State<InsuranceDashboardHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const InsuranceRequestsListScreen(),
    const AnalyticsScreen(),
    const InsuranceProfilePage(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7E57C2),
        unselectedItemColor: const Color(0xFF999999),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Claims',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.policy), label: 'Policies'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
