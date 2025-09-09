import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campusapp/core/routes.dart';
import 'package:campusapp/ui/widgets/base/day_selector.dart';

import '../../providers/register_subjects_provider.dart';
import '../../providers/subject_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedDay = 'จันทร์';

  final List<String> days = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์',
  ];

  @override
  Widget build(BuildContext context) {
    final registeredProvider = Provider.of<RegisteredSubjectsProvider>(context);
    final subjectProvider = Provider.of<SubjectProvider>(context);

    // ดึง subject_id ที่ user ลงทะเบียน
    final registeredSubjectIds =
        registeredProvider.subjects
            .map((s) => s['subject_id'] as String)
            .toSet();

    // กรองรายวิชาจาก subjectProvider โดยเฉพาะที่ user ลงทะเบียนแล้ว
    final registeredSubjects =
        subjectProvider.subjects
            .where((subj) => registeredSubjectIds.contains(subj.subjectId))
            .toList();

    // กรองตามวันที่เลือก (ถ้าเลือก "ทั้งหมด" แสดงหมด)
    final filteredSubjects =
        selectedDay == 'ทั้งหมด'
            ? registeredSubjects
            : registeredSubjects
                .where((subj) => subj.day == selectedDay)
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตารางเรียน'),
        backgroundColor: const Color(0xFF113F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.home);
          },
        ),
      ),
      body: Column(
        children: [
          DaySelector(
            selectedDay: selectedDay,
            days: days,
            onChanged: (value) {
              setState(() {
                selectedDay = value;
              });
            },
          ),
          Expanded(
            child:
                filteredSubjects.isEmpty
                    ? const Center(child: Text('ไม่มีวิชาเรียนในวันนี้'))
                    : ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subject = filteredSubjects[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${subject.subject} (${subject.subjectId})',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text('ผู้สอน: ${subject.teacher}'),
                                Text(
                                  'เวลา: ${subject.startTime} - ${subject.endTime}',
                                ),
                                Text('ห้อง: ${subject.room}'),
                                Text('วัน: ${subject.day}'),
                                Text('หน่วยกิต: ${subject.credit}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
