import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';

class AppActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const AppActionButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 35,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.btnColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textOrange,
            ),
          ),
        ),
      ),
    );
  }
}
