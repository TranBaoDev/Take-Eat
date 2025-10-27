part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadHomeData() = LoadHomeData;
  const factory HomeEvent.loadProducts() = LoadProducts;
  const factory HomeEvent.loadProductsByCategory(String category) = LoadProductsByCategory;
}