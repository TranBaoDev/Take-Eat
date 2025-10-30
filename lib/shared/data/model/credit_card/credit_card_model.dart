import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

@freezed
abstract class CreditCardModel with _$CreditCardModel {
  const factory CreditCardModel({
    required String uid,
    String? name,
    String? email,
    @JsonKey(name: 'photo_url') String? photoUrl,
    String? phone,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'card_number') String? cardNumber,
    @JsonKey(name: 'card_expiry') String? cardExpiry,
    @JsonKey(name: 'card_cvv') String? cardCvv,
  }) = _CreditCardModel;

  factory CreditCardModel.fromJson(Map<String, dynamic> json) =>
      _$CreditCardModelFromJson(json);
}
