import 'package:flutter/material.dart';
import 'take_subject_screen.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TakeSubjectScreen()),
          );
        },
        icon: const Icon(Icons.book),
        label: const Text('ไปยังหน้าลงทะเบียนวิชา'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
