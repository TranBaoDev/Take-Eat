import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';

class EditAddressSheet extends StatefulWidget {
  const EditAddressSheet({super.key});

  @override
  State<EditAddressSheet> createState() => _EditAddressSheetState();
}

class _EditAddressSheetState extends State<EditAddressSheet> {
  late final TextEditingController _controller;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    _controller = TextEditingController(text: 'Loading...');
    context.read<AddressBloc>().add(AddressEvent.loadLatestAddress(_userId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final newAddress = _controller.text.trim();
    if (newAddress.isEmpty) return;

    context.read<AddressBloc>().add(
      AddressEvent.addAddress(
        userId: _userId,
        fullAddress: newAddress,
        isSelected: false,
      ),
    );

    Navigator.pop(context, newAddress);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (address) {
              _controller.text = address.fullAddress;
            },
            empty: () {
              _controller.text =
                  "Bạn chưa có địa chỉ, vui lòng nhập địa chỉ mới.";
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Lỗi tải địa chỉ: $msg")),
              );
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(ConfirmOrderConstants.sheetPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ConfirmOrderConstants.sheetRadius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Shipping Address",
                      style: AppTextStyles.itemTextStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: ConfirmOrderConstants.titleSpacing),

                // --- Text field ---
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return TextField(
                      controller: _controller,
                      enabled: !isLoading,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Shipping Address",
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ConfirmOrderConstants.textFieldBorderRadius,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ConfirmOrderConstants.textFieldBorderRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.btnColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: ConfirmOrderConstants.sectionSpacing),

                // --- Save button ---
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ConfirmOrderConstants.buttonRadius,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: ConfirmOrderConstants.buttonPaddingV,
                        horizontal: ConfirmOrderConstants.buttonPaddingH,
                      ),
                    ),
                    onPressed: _onSavePressed,
                    child: const Text(
                      "Save",
                      style: AppTextStyles.textBtn,
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
