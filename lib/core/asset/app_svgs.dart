import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class SvgsAsset {
  const SvgsAsset._();
  // ---------------------PATHS --------------------//
  static const String _svgPath = 'assets/svgs';
  //----------------------LOGO ---------------------//
  static const String iconGg = '$_svgPath/ic_google.svg';
  static const String iconApple = '$_svgPath/ic_apple.svg';
  static const String iconCart = '$_svgPath/ic_cart.svg';
  static const String iconNotify = '$_svgPath/ic_notify.svg';
  static const String iconProfile = '$_svgPath/ic_profile.svg';
  static const String iconSnack = '$_svgPath/snacks.svg';
  static const String iconMeal = '$_svgPath/meal.svg';
  static const String iconVegan = '$_svgPath/vegan.svg';
  static const String iconDessert = '$_svgPath/dessert.svg';
  static const String iconDrink = '$_svgPath/drinks.svg';
}

class SvgPictureWidget extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SvgPictureWidget({
    required this.assetName,
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: fit,
    );
  }
}
