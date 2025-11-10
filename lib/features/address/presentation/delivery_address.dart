import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/address/widgets/add_widget_item.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository_impl.dart';
import 'package:take_eat/shared/widgets/app_btn.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        AddressRepository repository;
        try {
          repository = RepositoryProvider.of<AddressRepository>(context);
        } catch (_) {
          repository = AddressRepositoryImpl();
        }

        return AddressBloc(repository)
          ..add(AddressEvent.loadAllAddresses(userId));
      },
      child: AppScaffold(
        title: 'Delivery Address',
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            return state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (address) =>
                  AddressItemWidget(address: address, onSelected: () {}),
              loadedList: (addresses) => Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return AddressItemWidget(
                          address: addresses[index],
                          onSelected: () {
                            context.read<AddressBloc>().add(
                              AddressEvent.selectAddress(
                                userId: userId,
                                addressId: addresses[index].id,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: AppBtnWidget(
                      text: 'Add New Address',
                      bgColor: bgBtn,
                      textColor: primaryColor,
                      onTap: () {
                        GoRouter.of(context).go(
                          AppRoutes.addAddress,
                          extra: {'userId': userId},
                        );
                      },
                    ),
                  ),
                ],
              ),
              empty: () {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: AppBtnWidget(
                        text: 'Add New Address',
                        bgColor: bgBtn,
                        textColor: primaryColor,
                        onTap: () {
                          GoRouter.of(context).go(
                            AppRoutes.addAddress,
                            extra: {'userId': userId},
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              error: (message) => Center(child: Text('Error: $message')),
            );
          },
        ),
      ),
    );
  }
}
