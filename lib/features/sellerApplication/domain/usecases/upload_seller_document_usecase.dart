import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/sellerApplication/data/repositories/seller_application_repository.dart';
import 'package:bazar/features/sellerApplication/domain/repositories/seller_application_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadSellerDocumentUsecaseProvider =
    Provider<UploadSellerDocumentUsecase>((ref) {
      final repository = ref.read(sellerApplicationRepositoryProvider);
      return UploadSellerDocumentUsecase(repository: repository);
    });

class UploadSellerDocumentUsecase implements UsecaseWithParams<String, File> {
  final ISellerApplicationRepository _repository;

  UploadSellerDocumentUsecase({
    required ISellerApplicationRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uploadSellerDocument(params);
  }
}
