
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Onboarding Page State
class OnboardingPageState {
  final int currentPageIndex;
  final bool isLastPage;

  const OnboardingPageState({
    this.currentPageIndex = 0,
    this.isLastPage = false,
  });

  OnboardingPageState copyWith({
    int? currentPageIndex,
    bool? isLastPage,
  }) {
    return OnboardingPageState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

// Onboarding Page Controller using Riverpod
class OnboardingPageController extends StateNotifier<OnboardingPageState> {
  OnboardingPageController() : super(const OnboardingPageState());

  static const int totalPages = 3; // Adjust based on your onboarding pages

  void setCurrentPage(int index) {
    state = state.copyWith(
      currentPageIndex: index,
      isLastPage: index == totalPages - 1,
    );
  }

  void nextPage() {
    if (state.currentPageIndex < totalPages - 1) {
      final newIndex = state.currentPageIndex + 1;
      state = state.copyWith(
        currentPageIndex: newIndex,
        isLastPage: newIndex == totalPages - 1,
      );
    }
  }

  void previousPage() {
    if (state.currentPageIndex > 0) {
      final newIndex = state.currentPageIndex - 1;
      state = state.copyWith(
        currentPageIndex: newIndex,
        isLastPage: newIndex == totalPages - 1,
      );
    }
  }

  void skipToEnd() {
    state = state.copyWith(
      currentPageIndex: totalPages - 1,
      isLastPage: true,
    );
  }

  void reset() {
    state = const OnboardingPageState();
  }
}

// Provider for Onboarding Page Controller
final onboardingPageControllerProvider = StateNotifierProvider<OnboardingPageController, OnboardingPageState>((ref) {
  return OnboardingPageController();
});
