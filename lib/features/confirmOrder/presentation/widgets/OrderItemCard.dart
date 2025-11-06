import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';

class OrderItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onCancel;

  const OrderItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onCancel,
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
