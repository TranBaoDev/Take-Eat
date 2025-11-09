import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_filter_bloc.dart';

class FilterModal extends StatelessWidget {
  const FilterModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                        'Snacks',
                        'Meal',
                        'Vegan',
                        'Dessert',
                        'Drinks',
                      ]
                      .map((category) => _buildCategoryChip(context, category))
                      .toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildSortByOptions(context),
          const SizedBox(height: 20),
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildPriceRangeSlider(context),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<SearchFilterBloc>().add(ResetFilters());
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SearchFilterBloc>().add(ApplyFilters());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5CB58),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (context, state) {
        final isSelected = state.selectedCategories.contains(category);
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            selected: isSelected,
            label: Text(category),
            onSelected: (bool selected) {
              context.read<SearchFilterBloc>().add(
                FilterCategorySelected(category),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSortByOptions(BuildContext context) {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (context, state) {
        return Column(
          children: [
            RadioListTile<String>(
              title: const Text('Top Rated'),
              value: 'Top Rated',
              groupValue: state.sortBy,
              onChanged: (String? value) {
                if (value != null) {
                  context.read<SearchFilterBloc>().add(
                    FilterSortByChanged(value),
                  );
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: Low to High'),
              value: 'Price: Low to High',
              groupValue: state.sortBy,
              onChanged: (String? value) {
                if (value != null) {
                  context.read<SearchFilterBloc>().add(
                    FilterSortByChanged(value),
                  );
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: High to Low'),
              value: 'Price: High to Low',
              groupValue: state.sortBy,
              onChanged: (String? value) {
                if (value != null) {
                  context.read<SearchFilterBloc>().add(
                    FilterSortByChanged(value),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceRangeSlider(BuildContext context) {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (context, state) {
        return Column(
          children: [
            RangeSlider(
              values: RangeValues(state.minPrice, state.maxPrice),
              min: 0,
              max: 500,
              divisions: 50,
              labels: RangeLabels(
                '\$${state.minPrice.toStringAsFixed(0)}',
                '\$${state.maxPrice.toStringAsFixed(0)}',
              ),
              onChanged: (RangeValues values) {
                context.read<SearchFilterBloc>().add(
                  FilterPriceRangeChanged(
                    minPrice: values.start,
                    maxPrice: values.end,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${state.minPrice.toStringAsFixed(0)}'),
                Text('\$${state.maxPrice.toStringAsFixed(0)}'),
              ],
            ),
          ],
        );
      },
    );
  }
}
