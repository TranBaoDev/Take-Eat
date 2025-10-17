import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/features/home/presentation/home.dart';
import 'package:take_eat/features/launch/launch.dart';
import 'package:take_eat/features/onBoarding/presentation/screens/onboarding_screen.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const lauch = '/lauch';
  static const home = '/home';
}
abstract class AppRouter {
  AppRouter._();
  static final routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.lauch,
    routes: [
      GoRoute(path: AppRoutes.lauch, builder: (_, __) => const LaunchPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
    ]
  );
}
