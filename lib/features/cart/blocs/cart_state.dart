import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';

part 'cart_state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool loading,
    String? error,
  }) = _CartState;
}
