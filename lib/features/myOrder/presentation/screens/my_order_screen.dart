import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/OrderItemCard.dart';
import 'package:take_eat/features/myOrder/presentation/screens/cancel_order_screen.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';
import 'package:take_eat/features/payment/screens/delivery_time_screen.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
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
      ],
      child: AppScaffold(
        title: 'My Orders',
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = state.items;
            if (items.isEmpty) {
              return Center(
                child: Image.asset(
                  AppAssets.myOrderEmptyImage,
                  fit: BoxFit.cover,
                  scale: 2.0,
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(
                ConfirmOrderConstants.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderStatusSelector(
                    selected: state.filterStatus,
                    onChanged: (newStatus) {
                      context.read<CartBloc>().add(
                        CartEvent.changeFilterStatus(newStatus),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
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
                      onCancel: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<CartBloc>(),
                              child: CancelOrderScreen(cartItem: item),
                            ),
                          ),
                        );
                      },
                      onTrackDriver: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DeliveryTimeScreen(),
                          ),
                        );
                      },
                      showCompleted: item.orderStatus == OrderStatus.completed,
                      onCompleted: () {
                        final bloc = context.read<CartBloc>()
                          // 1) Cập nhật trạng thái
                          ..add(
                            CartEvent.updateStatus(
                              item.id,
                              OrderStatus.completed,
                            ),
                          )
                          // 2) Thay đổi tab sang Completed để list filter lại ngay
                          ..add(
                            const CartEvent.changeFilterStatus(
                              OrderStatus.completed,
                            ),
                          );
                      },
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
}
