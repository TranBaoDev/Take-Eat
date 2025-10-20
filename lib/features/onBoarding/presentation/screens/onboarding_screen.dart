import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/onBoarding/intro_constants.dart';
import 'package:take_eat/features/onBoarding/presentation/blocs/onboarding_cubit.dart';
import 'package:take_eat/features/onBoarding/presentation/blocs/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:take_eat/features/onBoarding/presentation/data/intro_mock_data.dart';
import 'package:take_eat/features/onBoarding/presentation/widgets/intro_page_view.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  void _onNext() {
    if (currentIndex < introPages.length - 1) {
      _pageController.nextPage(
        duration: IntroConstants.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding complete then navigate to auth
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('is_first_launch', false);
        context.go(AppRoutes.authScreen);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = introPages[currentIndex].imageAsset;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Image.asset(
                background,
                key: ValueKey(background),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          // --- Skip Button ---
          Positioned(
            top: IntroConstants.skipTop,
            right: IntroConstants.skipRight,
            child: GestureDetector(
              onTap: () => _pageController.animateToPage(
                introPages.length - 1,
                duration: IntroConstants.pageTransitionDuration,
                curve: Curves.easeInOut,
              ),
              child: Row(
                children: [
                  const Text('Skip', style: AppTextStyles.skip),
                  const SizedBox(width: 6),
                  Image.asset(AppAssets.iconSkip, width: 8, height: 13),
                ],
              ),
            ),
          ),

          // --- Bottom PageView ---
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              child: PageView.builder(
                controller: _pageController,
                itemCount: introPages.length,
                onPageChanged: (i) => setState(() => currentIndex = i),
                itemBuilder: (context, index) {
                  final page = introPages[index];
                  return SizedBox(
                    width: double.infinity,
                    child: IntroPageView(
                      page: page,
                      index: index,
                      total: introPages.length,
                      onNext: _onNext,
                    ),
                  );
                },
              ),
            ),
          ),

          // --- Page Indicator ---
          Positioned(
            bottom: IntroConstants.indicatorBottom,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: introPages.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: Colors.orangeAccent,
                  dotHeight: IntroConstants.indicatorHeight,
                  dotWidth: IntroConstants.indicatorWidthInactive,
                  spacing: IntroConstants.indicatorSpacing,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
