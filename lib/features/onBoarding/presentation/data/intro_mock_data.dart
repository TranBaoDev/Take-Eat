import 'package:take_eat/core/asset/app_assets.dart';

class IntroPageModel {
  const IntroPageModel({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
  });
  final String imageAsset;
  final String title;
  final String subtitle;
  final String buttonText;
  final String icon;
}

final introPages = [
  const IntroPageModel(
    imageAsset: AppAssets.onboarding01,
    title: 'Order For Food',
    subtitle:
        'Easily order your favorite meals from local restaurants and get them delivered to your doorstep.',
    buttonText: 'Next',
    icon: AppAssets.iconIntro1,
  ),
  const IntroPageModel(
    imageAsset: AppAssets.onboarding02,
    title: 'Easy Payment',
    subtitle:
        'Make secure payments using your preferred methods — fast, simple, and safe.',
    buttonText: 'Next',
    icon: AppAssets.iconIntro2,
  ),
  const IntroPageModel(
    imageAsset: AppAssets.onboarding03,
    title: 'Fast Delivery',
    subtitle:
        'Track your order in real time and enjoy quick delivery right when you need it.',
    buttonText: 'Get Started',
    icon: AppAssets.iconIntro3,
  ),
];
