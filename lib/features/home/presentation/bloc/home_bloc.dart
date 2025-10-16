import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) {
      final now = DateTime.now();
      final greeting = now.hour < 12 ? 'Good Morning' : 'Good Day';
      emit(HomeLoaded(greeting: greeting));
    });
  }
}
