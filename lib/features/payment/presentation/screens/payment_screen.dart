import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/payment/data/repository/credit_card_repository.dart';
import 'package:take_eat/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:take_eat/features/payment/screens/payment_success_screen.dart';
import 'package:take_eat/shared/data/model/order/order.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/shared/widgets/shipping_address.dart';

class PaymentScreenWrapper extends StatelessWidget {
  final double total;
  const PaymentScreenWrapper({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConfirmOrderBloc(OrderRepositoryImpl())),
        BlocProvider(create: (_) => CartBloc(CartRepository())),
        BlocProvider(create: (_) => PaymentBloc(CreditCardRepository())),
      ],
      child: PaymentScreen(total: total),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({super.key, required this.total});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfirmOrderBloc>().add(ConfirmOrderEvent.loadOrder(userId));
      context.read<PaymentBloc>().add(LoadUserCardsEvent(userId));
    });
  }

  Future<void> _onConfirmOrderPressed(
    BuildContext context,
    String userId,
    Order order,
    List<OrderItem> items,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang xử lý đơn hàng...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      context.read<ConfirmOrderBloc>().add(
        ConfirmOrderEvent.updateOrder(
          userId: userId,
          orderId: order.id,
          items: items,
          total: order.total,
          address: order.address,
        ),
      );

      context.read<CartBloc>().add(CartEvent.clearCart(userId));
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfirmOrderBloc, ConfirmOrderState>(
      listener: (context, state) async {
        if (!state.loading &&
            state.order?.status != "Pending" &&
            state.order != null) {
          if (Navigator.of(context).canPop()) {
            debugPrint("Closing dialog");
            Navigator.of(context).pop();
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PaymentSuccessScreen(),
            ),
          );
        }

        if (state.errorMessage != null) {
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Lỗi: ${state.errorMessage!}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final order = state.order;
        if (order == null) {
          return const Scaffold(
            body: Center(child: Text("No order found")),
          );
        }

        final items = order.items;

        return AppScaffold(
          title: 'Payment',
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShippingAddressSection(),
                const SizedBox(height: 40),

                _SectionHeader(
                  title: "Order Summary",
                  onEdit: () => context.pop(),
                ),
                const SizedBox(height: 8),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items
                          .map(
                            (item) => Row(
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  '${item.quantity} items',
                                  style: const TextStyle(
                                    color: AppColors.textOrange,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '\$${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32, color: Color(0xFFFFD8C7)),

                _SectionHeader(title: "Payment Method", onEdit: () {}),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.payment,
                          color: AppColors.iconColor,
                          size: 35,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Credit Card",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<PaymentBloc, PaymentState>(
                      builder: (context, state) {
                        if (state is PaymentLoading) {
                          return const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        } else if (state is PaymentLoaded &&
                            state.cards.isNotEmpty) {
                          final card = state.cards.first;
                          final last4 = card.cardNumber.length >= 4
                              ? card.cardNumber.substring(
                                  card.cardNumber.length - 4,
                                )
                              : card.cardNumber;
                          return Text(
                            "**** **** **** $last4",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          );
                        } else if (state is PaymentLoaded &&
                            state.cards.isEmpty) {
                          return const Text(
                            "No saved cards",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          );
                        } else if (state is PaymentError) {
                          return Text(
                            "Error",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[400],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),

                const Divider(height: 32, color: Color(0xFFFFD8C7)),

                const Text("Delivery Time", style: AppTextStyles.titleAd),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Estimated Delivery",
                      style: TextStyle(fontSize: 14, color: AppColors.textDark),
                    ),
                    Text(
                      "25 mins",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textOrange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),

                Center(
                  child: TextButton(
                    onPressed: () =>
                        _onConfirmOrderPressed(context, userId, order, items),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 60,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Pay Now",
                        style: AppTextStyles.textBtn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onBack: () {
            context.read<ConfirmOrderBloc>().add(
              ConfirmOrderEvent.deleteOrder(userId: userId),
            );
            context.pop();
          },
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  const _SectionHeader({required this.title, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleAd),
        if (onEdit != null)
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 58,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: AppColors.btnColor,
              ),
              child: const Text(
                "Edit",
                style: TextStyle(color: AppColors.textOrange, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
