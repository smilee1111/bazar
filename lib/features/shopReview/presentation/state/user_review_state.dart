import 'package:equatable/equatable.dart';

class UserReviewState extends Equatable {
  final bool isLoading;
  final Set<String> reviewedShopIds;
  final String? errorMessage;

  const UserReviewState({
    this.isLoading = false,
    this.reviewedShopIds = const {},
    this.errorMessage,
  });

  UserReviewState copyWith({
    bool? isLoading,
    Set<String>? reviewedShopIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserReviewState(
      isLoading: isLoading ?? this.isLoading,
      reviewedShopIds: reviewedShopIds ?? this.reviewedShopIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, reviewedShopIds, errorMessage];
}
