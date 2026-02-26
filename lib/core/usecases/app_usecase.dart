import 'package:bazar/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}

/// Params for paginated requests.
class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({this.page = 1, this.limit = 15});

  @override
  String toString() => 'PaginationParams(page: $page, limit: $limit)';
}