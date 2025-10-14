import 'package:flutter/material.dart';

abstract class SvgsAsset {
  const SvgsAsset._();
  // ---------------------PATHS --------------------//
  static const String _svgPath = 'assets/svgs/';
  //----------------------LOGO ---------------------//
  static const String iconGg = '$_svgPath/ic_google.svg';
  static const String iconApple = '$_svgPath/ic_apple.svg';
}

class SvgPictureWidget extends StatelessWidget {
  const SvgPictureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO finish up SvgPictureWidget
    return Container();
  }
}
