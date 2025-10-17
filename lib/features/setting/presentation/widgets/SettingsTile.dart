import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/setting/settings_constants.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool expanded;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SettingsConstants.horizontalPadding + 4,
        vertical: 4,
      ),
      leading: Icon(
        icon,
        color: AppColors.iconColor,
        size: SettingsConstants.iconSize,
      ),
      title: Text(title, style: AppTextStyles.itemTextStyle),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey,
        size: SettingsConstants.trailingIconSize,
      ),
      onTap: onTap,
    );
  }
}
