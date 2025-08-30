import 'package:flutter/material.dart';
import 'package:notes_knot/splash_screen.dart';
import 'package:notes_knot/Home_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knot Note',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),},
    );
  }}
  
