import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/shared/app_btn.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // navigate to home on success
            context.go(AppRoutes.home);
          } else if (state is AuthError) {
            // Show friendly message to user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.userMessage)),
            );

            // Show dev message only when in debug mode
            if (kDebugMode && state.devMessage != null) {
              // ignore: avoid_print
              print('Dev Auth error: ${state.devMessage}');
              unawaited(
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Debug info'),
                    content: SingleChildScrollView(
                      child: Text(state.devMessage!),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SizedBox(
            height: size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.logo,
                  width: size.width * 0.6,
                  height: size.height * 0.25,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Take',
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Eat',
                        style: TextStyle(
                          fontSize: size.width * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'From favorites to faraway delights, we bring flavors to your door in minutes!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return AppBtnWidget(
                      text: isLoading ? 'Signing in...' : 'Sign in with Google',
                      imageTxt: AppAssets.googleIcon,
                      bgColor: Colors.white,
                      textColor: primaryColor,
                      onTap: isLoading
                          ? null
                          : () => context.read<AuthCubit>().signInWithGoogle(),
                    );
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return AppBtnWidget(
                      text: isLoading ? 'Signing in...' : 'Sign in with Apple',
                      imageTxt: AppAssets.appleIcon,
                      bgColor: Colors.black,
                      textColor: Colors.black,
                      onTap: isLoading
                          ? null
                          : () => context.read<AuthCubit>().signInWithApple(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
