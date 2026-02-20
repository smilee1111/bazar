import 'package:bazar/features/shopReview/domain/usecases/get_user_reviews_usecase.dart';
import 'package:bazar/features/shopReview/presentation/state/user_review_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userReviewViewModelProvider =
    NotifierProvider<UserReviewViewModel, UserReviewState>(
      UserReviewViewModel.new,
    );

class UserReviewViewModel extends Notifier<UserReviewState> {
  late final GetUserReviewsUsecase _getUserReviewsUsecase;

  @override
  UserReviewState build() {
    _getUserReviewsUsecase = ref.read(getUserReviewsUsecaseProvider);
    return const UserReviewState();
  }

  Future<void> loadReviewedShops({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (!forceRefresh && state.reviewedShopIds.isNotEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getUserReviewsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (reviews) {
        final reviewedShopIds = reviews
            .map((item) => item.shopId.trim())
            .where((shopId) => shopId.isNotEmpty)
            .toSet();
        state = state.copyWith(
          isLoading: false,
          reviewedShopIds: reviewedShopIds,
          clearError: true,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void markReviewedShop(String shopId) {
    final normalized = shopId.trim();
    if (normalized.isEmpty) return;
    final reviewedShopIds = {...state.reviewedShopIds, normalized};
    state = state.copyWith(reviewedShopIds: reviewedShopIds, clearError: true);
  }
}
