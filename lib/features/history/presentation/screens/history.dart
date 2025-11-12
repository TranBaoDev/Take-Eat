import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/screens/confirmOrder_Screen.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/OrderItemCard.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';

class HistoryScreen extends StatefulWidget {
  final CartItem? item;
  const HistoryScreen({super.key, this.item});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    if (widget.item != null) {
      final item = widget.item!;
      return AppScaffold(
        title: 'History',
        body: Padding(
          padding: const EdgeInsets.all(ConfirmOrderConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: ConfirmOrderConstants.verticalSpacingLarge,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No. ${shortId(item.id?.toString())}",
                        style: AppTextStyles.itemTitle,
                      ),

                      Text(
                        "\$${item.total.toStringAsFixed(2)}",
                        style: AppTextStyles.itemPrice,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item.dateTime.day} ${_month(item.dateTime.month)}, "
                        "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')} pm",
                        style: AppTextStyles.subText,
                      ),
                      Text(
                        "${item.quantity} items",
                        style: AppTextStyles.itemTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.iconCheck,
                        width: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Order delivered",
                        style: TextStyle(
                          color: AppColors.textOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ConfirmOrderScreen(item: item),
                                ),
                              );
                            
                      }, // Navigate to order details
                      child: const Text(
                        "Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: ConfirmOrderConstants.dividerHeight,
                color: Color(0xFFFFD8C7),
              ),
            ],
          ),
        ),
      );
    }

    
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
      ],
      child: AppScaffold(
        title: 'History',
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = state.items
                .where((i) => i.orderStatus == OrderStatus.completed)
                .toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(
                ConfirmOrderConstants.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: ConfirmOrderConstants.verticalSpacingLarge,
                    color: Color(0xFFFFD8C7),
                  ),
                  ...items.map(
                    (item) => OrderItemCard(
                      item: item,
                      showQuantityControls: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _month(int m) => ConfirmOrderConstants.months[m - 1];

  String shortId(String? id) {
    if (id == null || id.isEmpty) return '000000';
    final cleaned = id.replaceAll(RegExp(r'[^0-9]'), ''); // chỉ giữ số
    if (cleaned.length < 7) {
      return cleaned.padLeft(7, '0');
    }
    return cleaned.substring(cleaned.length - 7);
  }
}
