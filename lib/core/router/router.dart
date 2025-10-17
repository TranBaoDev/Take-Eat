import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/features/auth/auth.dart';
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
