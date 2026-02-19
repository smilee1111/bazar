import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/sellerApplication/data/repositories/seller_application_repository.dart';
import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:bazar/features/sellerApplication/domain/repositories/seller_application_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final getMySellerApplicationUsecaseProvider =
    Provider<GetMySellerApplicationUsecase>((ref) {
  final repository = ref.read(sellerApplicationRepositoryProvider);
  return GetMySellerApplicationUsecase(repository: repository);
});

class GetMySellerApplicationUsecase
    implements UsecaseWithoutParams<Either<Failure, SellerApplicationEntity?>> {
  final ISellerApplicationRepository _repository;

  GetMySellerApplicationUsecase({required ISellerApplicationRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Either<Failure, SellerApplicationEntity?>>> call() {
    return _repository.getMySellerApplication().then((result) => Right(result));
  }
}
