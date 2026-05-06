import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login/auth_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',

      theme: ThemeData(
          primarySwatch: Colors.blue ,

      ),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class gggg extends StatefulWidget {
  const gggg({super.key});

  @override
  State<gggg> createState() => _ggggState();
}

class _ggggState extends State<gggg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
            Colors.green ,
            Colors.greenAccent,
            Colors.lightGreen ,
          ],
          )
        ),
      ),
    );
  }
}
