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
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onCancel;
  final VoidCallback? onLeaveReview;
  final VoidCallback? onTrackDriver;
  final VoidCallback? onOrderAgain;
  final bool showTrackDriver;
  final bool showQuantityControls;

  const OrderItemCard({
    super.key,
    required this.item,
    this.onIncrease,
    this.onDecrease,
    this.onCancel,
    this.onLeaveReview,
    this.onTrackDriver,
    this.showTrackDriver = true,
    this.onOrderAgain,
    this.showQuantityControls = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.orderStatus == OrderStatus.completed;
    final isCancelled = item.orderStatus == OrderStatus.cancelled;
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
                  Text(
                    item.name,
                    style: AppTextStyles.itemTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  Text(
                    "${item.dateTime.day} ${_month(item.dateTime.month)}, "
                    "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')} pm",
                    style: AppTextStyles.subText,
                  ),
                  const SizedBox(height: 15),
                  if (isCancelled)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Order cancelled",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isCompleted)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Order delivered",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColors.btnColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: AppColors.textOrange,
                            ),
                            onPressed: onLeaveReview,
                            child: const Center(
                              child: Text(
                                "Leave a Review",
                                style: TextStyle(
                                  color: AppColors.textOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: AppColors.textOrange,
                        ),
                        onPressed: onCancel,
                        child: const Center(
                          child: Text(
                            "Cancel Order",
                            style: TextStyle(
                              color: AppColors.textOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                Text(
                  "${item.quantity} items",
                  style: AppTextStyles.itemTextStyle,
                ),
                const SizedBox(height: ConfirmOrderConstants.priceSpacing),
                if (showQuantityControls &&
                    (onIncrease != null || onDecrease != null))
                  Row(
                    children: [
                      if (onDecrease != null)
                        IconButton(
                          onPressed: onDecrease,
                          icon: const Icon(
                            Icons.remove,
                            size: ConfirmOrderConstants.iconSize,
                          ),
                        ),
                      Text(
                        "${item.quantity}",
                        style: AppTextStyles.itemTextStyle,
                      ),
                      if (onIncrease != null)
                        IconButton(
                          onPressed: onIncrease,
                          icon: const Icon(
                            Icons.add,
                            size: ConfirmOrderConstants.iconSize,
                          ),
                        ),
                    ],
                  ),
                if (!isCancelled && !isCompleted && showTrackDriver && onTrackDriver != null)
                  AppActionButton(
                    title: "Track Driver",
                    onPressed: onTrackDriver,
                  ),
                if (isCompleted && onOrderAgain != null)
                  AppActionButton(
                    title: "Order Again",
                    onPressed: onOrderAgain,
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