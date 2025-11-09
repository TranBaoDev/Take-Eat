import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textGray,
    height: 1.5,
  );

  static const TextStyle skip = TextStyle(
    fontSize: 15,
    color: AppColors.textOrange,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle itemTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF5B2E0D),
  );

  static const TextStyle titleAddress = TextStyle(
    color: Color(0XFF391713),
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    fontSize: 24,
  );
  static const TextStyle subAddress = TextStyle(
    color: Color(0XFF391713),
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static const TextStyle titleAd = TextStyle(
    color: Color(0XFF391713),
    fontWeight: FontWeight.w500,
    fontSize: 18,
    fontStyle: FontStyle.normal,
  );
  static const TextStyle itemTitle = TextStyle(
    color: Color(0XFF391713),
    fontWeight: FontWeight.w500,
    fontSize: 18,
    fontStyle: FontStyle.normal,
  );
  static const TextStyle subText = TextStyle(
    color: Color(0XFF391713),
    fontWeight: FontWeight.w300,
    fontSize: 14,
    fontStyle: FontStyle.normal,
  );
  static const TextStyle itemPrice = TextStyle(
    color: AppColors.textOrange,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle textBtn = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textOrange,
  );

  static const TextStyle nameProduct = TextStyle(
    color: Color(0xFF391713),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle textDes = TextStyle(
    color: Color(0xFF391713),
    fontFamily: 'League Spartan',
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
  static const TextStyle priceProduct = TextStyle(
    color: Color(0xFFE95322),
    fontFamily: 'League Spartan',
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );
}
