import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/setting/settings_constants.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    super.key,
    this.onBack,
  });
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SettingsConstants.headerHeight,
      padding: const EdgeInsets.only(
        top: ConfirmOrderConstants.headerTopPadding,
        bottom: ConfirmOrderConstants.headerBottomPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: AppTextStyles.titleStyle),
          Positioned(
            left: ConfirmOrderConstants.backButtonLeftPadding,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.iconColor,
              ),
              onPressed:
                  onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
            ),
          ),
        ],
      ),
    );
  }
}
