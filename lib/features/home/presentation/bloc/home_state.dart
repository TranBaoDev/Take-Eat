part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(String greeting) = HomeLoaded;
  const factory HomeState.error(String error) = HomeError;
  const factory HomeState.productsLoaded(List<Product> products) = ProductsLoaded;
}