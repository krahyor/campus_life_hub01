import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back, color: Colors.black),
                  // เส้นหยัก/โลโก้/แถบสถานะ
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/wave_logo.png',
                        ), // ใส่โลโก้หรือเส้นหยัก
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications, color: Colors.black),
                ],
              ),
            ),
            // Banner (Slideshow)
            SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: 3, // จำนวนสไลด์
                itemBuilder:
                    (context, index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blue[200],
                        image: DecorationImage(
                          image: AssetImage('assets/banner_$index.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              ),
            ),
            // Dots indicator (mock)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == 0 ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ),
            ),
            // What's new - Announcements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        "What's new",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Announcements',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text('view all', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder:
                    (context, index) => Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Center(child: Text('ข่าว/ประกาศ $index')),
                    ),
              ),
            ),
            // What's new - Events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        "What's new",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Events',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text('view all', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder:
                    (context, index) => Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Center(child: Text('กิจกรรม $index')),
                    ),
              ),
            ),
            // Tools Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tools',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildToolButton(Icons.school, 'Exam Info'),
                  _buildToolButton(Icons.computer, 'Simulation'),
                  _buildToolButton(Icons.group, 'Group'),
                  _buildToolButton(Icons.map, 'Map'),
                  // เพิ่มปุ่มอื่น ๆ ได้ตามต้องการ
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF113F67),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
