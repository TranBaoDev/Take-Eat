part of 'address_bloc.dart';

@freezed
abstract class AddressEvent with _$AddressEvent {
  const factory AddressEvent.loadLatestAddress(String userId) =
      _LoadLatestAddress;
  const factory AddressEvent.addAddress({
    required String userId,
    required String fullAddress,
    required bool isSelected,
    String? title,
  }) = _AddAddress;
  const factory AddressEvent.loadAllAddresses(String userId) =
      _LoadAllAddresses;
  const factory AddressEvent.selectAddress({
    required String userId,
    required String addressId,
  }) = _SelectAddress;
}
