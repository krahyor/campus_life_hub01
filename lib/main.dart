import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/routes.dart';

import 'ui/screens/started_screen/splash_screen.dart';
import 'ui/providers/subject_provider.dart';
import 'ui/providers/register_subjects_provider.dart';
import 'ui/viewmodels/post_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SubjectProvider()),

            // เพิ่ม StreamProvider ฟังสถานะ user
            StreamProvider<User?>.value(
              value: FirebaseAuth.instance.authStateChanges(),
              initialData: FirebaseAuth.instance.currentUser,
            ),

            // ใช้ ChangeNotifierProxyProvider เพื่อรับ user จาก StreamProvider
            ChangeNotifierProxyProvider<User?, RegisteredSubjectsProvider>(
              create: (_) => RegisteredSubjectsProvider(),
              update: (_, user, registeredProvider) {
                if (user != null) {
                  registeredProvider!.loadRegisteredSubjects(user.uid);
                } else {
                  // กรณี logout, เคลียร์ข้อมูล
                  registeredProvider?.loadRegisteredSubjects('');
                }
                return registeredProvider!;
              },
            ),

            ChangeNotifierProvider(create: (_) => PostViewModel()), // 👈
          ],
          child: MaterialApp(
            // home: SubjectScreen(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: AppRoutes.splash,
            title: 'Flutter Onboarding Example',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF113F67),
              ),
              textTheme: GoogleFonts.promptTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: const Color(0xFF113F67),
                centerTitle: true,
                titleTextStyle: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.white, // สีของลูกศร
                  size: 18.sp, // ขนาดของลูกศร (ถ้าต้องการ)
                ),
              ),
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
