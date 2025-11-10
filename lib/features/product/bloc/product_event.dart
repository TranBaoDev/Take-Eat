// product_event.dart
part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProductEvent extends ProductEvent {
  FetchProductEvent(this.productId);
  final String productId;
}
