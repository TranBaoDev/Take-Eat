import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/EditAddressSheet.dart';

class ShippingAddressSection extends StatelessWidget {
  final bool isEdit;
  const ShippingAddressSection({super.key, this.isEdit = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Shipping Address",
              style: AppTextStyles.titleAddress,
            ),
            const SizedBox(width: 6),
            if (isEdit)
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.iconColor,size: 17,),
                onPressed: () async {
                  final selectedAddress = await showModalBottomSheet<String>(
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
          child: BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              state.maybeWhen(
                error: (msg) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi tải địa chỉ: $msg")),
                  );
                },
                orElse: () {},
              );
            },
            child: BlocBuilder<AddressBloc, AddressState>(
              builder: (context, state) {
                final textAddress = state.maybeWhen(
                  loaded: (address) => address.fullAddress,
                  loadedList: (addresses) {
                    final selected = addresses.firstWhere(
                      (addr) => addr.isSelected,
                      orElse: () => addresses.first,
                    );
                    return selected.fullAddress;
                  },
                  empty: () =>
                      "Bạn chưa có địa chỉ, vui lòng chọn địa chỉ.",
                  loading: () => "Đang tải địa chỉ...",
                  orElse: () => "Đang tải...",
                );

                return Text(
                  textAddress,
                  style: AppTextStyles.subAddress,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
