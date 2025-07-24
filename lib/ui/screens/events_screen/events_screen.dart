import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<Map<String, dynamic>>> futureEvents;
  int currentPage = 0;
  final int itemsPerPage = 4;

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

        final events = snapshot.data!;
        final totalPages = (events.length / itemsPerPage).ceil();

        // Slice events for current page
        final startIndex = currentPage * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage).clamp(0, events.length);
        final pageEvents = events.sublist(startIndex, endIndex);

        return Column(
          children: [
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
