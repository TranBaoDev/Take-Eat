import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/shared/app_btn.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(
        height: size.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: size.width * 0.6,
              height: size.height * 0.25,
            ),
            RichText(
              text: TextSpan(
                text: 'Take',
                style: TextStyle(
                  fontSize: size.width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Eat',
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'From favorites to faraway delights, we bring flavors to your door in minutes!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 75),
            AppBtnWidget(
              text: 'Sign in with Google',
              imageTxt: AppAssets.logo, //TODO: Change to svg
              bgColor: Colors.white,
              textColor: primaryColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
