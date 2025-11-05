import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/setting/settings_constants.dart';
import 'package:take_eat/shared/widgets/app_header.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final bool hasDecoration;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.hasDecoration = true,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppColors.headerColor,
        body: Column(
          children: [
            AppHeader(title: title, onBack: onBack),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: const BoxDecoration(
                  color: SettingsConstants.backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(SettingsConstants.cornerRadius),
                  ),
                ),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
