part of 'confirm_order_bloc.dart';

@freezed
abstract class ConfirmOrderState with _$ConfirmOrderState {
  const factory ConfirmOrderState({
    @Default(false) bool loading,
    Order? order,
    String? errorMessage,
  }) = _ConfirmOrderState;
}
