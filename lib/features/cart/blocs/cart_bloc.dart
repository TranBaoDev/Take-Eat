import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/cart/blocs/cart_event.dart';
import 'package:take_eat/features/cart/blocs/cart_state.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/repositories/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(const CartState()) {
    on<CartEvent>(_onCartEvent);
  }

  Future<void> _onCartEvent(CartEvent event, Emitter<CartState> emit) async {
    await event.map(
      addToCart: (e) async {
        try {
          await _repository.addToCart(e.item);
          add(CartEvent.loadCart(e.item.userId));
        } catch (err) {
          emit(state.copyWith(error: err.toString()));
        }
      },
      removeFromCart: (e) async {
        try {
          await _repository.removeFromCart(e.userId, e.itemId);
          add(CartEvent.loadCart(e.userId));
        } catch (err) {
          emit(state.copyWith(error: err.toString()));
        }
      },
      loadCart: (e) async {
        emit(state.copyWith(loading: true));
        try {
          final cartItems = await _repository.getCartByUserId(e.userId);
          emit(state.copyWith(items: cartItems, loading: false));
        } catch (err) {
          emit(state.copyWith(loading: false, error: err.toString()));
        }
      },
      clearCart: (e) async {
        try {
          await _repository.clearCart(e.userId);
          add(CartEvent.loadCart(e.userId));
        } catch (err) {
          emit(state.copyWith(error: err.toString()));
        }
      },
      increaseQuantity: (e) async {
        final item = state.items.firstWhere((i) => i.id == e.itemId);
        await _repository.addToCart(item.copyWith(quantity: item.quantity + 1));
        add(CartEvent.loadCart(e.userId));
      },
      decreaseQuantity: (e) async {
        final item = state.items.firstWhere((i) => i.id == e.itemId);
        if (item.quantity > 1) {
          await _repository.addToCart(item.copyWith(quantity: item.quantity - 1));
        } else {
          await _repository.removeFromCart(e.userId, e.itemId);
        }
        add(CartEvent.loadCart(e.userId));
      },
    );
  }
}
