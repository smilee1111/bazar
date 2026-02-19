import 'dart:io';

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
import 'package:bazar/features/shopReview/domain/usecases/get_shop_reviews_by_shop_usecase.dart';
import 'package:bazar/features/shopReview/domain/usecases/react_shop_review_usecase.dart';
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
  late final ReactShopReviewUsecase _reactShopReviewUsecase;

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
    _reactShopReviewUsecase = ref.read(reactShopReviewUsecaseProvider);
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

    final payload = ShopReviewEntity(
      reviewName: reviewName.trim(),
      shopId: shopId,
      starNum: starNum.clamp(1, 5),
      reviewedBy: null,
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
        state = state.copyWith(
          isSubmittingReview: false,
          reviews: [review, ...state.reviews],
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<bool> reactToReview({
    required String reviewId,
    required bool isLike,
  }) async {
    final result = await _reactShopReviewUsecase(
      ReactShopReviewParams(
        reviewId: reviewId,
        reaction: isLike ? ShopReviewReaction.like : ShopReviewReaction.dislike,
      ),
    );
    return result.fold(
      (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
      (updated) {
        final list = state.reviews
            .map((r) => r.reviewId == updated.reviewId ? updated : r)
            .toList();
        state = state.copyWith(reviews: list, clearError: true);
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
}
