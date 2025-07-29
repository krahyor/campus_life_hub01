import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<List<Map<String, dynamic>>> futureSchedule;
  String selectedDay = 'ทั้งหมด';

  final List<String> days = [
    'ทั้งหมด',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์',
  ];

  @override
  void initState() {
    super.initState();
    futureSchedule = loadScheduleFromJson();
  }

  Future<List<Map<String, dynamic>>> loadScheduleFromJson() async {
    final String jsonString = await rootBundle.loadString(
      'assets/mock_schedule/schedule.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตารางเรียน'),
        backgroundColor: const Color(0xFF113F67),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureSchedule,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ไม่พบข้อมูลตารางเรียน"));
          }

          final scheduleList = snapshot.data!;
          final filteredList =
              selectedDay == 'ทั้งหมด'
                  ? scheduleList
                  : scheduleList
                      .where((item) => item['day'] == selectedDay)
                      .toList();

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.w),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "เลือกวัน",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                  value: selectedDay,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDay = value;
                      });
                    }
                  },
                  items:
                      days
                          .map(
                            (day) =>
                                DropdownMenuItem(value: day, child: Text(day)),
                          )
                          .toList(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["subject"] ?? "ไม่มีชื่อวิชา",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text("ผู้สอน: ${item["teacher"] ?? "-"}"),
                              Text("เวลา: ${item["time"] ?? "-"}"),
                              Text("ห้อง: ${item["room"] ?? "-"}"),
                              Text("วัน: ${item["day"] ?? "-"}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
