import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:equatable/equatable.dart';

class ShopContentState extends Equatable {
  final String? shopId;
  final bool isLoading;
  final bool isSavingDetail;
  final bool isUploadingPhoto;
  final bool isSubmittingReview;
  final bool isUpdatingReview;
  final ShopDetailEntity? detail;
  final List<ShopPhotoEntity> photos;
  final List<ShopReviewEntity> reviews;
  final Set<String> likedReviewIds;
  final Set<String> dislikedReviewIds;
  final Set<String> reactingReviewIds;
  final String? errorMessage;

  const ShopContentState({
    this.shopId,
    this.isLoading = false,
    this.isSavingDetail = false,
    this.isUploadingPhoto = false,
    this.isSubmittingReview = false,
    this.isUpdatingReview = false,
    this.detail,
    this.photos = const [],
    this.reviews = const [],
    this.likedReviewIds = const {},
    this.dislikedReviewIds = const {},
    this.reactingReviewIds = const {},
    this.errorMessage,
  });

  ShopContentState copyWith({
    String? shopId,
    bool? isLoading,
    bool? isSavingDetail,
    bool? isUploadingPhoto,
    bool? isSubmittingReview,
    bool? isUpdatingReview,
    ShopDetailEntity? detail,
    bool clearDetail = false,
    List<ShopPhotoEntity>? photos,
    List<ShopReviewEntity>? reviews,
    Set<String>? likedReviewIds,
    Set<String>? dislikedReviewIds,
    Set<String>? reactingReviewIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ShopContentState(
      shopId: shopId ?? this.shopId,
      isLoading: isLoading ?? this.isLoading,
      isSavingDetail: isSavingDetail ?? this.isSavingDetail,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
      isUpdatingReview: isUpdatingReview ?? this.isUpdatingReview,
      detail: clearDetail ? null : (detail ?? this.detail),
      photos: photos ?? this.photos,
      reviews: reviews ?? this.reviews,
      likedReviewIds: likedReviewIds ?? this.likedReviewIds,
      dislikedReviewIds: dislikedReviewIds ?? this.dislikedReviewIds,
      reactingReviewIds: reactingReviewIds ?? this.reactingReviewIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    shopId,
    isLoading,
    isSavingDetail,
    isUploadingPhoto,
    isSubmittingReview,
    isUpdatingReview,
    detail,
    photos,
    reviews,
    likedReviewIds,
    dislikedReviewIds,
    reactingReviewIds,
    errorMessage,
  ];
}
