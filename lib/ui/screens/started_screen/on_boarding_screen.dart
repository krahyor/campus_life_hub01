import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screen/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome',
      'subtitle': 'This is a simple onboarding screen example.',
      'image': 'assets/onboarding1.png',
    },
    {
      'title': 'Easy to Use',
      'subtitle': 'Swipe to navigate through onboarding pages.',
      'image': 'assets/onboarding2.png',
    },
    {
      'title': 'Get Started',
      'subtitle': 'Tap Start to enter the app.',
      'image': 'assets/onboarding3.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _goToHome();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _goToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF113F67), // ✅ เปลี่ยนสีพื้นหลังทั้งหน้า
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = pages[index];
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (page['image'] != null)
                  SizedBox(
                    height: 250,
                    child: Image.asset(page['image']!, fit: BoxFit.contain),
                  ),
                const SizedBox(height: 40),
                Text(
                  page['title']!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  page['subtitle']!,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        height: 80,
        color: const Color(0xFF113F67),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // ฝั่งซ้าย - Previous หรือช่องว่างเท่ากัน
            SizedBox(
              width: 80,
              child:
                  _currentPage == 0
                      ? const SizedBox.shrink()
                      : TextButton(
                        onPressed: _previousPage,
                        child: const Text(
                          'ก่อนหน้า',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
            ),

            // ไข่ปลา - อยู่ตรงกลาง และขยายเต็มพื้นที่ที่เหลือ
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีจุดไข่ปลา
                  children: List.generate(
                    pages.length,
                    (indexDot) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == indexDot ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == indexDot
                                ? Colors.white
                                : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ฝั่งขวา - Next / Start ปุ่ม อยู่ใน SizedBox เท่ากับฝั่งซ้าย
            SizedBox(
              width: 80,
              child:
                  _currentPage == pages.length - 1
                      ? TextButton(
                        onPressed: _nextPage,
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : IconButton(
                        onPressed: _nextPage,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        iconSize: 20,
                        tooltip: 'Next',
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
