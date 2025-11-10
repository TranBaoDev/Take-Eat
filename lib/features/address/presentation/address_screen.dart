import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({required this.userId, super.key});
  final String userId;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _titleController = TextEditingController();
  final _fullAddressController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _fullAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressBloc>(),
      child: Builder(
        builder: (builderContext) => AppScaffold(
          title: 'Add New Address',
          body: BlocListener<AddressBloc, AddressState>(
            listener: (builderContext, state) {
              state.whenOrNull(
                loaded: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address added successfully')),
                  );

                  // Kiểm tra có thể pop không
                  if (context.canPop()) {
                    context.pop(true);
                  } else {
                    // Nếu không thể pop, navigate về màn hình delivery address
                    GoRouter.of(
                      context,
                    ).go(
                      AppRoutes.deliveryAddress,
                      extra: {'userId': widget.userId},
                    );
                  }
                },
                error: (message) {
                  ScaffoldMessenger.of(
                    builderContext,
                  ).showSnackBar(SnackBar(content: Text('Error: $message')));
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SvgPictureWidget(
                    assetName: SvgsAsset.iconHouse,
                    width: 75,
                    height: 75,
                  ),
                  _buildProfileField(
                    controller: _titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 16),
                  _buildProfileField(
                    controller: _fullAddressController,
                    label: 'Address',
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      final fullAddress = _fullAddressController.text.trim();
                      if (fullAddress.isEmpty) {
                        ScaffoldMessenger.of(builderContext).showSnackBar(
                          const SnackBar(content: Text('Address is required')),
                        );
                        return;
                      }
                      builderContext.read<AddressBloc>().add(
                        AddressEvent.addAddress(
                          userId: widget.userId,
                          fullAddress: fullAddress,
                          title: _titleController.text.trim().isNotEmpty
                              ? _titleController.text.trim()
                              : null,
                          isSelected:
                              false, // Default false, select ở list screen
                        ),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5A3527),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2B2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: keyboardType,
              style: const TextStyle(color: Color(0xFF5A3527), fontSize: 16),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
