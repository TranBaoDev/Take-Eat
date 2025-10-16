import 'dart:core';

import 'package:flutter/material.dart';

abstract class AppAssets {
  const AppAssets._();
  // ---------------------PATHS --------------------//
  static const String _imagePath = 'assets/images';
  static const String _logoPath = 'assets/images/logos';
  static const String _iconPath = 'assets/images/icons';

  //----------------------LOGO ---------------------//
  static const String logo = '$_logoPath/onboard-logo.png';
  static const String googleIcon = '$_logoPath/google.png';
  static const String cart = '$_imagePath/cart.png';
  static const String profile = '$_imagePath/profile.png';
  static const String notifi = '$_imagePath/notifi.png';

  //----------------------IMAGE--------------------//
  static const String onboarding01 = '$_imagePath/onboarding1.png';
  static const String onboarding02 = '$_imagePath/onboarding2.png';
  static const String onboarding03 = '$_imagePath/onboarding3.png';

  //----------------------ICONS---------------------//
  static const String iconIntro1 = '$_iconPath/iconIntro1.png';
  static const String iconIntro2 = '$_iconPath/iconIntro2.png';
  static const String iconIntro3 = '$_iconPath/iconIntro3.png';
  static const String iconSkip = '$_iconPath/skip.png';
}

class AppAssetImageWidget extends StatelessWidget {
  const AppAssetImageWidget({
    required this.name,
    this.size = const Size(100, 100),
    this.borderRadius = BorderRadius.zero,
    super.key,
    this.fit = BoxFit.contain,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String name;
  final BoxFit fit;
  final Size size;
  final BorderRadius borderRadius;
  final int? cacheWidth;
  final int? cacheHeight;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheW = (size.width * dpr).round();
    final cacheH = (size.height * dpr).round();
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        //TODO improve AppAssetImageWidget
        name,
        fit: fit,
        width: size.width,
        height: size.height,
        cacheHeight: cacheHeight ?? cacheH,
        cacheWidth: cacheWidth ?? cacheW,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Loading spinner
          }
          return child;
        },
      ),
    );
  }
}
