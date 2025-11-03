import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

@freezed
abstract class UserCreditCardModel with _$UserCreditCardModel {
  const factory UserCreditCardModel({
    required String cardNumber,
    required String cardExpiry,
    required String cardCvv,
    required String nameOnCard,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserCreditCardModel;

  factory UserCreditCardModel.fromJson(Map<String, dynamic> json) =>
      _$UserCreditCardModelFromJson(json);
}
