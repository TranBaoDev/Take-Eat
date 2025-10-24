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
}
