import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory_impl.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double total;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.total,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = "COD";
  
  @override
  Widget build(BuildContext context) {
    debugPrint('[PaymentScreen] Building PaymentScreen for orderId: ${widget.orderId} with total: ${widget.total}');
    return BlocProvider(
      create: (_) => ConfirmOrderBloc(OrderRepositoryImpl()),
      child: AppScaffold(
        title: 'Payment',
        body: BlocConsumer<ConfirmOrderBloc, ConfirmOrderState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanh toán thành công!')),
                );
                Navigator.pop(context);
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: $message')),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            // final loading = state.maybeWhen(
            //   loading: () => true,
            //   orElse: () => false,
            // );

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Phương thức thanh toán",
                      style: AppTextStyles.titleAd),
                  const SizedBox(height: 16),
                  _PaymentOption(
                    label: "Thanh toán khi nhận hàng (COD)",
                    selected: _selectedMethod == "COD",
                    onTap: () => setState(() => _selectedMethod = "COD"),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    label: "Thẻ tín dụng / ghi nợ",
                    selected: _selectedMethod == "CARD",
                    onTap: () => setState(() => _selectedMethod = "CARD"),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    label: "Ví Momo",
                    selected: _selectedMethod == "MOMO",
                    onTap: () => setState(() => _selectedMethod = "MOMO"),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Color(0xFFFFD8C7)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng cộng:",
                          style: AppTextStyles.itemTitle),
                      Text(
                        "\$${widget.total.toStringAsFixed(2)}",
                        style: AppTextStyles.itemTitle,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Center(
                  //   child: TextButton(
                  //     onPressed: (){

                  //     },
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         vertical: 14,
                  //         horizontal: 80,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: loading
                  //             ? Colors.grey
                  //             : AppColors.btnColor,
                  //         borderRadius: BorderRadius.circular(50),
                  //       ),
                  //       child: Text(
                  //         loading
                  //             ? "Đang xử lý..."
                  //             : "Xác nhận thanh toán",
                  //         style: AppTextStyles.textBtn,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
        onBack: () => context.pop(widget.orderId)
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.btnColor : Colors.grey,
            width: 1.5,
          ),
          color: selected
              ? const Color(0xFFFFF2EA)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? AppColors.btnColor
                  : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.subText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
