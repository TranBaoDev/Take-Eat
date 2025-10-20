import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_event.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_state.dart';
import 'package:take_eat/shared/data/model/order_item.dart';
import 'package:intl/intl.dart';

class CartPopup extends StatelessWidget {
  const CartPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => ConfirmOrderBloc()..add(LoadConfirmOrder()),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: size.width * 0.87,
            height: size.height,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: BlocBuilder<ConfirmOrderBloc, ConfirmOrderState>(
                builder: (context, state) {
                  if (state is ConfirmOrderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (state is ConfirmOrderLoaded) {
                    final summary = state.summary;
                    final items = summary.items;

                    if (items.isEmpty) {
                      return _buildEmptyCart(context);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cart',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white70, thickness: 1),
                        const SizedBox(height: 20),

                        Text(
                          'You have ${items.length} items in the cart',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.white24),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildCartItem(
                                context,
                                item,
                                onIncrease: () => context
                                    .read<ConfirmOrderBloc>()
                                    .add(IncreaseQuantity(item.id)),
                                onDecrease: () => context
                                    .read<ConfirmOrderBloc>()
                                    .add(DecreaseQuantity(item.id)),
                              );
                            },
                          ),
                        ),
                        const Divider(color: Colors.white70, thickness: 1),

                        _buildSummaryRow(
                          'Subtotal',
                          '\$${summary.subtotal.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          'Tax and Fees',
                          '\$${summary.taxAndFees.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          'Delivery',
                          '\$${summary.deliveryFee.toStringAsFixed(2)}',
                        ),
                        const Divider(color: Colors.white30, thickness: 1),
                        _buildSummaryRow(
                          'Total',
                          '\$${summary.total.toStringAsFixed(2)}',
                          isBold: true,
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 14,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    );
                  }

                  return _buildEmptyCart(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------
  // Helper Widgets
  // ------------------------

  Widget _buildEmptyCart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Your cart is empty',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.background, width: 5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 90),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Want To Add\nSomething?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    OrderItem item, {
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    final dateFormatted = DateFormat('dd/MM/yy HH:mm').format(item.dateTime);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dateFormatted,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onDecrease,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        size: 11,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onIncrease,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 11,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
