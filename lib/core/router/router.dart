import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/features/onBoarding/presentation/screens/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingScreen(),
      ),
    ),
  ],
);
