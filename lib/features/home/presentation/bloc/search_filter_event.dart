part of 'search_filter_bloc.dart';

abstract class SearchFilterEvent extends Equatable {
  const SearchFilterEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchFilterEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class FilterCategorySelected extends SearchFilterEvent {
  const FilterCategorySelected(this.category);
  final String category;

  @override
  List<Object?> get props => [category];
}

class FilterPriceRangeChanged extends SearchFilterEvent {
  const FilterPriceRangeChanged({
    required this.minPrice,
    required this.maxPrice,
  });
  final double minPrice;
  final double maxPrice;

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

class FilterSortByChanged extends SearchFilterEvent {
  const FilterSortByChanged(this.sortBy);
  final String sortBy;

  @override
  List<Object?> get props => [sortBy];
}

class ApplyFilters extends SearchFilterEvent {}

class ResetFilters extends SearchFilterEvent {}
