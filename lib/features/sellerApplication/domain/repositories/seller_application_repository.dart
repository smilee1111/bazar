import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ISellerApplicationRepository {
  /// Create a new seller application (User applies)
  Future<Either<Failure, SellerApplicationEntity>> createSellerApplication(
    SellerApplicationEntity application,
  );

  /// Get current logged-in user's seller application
  Future<Either<Failure, SellerApplicationEntity?>> getMySellerApplication();

  /// Upload a seller verification document and get hosted URL
  Future<Either<Failure, String>> uploadSellerDocument(File document);
}
