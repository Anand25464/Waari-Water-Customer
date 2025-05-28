
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class OnboardingPageState extends Equatable {
  const OnboardingPageState();

  @override
  List<Object> get props => [];
}

class OnboardingPageInitial extends OnboardingPageState {}

class OnboardingPageChanged extends OnboardingPageState {
  final int currentIndex;

  const OnboardingPageChanged(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class OnboardingPageCompleted extends OnboardingPageState {}

// Cubit
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  OnboardingPageCubit() : super(OnboardingPageInitial());

  int _currentIndex = 0;

  void nextPage() {
    _currentIndex++;
    emit(OnboardingPageChanged(_currentIndex));
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _currentIndex--;
      emit(OnboardingPageChanged(_currentIndex));
    }
  }

  void setPage(int index) {
    _currentIndex = index;
    emit(OnboardingPageChanged(_currentIndex));
  }

  void completeOnboarding() {
    emit(OnboardingPageCompleted());
  }

  int get currentIndex => _currentIndex;
}
