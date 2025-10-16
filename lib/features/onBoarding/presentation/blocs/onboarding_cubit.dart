import 'package:bloc/bloc.dart';
import 'package:take_eat/features/onBoarding/presentation/blocs/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentIndex: 0));
  void jumpTo(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
