import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart'; // สำหรับเรียกใช้ MyHomePage

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

  void _goToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true); // 👈 บันทึกว่าเคยดูแล้ว
    // await prefs.clear(); // ล้างทั้งหมดเพื่อทดสอบ
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'Home Page'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  page['subtitle']!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: _goToHome, child: const Text('Skip')),
            ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == pages.length - 1 ? 'Start' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
