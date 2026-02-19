import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/sellerApplication/data/datasources/seller_application_remote_datasource.dart';
import 'package:bazar/features/sellerApplication/data/models/seller_application_model.dart';
import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:bazar/features/sellerApplication/domain/repositories/seller_application_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sellerApplicationRepositoryProvider = Provider<ISellerApplicationRepository>((ref) {
  final remoteDatasource = ref.read(sellerApplicationRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return SellerApplicationRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class SellerApplicationRepository implements ISellerApplicationRepository {
  final ISellerApplicationRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  SellerApplicationRepository({
    required ISellerApplicationRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, SellerApplicationEntity>> createSellerApplication(
      SellerApplicationEntity application) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = SellerApplicationApiModel.fromEntity(application);
        final response = await _remoteDatasource.createSellerApplication(model);
        return Right(response.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to create seller application'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SellerApplicationEntity?>> getMySellerApplication() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDatasource.getMySellerApplication();
        if (response != null) {
          return Right(response.toEntity());
        }
        return const Right(null);
      } on DioException catch (e) {
        return Left(ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to fetch seller application'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
