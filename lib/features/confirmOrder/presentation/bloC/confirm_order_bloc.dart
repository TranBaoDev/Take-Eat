import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_event.dart';
import 'package:take_eat/features/confirmOrder/presentation/bloC/confirm_order_state.dart';
import 'package:take_eat/shared/data/model/order/order_item.dart';
import 'package:take_eat/shared/data/model/order/order_summary.dart';

class ConfirmOrderBloc extends Bloc<ConfirmOrderEvent, ConfirmOrderState> {
  ConfirmOrderBloc() : super(ConfirmOrderLoading()) {
    on<LoadConfirmOrder>(_onLoad);
    on<IncreaseQuantity>(_onIncrease);
    on<DecreaseQuantity>(_onDecrease);
    on<CancelItem>(_onCancel);
    on<UpdateAddress>(_onUpdateAddress);
  }

  Future<void> _onLoad(
    LoadConfirmOrder event,
    Emitter<ConfirmOrderState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final mockItems = [
      OrderItem(
        id: '1',
        name: 'Strawberry Shake',
        imageUrl:
            'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
        price: 20.00,
        quantity: 2,
        dateTime: DateTime(2025, 11, 29, 15, 20),
      ),
      OrderItem(
        id: '2',
        name: 'Broccoli Lasagna',
        imageUrl:
            'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
        price: 12.99,
        quantity: 1,
        dateTime: DateTime(2025, 11, 29, 12, 00),
      ),
    ];

    emit(
      ConfirmOrderLoaded(
        OrderSummary(items: mockItems, taxAndFees: 5.00, deliveryFee: 3.00),
      ),
    );
  }

  void _onIncrease(IncreaseQuantity event, Emitter<ConfirmOrderState> emit) {
    if (state is ConfirmOrderLoaded) {
      final s = state as ConfirmOrderLoaded;
      final updated = s.summary.items.map((item) {
        return item.id == event.id
            ? item.copyWith(quantity: item.quantity + 1)
            : item;
      }).toList();
      emit(ConfirmOrderLoaded(s.summary.copyWith(items: updated)));
    }
  }

  void _onDecrease(DecreaseQuantity event, Emitter<ConfirmOrderState> emit) {
    if (state is ConfirmOrderLoaded) {
      final s = state as ConfirmOrderLoaded;
      final updated = s.summary.items.map((item) {
        if (item.id == event.id && item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();
      emit(ConfirmOrderLoaded(s.summary.copyWith(items: updated)));
    }
  }

  void _onCancel(CancelItem event, Emitter<ConfirmOrderState> emit) {
    if (state is ConfirmOrderLoaded) {
      final s = state as ConfirmOrderLoaded;
      final updated = s.summary.items
          .where((item) => item.id != event.id)
          .toList();
      emit(ConfirmOrderLoaded(s.summary.copyWith(items: updated)));
    }
  }

  void _onUpdateAddress(UpdateAddress event, Emitter<ConfirmOrderState> emit) {
    if (state is ConfirmOrderLoaded) {
      final s = state as ConfirmOrderLoaded;
      emit(
        ConfirmOrderLoaded(
          s.summary.copyWith(address: event.newAddress),
        ),
      );
    }
  }
}
