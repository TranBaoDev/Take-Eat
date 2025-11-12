import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/features/product/bloc/product_bloc.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/repositories/product/product_repository.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository = ProductRepository();
  List<Product> _originalProducts = [];
  HomeBloc() : super(const HomeState.loading()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SerachProduct>(_onSearch);
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

  Future<void> _onSearch(SerachProduct event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    debugPrint('🏠 HomeBloc received search query: ${event.query}');
    try {
      final query = event.query.toLowerCase();
      final filltered = _originalProducts
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
      emit(HomeState.productsLoaded(filltered));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> _onFilterPrice(
    FiltersPrice event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    debugPrint(
      '🏠 HomeBloc received filter query: ${event.query}, '
      'min: ${event.minPrice}, max: ${event.maxPrice}, sort: ${event.sortBy}',
    );
    try {
      // Lọc theo tên và khoảng giá
      final filtered = _originalProducts
          .where(
            (p) => p.name.toLowerCase().contains(event.query.toLowerCase()),
          )
          .where((p) => p.price >= event.minPrice && p.price <= event.maxPrice)
          .toList();

      // Sắp xếp theo tiêu chí
      final sorted = _applySort(filtered, event.sortBy);

      emit(HomeState.productsLoaded(sorted));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  List<Product> _applySort(List<Product> products, String sortBy) {
    switch (sortBy) {
      case 'Price: Low to High':
        return products..sort((a, b) => a.price.compareTo(b.price));
      case 'Price: High to Low':
        return products..sort((a, b) => b.price.compareTo(a.price));
      case 'Top Rated':
        return products..sort((a, b) => b.rating.compareTo(a.rating));
      default:
        return products;
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
      _originalProducts = all;
      final category = event.category.toLowerCase();

      // More precise category mapping
      final Map<String, List<String>> categoryKeywords = {
        'snacks': ['snack', 'chips', 'appetizer', 'nacho', 'finger food'],
        'meal': [
          'burger',
          'meal',
          'pasta',
          'risotto',
          'lasagna',
          'skewer',
          'chicken',
          'steak',
          'rice',
        ],
        'vegan': [
          'vegan',
          'salad',
          'broccoli',
          'tofu',
          'vegetarian',
          'plant-based',
        ],
        'dessert': [
          'dessert',
          'cake',
          'pie',
          'ice cream',
          'pudding',
          'sweet',
          'chocolate',
        ],
        'drinks': [
          'drink',
          'juice',
          'coffee',
          'tea',
          'smoothie',
          'milkshake',
          'soda',
        ],
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
