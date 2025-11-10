// product_state.dart

part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded(this.product);
  final Product product;
}

class ProductError extends ProductState {
  ProductError(this.message);
  final String message;
}
