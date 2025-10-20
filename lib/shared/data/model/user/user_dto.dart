import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart'; // ✅ Cho JSON serialization (tùy chọn, nếu cần toJson/fromJson)

@freezed
abstract class UserDto with _$UserDto {
  @JsonSerializable(explicitToJson: true)
  const factory UserDto({
    required String uid,
    String? name,
    String? email,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _UserDto;

  // ✅ Factory cho fromJson (nếu cần serialize từ API/Firestore)
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
