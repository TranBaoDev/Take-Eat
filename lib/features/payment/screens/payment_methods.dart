import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/shared/widgets/app_btn.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Payment Methods',
      body: Column(
        children: [
          _addMethods(
            onTap: () {
              print("Tapped PayPal");
            },
            assetName: SvgsAsset.iconCreditCard,
            title: 'Cards',
            size: size,
          ),
          _addMethods(
            onTap: () {},
            assetName: SvgsAsset.iconApplePay,
            title: 'Apple Pay',
            size: size,
          ),
          _addMethods(
            onTap: () {},
            assetName: SvgsAsset.iconPaypal,
            title: 'PayPal',
            size: size,
          ),
          _addMethods(
            onTap: () {},
            assetName: SvgsAsset.iconGooglePay,
            title: 'Google Pay',
            size: size,
          ),

          SizedBox(height: size.height * 0.02),
          AppBtnWidget(
            text: 'Add New Card',
            bgColor: bgBtn,
            textColor: primaryColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _addMethods({
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
        child: Column(
          children: [
            Row(
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
            const SizedBox(
              height: 25,
            ),
            Divider(
              color: dividerColor,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
