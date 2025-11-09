import 'package:flutter/material.dart';
import 'package:take_eat/core/theme/app_colors.dart';

enum OrderStatus { active, completed, cancelled }

class OrderStatusSelector extends StatelessWidget {
  final OrderStatus selected;
  final ValueChanged<OrderStatus> onChanged;

  const OrderStatusSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.textOrange;
    const inactiveColor = AppColors.btnColor;

    Widget buildChip(OrderStatus status, String label) {
      final isSelected = selected == status;

      return GestureDetector(
        onTap: () => onChanged(status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : activeColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildChip(OrderStatus.active, "Active"),
        buildChip(OrderStatus.completed, "Completed"),
        buildChip(OrderStatus.cancelled, "Cancelled"),
      ],
    );
  }
}
