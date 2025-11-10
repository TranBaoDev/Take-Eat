import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/setting/settings_constants.dart';
import 'package:take_eat/shared/widgets/app_header.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    super.key,
    this.onBack,
    this.hasDecoration = true,
    this.bottomNavigationBar,
  });
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final bool hasDecoration;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppColors.headerColor,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  AppHeader(title: title, onBack: onBack),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 26,
                        bottom: bottomNavigationBar != null ? 60 : 26,
                      ),
                      decoration: BoxDecoration(
                        color: hasDecoration
                            ? SettingsConstants.backgroundColor
                            : AppColors.headerColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(SettingsConstants.cornerRadius),
                        ),
                      ),
                      child: body,
                    ),
                  ),
                ],
              ),
              if (bottomNavigationBar != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: bottomNavigationBar!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
