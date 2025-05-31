
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Onboarding Page State
class OnboardingPageState {
  final int currentPage;
  final bool isCompleted;

  const OnboardingPageState({
    this.currentPage = 0,
    this.isCompleted = false,
  });

  OnboardingPageState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnboardingPageState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Onboarding Page Controller using Riverpod
class OnboardingPageController extends StateNotifier<OnboardingPageState> {
  OnboardingPageController() : super(const OnboardingPageState());

  void nextPage() {
    if (state.currentPage < 2) { // Assuming 3 onboarding pages (0, 1, 2)
      state = state.copyWith(currentPage: state.currentPage + 1);
    } else {
      state = state.copyWith(isCompleted: true);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void goToPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void completeOnboarding() {
    state = state.copyWith(isCompleted: true);
  }

  void reset() {
    state = const OnboardingPageState();
  }
}

// Provider for Onboarding Page Controller
final onboardingPageControllerProvider = StateNotifierProvider<OnboardingPageController, OnboardingPageState>((ref) {
  return OnboardingPageController();
});
