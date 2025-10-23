part of 'cart_bloc.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool loading,
    String? error,
  }) = _CartState;
  
  const CartState._();
}
