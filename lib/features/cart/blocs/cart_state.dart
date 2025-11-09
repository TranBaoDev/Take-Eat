part of 'cart_bloc.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    String? userId,
    @Default([]) List<CartItem> items,
    @Default(false) bool loading,
    String? error,
    @Default(OrderStatus.active) OrderStatus filterStatus,
  }) = _CartState;

  const CartState._();
}
