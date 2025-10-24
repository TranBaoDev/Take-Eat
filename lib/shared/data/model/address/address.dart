import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const Address._();

  const factory Address({
    required String id,
    required String userId,
    required String fullAddress,
    required DateTime createdAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
