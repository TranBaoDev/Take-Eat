import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/startup_screen.dart';
import 'package:take_eat/features/auth/auth.dart';
import 'package:take_eat/features/confirmOrder/presentation/screens/confirmOrder_Screen.dart';
import 'package:take_eat/features/home/presentation/home.dart';
import 'package:take_eat/features/myOrder/presentation/screens/my_order_screen.dart';
import 'package:take_eat/features/myOrder/presentation/screens/order_cancelled_screen.dart';
import 'package:take_eat/features/myOrder/presentation/screens/cancel_order_screen.dart';
import 'package:take_eat/features/onBoarding/presentation/screens/onboarding_screen.dart';
import 'package:take_eat/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:take_eat/features/payment/presentation/screens/add_card_screen.dart';
import 'package:take_eat/features/payment/presentation/screens/payment_methods.dart';
import 'package:take_eat/core/router/startup_screen.dart';
import 'package:take_eat/features/payment/presentation/screens/payment_screen.dart';
import 'package:take_eat/features/payment/screens/delivery_time_screen.dart';
import 'package:take_eat/features/payment/screens/payment_success_screen.dart';
import 'package:take_eat/features/profile/screen/my_profile.dart';
import 'package:take_eat/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:take_eat/features/setting/data/repositories/settings_repository_impl.dart';
import 'package:take_eat/features/setting/domain/usecases/delete_account_usecase.dart';
import 'package:take_eat/features/setting/presentation/bloC/settings_bloc.dart';
import 'package:take_eat/features/setting/presentation/screens/settings_screen.dart';
import 'package:take_eat/features/support/screens/contacts.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const String onboarding = '/onboarding';
  static const String splash = '/';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String authScreen = '/authScreen';
  static const String confirmOrder = '/confirmOrder';
  static const String myProfile = '/myProfile';
  static const String paymentMethods = '/paymentMethods';
  static const String addCard = '/addCard';
  static const String contactUs = '/contactUs';
  static const String pmSuccess = '/pmSuccess';
  static const String payment = '/payment';
  static const String deliveryTime = '/delivery-time';
  static const String myOrder = '/myOrder';
}

abstract class AppRouter {
  AppRouter._();
  static final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const StartupScreen(),
      ),
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
        path: AppRoutes.myProfile,
        pageBuilder: (_, __) => const MaterialPage(
          child: MyProfile(),
        ),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        pageBuilder: (context, state) => MaterialPage(
          child: BlocProvider.value(
            // Use the existing PaymentBloc provided at app root (MultiBlocProvider)
            value: context.read<PaymentBloc>(),
            child: const PaymentMethods(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.addCard,
        pageBuilder: (context, state) => MaterialPage(
          child: BlocProvider.value(
            value: context.read<PaymentBloc>(),
            child: const AddCardScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.contactUs,
        pageBuilder: (context, state) => const MaterialPage(
          child: ContactsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.setting,
        pageBuilder: (context, state) {
          final remoteDataSource = SettingsRemoteDataSourceImpl();
          final repository = SettingsRepositoryImpl(remoteDataSource);
          final deleteAccountUseCase = DeleteAccountUseCase(repository);

          return MaterialPage(
            child: BlocProvider(
              create: (_) => SettingsBloc(deleteAccountUseCase),
              child: const SettingsScreen(),
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.confirmOrder,
        pageBuilder: (context, state) => const MaterialPage(
          child: ConfirmOrderScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.pmSuccess,
        pageBuilder: (context, state) => const MaterialPage(
          child: PaymentSuccessScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) {
          final total = state.extra as double? ?? 0.0;
          return PaymentScreen(total: total);
        },
      ),
      GoRoute(
        path: AppRoutes.deliveryTime,
        builder: (context, state) => const DeliveryTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.myOrder,
        pageBuilder: (context, state) => const MaterialPage(
          child: MyOrderScreen(),
        ),
      ),
    ],
  );
}
