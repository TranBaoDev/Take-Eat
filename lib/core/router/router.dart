import 'package:flutter/material.dart';
import 'package:take_eat/features/home/presentation/screens/home_screen.dart';
import 'package:take_eat/features/launch/presentation/launch_page.dart';

class AppRouter {
  AppRouter._();
  static const String launch = '/';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launch:
        return MaterialPageRoute(builder: (_) => const LaunchPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}