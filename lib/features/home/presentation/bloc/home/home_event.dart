part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadHomeData() = LoadHomeData;
  const factory HomeEvent.loadProducts() = LoadProducts;
  const factory HomeEvent.loadProductsByCategory(String category) =
      LoadProductsByCategory;
  const factory HomeEvent.serachProduct(String query) = SerachProduct;
  const factory HomeEvent.filtersPrice(
    String query,
    String sortBy,
    double minPrice,
    double maxPrice,
  ) = FiltersPrice;
}
