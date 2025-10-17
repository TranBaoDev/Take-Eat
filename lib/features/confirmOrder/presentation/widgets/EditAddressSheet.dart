import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/confirmOrder/confirm_order_constants.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_state.dart';

class EditAddressSheet extends StatefulWidget {
  const EditAddressSheet({super.key});

  @override
  State<EditAddressSheet> createState() => _EditAddressSheetState();
}

class _EditAddressSheetState extends State<EditAddressSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<ConfirmOrderBloc>().state;
    final initialAddress = state is ConfirmOrderLoaded
        ? state.summary.address
        : '';
    _controller = TextEditingController(text: initialAddress);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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

              TextField(
                controller: _controller,
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
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ConfirmOrderConstants.textFieldBorderRadius,
                    ),
                    borderSide: const BorderSide(color: AppColors.btnColor),
                  ),
                ),
              ),

              const SizedBox(height: ConfirmOrderConstants.sectionSpacing),

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
                  onPressed: () {
                    Navigator.pop(context, _controller.text);
                  },
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
    );
  }
}
