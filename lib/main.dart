import 'package:flutter/material.dart';
import 'features/started_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

// Root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Onboarding Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), // 👈 เรียกใช้จากไฟล์ใหม่
    );
  }
}
