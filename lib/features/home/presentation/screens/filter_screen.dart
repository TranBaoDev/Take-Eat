import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/category/presentation/widgets/category_section.dart';
import 'package:take_eat/features/home/presentation/bloc/search_filter_bloc.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCategory;
  void _onCategorySelected(String category) {
    setState(() {
      setState(() => selectedCategory = category.isEmpty ? null : category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Filter',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CategorySection(
                      onCategorySelected: _onCategorySelected,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSortBySection(),
                    const SizedBox(height: 24),
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPriceRangeSlider(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildSortByOption(
              context,
              icon: '⭐',
              title: 'Top Rated',
              value: 'Top Rated',
              state: state,
            ),
            _buildSortByOption(
              context,
              icon: '💰',
              title: 'Price: Low to High',
              value: 'Price: Low to High',
              state: state,
            ),
            _buildSortByOption(
              context,
              icon: '💎',
              title: 'Price: High to Low',
              value: 'Price: High to Low',
              state: state,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortByOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required SearchFilterState state,
  }) {
    final isSelected = state.sortBy == value;

    return GestureDetector(
      onTap: () {
        context.read<SearchFilterBloc>().add(FilterSortByChanged(value));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5CB58) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFF5CB58) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (context, state) {
        return Column(
          children: [
            RangeSlider(
              values: RangeValues(state.minPrice, state.maxPrice),
              min: 0,
              max: 500,
              divisions: 50,
              activeColor: const Color(0xFFF5CB58),
              inactiveColor: Colors.grey[300],
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
                Text(
                  '\$${state.minPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${state.maxPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<SearchFilterBloc>().add(ResetFilters());
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFF5CB58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
