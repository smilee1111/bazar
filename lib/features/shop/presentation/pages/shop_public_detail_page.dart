import 'dart:io';

import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/core/services/storage/user_session_service.dart';
import 'package:bazar/core/utils/snackbar_utils.dart';
import 'package:bazar/features/savedShop/presentation/view_model/saved_shop_view_model.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/presentation/view_model/shop_content_view_model.dart';
import 'package:bazar/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:bazar/features/shopReview/presentation/view_model/user_review_view_model.dart';
import 'package:bazar/features/shop/presentation/widgets/shop_content_sections.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopPublicDetailPage extends ConsumerStatefulWidget {
  const ShopPublicDetailPage({
    super.key,
    required this.shop,
    this.allowOwnerEdit = false,
  });

  final ShopEntity shop;
  final bool allowOwnerEdit;

  @override
  ConsumerState<ShopPublicDetailPage> createState() =>
      _ShopPublicDetailPageState();
}

class _ShopPublicDetailPageState extends ConsumerState<ShopPublicDetailPage> {
  bool _isOwner = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _isOwner = widget.allowOwnerEdit;
    Future.microtask(() async {
      _currentUserId = ref.read(userSessionServiceProvider).getCurrentUserId();
      final sessionUserId = _currentUserId;
      final ownerMatch =
          sessionUserId != null &&
          widget.shop.ownerId != null &&
          sessionUserId == widget.shop.ownerId;
      setState(() {
        _isOwner = _isOwner || ownerMatch;
      });
      await Future.wait([
        ref.read(savedShopViewModelProvider.notifier).loadSavedShops(),
        ref.read(favouriteViewModelProvider.notifier).loadFavourites(),
        ref.read(userReviewViewModelProvider.notifier).loadReviewedShops(),
      ]);
      await ref
          .read(shopContentViewModelProvider.notifier)
          .load(widget.shop.shopId ?? '', forceRefresh: true);
    });
  }

  Future<File?> _pickImage() async {
    final picked = await FilePicker.platform.pickFiles(type: FileType.image);
    if (picked == null || picked.files.isEmpty) return null;
    final path = picked.files.single.path;
    if (path == null || path.isEmpty) return null;
    return File(path);
  }

  Future<void> _showDetailEditSheet() async {
    final state = ref.read(shopContentViewModelProvider);
    final l1 = TextEditingController(text: state.detail?.link1 ?? '');
    final l2 = TextEditingController(text: state.detail?.link2 ?? '');
    final l3 = TextEditingController(text: state.detail?.link3 ?? '');
    final l4 = TextEditingController(text: state.detail?.link4 ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: l1,
                  decoration: const InputDecoration(labelText: 'Link 1'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: l2,
                  decoration: const InputDecoration(labelText: 'Link 2'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: l3,
                  decoration: const InputDecoration(labelText: 'Link 3'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: l4,
                  decoration: const InputDecoration(labelText: 'Link 4'),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await ref
                        .read(shopContentViewModelProvider.notifier)
                        .saveDetail(
                          shopId: widget.shop.shopId ?? '',
                          link1: l1.text,
                          link2: l2.text,
                          link3: l3.text,
                          link4: l4.text,
                        );
                    if (!mounted) return;
                    if (ok) {
                      SnackbarUtils.showSuccess(
                        context,
                        'Shop details updated',
                      );
                      Navigator.of(context).pop();
                    } else {
                      final err =
                          ref.read(shopContentViewModelProvider).errorMessage ??
                          'Failed to update details';
                      SnackbarUtils.showError(context, err);
                    }
                  },
                  child: const Text('Save Details'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addPhoto() async {
    final image = await _pickImage();
    if (image == null) return;
    final ok = await ref
        .read(shopContentViewModelProvider.notifier)
        .addPhoto(widget.shop.shopId ?? '', image);
    if (!mounted) return;
    if (!ok) {
      final err =
          ref.read(shopContentViewModelProvider).errorMessage ??
          'Failed to upload photo';
      SnackbarUtils.showError(context, err);
      return;
    }
    SnackbarUtils.showSuccess(context, 'Photo uploaded');
  }

  Future<void> _updatePhoto(ShopPhotoEntity photo) async {
    final image = await _pickImage();
    if (image == null || photo.photoId == null) return;
    final ok = await ref
        .read(shopContentViewModelProvider.notifier)
        .updatePhoto(widget.shop.shopId ?? '', photo.photoId!, image);
    if (!mounted) return;
    if (!ok) {
      final err =
          ref.read(shopContentViewModelProvider).errorMessage ??
          'Failed to update photo';
      SnackbarUtils.showError(context, err);
      return;
    }
    SnackbarUtils.showSuccess(context, 'Photo updated');
  }

  Future<void> _deletePhoto(ShopPhotoEntity photo) async {
    if (photo.photoId == null) return;
    final ok = await ref
        .read(shopContentViewModelProvider.notifier)
        .deletePhoto(widget.shop.shopId ?? '', photo.photoId!);
    if (!mounted) return;
    if (!ok) {
      final err =
          ref.read(shopContentViewModelProvider).errorMessage ??
          'Failed to delete photo';
      SnackbarUtils.showError(context, err);
      return;
    }
    SnackbarUtils.showSuccess(context, 'Photo deleted');
  }

  Future<void> _showReviewSheet() async {
    if (_isOwner) {
      SnackbarUtils.showWarning(context, 'You cannot review your own shop.');
      return;
    }
    final reviewCtrl = TextEditingController();
    int stars = 5;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: reviewCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Write review',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Rating'),
                      const SizedBox(width: 12),
                      _StarRatingInput(
                        value: stars,
                        onChanged: (value) {
                          setSheetState(() => stars = value);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (reviewCtrl.text.trim().isEmpty) {
                        SnackbarUtils.showWarning(
                          context,
                          'Please write a review',
                        );
                        return;
                      }
                      final ok = await ref
                          .read(shopContentViewModelProvider.notifier)
                          .submitReview(
                            shopId: widget.shop.shopId ?? '',
                            reviewName: reviewCtrl.text,
                            starNum: stars,
                          );
                      if (!mounted) return;
                      if (ok) {
                        final shopId = widget.shop.shopId ?? '';
                        if (shopId.isNotEmpty) {
                          ref
                              .read(userReviewViewModelProvider.notifier)
                              .markReviewedShop(shopId);
                          await ref
                              .read(favouriteViewModelProvider.notifier)
                              .ensureReviewedFavourite(shopId);
                        }
                        ref
                            .read(userReviewViewModelProvider.notifier)
                            .loadReviewedShops(forceRefresh: true);
                        ref
                            .read(favouriteViewModelProvider.notifier)
                            .loadFavourites(forceRefresh: true);
                        SnackbarUtils.showSuccess(context, 'Review submitted');
                        Navigator.of(context).pop();
                      } else {
                        final err =
                            ref
                                .read(shopContentViewModelProvider)
                                .errorMessage ??
                            'Failed to submit review';
                        SnackbarUtils.showError(context, err);
                      }
                    },
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditReviewSheet(ShopReviewEntity review) async {
    if (!_canEditReview(review) || review.reviewId == null) {
      SnackbarUtils.showWarning(context, 'You can only edit your own review.');
      return;
    }
    final reviewCtrl = TextEditingController(text: review.reviewName);
    int stars = review.starNum.clamp(1, 5);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: reviewCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Edit review'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Rating'),
                      const SizedBox(width: 12),
                      _StarRatingInput(
                        value: stars,
                        onChanged: (value) {
                          setSheetState(() => stars = value);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (reviewCtrl.text.trim().isEmpty) {
                        SnackbarUtils.showWarning(
                          context,
                          'Please write a review',
                        );
                        return;
                      }
                      final ok = await ref
                          .read(shopContentViewModelProvider.notifier)
                          .updateReview(
                            shopId: widget.shop.shopId ?? '',
                            reviewId: review.reviewId!,
                            reviewName: reviewCtrl.text,
                            starNum: stars,
                          );
                      if (!mounted) return;
                      if (ok) {
                        ref
                            .read(userReviewViewModelProvider.notifier)
                            .loadReviewedShops(forceRefresh: true);
                        ref
                            .read(favouriteViewModelProvider.notifier)
                            .loadFavourites(forceRefresh: true);
                        SnackbarUtils.showSuccess(context, 'Review updated');
                        Navigator.of(context).pop();
                      } else {
                        final err =
                            ref
                                .read(shopContentViewModelProvider)
                                .errorMessage ??
                            'Failed to update review';
                        SnackbarUtils.showError(context, err);
                      }
                    },
                    child: const Text('Update Review'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteReview(ShopReviewEntity review) async {
    if (!_canEditReview(review) || review.reviewId == null) {
      SnackbarUtils.showWarning(context, 'You can only delete your own review.');
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final ok = await ref.read(shopContentViewModelProvider.notifier).deleteReview(
      shopId: widget.shop.shopId ?? '',
      reviewId: review.reviewId!,
    );
    if (!mounted) return;
    if (ok) {
      ref
          .read(userReviewViewModelProvider.notifier)
          .loadReviewedShops(forceRefresh: true);
      ref
          .read(favouriteViewModelProvider.notifier)
          .loadFavourites(forceRefresh: true);
      SnackbarUtils.showSuccess(context, 'Review deleted');
    } else {
      final err =
          ref.read(shopContentViewModelProvider).errorMessage ??
          'Failed to delete review';
      SnackbarUtils.showError(context, err);
    }
  }

  bool _canEditReview(ShopReviewEntity review) {
    final currentId = _currentUserId?.trim();
    final reviewedBy = review.reviewedBy?.trim();
    if (currentId == null || currentId.isEmpty) return false;
    if (reviewedBy == null || reviewedBy.isEmpty) return false;
    return currentId == reviewedBy;
  }

  Future<void> _toggleSaveShop() async {
    final shopId = widget.shop.shopId ?? '';
    if (shopId.isEmpty) return;
    final wasSaved = ref.read(savedShopViewModelProvider).savedShopIds.contains(
          shopId,
        );
    final ok = await ref.read(savedShopViewModelProvider.notifier).toggleSaved(
          shopId,
        );
    if (!mounted) return;
    if (ok) {
      SnackbarUtils.showSuccess(
        context,
        wasSaved ? 'Removed from saved shops' : 'Shop saved successfully',
      );
      return;
    }
    final err = ref.read(savedShopViewModelProvider).errorMessage;
    if (err != null && err.isNotEmpty) {
      SnackbarUtils.showError(context, err);
    }
  }

  Future<void> _toggleFavouriteShop({required bool reviewed}) async {
    final shopId = widget.shop.shopId ?? '';
    if (shopId.isEmpty) return;
    final wasFavourite = ref
        .read(favouriteViewModelProvider)
        .favouriteShopIds
        .contains(shopId);
    final ok = await ref
        .read(favouriteViewModelProvider.notifier)
        .toggleFavourite(shopId: shopId, isReviewed: reviewed ? true : null);
    if (!mounted) return;
    if (ok) {
      SnackbarUtils.showSuccess(
        context,
        wasFavourite ? 'Removed from favourites' : 'Added to favourites',
      );
      return;
    }
    final err = ref.read(favouriteViewModelProvider).errorMessage;
    if (err != null && err.isNotEmpty) {
      SnackbarUtils.showError(context, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopContentViewModelProvider);
    final savedState = ref.watch(savedShopViewModelProvider);
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final userReviewState = ref.watch(userReviewViewModelProvider);

    final shopId = widget.shop.shopId ?? '';
    final reviewedIds = {
      ...userReviewState.reviewedShopIds,
      ...favouriteState.reviewedShopIds,
    };
    final isReviewed = reviewedIds.contains(shopId);
    final isSaved = savedState.savedShopIds.contains(shopId);
    final isFavourite = favouriteState.favouriteShopIds.contains(shopId);
    final isSaveBusy = savedState.processingShopIds.contains(shopId);
    final isFavouriteBusy = favouriteState.processingShopIds.contains(shopId);

    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.shopName)),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(shopContentViewModelProvider.notifier)
            .load(widget.shop.shopId ?? '', forceRefresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.shop.shopName,
                          style: AppTextStyle.inputBox.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: isFavouriteBusy
                            ? const Padding(
                                padding: EdgeInsets.all(7),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                tooltip: isFavourite
                                    ? 'Remove from favourites'
                                    : 'Add to favourites',
                                onPressed: () =>
                                    _toggleFavouriteShop(reviewed: isReviewed),
                                icon: Icon(
                                  isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavourite
                                      ? AppColors.error
                                      : Colors.grey.shade600,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: isSaveBusy
                            ? const Padding(
                                padding: EdgeInsets.all(7),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                tooltip: isSaved
                                    ? 'Remove from saved'
                                    : 'Save shop',
                                onPressed: _toggleSaveShop,
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isSaved
                                      ? AppColors.primary
                                      : Colors.grey.shade600,
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (isReviewed) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          'You reviewed this',
                          style: AppTextStyle.inputBox.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _info(
                    icon: Icons.location_on_outlined,
                    value: widget.shop.shopAddress,
                  ),
                  _info(
                    icon: Icons.phone_outlined,
                    value: widget.shop.shopContact,
                  ),
                  if ((widget.shop.email ?? '').isNotEmpty)
                    _info(
                      icon: Icons.mail_outline_rounded,
                      value: widget.shop.email!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (state.isLoading) const LinearProgressIndicator(minHeight: 2),
            if ((state.errorMessage ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: AppTextStyle.minimalTexts.copyWith(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 8),
            ShopDetailSection(
              detail: state.detail,
              canEdit: _isOwner,
              onEdit: _showDetailEditSheet,
            ),
            ShopPhotosSection(
              photos: state.photos,
              canEdit: _isOwner,
              onAdd: _addPhoto,
              onUpdate: _updatePhoto,
              onDelete: _deletePhoto,
            ),
            ShopReviewsSection(
              reviews: state.reviews,
              canAddReview: !_isOwner,
              onAddReview: _isOwner ? null : _showReviewSheet,
              canEditReview: _canEditReview,
              onEditReview: _showEditReviewSheet,
              onDeleteReview: _deleteReview,
              isLiked: (review) =>
                  review.reviewId != null &&
                  state.likedReviewIds.contains(review.reviewId!),
              isDisliked: (review) =>
                  review.reviewId != null &&
                  state.dislikedReviewIds.contains(review.reviewId!),
              isReacting: (review) =>
                  review.reviewId != null &&
                  state.reactingReviewIds.contains(review.reviewId!),
              onLike: (review) {
                if (review.reviewId == null) return;
                ref
                    .read(shopContentViewModelProvider.notifier)
                    .reactToReview(
                      shopId: widget.shop.shopId ?? '',
                      reviewId: review.reviewId!,
                      isLike: true,
                    );
              },
              onDislike: (review) {
                if (review.reviewId == null) return;
                ref
                    .read(shopContentViewModelProvider.notifier)
                    .reactToReview(
                      shopId: widget.shop.shopId ?? '',
                      reviewId: review.reviewId!,
                      isLike: false,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _info({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.inputBox.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRatingInput extends StatelessWidget {
  const _StarRatingInput({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final star = index + 1;
        return IconButton(
          onPressed: () => onChanged(star),
          iconSize: 24,
          visualDensity: VisualDensity.compact,
          splashRadius: 20,
          icon: Icon(
            star <= value ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppColors.warning,
          ),
        );
      }),
    );
  }
}
