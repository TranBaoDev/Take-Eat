import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';

// A simple detail screen for each category
class CategoryDetailScreen extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        child: Text(
          'Welcome to $categoryTitle Section!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': SvgsAsset.iconSnack, 'title': 'Snacks'},
      {'icon': SvgsAsset.iconMeal, 'title': 'Meal'},
      {'icon': SvgsAsset.iconVegan, 'title': 'Vegan'},
      {'icon': SvgsAsset.iconDessert, 'title': 'Dessert'},
      {'icon': SvgsAsset.iconDrink, 'title': 'Drinks'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((c) {
        return GestureDetector(
          onTap: () {
            // Navigate to the detail screen when the icon is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(
                  categoryTitle: c['title']!,
                ),
              ),
            );
          },
          child: Column(

            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFF1D9),
                child: SvgPictureWidget(assetName: c['icon']!),
              ),
              const SizedBox(height: 6),
              Text(
                c['title']!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}