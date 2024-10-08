import 'package:allurelle_test_2/home_page.dart' as home;
import 'package:allurelle_test_2/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'user_auth/login_page.dart';
import 'user_auth/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AuthCheck(), // Start the app with the AuthCheck widget
      routes: {
        '/home': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(), // Ensure SignUpPage exists in signup_page.dart
        '/homepage': (context) => home.HomePage(), // Remove const for non-const constructor
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

// This widget checks if the user is logged in or not
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in, redirect to HomePage
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginPage(); // If the user is not logged in, show login page
          } else {
            return home.HomePage(); // Remove const for non-const constructor
          }
        }
        // Show loading screen while checking the auth status
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
