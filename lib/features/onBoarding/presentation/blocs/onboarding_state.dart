import 'package:flutter/material.dart';

@immutable
class OnboardingState {
  const OnboardingState({required this.currentIndex});
  final int currentIndex;
  OnboardingState copyWith({int? currentIndex}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
