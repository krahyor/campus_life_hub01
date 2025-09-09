import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/subject_provider.dart';
import '../../providers/register_subjects_provider.dart';
import '../account_screen/login_screen.dart';
import '../../../core/routes.dart';

class TakeSubjectScreen extends StatefulWidget {
  const TakeSubjectScreen({super.key});

  @override
  State<TakeSubjectScreen> createState() => _TakeSubjectScreenState();
}

class _TakeSubjectScreenState extends State<TakeSubjectScreen> {
  late final User? _firebaseUser;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;

    if (_firebaseUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final subjectProvider = Provider.of<SubjectProvider>(
          context,
          listen: false,
        );
        subjectProvider.loadSubjects();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_firebaseUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ลงทะเบียนรายวิชา'),
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
            child: const Text("เข้าสู่ระบบ เพื่อทำการลงทะเบียน"),
          ),
        ),
      );
    }

    final subjectProvider = Provider.of<SubjectProvider>(context);
    final registeredProvider = Provider.of<RegisteredSubjectsProvider>(context);

    // กรองเฉพาะรายวิชาที่ user นี้ลงทะเบียน
    final userRegisteredSubjects = registeredProvider.subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนรายวิชา'),
        backgroundColor: const Color(0xFF113F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
        ),
      ),
      body:
          subjectProvider.subjects.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: subjectProvider.subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjectProvider.subjects[index];
                  final isRegistered = userRegisteredSubjects.any(
                    (s) => s['subject_id'] == subject.subjectId,
                  );

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
                        onPressed:
                            isRegistered
                                ? null
                                : () async {
                                  await registeredProvider.registerSubject(
                                    subject.subjectId,
                                    subject.toJson(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ลงทะเบียนสำเร็จ'),
                                    ),
                                  );
                                },
                        child: Text(
                          isRegistered ? 'ลงทะเบียนแล้ว' : 'ลงทะเบียน',
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
