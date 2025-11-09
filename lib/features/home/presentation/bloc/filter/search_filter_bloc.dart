import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_filter_event.dart';
part 'search_filter_state.dart';

class SearchFilterBloc extends Bloc<SearchFilterEvent, SearchFilterState> {
  SearchFilterBloc() : super(const SearchFilterState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterCategorySelected>(_onFilterCategorySelected);
    on<FilterPriceRangeChanged>(_onFilterPriceRangeChanged);
    on<FilterSortByChanged>(_onFilterSortByChanged);
    on<ApplyFilters>(_onApplyFilters);
    on<ResetFilters>(_onResetFilters);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilterCategorySelected(
    FilterCategorySelected event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategories: {...state.selectedCategories, event.category},
      ),
    );
  }

  void _onFilterPriceRangeChanged(
    FilterPriceRangeChanged event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(
      state.copyWith(
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      ),
    );
  }

  void _onFilterSortByChanged(
    FilterSortByChanged event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(state.copyWith(sortBy: event.sortBy));
  }

  void _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(state.copyWith(isFilterApplied: true));
  }

  void _onResetFilters(
    ResetFilters event,
    Emitter<SearchFilterState> emit,
  ) {
    emit(const SearchFilterState());
  }
}
