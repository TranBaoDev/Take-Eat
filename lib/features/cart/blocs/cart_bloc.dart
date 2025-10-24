import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(const CartState()) {
    on<_AddToCart>(_onAddToCart);
    on<_RemoveFromCart>(_onRemoveFromCart);
    on<_LoadCart>(_onLoadCart);
    on<_ClearCart>(_onClearCart);
    on<_SaveCartChanges>(_onSaveCartChanges);
    on<_UpdateQuantityLocally>(_onUpdateQuantityLocally);
  }

  Future<void> _onAddToCart(_AddToCart e, Emitter<CartState> emit) async {
    try {
      await _repository.addToCart(e.item);
      add(CartEvent.loadCart(e.item.userId));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _onRemoveFromCart(_RemoveFromCart e, Emitter<CartState> emit) async {
    try {
      await _repository.removeFromCart(e.userId, e.itemId);
      add(CartEvent.loadCart(e.userId));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _onLoadCart(_LoadCart e, Emitter<CartState> emit) async {
    debugPrint('[CartBloc] _onLoadCart called for userId: ${e.userId}');
    emit(state.copyWith(loading: true));

    try {
      final cartItems = await _repository.getCartByUserId(e.userId);
      debugPrint('[CartBloc] Loaded ${cartItems.length} items from repository');

      emit(state.copyWith(items: cartItems, loading: false));
      debugPrint('[CartBloc] State updated successfully');
    } catch (err, stack) {
      debugPrint('[CartBloc] Error loading cart: $err');
      debugPrint(stack.toString());
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }


  Future<void> _onClearCart(_ClearCart e, Emitter<CartState> emit) async {
    try {
      await _repository.clearCart(e.userId);
      add(CartEvent.loadCart(e.userId));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _onUpdateQuantityLocally(_UpdateQuantityLocally e, Emitter<CartState> emit) async {
    final updatedItems = state.items.map((item) {
      if (item.id == e.itemId) {
        return item.copyWith(quantity: e.quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  Future<void> _onSaveCartChanges(_SaveCartChanges e, Emitter<CartState> emit) async {
    debugPrint('[CartBloc] _onSaveCartChanges called for userId: ${e.userId}');
    debugPrint('[CartBloc] Items to save: ${state.items.length}');

    try {
      for (final item in state.items) {
        debugPrint(
          '[CartBloc] Saving item: id=${item.id}, name=${item.name}, quantity=${item.quantity}'
        );
        await _repository.addToCart(item);
        debugPrint('[CartBloc] Saved item ${item.id} successfully');
      }
    } catch (err, stack) {
      debugPrint('[CartBloc] Error saving cart: $err');
      debugPrint(stack.toString());
      emit(state.copyWith(error: err.toString()));
    }
  }


}
