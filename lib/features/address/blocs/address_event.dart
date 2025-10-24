part of 'address_bloc.dart';

@freezed
abstract class AddressEvent with _$AddressEvent {
  const factory AddressEvent.loadLatestAddress(String userId) = _LoadLatestAddress;
  const factory AddressEvent.addAddress({
    required String userId,
    required String fullAddress,
  }) = _AddAddress;
}
