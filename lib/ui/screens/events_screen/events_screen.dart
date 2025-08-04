import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:campusapp/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<Map<String, dynamic>>> futureEvents;
  int currentPage = 0;
  final int itemsPerPage = 4;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    futureEvents = loadEventsFromJson();
  }

  Future<List<Map<String, dynamic>>> loadEventsFromJson() async {
    final String jsonString = await rootBundle.loadString(
      'assets/mock_events/mock_events.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange:
          selectedDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now.add(const Duration(days: 7)),
          ),
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("ไม่พบข้อมูลกิจกรรม"));
        }

        List<Map<String, dynamic>> events = snapshot.data!;

        if (selectedDateRange != null) {
          events =
              events.where((event) {
                final start = DateTime.tryParse(event["start_date"] ?? '');
                final end = DateTime.tryParse(event["end_date"] ?? '');
                if (start == null || end == null) return false;
                return start.isBefore(
                      selectedDateRange!.end.add(const Duration(days: 1)),
                    ) &&
                    end.isAfter(
                      selectedDateRange!.start.subtract(
                        const Duration(days: 1),
                      ),
                    );
              }).toList();
        }

        final totalPages = (events.length / itemsPerPage).ceil();
        final startIndex = currentPage * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage).clamp(0, events.length);
        final pageEvents = events.sublist(startIndex, endIndex);

        return Scaffold(
          appBar: AppBar(
            title: const Text('กิจกรรม'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          const Spacer(flex: 2),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: _selectDateRange,
                                icon: const Icon(Icons.date_range),
                                label: Text(
                                  "เลือกช่วงวันที่",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                    if (selectedDateRange != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                "แสดงกิจกรรมระหว่าง\n${selectedDateRange!.start.toLocal().toString().split(' ')[0]} ถึง ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            const Spacer(flex: 2),
                            Expanded(
                              flex: 4,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDateRange = null;
                                      currentPage = 0;
                                    });
                                  },
                                  child: Text(
                                    "ล้างช่วงวันที่",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: GridView.builder(
                    itemCount: pageEvents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.h,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final event = pageEvents[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.event,
                                size: 36.sp,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                event["name"] ?? "ไม่มีชื่อกิจกรรม",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                event["description"] ?? "ไม่มีรายละเอียด",
                                style: TextStyle(fontSize: 12.sp),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                "เริ่ม: ${event["start_date"] ?? "-"}",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              Text(
                                "สิ้นสุด: ${event["end_date"] ?? "-"}",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          currentPage > 0
                              ? () => setState(() => currentPage--)
                              : null,
                      child: Text(
                        "< ก่อนหน้า",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "หน้า ${currentPage + 1} / $totalPages",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton(
                      onPressed:
                          currentPage < totalPages - 1
                              ? () => setState(() => currentPage++)
                              : null,
                      child: Text("ถัดไป >", style: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
