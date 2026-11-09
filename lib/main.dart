import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';

void main() => runApp(const AuthApp());

/// Root widget: app-wide configuration only (theme, title, home screen).
class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
