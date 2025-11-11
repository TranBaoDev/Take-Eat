part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addToCart(CartItem item) = _AddToCart;
  const factory CartEvent.removeFromCart(String userId, String itemId) =
      _RemoveFromCart;
  const factory CartEvent.loadCart(String userId) = _LoadCart;
  const factory CartEvent.clearCart(String userId) = _ClearCart;
  const factory CartEvent.updateQuantityLocally(String itemId, int quantity) =
      _UpdateQuantityLocally;
  const factory CartEvent.saveCartChanges(String userId) = _SaveCartChanges;
  const factory CartEvent.changeFilterStatus(
    OrderStatus status,
    String userId,
  ) = _ChangeFilterStatus;
  const factory CartEvent.updateStatus(String itemId, OrderStatus status) =
      _UpdateStatus;
}
