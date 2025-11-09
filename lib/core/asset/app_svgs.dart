import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class SvgsAsset {
  const SvgsAsset._();
  // ---------------------PATHS --------------------//
  static const String _svgPath = 'assets/svgs';
  //----------------------LOGO ---------------------//
  static const String iconGg = '$_svgPath/ic_google.svg';
  static const String iconApple = '$_svgPath/ic_apple.svg';
  //----------------------ICON ---------------------//
  static const String iconCart = '$_svgPath/ic_cart.svg';
  static const String iconCartDrawer = '$_svgPath/ic_cartDrawer.svg';
  static const String iconNotify = '$_svgPath/ic_notify.svg';
  static const String iconNotifiDrawer = '$_svgPath/ic_notifiDrawer.svg';
  static const String iconProfile = '$_svgPath/ic_profile.svg';
  static const String iconSnack = '$_svgPath/snacks.svg';
  static const String iconMeal = '$_svgPath/meal.svg';
  static const String iconVegan = '$_svgPath/vegan.svg';
  static const String iconDessert = '$_svgPath/dessert.svg';
  static const String iconDrink = '$_svgPath/drinks.svg';
  static const String iconMyOrder = '$_svgPath/ic_myOrder.svg';
  static const String iconContacts = '$_svgPath/ic_contacts.svg';
  static const String iconAddress = '$_svgPath/ic_deliveryAddress.svg';
  static const String iconLogout = '$_svgPath/ic_logOut.svg';
  static const String iconPayment = '$_svgPath/ic_paymentMethod.svg';
  static const String iconPaypal = '$_svgPath/ic_paypal.svg';
  static const String iconGooglePay = '$_svgPath/ic_googlePay.svg';
  static const String iconApplePay = '$_svgPath/ic_applePay.svg';
  static const String iconCreditCard = '$_svgPath/ic_creditCard.svg';
  static const String iconSettings = '$_svgPath/ic_settings.svg';
  static const String iconFAQs = '$_svgPath/ic_FAQs.svg';
  static const String iconContact = '$_svgPath/ic_headphones.svg';
  static const String iconFb = '$_svgPath/ic_facebook.svg';
  static const String iconWhatsApps = '$_svgPath/ic_whatsapp.svg';
  static const String iconWeb = '$_svgPath/ic_global.svg';
  static const String iconInsta = '$_svgPath/ic_instagram.svg';
  static const String iconMap = '$_svgPath/map.svg';
}

class SvgPictureWidget extends StatelessWidget {
  const SvgPictureWidget({
    required this.assetName,
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

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
