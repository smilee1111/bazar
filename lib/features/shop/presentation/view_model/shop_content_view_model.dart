import 'dart:io';

import 'package:bazar/core/services/storage/user_session_service.dart';
import 'package:bazar/features/shop/presentation/state/shop_content_state.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/usecases/create_shop_detail_usecase.dart';
import 'package:bazar/features/shopDetail/domain/usecases/get_shop_detail_by_shop_usecase.dart';
import 'package:bazar/features/shopDetail/domain/usecases/update_shop_detail_usecase.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/usecases/create_shop_photo_usecase.dart';
import 'package:bazar/features/shopPhoto/domain/usecases/delete_shop_photo_usecase.dart';
import 'package:bazar/features/shopPhoto/domain/usecases/get_shop_photos_by_shop_usecase.dart';
import 'package:bazar/features/shopPhoto/domain/usecases/update_shop_photo_usecase.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/usecases/create_shop_review_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/delete_shop_review_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/get_review_reaction_status_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/get_shop_reviews_by_shop_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/react_shop_review_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/update_shop_review_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopContentViewModelProvider =
    NotifierProvider<ShopContentViewModel, ShopContentState>(
      ShopContentViewModel.new,
    );

class ShopContentViewModel extends Notifier<ShopContentState> {
  late final GetShopDetailByShopUsecase _getShopDetailByShopUsecase;
  late final CreateShopDetailUsecase _createShopDetailUsecase;
  late final UpdateShopDetailUsecase _updateShopDetailUsecase;
  late final GetShopPhotosByShopUsecase _getShopPhotosByShopUsecase;
  late final CreateShopPhotoUsecase _createShopPhotoUsecase;
  late final UpdateShopPhotoUsecase _updateShopPhotoUsecase;
  late final DeleteShopPhotoUsecase _deleteShopPhotoUsecase;
  late final GetShopReviewsByShopUsecase _getShopReviewsByShopUsecase;
  late final CreateShopReviewUsecase _createShopReviewUsecase;
  late final DeleteShopReviewUsecase _deleteShopReviewUsecase;
  late final UpdateShopReviewUsecase _updateShopReviewUsecase;
  late final ReactShopReviewUsecase _reactShopReviewUsecase;
  late final GetReviewLikedStatusUsecase _getReviewLikedStatusUsecase;
  late final GetReviewDislikedStatusUsecase _getReviewDislikedStatusUsecase;

  @override
  ShopContentState build() {
    _getShopDetailByShopUsecase = ref.read(getShopDetailByShopUsecaseProvider);
    _createShopDetailUsecase = ref.read(createShopDetailUsecaseProvider);
    _updateShopDetailUsecase = ref.read(updateShopDetailUsecaseProvider);
    _getShopPhotosByShopUsecase = ref.read(getShopPhotosByShopUsecaseProvider);
    _createShopPhotoUsecase = ref.read(createShopPhotoUsecaseProvider);
    _updateShopPhotoUsecase = ref.read(updateShopPhotoUsecaseProvider);
    _deleteShopPhotoUsecase = ref.read(deleteShopPhotoUsecaseProvider);
    _getShopReviewsByShopUsecase = ref.read(
      getShopReviewsByShopUsecaseProvider,
    );
    _createShopReviewUsecase = ref.read(createShopReviewUsecaseProvider);
    _deleteShopReviewUsecase = ref.read(deleteShopReviewUsecaseProvider);
    _updateShopReviewUsecase = ref.read(updateShopReviewUsecaseProvider);
    _reactShopReviewUsecase = ref.read(reactShopReviewUsecaseProvider);
    _getReviewLikedStatusUsecase = ref.read(getReviewLikedStatusUsecaseProvider);
    _getReviewDislikedStatusUsecase = ref.read(
      getReviewDislikedStatusUsecaseProvider,
    );
    return const ShopContentState();
  }

  Future<void> load(String shopId, {bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (!forceRefresh &&
        state.shopId == shopId &&
        (state.detail != null ||
            state.photos.isNotEmpty ||
            state.reviews.isNotEmpty)) {
      return;
    }

    state = state.copyWith(
      shopId: shopId,
      isLoading: true,
      clearError: true,
      clearDetail: true,
      photos: const [],
      reviews: const [],
      likedReviewIds: const {},
      dislikedReviewIds: const {},
      reactingReviewIds: const {},
    );

    final detailResult = await _getShopDetailByShopUsecase(
      GetShopDetailByShopParams(shopId: shopId),
    );
    final photoResult = await _getShopPhotosByShopUsecase(
      GetShopPhotosByShopParams(shopId: shopId),
    );
    final reviewResult = await _getShopReviewsByShopUsecase(
      GetShopReviewsByShopParams(shopId: shopId),
    );

    final detail = detailResult.fold<ShopDetailEntity?>((_) => null, (v) => v);
    final photos = photoResult.fold<List<ShopPhotoEntity>>(
      (_) => const [],
      (v) => v,
    );
    final reviews = reviewResult.fold<List<ShopReviewEntity>>(
      (_) => const [],
      (v) => v,
    );
    final error =
        detailResult.fold<String?>((f) => f.message, (_) => null) ??
        photoResult.fold<String?>((f) => f.message, (_) => null) ??
        reviewResult.fold<String?>((f) => f.message, (_) => null);

    state = state.copyWith(
      isLoading: false,
      detail: detail,
      photos: photos,
      reviews: reviews,
      errorMessage: error,
      clearError: error == null,
    );

    if (reviews.isNotEmpty) {
      await _syncReactionStates(shopId: shopId, reviews: reviews);
    }
  }

  Future<bool> saveDetail({
    required String shopId,
    required String? link1,
    required String? link2,
    required String? link3,
    required String? link4,
  }) async {
    if (state.isSavingDetail) return false;
    state = state.copyWith(isSavingDetail: true, clearError: true);

    final payload = ShopDetailEntity(
      detailId: state.detail?.detailId,
      shopId: shopId,
      link1: _emptyToNull(link1),
      link2: _emptyToNull(link2),
      link3: _emptyToNull(link3),
      link4: _emptyToNull(link4),
    );

    final result = state.detail?.detailId == null
        ? await _createShopDetailUsecase(
            CreateShopDetailParams(shopId: shopId, detail: payload),
          )
        : await _updateShopDetailUsecase(
            UpdateShopDetailParams(
              shopId: shopId,
              detailId: state.detail!.detailId!,
              detail: payload,
            ),
          );

    return result.fold(
      (f) {
        state = state.copyWith(isSavingDetail: false, errorMessage: f.message);
        return false;
      },
      (detail) {
        state = state.copyWith(
          isSavingDetail: false,
          detail: detail,
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> addPhoto(String shopId, File image) async {
    if (state.isUploadingPhoto) return false;
    state = state.copyWith(isUploadingPhoto: true, clearError: true);

    final result = await _createShopPhotoUsecase(
      CreateShopPhotoParams(shopId: shopId, image: image),
    );
    return result.fold(
      (f) {
        state = state.copyWith(
          isUploadingPhoto: false,
          errorMessage: f.message,
        );
        return false;
      },
      (photo) {
        state = state.copyWith(
          isUploadingPhoto: false,
          photos: [...state.photos, photo],
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> updatePhoto(String shopId, String photoId, File image) async {
    if (state.isUploadingPhoto) return false;
    state = state.copyWith(isUploadingPhoto: true, clearError: true);

    final result = await _updateShopPhotoUsecase(
      UpdateShopPhotoParams(shopId: shopId, photoId: photoId, image: image),
    );
    return result.fold(
      (f) {
        state = state.copyWith(
          isUploadingPhoto: false,
          errorMessage: f.message,
        );
        return false;
      },
      (updated) {
        final list = state.photos
            .map((p) => p.photoId == updated.photoId ? updated : p)
            .toList();
        state = state.copyWith(
          isUploadingPhoto: false,
          photos: list,
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deletePhoto(String shopId, String photoId) async {
    final result = await _deleteShopPhotoUsecase(
      DeleteShopPhotoParams(shopId: shopId, photoId: photoId),
    );
    return result.fold(
      (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          photos: state.photos.where((p) => p.photoId != photoId).toList(),
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> submitReview({
    required String shopId,
    required String reviewName,
    required int starNum,
  }) async {
    if (state.isSubmittingReview) return false;
    state = state.copyWith(isSubmittingReview: true, clearError: true);

    final session = ref.read(userSessionServiceProvider);
    final currentUserId = session.getCurrentUserId();
    final currentUserName = session.getCurrentUserFullName();
    final currentUsername = session.getCurrentUserUsername();

    final payload = ShopReviewEntity(
      reviewName: reviewName.trim(),
      shopId: shopId,
      starNum: starNum.clamp(1, 5),
      reviewedBy: currentUserId,
      reviewedByName: (currentUserName != null && currentUserName.trim().isNotEmpty)
          ? currentUserName.trim()
          : ((currentUsername != null && currentUsername.trim().isNotEmpty)
                ? currentUsername.trim()
                : 'You'),
    );

    final result = await _createShopReviewUsecase(
      CreateShopReviewParams(shopId: shopId, review: payload),
    );
    return result.fold(
      (f) {
        state = state.copyWith(
          isSubmittingReview: false,
          errorMessage: f.message,
        );
        return false;
      },
      (review) {
        final merged = _mergeReviewForUi(
          previous: payload,
          updated: review,
          fallbackReviewId: review.reviewId ?? '',
          fallbackShopId: shopId,
        );
        state = state.copyWith(
          isSubmittingReview: false,
          reviews: [merged, ...state.reviews],
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> updateReview({
    required String shopId,
    required String reviewId,
    required String reviewName,
    required int starNum,
  }) async {
    if (state.isUpdatingReview) return false;
    state = state.copyWith(isUpdatingReview: true, clearError: true);

    final current = state.reviews
        .where((item) => item.reviewId == reviewId)
        .toList();
    if (current.isEmpty) {
      state = state.copyWith(
        isUpdatingReview: false,
        errorMessage: 'Review not found',
      );
      return false;
    }

    final old = current.first;
    final payload = ShopReviewEntity(
      reviewId: old.reviewId,
      reviewName: reviewName.trim(),
      shopId: old.shopId,
      reviewedBy: old.reviewedBy,
      reviewedByName: old.reviewedByName,
      starNum: starNum.clamp(1, 5),
      likesCount: old.likesCount,
      dislikeCount: old.dislikeCount,
      isActive: old.isActive,
    );

    final result = await _updateShopReviewUsecase(
      UpdateShopReviewParams(shopId: shopId, reviewId: reviewId, review: payload),
    );
    return result.fold(
      (f) {
        state = state.copyWith(
          isUpdatingReview: false,
          errorMessage: f.message,
        );
        return false;
      },
      (updated) {
        final merged = _mergeReviewForUi(
          previous: old,
          updated: updated,
          fallbackReviewId: reviewId,
          fallbackShopId: shopId,
        );
        final list = state.reviews
            .map((r) => r.reviewId == reviewId ? merged : r)
            .toList();
        state = state.copyWith(
          isUpdatingReview: false,
          reviews: list,
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteReview({
    required String shopId,
    required String reviewId,
  }) async {
    final result = await _deleteShopReviewUsecase(
      DeleteShopReviewParams(shopId: shopId, reviewId: reviewId),
    );
    return result.fold(
      (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
      (_) {
        final reviews = state.reviews
            .where((item) => item.reviewId != reviewId)
            .toList();
        final liked = {...state.likedReviewIds}..remove(reviewId);
        final disliked = {...state.dislikedReviewIds}..remove(reviewId);
        final reacting = {...state.reactingReviewIds}..remove(reviewId);
        state = state.copyWith(
          reviews: reviews,
          likedReviewIds: liked,
          dislikedReviewIds: disliked,
          reactingReviewIds: reacting,
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> reactToReview({
    required String shopId,
    required String reviewId,
    required bool isLike,
  }) async {
    final reacting = {...state.reactingReviewIds, reviewId};
    state = state.copyWith(reactingReviewIds: reacting, clearError: true);

    final status = await _getReactionStatus(shopId: shopId, reviewId: reviewId);
    final liked = status[0];
    final disliked = status[1];
    final reaction = isLike
        ? (liked ? ShopReviewReaction.unlike : ShopReviewReaction.like)
        : (disliked ? ShopReviewReaction.undislike : ShopReviewReaction.dislike);

    final result = await _reactShopReviewUsecase(
      ReactShopReviewParams(
        shopId: shopId,
        reviewId: reviewId,
        reaction: reaction,
      ),
    );
    return result.fold<Future<bool>>(
      (f) async {
        final fallback = await _handleAlreadyReactedFallback(
          shopId: shopId,
          reviewId: reviewId,
          attemptedReaction: reaction,
          message: f.message,
        );
        if (fallback != null) {
          await _applyUpdatedReview(
            updated: fallback,
            reviewId: reviewId,
            shopId: shopId,
          );
          return true;
        }
        final lower = f.message.toLowerCase();
        if (lower.contains('already liked') ||
            lower.contains('already disliked')) {
          final updatedReacting = {...state.reactingReviewIds}..remove(reviewId);
          state = state.copyWith(
            reactingReviewIds: updatedReacting,
            clearError: true,
          );
          await _syncSingleReactionState(shopId: shopId, reviewId: reviewId);
          return false;
        }
        final updatedReacting = {...state.reactingReviewIds}..remove(reviewId);
        state = state.copyWith(
          reactingReviewIds: updatedReacting,
          errorMessage: f.message,
        );
        return false;
      },
      (updated) async {
        await _applyUpdatedReview(
          updated: updated,
          reviewId: reviewId,
          shopId: shopId,
        );
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String? _emptyToNull(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }

  Future<void> _syncReactionStates({
    required String shopId,
    required List<ShopReviewEntity> reviews,
  }) async {
    final reviewIds = reviews
        .map((item) => item.reviewId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toList();
    if (reviewIds.isEmpty) return;

    final liked = <String>{};
    final disliked = <String>{};

    for (final reviewId in reviewIds) {
      final likedResult = await _getReviewLikedStatusUsecase(
        GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
      );
      final dislikedResult = await _getReviewDislikedStatusUsecase(
        GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
      );
      likedResult.fold((_) {}, (value) {
        if (value) liked.add(reviewId);
      });
      dislikedResult.fold((_) {}, (value) {
        if (value) disliked.add(reviewId);
      });
    }

    state = state.copyWith(likedReviewIds: liked, dislikedReviewIds: disliked);
  }

  Future<void> _syncSingleReactionState({
    required String shopId,
    required String reviewId,
  }) async {
    final likedResult = await _getReviewLikedStatusUsecase(
      GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
    );
    final dislikedResult = await _getReviewDislikedStatusUsecase(
      GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
    );

    final likedIds = {...state.likedReviewIds};
    final dislikedIds = {...state.dislikedReviewIds};

    likedResult.fold((_) {}, (value) {
      if (value) {
        likedIds.add(reviewId);
      } else {
        likedIds.remove(reviewId);
      }
    });
    dislikedResult.fold((_) {}, (value) {
      if (value) {
        dislikedIds.add(reviewId);
      } else {
        dislikedIds.remove(reviewId);
      }
    });

    state = state.copyWith(likedReviewIds: likedIds, dislikedReviewIds: dislikedIds);
  }

  Future<List<bool>> _getReactionStatus({
    required String shopId,
    required String reviewId,
  }) async {
    var liked = state.likedReviewIds.contains(reviewId);
    var disliked = state.dislikedReviewIds.contains(reviewId);

    final likedResult = await _getReviewLikedStatusUsecase(
      GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
    );
    likedResult.fold((_) {}, (value) => liked = value);

    final dislikedResult = await _getReviewDislikedStatusUsecase(
      GetReviewReactionStatusParams(shopId: shopId, reviewId: reviewId),
    );
    dislikedResult.fold((_) {}, (value) => disliked = value);

    return [liked, disliked];
  }

  ShopReviewEntity _mergeReviewForUi({
    required ShopReviewEntity? previous,
    required ShopReviewEntity updated,
    required String fallbackReviewId,
    required String fallbackShopId,
  }) {
    final hasName = updated.reviewedByName?.trim().isNotEmpty ?? false;
    final hasReviewerId = updated.reviewedBy?.trim().isNotEmpty ?? false;

    return ShopReviewEntity(
      reviewId: updated.reviewId ?? previous?.reviewId ?? fallbackReviewId,
      reviewName: updated.reviewName,
      shopId: updated.shopId.isNotEmpty
          ? updated.shopId
          : (previous?.shopId ?? fallbackShopId),
      reviewedBy: hasReviewerId ? updated.reviewedBy : previous?.reviewedBy,
      reviewedByName: hasName ? updated.reviewedByName : previous?.reviewedByName,
      starNum: updated.starNum,
      likesCount: updated.likesCount,
      dislikeCount: updated.dislikeCount,
      isActive: updated.isActive,
    );
  }

  Future<void> _applyUpdatedReview({
    required ShopReviewEntity updated,
    required String reviewId,
    required String shopId,
  }) async {
    ShopReviewEntity? previous;
    for (final item in state.reviews) {
      if (item.reviewId == reviewId) {
        previous = item;
        break;
      }
    }
    final merged = _mergeReviewForUi(
      previous: previous,
      updated: updated,
      fallbackReviewId: reviewId,
      fallbackShopId: shopId,
    );
    final list = state.reviews
        .map((r) => r.reviewId == reviewId ? merged : r)
        .toList();
    final updatedReacting = {...state.reactingReviewIds}..remove(reviewId);
    state = state.copyWith(
      reviews: list,
      reactingReviewIds: updatedReacting,
      clearError: true,
    );
    await _syncSingleReactionState(shopId: shopId, reviewId: reviewId);
  }

  Future<ShopReviewEntity?> _handleAlreadyReactedFallback({
    required String shopId,
    required String reviewId,
    required ShopReviewReaction attemptedReaction,
    required String message,
  }) async {
    final lower = message.toLowerCase();
    if (attemptedReaction == ShopReviewReaction.like &&
        lower.contains('already liked')) {
      final res = await _reactShopReviewUsecase(
        ReactShopReviewParams(
          shopId: shopId,
          reviewId: reviewId,
          reaction: ShopReviewReaction.unlike,
        ),
      );
      return res.fold((_) => null, (v) => v);
    }
    if (attemptedReaction == ShopReviewReaction.dislike &&
        lower.contains('already disliked')) {
      final res = await _reactShopReviewUsecase(
        ReactShopReviewParams(
          shopId: shopId,
          reviewId: reviewId,
          reaction: ShopReviewReaction.undislike,
        ),
      );
      return res.fold((_) => null, (v) => v);
    }
    return null;
  }
}
