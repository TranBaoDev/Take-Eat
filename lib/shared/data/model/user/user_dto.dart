import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  @JsonSerializable(explicitToJson: true)
  const factory UserDto({
    required String uid,
    String? name,
    String? email,
    @JsonKey(name: 'photo_url') String? photoUrl,
    String? phone,
    @JsonKey(name: 'birth_date') String? birthDate,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
