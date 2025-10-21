import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';

part 'cart_event.freezed.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addToCart(CartItem item) = _AddToCart;
  const factory CartEvent.removeFromCart(String userId, String itemId) = _RemoveFromCart;
  const factory CartEvent.loadCart(String userId) = _LoadCart;
  const factory CartEvent.clearCart(String userId) = _ClearCart;
  const factory CartEvent.increaseQuantity(String userId, String itemId) = _IncreaseQuantity;
  const factory CartEvent.decreaseQuantity(String userId, String itemId) = _DecreaseQuantity;
}
