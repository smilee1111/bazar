import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/favourite/data/datasources/favourite_remote_datasource.dart';
import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';
import 'package:bazar/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteRepositoryProvider = Provider<IFavouriteRepository>((ref) {
  return FavouriteRepository(
    remoteDataSource: ref.read(favouriteRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class FavouriteRepository implements IFavouriteRepository {
  final IFavouriteRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  FavouriteRepository({
    required IFavouriteRemoteDataSource remoteDataSource,
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
  Future<Either<Failure, FavouriteEntity>> addFavourite({
    required String shopId,
    bool? isReviewed,
  }) {
    return _guard(() async {
      final response = await _remoteDataSource.addFavourite(
        shopId: shopId,
        isReviewed: isReviewed,
      );
      return response.toEntity();
    }, 'Failed to add favourite');
  }

  @override
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites() {
    return _guard(() async {
      final response = await _remoteDataSource.getFavourites();
      return response.map((item) => item.toEntity()).toList();
    }, 'Failed to fetch favourites');
  }

  @override
  Future<Either<Failure, bool>> removeFavourite(String shopId) {
    return _guard(
      () => _remoteDataSource.removeFavourite(shopId),
      'Failed to remove favourite',
    );
  }
}
