import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/shopReview/data/datasources/shop_review_remote_datasource.dart';
import 'package:bazar/features/shopReview/data/models/shop_review_api_model.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopReviewRepositoryProvider = Provider<IShopReviewRepository>((ref) {
  return ShopReviewRepository(
    remoteDataSource: ref.read(shopReviewRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ShopReviewRepository implements IShopReviewRepository {
  final IShopReviewRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ShopReviewRepository({
    required IShopReviewRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  String _error(Object? data, String fallback) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  Future<Either<Failure, T>> _guard<T>(
    Future<T> Function() task,
    String fallbackMessage,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await task();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _error(e.response?.data, fallbackMessage),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> createReview(
    String shopId,
    ShopReviewEntity review,
  ) {
    return _guard(() async {
      final model = ShopReviewApiModel.fromEntity(review);
      final response = await _remoteDataSource.createReview(shopId, model);
      return response.toEntity();
    }, 'Failed to create review');
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String shopId, String reviewId) {
    return _guard(
      () => _remoteDataSource.deleteReview(shopId, reviewId),
      'Failed to delete review',
    );
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> dislikeReview(
    String shopId,
    String reviewId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.dislikeReview(shopId, reviewId);
      return response.toEntity();
    }, 'Failed to dislike review');
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> undislikeReview(
    String shopId,
    String reviewId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.undislikeReview(
        shopId,
        reviewId,
      );
      return response.toEntity();
    }, 'Failed to remove dislike');
  }

  @override
  Future<Either<Failure, bool>> isReviewDisliked(String shopId, String reviewId) {
    return _guard(
      () => _remoteDataSource.isReviewDisliked(shopId, reviewId),
      'Failed to fetch dislike status',
    );
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> getReviewById(
    String shopId,
    String reviewId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.getReviewById(shopId, reviewId);
      return response.toEntity();
    }, 'Failed to fetch review');
  }

  @override
  Future<Either<Failure, List<ShopReviewEntity>>> getReviewsByShop(
    String shopId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.getReviewsByShop(shopId);
      return response.map((item) => item.toEntity()).toList();
    }, 'Failed to fetch reviews');
  }

  @override
  Future<Either<Failure, List<ShopReviewEntity>>> getUserReviews() {
    return _guard(() async {
      final response = await _remoteDataSource.getUserReviews();
      return response.map((item) => item.toEntity()).toList();
    }, 'Failed to fetch user reviews');
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> likeReview(
    String shopId,
    String reviewId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.likeReview(shopId, reviewId);
      return response.toEntity();
    }, 'Failed to like review');
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> unlikeReview(
    String shopId,
    String reviewId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.unlikeReview(shopId, reviewId);
      return response.toEntity();
    }, 'Failed to remove like');
  }

  @override
  Future<Either<Failure, bool>> isReviewLiked(String shopId, String reviewId) {
    return _guard(
      () => _remoteDataSource.isReviewLiked(shopId, reviewId),
      'Failed to fetch like status',
    );
  }

  @override
  Future<Either<Failure, ShopReviewEntity>> updateReview(
    String shopId,
    String reviewId,
    ShopReviewEntity review,
  ) {
    return _guard(() async {
      final model = ShopReviewApiModel.fromEntity(review);
      final response = await _remoteDataSource.updateReview(
        shopId,
        reviewId,
        model,
      );
      return response.toEntity();
    }, 'Failed to update review');
  }
}
