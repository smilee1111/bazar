import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/shopPhoto/data/datasources/shop_photo_remote_datasource.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopPhotoRepositoryProvider = Provider<IShopPhotoRepository>((ref) {
  return ShopPhotoRepository(
    remoteDataSource: ref.read(shopPhotoRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ShopPhotoRepository implements IShopPhotoRepository {
  final IShopPhotoRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ShopPhotoRepository({
    required IShopPhotoRemoteDataSource remoteDataSource,
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
  Future<Either<Failure, ShopPhotoEntity>> createPhoto(
    String shopId,
    File image,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.createPhoto(shopId, image);
      return response.toEntity();
    }, 'Failed to create photo');
  }

  @override
  Future<Either<Failure, bool>> deletePhoto(String shopId, String photoId) {
    return _guard(
      () => _remoteDataSource.deletePhoto(shopId, photoId),
      'Failed to delete photo',
    );
  }

  @override
  Future<Either<Failure, ShopPhotoEntity>> getPhotoById(
    String shopId,
    String photoId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.getPhotoById(shopId, photoId);
      return response.toEntity();
    }, 'Failed to fetch photo');
  }

  @override
  Future<Either<Failure, List<ShopPhotoEntity>>> getPhotosByShop(
    String shopId,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.getPhotosByShop(shopId);
      return response.map((item) => item.toEntity()).toList();
    }, 'Failed to fetch photos');
  }

  @override
  Future<Either<Failure, ShopPhotoEntity>> updatePhoto(
    String shopId,
    String photoId,
    File image,
  ) {
    return _guard(() async {
      final response = await _remoteDataSource.updatePhoto(
        shopId,
        photoId,
        image,
      );
      return response.toEntity();
    }, 'Failed to update photo');
  }
}
