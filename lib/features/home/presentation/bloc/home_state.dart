abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final String greeting;

  HomeLoaded({required this.greeting});
}
