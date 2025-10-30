import 'package:flutter/material.dart';

class AppBtnWidget extends StatelessWidget {
  const AppBtnWidget({
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    this.imageTxt,
    super.key,
  });
  final VoidCallback? onTap;
  final String? imageTxt;
  final String text;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.015,
          horizontal: size.width * 0.15,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageTxt != null && imageTxt!.isNotEmpty)
            Image.asset(
              imageTxt!,
              height: size.width * 0.07,
              width: size.width * 0.07,
            ),
          if (imageTxt != null && imageTxt!.isNotEmpty)
            const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
