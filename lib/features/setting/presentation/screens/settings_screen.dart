import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/core/utils/utils.dart';
import 'package:take_eat/features/setting/presentation/widgets/SettingsTile.dart';
import 'package:take_eat/features/setting/settings_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _onNotification(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showToast(rootContext, "Chức năng đang phát triển", type: ToastType.info);
  }

  void _onConfirmDelete(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showToast(
      rootContext,
      "Account deleted successfully",
      type: ToastType.success,
    );
    context.go(AppRoutes.authScreen);
  }

  void _showDeleteAccountBottomSheet(BuildContext context) {
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
                      onPressed: () => _onConfirmDelete(context),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerColor,
      body: Column(
        children: [
          // --- Header ---
          Container(
            width: double.infinity,
            height: SettingsConstants.headerHeight,
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text('Settings', style: AppTextStyles.titleStyle),
                Positioned(
                  left: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.iconColor,
                      size: 13,
                      fontWeight: FontWeight.w900,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // --- Body ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: SettingsConstants.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SettingsConstants.cornerRadius),
                  topRight: Radius.circular(SettingsConstants.cornerRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: SettingsConstants.shadowColor,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
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
          ),
        ],
      ),
    );
  }
}
