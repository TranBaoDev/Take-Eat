part of 'notifi_bloc.dart';

@freezed
class NotifiState with _$NotifiState {
  const factory NotifiState.initial() = _Initial;
  const factory NotifiState.loading() = _Loading;
  const factory NotifiState.loaded(List<NotificationItem> items) = _Loaded;
  const factory NotifiState.error(String message) = _Error;
}
