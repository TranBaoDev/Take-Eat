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

  ConfirmOrderBloc(this.orderRepository) : super(const ConfirmOrderState()) {
    on<_AddOrder>(_onAddOrder);
    on<_LoadOrder>(_onLoadOrder);
    on<_UpdateOrder>(_onUpdateOrder);
    on<_DeleteOrder>(_onDeleteOrder);
    on<_Reset>((event, emit) => emit(const ConfirmOrderState()));
  }

  Future<void> _onAddOrder(
    _AddOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final String id = const Uuid().v4();

    try {
      if (event.items.isEmpty) {
        emit(
          state.copyWith(
            loading: false,
            errorMessage: "Order items cannot be empty",
          ),
        );
        return;
      }

      final newOrder = Order(
        id: id,
        userId: event.userId,
        status: "Pending",
        items: event.items,
        total: event.total,
        address: event.address,
        createdAt: DateTime.now(),
      );

      await orderRepository.addOrder(newOrder);
      emit(state.copyWith(loading: false, order: newOrder));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadOrder(
    _LoadOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final orders = await orderRepository.getOrders(event.userId);

      final latestOrder = orders.isNotEmpty ? orders.first : null;
      emit(state.copyWith(loading: false, order: latestOrder));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateOrder(
    _UpdateOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      var updatedOrder = Order(
        id: event.orderId,
        userId: event.userId,
        status: "Payment",
        items: event.items,
        total: event.total,
        address: event.address,
        createdAt: DateTime.now(),
      );

      await orderRepository.addOrder(updatedOrder);
      emit(state.copyWith(order: updatedOrder, loading: false));

      final nextStatuses = ["Pending", "Ongoing", "Arrived"];

      for (final status in nextStatuses) {
        await Future.delayed(const Duration(seconds: 5));
        updatedOrder = updatedOrder.copyWith(
          status: status,
        );
        print("order by status $status");
        await orderRepository.addOrder(updatedOrder);
        emit(state.copyWith(order: updatedOrder));
      }
    } catch (e, stack) {
      print(stack);
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteOrder(
    _DeleteOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      await orderRepository.deleteOrder(event.userId);
      emit(const ConfirmOrderState(loading: false));
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: "Failed to delete order: $e",
        ),
      );
    }
  }
}
