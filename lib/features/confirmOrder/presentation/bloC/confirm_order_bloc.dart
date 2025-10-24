import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/order/order.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory.dart';
import 'package:uuid/uuid.dart';

part 'confirm_order_event.dart';
part 'confirm_order_state.dart';
part 'confirm_order_bloc.freezed.dart';

class ConfirmOrderBloc extends Bloc<ConfirmOrderEvent, ConfirmOrderState> {
  final OrderRepository orderRepository;

  ConfirmOrderBloc(this.orderRepository) : super(const ConfirmOrderState.initial()) {
    on<_AddOrder>(_onAddOrder);
    on<_LoadOrder>(_onLoadOrder);
  }

  Future<void> _onAddOrder(
    _AddOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    emit(const ConfirmOrderState.loading());
    try {
      final newOrder = Order(
        id: const Uuid().v4(),
        userId: event.userId,
        status: "Pending",
        items: event.items,
        total: event.total,
        address: event.address,
        createdAt: DateTime.now(),
      );

      await orderRepository.addOrder(newOrder);
      emit(const ConfirmOrderState.success());
    } catch (e) {
      emit(ConfirmOrderState.error(e.toString()));
    }
  }

  Future<void> _onLoadOrder(
    _LoadOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    try {
      emit(const ConfirmOrderState.loading());
      await orderRepository.getOrders(event.userId);
      emit(const ConfirmOrderState.success());
    } catch (e) {
      emit(ConfirmOrderState.error(e.toString()));
    }
  }
}
