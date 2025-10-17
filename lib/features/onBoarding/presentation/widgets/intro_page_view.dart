import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/onBoarding/intro_constants.dart';
import 'package:take_eat/features/onBoarding/presentation/data/intro_mock_data.dart';

class IntroPageView extends StatelessWidget {
  const IntroPageView({
    required this.page,
    required this.index,
    required this.total,
    required this.onNext,
    super.key,
  });

  final IntroPageModel page;
  final int index;
  final int total;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(IntroConstants.buttonRadius * 2),
          topRight: Radius.circular(IntroConstants.buttonRadius * 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: IntroConstants.horizontalPadding,
        vertical: IntroConstants.titleSpacing,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          Image.asset(page.icon, width: 35, height: 41),

          const SizedBox(height: IntroConstants.subtitleSpacing),

          Text(
            page.title,
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: IntroConstants.subtitleSpacing),

          Text(
            page.subtitle,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 55),

          // --- Button ---
          SizedBox(
            width: IntroConstants.buttonWidth,
            height: IntroConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    IntroConstants.buttonRadius * 2,
                  ),
                ),
              ),
              child: Text(
                page.buttonText,
                style: const TextStyle(color: AppColors.textLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
