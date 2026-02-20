import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestPasswordResetParams extends Equatable {
  final String email;

  const RequestPasswordResetParams({required this.email});

  @override
  List<Object?> get props => [email];
}

final requestPasswordResetUsecaseProvider = Provider<RequestPasswordResetUsecase>(
  (ref) {
    return RequestPasswordResetUsecase(
      authRepository: ref.read(authRepositoryProvider),
    );
  },
);

class RequestPasswordResetUsecase
    implements UsecaseWithParams<bool, RequestPasswordResetParams> {
  final IAuthRepository _authRepository;

  RequestPasswordResetUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RequestPasswordResetParams params) {
    return _authRepository.requestPasswordReset(params.email);
  }
}
