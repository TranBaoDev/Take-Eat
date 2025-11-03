import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AppScaffold(
      title: 'Contacts',
      body: Column(
        children: [
          _addHeading(
            assetName: SvgsAsset.iconContact,
            title: 'Customer Service',
            size: size,
            onTap: () {},
          ),
          _addHeading(
            assetName: SvgsAsset.iconWeb,
            title: 'Website',
            size: size,
            onTap: () {},
          ),
          _addHeading(
            assetName: SvgsAsset.iconWhatsApps,
            title: 'WhatsApp',
            size: size,
            onTap: () {},
          ),
          _addHeading(
            assetName: SvgsAsset.iconFb,
            title: 'Facebook',
            size: size,
            onTap: () {},
          ),
          _addHeading(
            assetName: SvgsAsset.iconInsta,
            title: 'Instagram',
            size: size,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _addHeading({
    required String assetName,
    required String title,
    required Size size,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap ?? () {},
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: SvgPictureWidget(
                  assetName: assetName,
                  width: 27,
                  height: 27,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.07),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
