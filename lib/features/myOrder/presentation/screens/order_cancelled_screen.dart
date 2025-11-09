import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';

class OrderCancelledScreen extends StatefulWidget {
  const OrderCancelledScreen({super.key});

  @override
  State<OrderCancelledScreen> createState() => _OrderCancelledScreenState();
}

class _OrderCancelledScreenState extends State<OrderCancelledScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "",
      hasDecoration: false,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAssets.orderCancelledImage,
                    width: 140,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Order Cancelled!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your order has been successfully\ncancelled",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              child: Text(
                "If you have any question reach directly to our\ncustomer support",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
