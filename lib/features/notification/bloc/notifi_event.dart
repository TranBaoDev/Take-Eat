part of 'notifi_bloc.dart';

@freezed
abstract class NotifiEvent with _$NotifiEvent {
  const factory NotifiEvent.loadNotifications(String userId) =
      _LoadNotifications;
  const factory NotifiEvent.markAsRead(String notificationId) = _MarkAsRead;
  const factory NotifiEvent.deleteNotification(String notificationId) =
      _DeleteNotification;
  const factory NotifiEvent.reset() = _Reset;

  // Create a notification from an Order when its status changes
  const factory NotifiEvent.orderStatusChanged(
    String orderId,
    String userId,
    String status,
  ) = _OrderStatusChanged;
}
