import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/EditAddressSheet.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/OrderItemCard.dart';
import 'package:take_eat/shared/data/model/order/order.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository_impl.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _onPlaceOrder(BuildContext context, String userId) {
      final cartState = context.read<CartBloc>().state;
      final addressState = context.read<AddressBloc>().state;
      if (cartState.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Giỏ hàng trống!")),
        );
        return;
      }
      final address = addressState.maybeWhen(
        loaded: (address) => address.fullAddress,
        orElse: () => null,
      );

      if (address == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng thêm địa chỉ giao hàng.")),
        );
        return;
      }
      final items = cartState.items
          .map(
            (item) => OrderItem(
              name: item.name,
              quantity: item.quantity,
              price: item.price,
            ),
          )
          .toList();
      final subtotal = items.fold<double>(
        0,
        (sum, i) => sum + (i.price * i.quantity),
      );

      final total = subtotal + (subtotal * 0.1) + 5;


      context.read<ConfirmOrderBloc>().add(
        ConfirmOrderEvent.addOrder(
          userId: userId,
          items: items,
          total: total,
          address: address
        ),
      );
      context.read<CartBloc>().add(CartEvent.saveCartChanges(userId));
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final bloc = CartBloc(CartRepository());
            bloc.add(CartEvent.loadCart(userId));
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) => ConfirmOrderBloc(OrderRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) {
            final bloc = AddressBloc(AddressRepositoryImpl());
            bloc.add(AddressEvent.loadLatestAddress(userId));
            return bloc;
          },
        ),

      ],
      child: AppScaffold(
        title: 'Confirm Order',
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = state.items;
            if (items.isEmpty) {
              return Text("Bạn chưa có đơn hàng nào");
            }
            final subtotal = items.fold<double>(
              0,
              (sum, i) => sum + (i.price * i.quantity),
            );
            final taxAndFees = subtotal * 0.1;
            const deliveryFee = 5.0;
            final total = subtotal + taxAndFees + deliveryFee;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(
                ConfirmOrderConstants.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShippingAddressSection(),
                  const SizedBox(height: 24),
                  const Text("Order Summary", style: AppTextStyles.titleAd),
                  const Divider(
                    height: ConfirmOrderConstants.verticalSpacingLarge,
                    color: Color(0xFFFFD8C7),
                  ),
                  ...items.map(
                    (item) => OrderItemCard(
                      item: item,
                      onIncrease: () {
                        final newQuantity = item.quantity + 1;
                        context.read<CartBloc>().add(
                          CartEvent.updateQuantityLocally(item.id, newQuantity),
                        );
                      },
                      onDecrease: () {
                        final newQuantity = item.quantity > 1
                            ? item.quantity - 1
                            : 1;
                        context.read<CartBloc>().add(
                          CartEvent.updateQuantityLocally(item.id, newQuantity),
                        );
                      },
                      onCancel: () => context.read<CartBloc>().add(
                        CartEvent.removeFromCart(userId, item.id),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PriceRow("Subtotal", subtotal),
                  _PriceRow("Tax and Fees", taxAndFees),
                  _PriceRow("Delivery", deliveryFee),
                  const Divider(height: 30, color: Color(0xFFFFD8C7)),
                  _PriceRow("Total", total, bold: true),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () => _onPlaceOrder(context, userId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: ConfirmOrderConstants.buttonVerticalPadding,
                          horizontal:
                              ConfirmOrderConstants.buttonHorizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.btnColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Place Order",
                          style: AppTextStyles.textBtn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
  const _ShippingAddressSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Shipping Address", style: AppTextStyles.titleAddress),
            const SizedBox(width: 6),
            TextButton(
              onPressed: () async {
                final newAddress = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<AddressBloc>(),
                      child: const EditAddressSheet(),
                    );
                  },
                );
              },
              child: const Text(
                "✎",
                style: TextStyle(color: AppColors.iconColor),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E9B5),
            borderRadius: BorderRadius.circular(
              ConfirmOrderConstants.cornerRadius,
            ),
          ),
          child: BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              final textAddress = state.maybeWhen(
                loaded: (address) => address.fullAddress,
                empty: () => "Bạn chưa có địa chỉ, vui lòng nhập địa chỉ mới.",
                error: (msg) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi tải địa chỉ: $msg")),
                    );
                  });
                  return "Không thể tải địa chỉ.";
                },
                orElse: () => "Đang tải địa chỉ...",
              );

              return Text(
                textAddress,
                style: AppTextStyles.subAddress,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _PriceRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold ? AppTextStyles.itemTitle : AppTextStyles.subText,
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: bold ? AppTextStyles.itemTitle : AppTextStyles.subText,
          ),
        ],
      ),
    );
  }
}
