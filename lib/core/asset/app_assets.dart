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
  static const String googleIcon = '$_logoPath/ic_google.png';
  static const String appleIcon = '$_logoPath/ic_apple.png';
  static const String cart = '$_imagePath/cart.png';
  static const String profile = '$_imagePath/profile.png';
  static const String notifi = '$_imagePath/notifi.png';

  //----------------------IMAGE--------------------//
  static const String defaultAvatar = '$_imagePath/defaultPfp.png';
  static const String onboarding01 = '$_imagePath/onboarding1.png';
  static const String onboarding02 = '$_imagePath/onboarding2.png';
  static const String onboarding03 = '$_imagePath/onboarding3.png';
  static const String sushiImage = '$_imagePath/shushi.png';
  static const String bannerImage = '$_imagePath/banner.png';
  static const String mapImage ='$_imagePath/map.png';
  static const String myOrderEmptyImage ='$_imagePath/my_order_empty.png';
  static const String orderCancelledImage ='$_imagePath/order_cancelled.png';

  //----------------------ICONS---------------------//
  static const String iconIntro1 = '$_iconPath/iconIntro1.png';
  static const String iconIntro2 = '$_iconPath/iconIntro2.png';
  static const String iconIntro3 = '$_iconPath/iconIntro3.png';
  static const String iconSkip = '$_iconPath/skip.png';
  static const String iconFillter = '$_iconPath/fillter.png';
  static const String iconStar = '$_iconPath/star.png';
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
