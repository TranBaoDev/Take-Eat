import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/router/router.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        // GoRouter.of(context).go(AppRoutes.category);
        break;
      case 2:
        context.go('/favourite');
        break;
      case 3:
        context.go(AppRoutes.myOrders);
        break;
      case 4:
        context.go('/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFE85C1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final icons = [
            AppAssets.iconHome,
            AppAssets.iconCategory,
            AppAssets.iconFavourite,
            AppAssets.iconMyOrder,
            AppAssets.iconHelp,
          ];

          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: Image.asset(
              icons[index],
              width: 28,
              height: 28,
              color: currentIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
            ),
          );
        }),
      ),
    );
  }
}
