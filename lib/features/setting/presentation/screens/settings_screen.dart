import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/utils/utils.dart';
import 'package:take_eat/features/setting/presentation/bloC/settings_bloc.dart';
import 'package:take_eat/features/setting/presentation/widgets/SettingsTile.dart';
import 'package:take_eat/features/setting/settings_constants.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDeleteAccountBottomSheet(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to delete your account?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        parentContext.read<SettingsBloc>().add(
                          const SettingsEvent.deleteAccount(),
                        );
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onNotification(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showToast(rootContext, "Chức năng đang phát triển", type: ToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        final rootContext = Navigator.of(context, rootNavigator: true).context;

        state.whenOrNull(
          success: () {
            showToast(
              rootContext,
              "Account deleted successfully",
              type: ToastType.success,
            );
            context.go(AppRoutes.authScreen);
          },
          error: (message) {
            showToast(
              rootContext,
              "Vui lòng đăng nhập lại trước khi xóa",
              type: ToastType.error,
            );
          },
        );
      },
      builder: (context, state) {
        return Stack(
          children: [
            AppScaffold(
              title: 'Setting',
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SettingsConstants.verticalPadding,
                  horizontal: SettingsConstants.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification Setting',
                      expanded: false,
                      onTap: () => _onNotification(context),
                    ),
                    const SizedBox(height: SettingsConstants.tileSpacing),
                    SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Delete Account',
                      expanded: false,
                      onTap: () => _showDeleteAccountBottomSheet(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
