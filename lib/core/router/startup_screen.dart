import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _determineStartRoute();
  }

  Future<void> _determineStartRoute() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      // Mark onboarding as shown and go to onboarding
      await prefs.setBool('is_first_launch', false);
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
      return;
    }

    // Not first launch: check saved userid or firebase auth
    final savedUserId = prefs.getString('userId');
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Check the AuthCubit state if available
    AuthCubit? authCubit;
    try {
      authCubit = context.read<AuthCubit>();
    } catch (_) {
      authCubit = null;
    }

    final isAuthenticatedFromCubit =
        authCubit != null && (authCubit.state is! AuthInitial);

    if (savedUserId != null ||
        firebaseUser != null ||
        isAuthenticatedFromCubit) {
      if (!mounted) return;
      context.go(AppRoutes.home);
      return;
    }

    // Default: go to auth
    if (!mounted) return;
    context.go(AppRoutes.authScreen);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
