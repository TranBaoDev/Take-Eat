import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/myOrder/presentation/screens/order_cancelled_screen.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key, required this.cartItem});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
  final CartItem cartItem;
}

final List<String> reasons = [
  'Found a better price',
  'The delivery time is too long',
  'Changed my mind',
  'Ordered by mistake',
  'The item is not needed anymore',
];

String? selectedReason;
final TextEditingController otherController = TextEditingController();

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    return AppScaffold(
      title: 'Cancel Order',
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: HomeConstant.commonPadding.copyWith(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please let us know the reason for canceling your order. '
                  'Your feedback helps us improve.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                const Divider(
                  height: 2,
                  color: AppColors.dividerColor,
                ),

                // List lý do
                ...reasons.map((reason) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedReason = reason;
                            otherController.clear();
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                reason,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Radio<String>(
                              value: reason,
                              groupValue: selectedReason,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value;
                                  otherController.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 4,
                        color: AppColors.dividerColor,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 12),
                const Text('Others', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),

                // TextField lý do khác
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E9B5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: otherController,
                    maxLines: 4,
                    onTap: () {
                      setState(() => selectedReason = 'Others');
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Other reason...',
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Submit
                Center(
                  child: SizedBox(
                    width: 142,
                    child: ElevatedButton(
                      onPressed: () {
                        final result = selectedReason == 'Others'
                            ? otherController.text.trim()
                            : selectedReason;

                        if (result == null || result.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select or enter a reason.',
                              ),
                            ),
                          );
                          return;
                        }
                        context.read<CartBloc>().add(
                          CartEvent.removeFromCart(
                            userId,
                            widget.cartItem.id,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderCancelledScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE95322),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
