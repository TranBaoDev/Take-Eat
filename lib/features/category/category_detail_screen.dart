import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class CategoryDetailScreen extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailScreen({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final List<FoodItem> dummyItems = [
    FoodItem(
      name: 'Mexican Appetizer',
      description: 'Tortilla chips with nachos, guacamole',
      imageUrl: 'assets/images/banner.png',
      price: 15.00,
    ),
    FoodItem(
      name: 'Fresh Prawn Ceviche',
      description: 'Fresh prawns with citrus marinade',
      price: 15.00,
      imageUrl: 'assets/images/banner.png',
    ),
    FoodItem(
      name: 'Mushroom Risotto',
      description: 'Creamy risotto with mushrooms',
      price: 15.00,
      imageUrl: 'assets/images/banner.png',
    ),
    FoodItem(
      name: 'Pork Skewer',
      description: 'Marinated pork with spices',
      price: 14.99,
      imageUrl: 'assets/images/banner.png',
    ),
    FoodItem(
      name: 'Chicken Burger',
      description: 'Grilled chicken with fresh veggies',
      price: 12.99,
      imageUrl: 'assets/images/banner.png',
    ),
    FoodItem(
      name: 'Broccoli Lasagna',
      description: 'Layered pasta with broccoli and cheese',
      price: 12.99,
      imageUrl: 'assets/images/banner.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: dummyItems.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(0, 0, 0)..translate(
              0.0,
              index % 2 == 0 ? -30.0 : 30.0,
              0.0,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        dummyItems[index].imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dummyItems[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dummyItems[index].description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${dummyItems[index].price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
