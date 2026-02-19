import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/shopDetail/data/datasources/shop_detail_remote_datasource.dart';
import 'package:bazar/features/shopDetail/data/models/shop_detail_api_model.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopDetailRepositoryProvider = Provider<IShopDetailRepository>((ref) {
  return ShopDetailRepository(
    remoteDataSource: ref.read(shopDetailRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ShopDetailRepository implements IShopDetailRepository {
  final IShopDetailRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ShopDetailRepository({
    required IShopDetailRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  String _errorMessage(Object? data, String fallback) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  @override
  Future<Either<Failure, ShopDetailEntity>> createDetail(
    String shopId,
    ShopDetailEntity detail,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final model = ShopDetailApiModel.fromEntity(detail);
      final response = await _remoteDataSource.createDetail(shopId, model);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _errorMessage(
            e.response?.data,
            'Failed to create shop detail',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDetail(
    String shopId,
    String detailId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await _remoteDataSource.deleteDetail(shopId, detailId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _errorMessage(
            e.response?.data,
            'Failed to delete shop detail',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopDetailEntity>> getDetailById(
    String shopId,
    String detailId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await _remoteDataSource.getDetailById(shopId, detailId);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _errorMessage(
            e.response?.data,
            'Failed to fetch shop detail',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopDetailEntity?>> getDetailByShop(
    String shopId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await _remoteDataSource.getDetailByShop(shopId);
      if (response == null) return const Right(null);
      return Right(response.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Right(null);
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _errorMessage(
            e.response?.data,
            'Failed to fetch shop detail',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopDetailEntity>> updateDetail(
    String shopId,
    String detailId,
    ShopDetailEntity detail,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final model = ShopDetailApiModel.fromEntity(detail);
      final response = await _remoteDataSource.updateDetail(
        shopId,
        detailId,
        model,
      );
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _errorMessage(
            e.response?.data,
            'Failed to update shop detail',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
