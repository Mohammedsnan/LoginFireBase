import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login/auth_screen.dart' show AuthScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  تهيئة Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}