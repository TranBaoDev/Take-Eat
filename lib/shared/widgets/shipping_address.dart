import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/EditAddressSheet.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection();

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