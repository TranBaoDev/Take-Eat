import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/notification/model/notification_item.dart';
import 'package:take_eat/features/notification/repository/notify_repository.dart';

part 'notifi_bloc.freezed.dart';
part 'notifi_event.dart';
part 'notifi_state.dart';

class NotifiBloc extends Bloc<NotifiEvent, NotifiState> {
  NotifiBloc(this.repository) : super(const NotifiState.initial()) {
    on<_LoadNotifications>(_onLoad);
    on<_OrderStatusChanged>(_onOrderStatusChanged);
    on<_MarkAsRead>(_onMarkAsRead);
    on<_DeleteNotification>(_onDeleteNotification);
    on<_Reset>(_onReset);
  }
  final NotifyRepository repository;

  Future<void> _onLoad(
    _LoadNotifications event,
    Emitter<NotifiState> emit,
  ) async {
    emit(const NotifiState.loading());
    try {
      final items = await repository.getNotifications(event.userId);
      emit(NotifiState.loaded(items));
    } catch (e) {
      emit(NotifiState.error(e.toString()));
    }
  }

  Future<void> _onOrderStatusChanged(
    _OrderStatusChanged event,
    Emitter<NotifiState> emit,
  ) async {
    final current = state;
    final items = current is _Loaded
        ? List<NotificationItem>.from(current.items)
        : <NotificationItem>[];

    // Create notification item
    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: event.orderId,
      userId: event.userId,
      status: event.status,
      message: _messageForStatus(event.status, event.userId),
      assetName: _assetForStatus(event.status),
      createdAt: DateTime.now(),
      read: false,
    );

    // persist
    try {
      await repository.addNotification(newItem);
      items.insert(0, newItem);
      emit(NotifiState.loaded(items));
    } catch (e) {
      emit(NotifiState.error(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    _MarkAsRead event,
    Emitter<NotifiState> emit,
  ) async {
    final current = state;
    if (current is _Loaded) {
      try {
        await repository.markAsRead(
          current.items.first.userId,
          event.notificationId,
        );
        final items = current.items
            .map(
              (i) => i.id == event.notificationId ? i.copyWith(read: true) : i,
            )
            .toList();
        emit(NotifiState.loaded(items));
      } catch (e) {
        emit(NotifiState.error(e.toString()));
      }
    }
  }

  Future<void> _onDeleteNotification(
    _DeleteNotification event,
    Emitter<NotifiState> emit,
  ) async {
    final current = state;
    if (current is _Loaded) {
      try {
        await repository.deleteNotification(
          current.items.first.userId,
          event.notificationId,
        );
        final items = current.items
            .where((i) => i.id != event.notificationId)
            .toList();
        emit(NotifiState.loaded(items));
      } catch (e) {
        emit(NotifiState.error(e.toString()));
      }
    }
  }

  Future<void> _onReset(_Reset event, Emitter<NotifiState> emit) async {
    emit(const NotifiState.loaded([]));
  }

  String _assetForStatus(String status) {
    final s = status.toLowerCase();
    if (s.contains('pending')) return AppAssets.iconFood;
    if (s.contains('ongoing') ||
        s.contains('on the way') ||
        s.contains('on_going')) {
      return AppAssets.iconDelivery;
    }
    if (s.contains('arrived') || s.contains('delivered')) {
      return AppAssets.iconCart;
    }
    return SvgsAsset.iconNotify;
  }

  String _messageForStatus(String status, String userId) {
    // Use simple English defaults; UI uses l10n when displaying.
    final s = status.toLowerCase();
    switch (s) {
      case _ when s.contains('pending'):
        return 'Your order is pending.';
      case _ when s.contains('ongoing'):
        return 'The delivery is on its way.';
      case _ when s.contains('arrived'):
        return 'Your order has been delivered.';
      default:
        return 'Order status updated.';
    }
    // if (s.contains('pending')) {
    //   return 'Your order is pending.';
    // } else if (s.contains('ongoing')) {
    //   return 'The delivery is on its way.';
    // } else {
    //   return 'Your order has been delivered.';
    // }
  }
}
