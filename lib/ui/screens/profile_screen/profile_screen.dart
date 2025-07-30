import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campusapp/ui/auth/presentation/login_screen.dart';
import 'package:campusapp/ui/auth/presentation/auth_service.dart';
import 'package:campusapp/core/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // ถ้ายังไม่ได้ login
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ข้อมูลส่วนตัว'),
          backgroundColor: const Color(0xFF113F67),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.home, // ไปหน้า Home
              );
            },
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
            child: const Text("Login to view profile"),
          ),
        ),
      );
    }

    // ถ้า login แล้ว
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.home, // ไปหน้า Home
            );
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(height: 20),
            Text(
              user.displayName ?? 'User Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              user.email ?? 'user.email@example.com',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // 🔻 ปุ่ม Logout
            ElevatedButton.icon(
              onPressed: () async {
                await AuthService().signout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
