import 'package:flutter/material.dart';
import 'package:campusapp/ui/screens/main_screen/main_screen.dart';
import 'package:campusapp/ui/screens/events_screen/events_screen.dart';
import 'package:campusapp/ui/screens/profile_screen/profile_screen.dart';
import 'package:campusapp/ui/screens/schedule_screen/schedule_screen.dart';
import 'package:campusapp/ui/auth/presentation/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String events = '/events';
  static const String profile = '/profile';
  static const String schedule = '/schedule';
  static const String login = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildSlideRoute(MainHomeScreen(), settings);
      case events:
        return _buildSlideRoute(EventsScreen(), settings);
      case profile:
        return _buildSlideRoute(ProfileScreen(), settings);
      case schedule:
        return _buildSlideRoute(ScheduleScreen(), settings);
      case login:
        return _buildSlideRoute(LoginScreen(), settings);
      default:
        return _buildSlideRoute(MainHomeScreen(), settings);
    }
  }

  static PageRouteBuilder _buildSlideRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
