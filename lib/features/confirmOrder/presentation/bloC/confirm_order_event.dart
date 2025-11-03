part of 'confirm_order_bloc.dart';

@freezed
abstract class ConfirmOrderEvent with _$ConfirmOrderEvent {
  const factory ConfirmOrderEvent.loadOrder(String userId) = _LoadOrder;
  const factory ConfirmOrderEvent.addOrder({
    required String userId,
    required List<OrderItem> items,
    required double total,
    required String address,
  }) = _AddOrder;

  const factory ConfirmOrderEvent.updateOrder({
    required String orderId,
    required String userId,
    required List<OrderItem> items,
    required double total,
    required String address,
  }) = _UpdateOrder;
  const factory ConfirmOrderEvent.deleteOrder({
    required String userId,
  }) = _DeleteOrder;
  const factory ConfirmOrderEvent.reset() = _Reset;

}
