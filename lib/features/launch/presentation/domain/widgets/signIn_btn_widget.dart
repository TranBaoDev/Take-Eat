import 'package:flutter/material.dart';

class SigninBtnWidget extends StatelessWidget {
  const SigninBtnWidget({
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    required this.imageTxt,
    super.key,
  });
  final VoidCallback? onTap;
  final String imageTxt;
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
          horizontal: size.width * 0.5,
        ),
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage(imageTxt),
            height: size.width * 0.05,
            width: size.width * 0.05,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
