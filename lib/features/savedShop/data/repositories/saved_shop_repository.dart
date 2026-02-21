import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/savedShop/data/datasources/saved_shop_remote_datasource.dart';
import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';
import 'package:bazar/features/savedShop/domain/repositories/saved_shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedShopRepositoryProvider = Provider<ISavedShopRepository>((ref) {
  return SavedShopRepository(
    remoteDataSource: ref.read(savedShopRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class SavedShopRepository implements ISavedShopRepository {
  final ISavedShopRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  SavedShopRepository({
    required ISavedShopRemoteDataSource remoteDataSource,
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
  Future<Either<Failure, List<SavedShopEntity>>> getSavedShops() {
    return _guard(() async {
      final response = await _remoteDataSource.getSavedShops();
      return response.map((item) => item.toEntity()).toList();
    }, 'Failed to fetch saved shops');
  }

  @override
  Future<Either<Failure, bool>> removeSavedShop(String shopId) {
    return _guard(
      () => _remoteDataSource.removeSavedShop(shopId),
      'Failed to remove saved shop',
    );
  }

  @override
  Future<Either<Failure, SavedShopEntity>> saveShop(String shopId) {
    return _guard(() async {
      final response = await _remoteDataSource.saveShop(shopId);
      return response.toEntity();
    }, 'Failed to save shop');
  }
}
