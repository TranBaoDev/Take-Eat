part of 'address_bloc.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState.loading() = _Loading;
  const factory AddressState.loaded(Address address) = _Loaded;
  const factory AddressState.loadedList(List<Address> addresses) = _LoadedList;
  const factory AddressState.empty() = _Empty;
  const factory AddressState.error(String message) = _Error;
}
