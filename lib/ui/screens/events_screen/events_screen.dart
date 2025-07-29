import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
        currentPage = 0; // รีเซ็ตหน้าเมื่อเลือกวันที่ใหม่
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

        // Slice events for current page
        final startIndex = currentPage * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage).clamp(0, events.length);
        final pageEvents = events.sublist(startIndex, endIndex);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Row 1: ปุ่มเลือกช่วงวันที่ อยู่ตรงกลาง
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: _selectDateRange,
                              icon: const Icon(Icons.date_range),
                              label: const Text("เลือกช่วงวันที่"),
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),

                  // Row 2: ข้อความชิดซ้าย ปุ่มล้างชิดขวา
                  if (selectedDateRange != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              "แสดงกิจกรรมระหว่าง\n${selectedDateRange!.start.toLocal().toString().split(' ')[0]} ถึง ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
                              textAlign: TextAlign.left,
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
                                child: const Text("ล้างช่วงวันที่"),
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
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: pageEvents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final event = pageEvents[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.event,
                              size: 36,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event["name"] ?? "ไม่มีชื่อกิจกรรม",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event["description"] ?? "ไม่มีรายละเอียด",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Text("เริ่ม: ${event["start_date"] ?? "-"}"),
                            Text("สิ้นสุด: ${event["end_date"] ?? "-"}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        currentPage > 0
                            ? () => setState(() => currentPage--)
                            : null,
                    child: const Text("< ก่อนหน้า"),
                  ),
                  const SizedBox(width: 16),
                  Text("หน้า ${currentPage + 1} / $totalPages"),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed:
                        currentPage < totalPages - 1
                            ? () => setState(() => currentPage++)
                            : null,
                    child: const Text("ถัดไป >"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
