import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/Login.dart';
import 'package:newsapp/View/Splash_screen.dart'; 
import 'package:newsapp/View/Home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCNkdq-oQ-oC1jZMRnqgIsQaFr44KHAeXk",
      appId: "1:934169676207:android:2598c276fa99822157875a",
      messagingSenderId: "934169676207",
      projectId: "newsapp-f513b",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          SplashScreenHandler(), // Using SplashScreenHandler to manage splash and navigation
    );
  }
}

class SplashScreenHandler extends StatefulWidget {
  @override
  _SplashScreenHandlerState createState() => _SplashScreenHandlerState();
}

class _SplashScreenHandlerState extends State<SplashScreenHandler> {
  @override
  void initState() {
    super.initState();
    _handleSplashScreen();
  }

  Future<void> _handleSplashScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Duration of splash screen

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // User is not signed in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashinScreen(); // Show splash screen while checking auth status
  }
}
