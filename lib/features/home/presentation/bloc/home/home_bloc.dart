import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/repositories/product/product_repository.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository = ProductRepository();
  HomeBloc() : super(const HomeState.loading()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Compute greeting based on current time
      final now = DateTime.now();
      String greeting;
      if (now.hour < 12) {
        greeting = 'Good Morning';
      } else if (now.hour < 18) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }

      emit(HomeState.loaded(greeting));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    try {
      // Fetch products from repository
      final products = await repository.fetchAllProducts();
      emit(HomeState.productsLoaded(products));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    try {
      final all = await repository.fetchAllProducts();
      final category = event.category.toLowerCase();

      // Basic keyword based filtering when product model doesn't include category
      final Map<String, List<String>> categoryKeywords = {
        'snacks': ['snack', 'chips', 'appetizer', 'nacho'],
        'meal': ['burger', 'meal', 'pasta', 'risotto', 'lasagna', 'skewer', 'chicken'],
        'vegan': ['vegan', 'salad', 'broccoli', 'tofu'],
        'dessert': ['dessert', 'cake', 'pie', 'ice', 'pudding', 'sweet'],
        'drinks': ['drink', 'juice', 'coffee', 'tea', 'smoothie'],
      };

      final keywords = categoryKeywords[category] ?? [category];

      final filtered = all.where((p) {
        final name = p.name.toLowerCase();
        return keywords.any((k) => name.contains(k));
      }).toList();

      emit(HomeState.productsLoaded(filtered));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }
}