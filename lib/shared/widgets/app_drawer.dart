import 'package:flutter/material.dart';
import 'package:take_eat/features/home/presentation/widgets/cart_popup.dart';
import 'package:take_eat/features/notification/screen/notification_drawer.dart';
import 'package:take_eat/features/profile/screen/profile_drawer.dart';

enum DrawerType { profile, cart, notify }

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({required this.type, super.key});
  final DrawerType type;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case DrawerType.profile:
        content = const ProfileDrawer();
        break;
      case DrawerType.cart:
        content = const CartPopup();
        break;
      case DrawerType.notify:
        content = const NotificationDrawer();
        break;
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFE95322),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(child: content),
    );
  }
}
