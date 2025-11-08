import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:take_eat/features/category/presentation/screens/category_detail.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/shared/data/model/category/category_data.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({required this.onCategorySelected, super.key});
  final Function(String) onCategorySelected;

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int? _selectedIndex;
  void _onCategoryTap(BuildContext context, String categoryTitle, int index) {
    if (_selectedIndex == index) {
      widget.onCategorySelected("");
      setState(() => _selectedIndex = null);
      context.read<HomeBloc>().add(LoadHomeData());
      return;
    }
    setState(() => _selectedIndex = index);
    widget.onCategorySelected(categoryTitle);
    context.read<HomeBloc>().add(LoadProductsByCategory(categoryTitle));
  }

  @override
  Widget build(BuildContext context) {
    const categories = CategoryData.categories;

    return Padding(
      padding: HomeConstant.commonPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;

          return GestureDetector(
            onTap: () => _onCategoryTap(context, category.title, index),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    border: Border.all(
                      color: _selectedIndex == index
                          ? const Color(0xFFE95322)
                          : Colors.transparent,
                      width: 2,
                    ),

                    boxShadow: [
                      if (_selectedIndex == index)
                        BoxShadow(
                          color: const Color(0xFFE95322).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Container(
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
                      height: 62,
                    ),
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
