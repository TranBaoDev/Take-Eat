import 'package:take_eat/shared/data/model/order/order_summary.dart';

abstract class ConfirmOrderState {}

class ConfirmOrderLoading extends ConfirmOrderState {}

class ConfirmOrderLoaded extends ConfirmOrderState {
  final OrderSummary summary;
  ConfirmOrderLoaded(this.summary);
}
