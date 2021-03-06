import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_flix/screens/home_screen.dart';
import 'package:movie_flix/screens/login_screen.dart';
import 'package:movie_flix/screens/splash_screen.dart';
import 'package:movie_flix/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Flix',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: primaryColor
      ),
      routes: {
        "/login": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
        "/edit": (context) => SplashScreen(),
      },
      home: SplashScreen(),
    );
  }
}