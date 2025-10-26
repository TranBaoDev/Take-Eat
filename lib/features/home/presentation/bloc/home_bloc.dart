import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/repositories/product_repository.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository = ProductRepository();
  HomeBloc() : super(const HomeState.loading()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadProducts>(_onLoadProducts);
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
}