import 'package:smart_road_app/Splashscreen.dart';
import 'package:smart_road_app/Roleselection.dart';
import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
import 'package:smart_road_app/services/enhanced_notification_service.dart';
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

  // Initialize Firebase first (check if already initialized)
  try {
    // Check if Firebase apps already exist
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
    // Continue even if there's an error (Firebase might be auto-initialized)
  }

  // Initialize Enhanced Notification Service (includes background handler)
  await EnhancedNotificationService.initialize();

  runApp(VoiceAssistantApp());
}

class VoiceAssistantApp extends StatelessWidget {
  const VoiceAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageService()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: Consumer2<LanguageService, ThemeService>(
        builder: (context, languageService, themeService, child) {
          return MaterialApp(
            title: 'Smart Road App',
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            locale: languageService.currentLocale,
            theme: themeService.getLightTheme(),
            darkTheme: themeService.getDarkTheme(),
            themeMode: themeService.themeMode,
            routes: {
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/notifications': (context) => const NotificationHistoryScreen(),
            },
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
            // ADD THIS FOR BETTER PERFORMANCE
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
