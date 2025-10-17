import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // hoặc GetX nếu cậu xài GetX

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/menu');
        break;
      case 2:
        context.go('/favorite');
        break;
      case 3:
        context.go('/order');
        break;
      case 4:
        context.go('/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE85C1F),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final icons = [
            Icons.home_outlined,
            Icons.restaurant_menu_outlined,
            Icons.favorite_outline,
            Icons.receipt_long_outlined,
            Icons.headphones_outlined,
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
