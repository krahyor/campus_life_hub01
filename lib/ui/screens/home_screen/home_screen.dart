import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('Home Screen', style: TextStyle(fontSize: 24))),
    );
  }
}
