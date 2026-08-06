// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this
import 'firebase_options.dart'; // Add this
import 'screens/main_menu.dart'; 

void main() async {
  // Ensure Flutter is ready before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the settings from the CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GameHubApp());
}

class GameHubApp extends StatefulWidget {
  const GameHubApp({super.key});

  @override
  State<GameHubApp> createState() => _GameHubAppState();
}

class _GameHubAppState extends State<GameHubApp> {
  Locale _currentLocale = const Locale('ar');

  void _setLocale(String langCode) {
    setState(() {
      _currentLocale = Locale(langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('he')],
      locale: _currentLocale,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: MainMenuScreen(onLanguageChange: _setLocale),
    );
  }
}