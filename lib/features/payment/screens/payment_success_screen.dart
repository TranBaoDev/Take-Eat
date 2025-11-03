import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/home/presentation/screens/home_screen.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "",
      hasDecoration: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                'assets/animations/cartsuccess.json',
                width: 180,
                repeat: false,
              ),

              const SizedBox(height: 24),
              const Text(
                "Thanh toán thành công!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),
              const Text(
                "Cảm ơn bạn đã đặt hàng.\nĐơn hàng của bạn đang được xử lý.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Return home",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: AppColors.textOrange),
                ),
              ),
              SizedBox(height: 120),
              Text("If you have any questions, please reach out directly to our customer support",style: TextStyle(
                color: AppColors.textDark
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
