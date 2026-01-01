import 'package:bazar/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class UseCaseWithParams<SuccessType,Params>{
  Future<Either<Failure, SuccessType>> call(Params params);

}

abstract interface class UseCaseWithoutParams<SuccessType>{
  Future<Either<Failure, SuccessType>> call();

}