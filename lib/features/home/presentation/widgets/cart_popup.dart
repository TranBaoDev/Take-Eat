import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';

class CartPopup extends StatelessWidget {
  const CartPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    return BlocProvider(
      create: (_) {
        final bloc = CartBloc(CartRepository())
          ..add(CartEvent.loadCart(userId));
        return bloc;
      },
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final items = state.items;
                  if (items.isEmpty) {
                    return _buildEmptyCart(context);
                  }

                  final subtotal = items.fold<double>(
                    0,
                    (sum, i) => sum + (i.price * i.quantity),
                  );
                  final taxAndFees = subtotal * 0.1;
                  const deliveryFee = 5.0;
                  final total = subtotal + taxAndFees + deliveryFee;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SvgPictureWidget(
                            assetName: SvgsAsset.iconCartDrawer,
                            width: 28,
                            height: 28,
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.secPrimary, thickness: 2),
                      const SizedBox(height: 15),

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

                            return Dismissible(
                              key: ValueKey(item.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Remove item'),
                                    content: Text(
                                      'Are you sure you want to remove ${item.name} from the cart?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) {
                                context.read<CartBloc>().add(
                                  CartEvent.removeFromCart(userId, item.id),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item.name} removed from cart',
                                    ),
                                  ),
                                );
                              },
                              child: _buildCartItem(
                                context,
                                item,
                                onIncrease: () {
                                  final newQuantity = item.quantity + 1;
                                  context.read<CartBloc>().add(
                                    CartEvent.updateQuantityLocally(
                                      item.id,
                                      newQuantity,
                                    ),
                                  );
                                },
                                onDecrease: () {
                                  final newQuantity = item.quantity > 1
                                      ? item.quantity - 1
                                      : 1;
                                  context.read<CartBloc>().add(
                                    CartEvent.updateQuantityLocally(
                                      item.id,
                                      newQuantity,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      const Divider(color: Colors.white70, thickness: 1),

                      _buildSummaryRow(
                        'Subtotal',
                        '\$${subtotal.toStringAsFixed(2)}',
                      ),
                      _buildSummaryRow(
                        'Tax and Fees',
                        '\$${taxAndFees.toStringAsFixed(2)}',
                      ),
                      _buildSummaryRow(
                        'Delivery',
                        '\$${deliveryFee.toStringAsFixed(2)}',
                      ),
                      const Divider(color: Colors.white30, thickness: 1),
                      _buildSummaryRow(
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
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
                          onPressed: () {
                            context.read<CartBloc>().add(
                              CartEvent.saveCartChanges(userId),
                            );
                            context.go('/confirmOrder');
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

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
    CartItem item, {
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    final dateFormatted = DateFormat('dd/MM/yy HH:mm').format(item.dateTime);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.image,
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
                _circleButton(Icons.remove, onDecrease),
                const SizedBox(width: 8),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                _circleButton(Icons.add, onIncrease),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, size: 11, color: AppColors.iconColor),
        ),
      ),
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
