import 'package:smart_road_app/Splashscreen.dart';
import 'package:smart_road_app/ToeProvider/notificatinservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_road_app/core/language/language_service.dart';
import 'package:smart_road_app/core/language/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingHandler.initialize();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCOfjtsUEcqxB5Zr7d5BvnRKKiz3fLqUuE",
      appId: "1:210471346742:android:e0432932179a38707f6e97",
      messagingSenderId: "210471346742",
      projectId: "smart-4ebfc",
      storageBucket: "gs://smart-4ebfc.firebasestorage.app",
      databaseURL: "https://smart-4ebfc-default-rtdb.firebaseio.com/"
    ),
  );
  runApp(VoiceAssistantApp());
}

class VoiceAssistantApp extends StatelessWidget {
  const VoiceAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageService()),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'Personal AI Agent',
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
            locale: languageService.currentLocale,
            localizationsDelegates: const [
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