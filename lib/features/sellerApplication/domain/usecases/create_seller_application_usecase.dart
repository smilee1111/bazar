import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/sellerApplication/data/repositories/seller_application_repository.dart';
import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:bazar/features/sellerApplication/domain/repositories/seller_application_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSellerApplicationParams extends Equatable {
  final SellerApplicationEntity application;

  const CreateSellerApplicationParams({required this.application});

  @override
  List<Object?> get props => [application];
}

// Provider
final createSellerApplicationUsecaseProvider =
    Provider<CreateSellerApplicationUsecase>((ref) {
  final repository = ref.read(sellerApplicationRepositoryProvider);
  return CreateSellerApplicationUsecase(repository: repository);
});

class CreateSellerApplicationUsecase
    implements UsecaseWithParams<SellerApplicationEntity, CreateSellerApplicationParams> {
  final ISellerApplicationRepository _repository;

  CreateSellerApplicationUsecase({required ISellerApplicationRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, SellerApplicationEntity>> call(CreateSellerApplicationParams params) {
    return _repository.createSellerApplication(params.application);
  }
}
