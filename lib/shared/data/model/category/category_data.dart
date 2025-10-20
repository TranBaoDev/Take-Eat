import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/shared/data/model/category/category_model.dart';

class CategoryData {
  static const List<CategoryModel> categories = [
    CategoryModel(icon: SvgsAsset.iconSnack, title: 'Snacks'),
    CategoryModel(icon: SvgsAsset.iconMeal, title: 'Meal'),
    CategoryModel(icon: SvgsAsset.iconVegan, title: 'Vegan'),
    CategoryModel(icon: SvgsAsset.iconDessert, title: 'Dessert'),
    CategoryModel(icon: SvgsAsset.iconDrink, title: 'Drinks'),
  ];
}
