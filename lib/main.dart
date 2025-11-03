import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:smart_road_app/Splashscreen.dart';
import 'package:smart_road_app/Roleselection.dart';
import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_road_app/core/language/language_service.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';
import 'package:smart_road_app/services/theme_service.dart';
import 'package:smart_road_app/screens/notifications/notification_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCOfjtsUEcqxB5Zr7d5BvnRKKiz3fLqUuE",
          appId: "1:210471346742:android:e0432932179a38707f6e97",
          messagingSenderId: "210471346742",
          projectId: "smart-4ebfc",
          storageBucket: "gs://smart-4ebfc.firebasestorage.app",
          databaseURL: "https://smart-4ebfc-default-rtdb.firebaseio.com/",
        ),
      );
      print('Firebase initialized successfully');
    } else {
      print('Firebase already initialized');
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  // Initialize Firebase Messaging after Firebase is ready
  await FirebaseMessagingHandler.initialize();

  // Request storage, camera, and location permissions
  await _requestPermissions();

  runApp(const VoiceAssistantApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.storage,
    Permission.camera,
    Permission.photos, // For iOS
    Permission.videos, // For iOS
    Permission.location,
  ].request();
}

class VoiceAssistantApp extends StatelessWidget {
  const VoiceAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageService()),
      ],
      child: Consumer2<LanguageService, ThemeService>(
        builder: (context, languageService, themeService, child) {
          return MaterialApp(
            title: 'Smart Road App',
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            locale: languageService.currentLocale,
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
              Locale('hi', 'IN'),
              Locale('fr', 'FR'),
            ],
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}














// import 'package:smart_road_app/Splashscreen.dart';
// import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_road_app/core/language/language_service.dart';
// import 'package:smart_road_app/core/language/app_localizations.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase first (check if already initialized)
//   try {
//     // Check if Firebase apps already exist
//     if (Firebase.apps.isEmpty) {
//       await Firebase.initializeApp(
//         options: const FirebaseOptions(
//           apiKey: "AIzaSyCOfjtsUEcqxB5Zr7d5BvnRKKiz3fLqUuE",
//           appId: "1:210471346742:android:e0432932179a38707f6e97",
//           messagingSenderId: "210471346742",
//           projectId: "smart-4ebfc",
//           storageBucket: "gs://smart-4ebfc.firebasestorage.app",
//           databaseURL: "https://smart-4ebfc-default-rtdb.firebaseio.com/",
//         ),
//       );
//       print('Firebase initialized successfully');
//     } else {
//       print('Firebase already initialized');
//     }
//   } catch (e) {
//     print('Firebase initialization error: $e');
//     // Continue even if there's an error (Firebase might be auto-initialized)
//   }

//   // Initialize Firebase Messaging after Firebase is ready
//   await FirebaseMessagingHandler.initialize();

//   runApp(VoiceAssistantApp());
// }

// class VoiceAssistantApp extends StatelessWidget {
//   const VoiceAssistantApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => LanguageService()),
//       ],
//       child: Consumer<LanguageService>(
//         builder: (context, languageService, child) {
//           return MaterialApp(
//             title: 'Personal AI Agent',
//             home: SplashScreen(),
//             debugShowCheckedModeBanner: false,
//             locale: languageService.currentLocale,
//             localizationsDelegates: [
//               AppLocalizationsDelegate(),
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: const [
//               Locale('en', 'US'),
//               Locale('es', 'ES'),
//               Locale('hi', 'IN'),
//               Locale('fr', 'FR'),
//             ],
//             // ADD THIS FOR BETTER PERFORMANCE
//             builder: (context, child) {
//               return MediaQuery(
//                 data: MediaQuery.of(
//                   context,
//                 ).copyWith(textScaler: const TextScaler.linear(1.0)),
//                 child: child!,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// // import 'package:smart_road_app/Splashscreen.dart';
// // import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:provider/provider.dart';
// // import 'package:smart_road_app/core/language/language_service.dart';
// // import 'package:smart_road_app/core/language/app_localizations.dart';
// // import 'package:permission_handler/permission_handler.dart'; // ✅ Added for permissions
// // import 'package:geolocator/geolocator.dart'; // ✅ For location

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   // Initialize Firebase
// //   try {
// //     if (Firebase.apps.isEmpty) {
// //       await Firebase.initializeApp(
// //         options: const FirebaseOptions(
// //           apiKey: "AIzaSyCOfjtsUEcqxB5Zr7d5BvnRKKiz3fLqUuE",
// //           appId: "1:210471346742:android:e0432932179a38707f6e97",
// //           messagingSenderId: "210471346742",
// //           projectId: "smart-4ebfc",
// //           storageBucket: "gs://smart-4ebfc.firebasestorage.app",
// //           databaseURL: "https://smart-4ebfc-default-rtdb.firebaseio.com/",
// //         ),
// //       );
// //       print('Firebase initialized successfully');
// //     } else {
// //       print('Firebase already initialized');
// //     }
// //   } catch (e) {
// //     print('Firebase initialization error: $e');
// //   }

// //   // Initialize notifications
// //   await FirebaseMessagingHandler.initialize();

// //   runApp(const VoiceAssistantApp());
// // }

// // class VoiceAssistantApp extends StatelessWidget {
// //   const VoiceAssistantApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(create: (context) => LanguageService()),
// //       ],
// //       child: Consumer<LanguageService>(
// //         builder: (context, languageService, child) {
// //           return MaterialApp(
// //             title: 'Personal AI Agent',
// //             home: const PermissionRequestScreen(), // ✅ Start from permission check
// //             debugShowCheckedModeBanner: false,
// //             locale: languageService.currentLocale,
// //             localizationsDelegates: const [
// //               AppLocalizationsDelegate(),
// //               GlobalMaterialLocalizations.delegate,
// //               GlobalWidgetsLocalizations.delegate,
// //               GlobalCupertinoLocalizations.delegate,
// //             ],
// //             supportedLocales: const [
// //               Locale('en', 'US'),
// //               Locale('es', 'ES'),
// //               Locale('hi', 'IN'),
// //               Locale('fr', 'FR'),
// //             ],
// //             builder: (context, child) {
// //               return MediaQuery(
// //                 data: MediaQuery.of(context)
// //                     .copyWith(textScaler: const TextScaler.linear(1.0)),
// //                 child: child!,
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class PermissionRequestScreen extends StatefulWidget {
// //   const PermissionRequestScreen({super.key});

// //   @override
// //   State<PermissionRequestScreen> createState() =>
// //       _PermissionRequestScreenState();
// // }

// // class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
// //   bool _checking = true;
// //   bool _allGranted = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _requestPermissions();
// //   }

// //   Future<void> _requestPermissions() async {
// //     // ✅ Request all necessary permissions
// //     Map<Permission, PermissionStatus> statuses = await [
// //       Permission.camera,
// //       Permission.photos,
// //       Permission.videos,
// //       Permission.storage,
// //       Permission.location,
// //     ].request();

// //     bool allGranted =
// //         statuses.values.every((status) => status.isGranted || status.isLimited);

// //     if (allGranted) {
// //       setState(() {
// //         _allGranted = true;
// //       });

// //       // ✅ Navigate to Splash Screen after short delay
// //       await Future.delayed(const Duration(seconds: 1));
// //       if (mounted) {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (_) => SplashScreen()),
// //         );
// //       }
// //     } else {
// //       setState(() {
// //         _checking = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_allGranted) return const SizedBox.shrink();

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: _checking
// //             ? const CircularProgressIndicator()
// //             : Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   const Icon(Icons.lock, size: 80, color: Colors.grey),
// //                   const SizedBox(height: 20),
// //                   const Text(
// //                     "We need some permissions to continue",
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: _requestPermissions,
// //                     style: ElevatedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 30, vertical: 12)),
// //                     child: const Text("Grant Permissions"),
// //                   ),
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// // }
