part of 'search_filter_bloc.dart';

class SearchFilterState extends Equatable {
  final String searchQuery;
  final Set<String> selectedCategories;
  final double minPrice;
  final double maxPrice;
  final String sortBy;
  final bool isFilterApplied;

  const SearchFilterState({
    this.searchQuery = '',
    this.selectedCategories = const {},
    this.minPrice = 0,
    this.maxPrice = 500,
    this.sortBy = 'Top Rated',
    this.isFilterApplied = false,
  });

  SearchFilterState copyWith({
    String? searchQuery,
    Set<String>? selectedCategories,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool? isFilterApplied,
  }) {
    return SearchFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    selectedCategories,
    minPrice,
    maxPrice,
    sortBy,
    isFilterApplied,
  ];
}
