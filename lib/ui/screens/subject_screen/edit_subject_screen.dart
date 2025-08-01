import 'package:flutter/material.dart';

class EditRegisteredSubjectScreen extends StatelessWidget {
  const EditRegisteredSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขการลงทะเบียนวิชา'),
        backgroundColor: const Color(0xFF113F67),
      ),
      body: const Center(child: Text('หน้านี้สำหรับแก้ไขรายวิชาที่ลงทะเบียน')),
    );
  }
}
