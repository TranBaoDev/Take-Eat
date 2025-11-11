import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/theme/app_colors.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                color: AppColors.dividerColor,
              ),
            ],
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
