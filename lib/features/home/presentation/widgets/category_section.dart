import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/shared/data/model/category/category_data.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCategoryTap(BuildContext context, String categoryTitle, int index) {
    setState(() => _selectedIndex = index);
    _controller.forward().then((_) {
      _controller.reverse();
      context.read<HomeBloc>().add(LoadProductsByCategory(categoryTitle));
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryData.categories;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () => _onCategoryTap(context, category.title, index),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final bounce = isSelected
                  ? Curves.easeInOut.transform(_controller.value) * 1.2
                  : 1.0;

              return Transform.scale(
                scale: bounce,
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween<double>(
                        begin: isSelected ? 1.0 : 0.0,
                        end: isSelected ? 0.0 : 1.0,
                      ),
                      builder: (context, value, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFF1D9).withOpacity(0.5),
                                blurRadius: 20 * value,
                                spreadRadius: 5 * value,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFFFFF1D9),
                            child: SvgPicture.asset(
                              category.icon,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}