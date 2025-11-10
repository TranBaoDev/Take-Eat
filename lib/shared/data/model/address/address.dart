import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    String? title,
    required String userId,
    required String fullAddress,
    required bool isSelected,
    required DateTime createdAt,
  }) = _Address;
  const Address._();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
