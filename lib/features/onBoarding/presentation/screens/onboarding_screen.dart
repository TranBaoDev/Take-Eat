import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/onBoarding/intro_constants.dart';
import 'package:take_eat/features/onBoarding/presentation/blocs/onboarding_cubit.dart';
import 'package:take_eat/features/onBoarding/presentation/blocs/onboarding_state.dart';

import 'package:take_eat/features/onBoarding/presentation/data/intro_mock_data.dart';
import 'package:take_eat/features/onBoarding/presentation/widgets/intro_page_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: introPages.length,
                    onPageChanged: cubit.jumpTo,
                    itemBuilder: (context, index) {
                      final page = introPages[index];
                      return IntroPageView(
                        page: page,
                        index: index,
                        total: introPages.length,
                        controller: pageController,
                        onNext: () async {
                          if (index < introPages.length - 1) {
                            await pageController.nextPage(
                              duration: IntroConstants.pageTransitionDuration,
                              curve: Curves.easeInOut,
                            );
                          } else {}
                        },
                      );
                    },
                  ),
                  Positioned(
                    top: IntroConstants.skipTop,
                    right: IntroConstants.skipRight,
                    child: GestureDetector(
                      onTap: () async {
                        await pageController.animateToPage(
                          introPages.length - 1,
                          duration: IntroConstants.pageTransitionDuration,
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Skip',
                            style: AppTextStyles.skip,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Image.asset(
                            AppAssets.iconSkip,
                            width: 8,
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
