import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/usecases/get_all_category_usecase.dart';
import 'package:bazar/features/shop/domain/usecases/get_public_shop_by_id_usecase.dart';
import 'package:bazar/features/shopDetail/domain/usecases/get_shop_detail_by_shop_usecase.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/usecases/get_shop_photos_by_shop_usecase.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/usecases/get_shop_reviews_by_shop_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopCardPreview {
  final double averageRating;
  final int reviewCount;
  final List<String> photoUrls;
  final String? detailSnippet;
  final List<String> categoryNames;
  final String? priceRange;

  const ShopCardPreview({
    required this.averageRating,
    required this.reviewCount,
    this.photoUrls = const [],
    this.detailSnippet,
    this.categoryNames = const [],
    this.priceRange,
  });

  static const empty = ShopCardPreview(averageRating: 0, reviewCount: 0);
}

final shopCardPreviewProvider =
    FutureProvider.family<ShopCardPreview, String>((ref, shopId) async {
      final normalized = shopId.trim();
      if (normalized.isEmpty) return ShopCardPreview.empty;

      final reviewsResult = await ref.read(getShopReviewsByShopUsecaseProvider)(
        GetShopReviewsByShopParams(shopId: normalized),
      );
      final photosResult = await ref.read(getShopPhotosByShopUsecaseProvider)(
        GetShopPhotosByShopParams(shopId: normalized),
      );
      final detailResult = await ref.read(getShopDetailByShopUsecaseProvider)(
        GetShopDetailByShopParams(shopId: normalized),
      );
      final shopResult = await ref.read(getPublicShopByIdUsecaseProvider)(
        GetPublicShopByIdParams(shopId: normalized),
      );
      final categoriesResult = await ref.read(getAllCategoryUseCaseProvider)();

      final reviews = reviewsResult.fold<List<ShopReviewEntity>>(
        (_) => const [],
        (value) => value,
      );
      final photos = photosResult.fold((_) => const <ShopPhotoEntity>[], (value) => value);
      final detail = detailResult.fold((_) => null, (value) => value);
      final shop = shopResult.fold((_) => null, (value) => value);
      final allCategories = categoriesResult.fold<List<CategoryEntity>>(
        (_) => const [],
        (value) => value,
      );

      final reviewCount = reviews.length;
      final starsTotal = reviews.fold<int>(0, (sum, item) => sum + item.starNum);
      final average = reviewCount == 0 ? 0.0 : starsTotal / reviewCount;

      final photoUrls = photos
          .map(_resolvePhotoUrl)
          .whereType<String>()
          .take(3)
          .toList();

      final links = [
        detail?.link1,
        detail?.link2,
        detail?.link3,
        detail?.link4,
      ].whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
      final detailSnippet =
          detail?.shopId == normalized && links.isNotEmpty ? links.first : null;

      final resolvedCategories = _resolveCategoryNames(
        raw: shop?.categoryNames ?? const [],
        allCategories: allCategories,
      );

      return ShopCardPreview(
        averageRating: average,
        reviewCount: reviewCount,
        photoUrls: photoUrls,
        detailSnippet: detailSnippet,
        categoryNames: resolvedCategories,
        priceRange: shop?.priceRange,
      );
    });

String? _resolvePhotoUrl(ShopPhotoEntity photo) {
  final raw = (photo.photoUrl ?? '').trim().isNotEmpty
      ? photo.photoUrl!.trim()
      : photo.photoName.trim();
  if (raw.isEmpty) return null;
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
  if (raw.startsWith('/')) return '${ApiEndpoints.serverUrl}$raw';
  if (raw.startsWith('uploads/')) return '${ApiEndpoints.serverUrl}/$raw';
  return null;
}

List<String> _resolveCategoryNames({
  required List<String> raw,
  required List<CategoryEntity> allCategories,
}) {
  if (raw.isEmpty) return const [];

  final idToName = <String, String>{};
  final normalizedNameToName = <String, String>{};

  for (final category in allCategories) {
    final id = category.categoryId?.trim();
    final name = category.categoryName.trim();
    if (name.isEmpty) continue;
    if (id != null && id.isNotEmpty) {
      idToName[id] = name;
    }
    normalizedNameToName[name.toLowerCase()] = name;
  }

  final resolved = <String>[];
  for (final item in raw) {
    final token = item.trim();
    if (token.isEmpty) continue;

    final byId = idToName[token];
    if (byId != null) {
      resolved.add(byId);
      continue;
    }

    final byName = normalizedNameToName[token.toLowerCase()];
    if (byName != null) {
      resolved.add(byName);
      continue;
    }

    // Fallback to raw value when no mapping is available.
    resolved.add(token);
  }

  return resolved.toSet().toList();
}
