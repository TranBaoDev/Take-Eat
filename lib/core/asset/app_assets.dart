import 'dart:core';

import 'package:flutter/material.dart';

abstract class AppAssets {
  const AppAssets._();
  // ---------------------PATHS --------------------//
  static const String _imagePath = 'assets/images';
  static const String _logoPath = 'assets/images/logos';

  //----------------------LOGO ---------------------//
  static const String logo = '$_logoPath/onboard-logo.png';
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
