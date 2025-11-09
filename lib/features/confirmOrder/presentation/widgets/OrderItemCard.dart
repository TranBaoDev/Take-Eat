import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/app_action_button.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';

class OrderItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onCancel;
  final VoidCallback? onTrackDriver;
  final bool showTrackDriver;
  final bool showCompleted;
  final VoidCallback? onCompleted;

  const OrderItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onCancel,
    this.onTrackDriver,
    this.showTrackDriver = true,
    this.onCompleted,
    this.showCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ConfirmOrderConstants.imageRadius,
              ),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: ConfirmOrderConstants.imageSize,
                height: ConfirmOrderConstants.imageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: ConfirmOrderConstants.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.itemTitle),
                  Text(
                    "${item.dateTime.day} ${_month(item.dateTime.month)}, "
                    "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')} pm",
                    style: AppTextStyles.subText,
                  ),
                  TextButton(
                    onPressed: onCancel,
                    child: const Text(
                      "Cancel Order",
                      style: TextStyle(color: AppColors.textOrange),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "\$${item.total.toStringAsFixed(2)}",
                  style: AppTextStyles.itemPrice,
                ),
                const SizedBox(height: ConfirmOrderConstants.priceSpacing),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(
                        Icons.remove,
                        size: ConfirmOrderConstants.iconSize,
                      ),
                    ),
                    Text("${item.quantity}"),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(
                        Icons.add,
                        size: ConfirmOrderConstants.iconSize,
                      ),
                    ),
                  ],
                ),
                if (showTrackDriver)
                  AppActionButton(
                    title: "Track Driver",
                    onPressed: onTrackDriver,
                  ),
                if (showCompleted)
                  SizedBox(
                    width: 120,
                    height: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: onCompleted,
                        child: const Text(
                          "Completed",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const Divider(
          height: ConfirmOrderConstants.dividerHeight,
          color: Color(0xFFFFD8C7),
        ),
      ],
    );
  }

  String _month(int m) => ConfirmOrderConstants.months[m - 1];
}
