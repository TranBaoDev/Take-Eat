import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart'; // hoặc GetX nếu cậu xài GetX

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(AppRoutes.home);
        break;
      case 1:
        // GoRouter.of(context).go(AppRoutes.category);
        break;
      case 2:
        context.go('/favorite');
        break;
      case 3:
        context.go('/order');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFE85C1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          final icons = [
            Icons.home_outlined,
            Icons.restaurant_menu_outlined,
            Icons.favorite_outline,
            Icons.receipt_long_outlined,
          ];

          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: Icon(
              icons[index],
              color: currentIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
              size: 28,
            ),
          );
        }),
      ),
    );
  }
}
