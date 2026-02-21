import 'dart:io';

import 'package:bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:bazar/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:bazar/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:bazar/core/services/storage/user_session_service.dart';
import 'package:bazar/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);


class AuthViewModel extends Notifier<AuthState>{
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;
  late final RequestPasswordResetUsecase _requestPasswordResetUsecase;
  late final VerifyResetOtpUsecase _verifyResetOtpUsecase;
  late final ResetPasswordUsecase _resetPasswordUsecase;


  @override
  AuthState build() {

    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    _requestPasswordResetUsecase = ref.read(requestPasswordResetUsecaseProvider);
    _verifyResetOtpUsecase = ref.read(verifyResetOtpUsecaseProvider);
    _resetPasswordUsecase = ref.read(resetPasswordUsecaseProvider);
    return const AuthState();
  }

   Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _registerUsecase(
      RegisterParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    result.fold(
      (failure) {
        print('Registration failed: ${failure.message}');
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        print('Registration success!');
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<bool> requestPasswordReset({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _requestPasswordResetUsecase(
      RequestPasswordResetParams(email: email.trim()),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.loaded, errorMessage: null);
        return success;
      },
    );
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _resetPasswordUsecase(
      ResetPasswordParams(token: token.trim(), newPassword: newPassword),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.loaded, errorMessage: null);
        return success;
      },
    );
  }

  Future<bool> verifyResetOtp({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _verifyResetOtpUsecase(
      VerifyResetOtpParams(
        email: email.trim(),
        otp: otp.trim(),
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.loaded, errorMessage: null);
        return success;
      },
    );
  }


    Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

   Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<String?> uploadPhoto(File profilePic) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _uploadPhotoUsecase(profilePic);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        final updatedUser = _copyUserWithProfilePic(url);
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadedPhotoUrl: url,
          user: updatedUser ?? state.user,
        );
        return url;
      },
    );
  }

  AuthEntity? _copyUserWithProfilePic(String profilePicUrl) {
    final user = state.user;
    if (user == null) return null;
    return AuthEntity(
      authId: user.authId,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      username: user.username,
      password: user.password,
      profilePic: profilePicUrl,
      roleId: user.roleId,
      role: user.role,
    );
  }

  Future<bool> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
    required String username,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final current = state.user;
    AuthEntity? baseUser = current;
    if (baseUser == null) {
      // Try to rebuild a minimal user from persisted session so updates still work after restart
      final session = ref.read(userSessionServiceProvider);
      final userId = session.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: 'No user available');
        return false;
      }
      baseUser = AuthEntity(
        authId: userId,
        fullName: session.getCurrentUserFullName() ?? '',
        email: session.getCurrentUserEmail() ?? '',
        phoneNumber: session.getCurrentUserPhoneNumber(),
        username: session.getCurrentUserUsername() ?? '',
        password: null,
        profilePic: session.getCurrentUserProfilePic(),
        roleId: session.getCurrentUserRoleId(),
        role: null,
      );
    }

    final updated = AuthEntity(
      authId: baseUser.authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber ?? baseUser.phoneNumber,
      username: username,
      password: baseUser.password,
      profilePic: baseUser.profilePic,
      roleId: baseUser.roleId,
      role: baseUser.role,
    );

    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.updateUser(updated);
      return result.fold((failure) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: failure.message);
        return false;
      }, (success) {
        // update in-memory state and session
        state = state.copyWith(status: AuthStatus.loaded, user: updated);
        final session = ref.read(userSessionServiceProvider);
        // persist session; fire-and-forget to avoid blocking UI
        session.saveUserSession(
          userId: updated.authId ?? '',
          email: updated.email,
          fullName: updated.fullName,
          username: updated.username,
          phoneNumber: updated.phoneNumber,
          roleId: updated.roleId,
          profilePic: updated.profilePic,
        );
        return true;
      });
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
      return false;
    }
  }


  
}
