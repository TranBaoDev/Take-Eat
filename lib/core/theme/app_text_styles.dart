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
}
