import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_eat/features/confirmOrder/presentation/screens/confirmOrder_Screen.dart';
import 'package:take_eat/features/home/presentation/home.dart';
import 'package:take_eat/features/onBoarding/presentation/screens/onboarding_screen.dart';
import 'package:take_eat/features/setting/presentation/screens/settings_screen.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String authScreen = '/authScreen';
  static const String confirmOrder = '/confirmOrder';
}

abstract class AppRouter {
  AppRouter._();
  static final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.authScreen,
        builder: (_, _) => const AuthScreen(),
        // If a user is already signed in (Firebase keeps the session), redirect
        // them from the auth screen to home so they don't need to log in again.
        redirect: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          final goingToAuth = state.uri.path == AppRoutes.authScreen;

          // If user is signed in and currently at auth screen, send to home
          if (user != null && goingToAuth) return AppRoutes.home;

          // If user is NOT signed in and is trying to go to home/protected routes,
          // redirect to auth screen. Adjust routes list as needed.
          final goingToHome = state.uri.path == AppRoutes.home;
          if (user == null && goingToHome) return AppRoutes.authScreen;

          return null;
        },
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => const MaterialPage(
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.setting,
        pageBuilder: (context, state) => const MaterialPage(
          child: SettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.confirmOrder,
        pageBuilder: (context, state) => const MaterialPage(
          child: ConfirmOrderScreen(),
        ),
      ),
    ],
  );
}
