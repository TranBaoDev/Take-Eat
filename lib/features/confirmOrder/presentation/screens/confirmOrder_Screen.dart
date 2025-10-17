import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_event.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_state.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/EditAddressSheet.dart';
import 'package:take_eat/features/confirmOrder/presentation/widgets/OrderItemCard.dart';
import 'package:take_eat/features/setting/settings_constants.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfirmOrderBloc()..add(LoadConfirmOrder()),
      child: Scaffold(
        backgroundColor: AppColors.headerColor,
        body: Column(
          children: [
            _Header(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: SettingsConstants.backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(SettingsConstants.cornerRadius),
                  ),
                ),
                child: BlocBuilder<ConfirmOrderBloc, ConfirmOrderState>(
                  builder: (context, state) {
                    if (state is ConfirmOrderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ConfirmOrderLoaded) {
                      final summary = state.summary;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(
                          ConfirmOrderConstants.screenPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ShippingAddressSection(),
                            const SizedBox(height: 24),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Summary",
                                  style: AppTextStyles.titleAd,
                                ),
                              ],
                            ),
                            const Divider(
                              height:
                                  ConfirmOrderConstants.verticalSpacingLarge,
                              color: Color(0xFFFFD8C7),
                            ),
                            ...summary.items.map(
                              (item) => OrderItemCard(
                                item: item,
                                onIncrease: () => context
                                    .read<ConfirmOrderBloc>()
                                    .add(IncreaseQuantity(item.id)),
                                onDecrease: () => context
                                    .read<ConfirmOrderBloc>()
                                    .add(DecreaseQuantity(item.id)),
                                onCancel: () => context
                                    .read<ConfirmOrderBloc>()
                                    .add(CancelItem(item.id)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _PriceRow("Subtotal", summary.subtotal),
                            _PriceRow("Tax and Fees", summary.taxAndFees),
                            _PriceRow("Delivery", summary.deliveryFee),
                            const Divider(height: 30, color: Color(0xFFFFD8C7)),
                            _PriceRow("Total", summary.total, bold: true),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: ConfirmOrderConstants
                                        .buttonVerticalPadding,
                                    horizontal: ConfirmOrderConstants
                                        .buttonHorizontalPadding,
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
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SettingsConstants.headerHeight,
      padding: const EdgeInsets.only(
        top: ConfirmOrderConstants.headerTopPadding,
        bottom: ConfirmOrderConstants.headerBottomPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text('Confirm Order', style: AppTextStyles.titleStyle),
          Positioned(
            left: ConfirmOrderConstants.backButtonLeftPadding,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.iconColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
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
                      value: context.read<ConfirmOrderBloc>(),
                      child: const EditAddressSheet(),
                    );
                  },
                );
                if (newAddress != null && newAddress.isNotEmpty) {
                  context.read<ConfirmOrderBloc>().add(
                    UpdateAddress(newAddress),
                  );
                }
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
          child: BlocBuilder<ConfirmOrderBloc, ConfirmOrderState>(
            builder: (context, state) {
              final address = (state is ConfirmOrderLoaded)
                  ? state.summary.address
                  : "Loading...";
              return Text(address, style: AppTextStyles.subAddress);
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
