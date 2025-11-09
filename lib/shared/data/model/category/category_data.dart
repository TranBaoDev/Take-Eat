import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/category/model/category.dart';

class CategoryData {
  static const List<Category> categories = [
    Category(id: "1", icon: SvgsAsset.iconSnack, title: 'Snacks'),
    Category(id: "2", icon: SvgsAsset.iconMeal, title: 'Meal'),
    Category(id: "3", icon: SvgsAsset.iconVegan, title: 'Vegan'),
    Category(id: "4", icon: SvgsAsset.iconDessert, title: 'Dessert'),
    Category(id: "5", icon: SvgsAsset.iconDrink, title: 'Drinks'),
  ];
}
