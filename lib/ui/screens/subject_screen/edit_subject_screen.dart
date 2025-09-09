import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/subject_provider.dart';
import '../../providers/register_subjects_provider.dart';
import '../account_screen/login_screen.dart';
import '../../../core/routes.dart';

class EditRegisteredSubjectScreen extends StatefulWidget {
  const EditRegisteredSubjectScreen({super.key});

  @override
  State<EditRegisteredSubjectScreen> createState() =>
      _EditRegisteredSubjectState();
}

class _EditRegisteredSubjectState extends State<EditRegisteredSubjectScreen> {
  late final User? _firebaseUser;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;

    // โหลดข้อมูลวิชาถ้า login แล้ว
    if (_firebaseUser != null) {
      Provider.of<SubjectProvider>(context, listen: false).loadSubjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ถ้ายังไม่ได้ login
    if (_firebaseUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('แก้ไขการทะเบียนรายวิชา'),
          backgroundColor: const Color(0xFF113F67),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("เข้าสู่ระบบ เพื่อแก้ไขการลงทะเบียนวิชา"),
          ),
        ),
      );
    }

    final subjectProvider = Provider.of<SubjectProvider>(context);
    final registeredProvider = Provider.of<RegisteredSubjectsProvider>(context);

    final registeredSubjectIds =
        registeredProvider.subjects
            .map((s) => s['subject_id'] as String)
            .toSet();

    final registeredSubjects =
        subjectProvider.subjects
            .where(
              (subject) => registeredSubjectIds.contains(subject.subjectId),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขการทะเบียนรายวิชา'),
        backgroundColor: const Color(0xFF113F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          registeredSubjects.isEmpty
              ? const Center(child: Text('ยังไม่มีการลงทะเบียนวิชา'))
              : ListView.builder(
                itemCount: registeredSubjects.length,
                itemBuilder: (context, index) {
                  final subject = registeredSubjects[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('${subject.subject} (${subject.subjectId})'),
                      subtitle: Text(
                        'ผู้สอน: ${subject.teacher}\n'
                        'วัน: ${subject.day} เวลา: ${subject.startTime} - ${subject.endTime}\n'
                        'ห้อง: ${subject.room} หน่วยกิต: ${subject.credit}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await registeredProvider.unregisterSubject(
                            subject.subjectId,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ยกเลิกรายวิชาเรียบร้อย'),
                            ),
                          );
                        },
                        child: const Text('ยกเลิกรายวิชา'),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
