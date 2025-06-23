import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/screens/login/login_screen.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIEthon3.0 team5',
      home: const LoginScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MainColors.background,
      ),
    );
  }
}
