import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:take_eat/core/asset/app_svgs.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPictureWidget(
                assetName: SvgsAsset.iconNotifiDrawer,
                width: 28,
                height: 28,
              ),
              SizedBox(width: 20),
              const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    'Your order #1234 is on the way!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    '50% off on desserts today!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildNotifyItem({
  //   required String assetName,
  //   required VoidCallback onTap,
  //   required String title,
  // }) {
  //   return ListTile(
  //     leading: SvgPictureWidget(
  //       assetName: assetName,
  //       width: 24,
  //       height: 24,
  //     ),
  //     title: Text(
  //       title,
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     onTap: onTap,
  //   );
  // }
}
