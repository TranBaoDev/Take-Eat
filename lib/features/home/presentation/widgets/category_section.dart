import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:take_eat/features/category/presentation/category_detail.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/shared/data/model/category/category_data.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';

class CategorySection extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategorySection({super.key, required this.onCategorySelected});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? _selectedIndex;

  void _onCategoryTap(BuildContext context, String categoryTitle, int index) {
    setState(() => _selectedIndex = index);
    context.read<HomeBloc>().add(LoadProductsByCategory(categoryTitle));
    widget.onCategorySelected(categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryData.categories;

    return Padding(
      padding: HomeConstant.commonPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedIndex == index;
      
          return GestureDetector(
            onTap: () => _onCategoryTap(context, category.title, index),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF1D9).withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    category.icon,
                    width: 49,
                    height:62
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}