import 'package:campusapp/ui/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../events_screen/events_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../setting_screen/setting_screen.dart';
import '../subject_screen/subject_screen.dart';
import '../subject_screen/take_subject_screen.dart';
import 'package:campusapp/core/routes.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> widgetOptions = const [
    HomeScreen(),
    EventsScreen(),
    SubjectScreen(),
    ProfileScreen(),
    SettingsScreen(),
    TakeSubjectScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Subject"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF11406C),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.schedule);
        },
        child: const Icon(Icons.schedule, color: Colors.white),
        tooltip: "เปิดตารางเรียน",
      ),
    );
  }
}
