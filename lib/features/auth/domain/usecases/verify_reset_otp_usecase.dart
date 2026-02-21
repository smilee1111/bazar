import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyResetOtpParams extends Equatable {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  const VerifyResetOtpParams({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword, confirmPassword];
}

final verifyResetOtpUsecaseProvider = Provider<VerifyResetOtpUsecase>((ref) {
  return VerifyResetOtpUsecase(authRepository: ref.read(authRepositoryProvider));
});

class VerifyResetOtpUsecase
    implements UsecaseWithParams<bool, VerifyResetOtpParams> {
  final IAuthRepository _authRepository;

  VerifyResetOtpUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(VerifyResetOtpParams params) {
    return _authRepository.verifyResetOtp(
      email: params.email,
      otp: params.otp,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}
