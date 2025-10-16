import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/features/auth/auth.dart';
import 'package:take_eat/features/onBoarding/presentation/screens/onboarding_screen.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String authScreen = '/authScreen';
}

abstract class AppRouter {
  AppRouter._();
  static final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.authScreen,
    routes: [
      GoRoute(
        path: AppRoutes.authScreen,
        builder: (_, _) => const AuthScreen(),
        //TODO add authCubit for state to recall
        redirect: (context, state) {},
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
    ],
  );
}
