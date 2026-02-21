import 'dart:io';

import 'package:bazar/core/services/storage/user_session_service.dart';
import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:bazar/features/sellerApplication/domain/usecases/create_seller_application_usecase.dart';
import 'package:bazar/features/sellerApplication/domain/usecases/get_my_seller_application_usecase.dart';
import 'package:bazar/features/sellerApplication/domain/usecases/upload_seller_document_usecase.dart';
import 'package:bazar/features/sellerApplication/presentation/state/seller_application_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sellerApplicationViewModelProvider =
    NotifierProvider<SellerApplicationViewModel, SellerApplicationState>(
      SellerApplicationViewModel.new,
    );

class SellerApplicationViewModel extends Notifier<SellerApplicationState> {
  late final CreateSellerApplicationUsecase _createSellerApplicationUsecase;
  late final GetMySellerApplicationUsecase _getMySellerApplicationUsecase;
  late final UploadSellerDocumentUsecase _uploadSellerDocumentUsecase;
  late final UserSessionService _sessionService;
  String? _activeUserId;

  @override
  SellerApplicationState build() {
    _createSellerApplicationUsecase = ref.read(
      createSellerApplicationUsecaseProvider,
    );
    _getMySellerApplicationUsecase = ref.read(
      getMySellerApplicationUsecaseProvider,
    );
    _uploadSellerDocumentUsecase = ref.read(
      uploadSellerDocumentUsecaseProvider,
    );
    _sessionService = ref.read(userSessionServiceProvider);
    return const SellerApplicationState();
  }

  Future<void> fetchMyApplication({bool forceRefresh = false}) async {
    final currentUserId = _sessionService.getCurrentUserId();
    if (currentUserId == null || currentUserId.isEmpty) {
      state = const SellerApplicationState(
        hasFetched: true,
        errorMessage: 'User session not found. Please login again.',
      );
      return;
    }

    if (_activeUserId != currentUserId) {
      _activeUserId = currentUserId;
      state = const SellerApplicationState();
      forceRefresh = true;
    }

    if (state.isLoading) return;
    if (!forceRefresh && state.hasFetched) return;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getMySellerApplicationUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          hasFetched: true,
          errorMessage: failure.message,
        );
      },
      (application) {
        state = state.copyWith(
          isLoading: false,
          hasFetched: true,
          application: application,
          clearError: true,
        );
      },
    );
  }

  Future<bool> submitApplication({
    required String businessName,
    required String categoryName,
    required String businessPhone,
    required String businessAddress,
    String? description,
    String? documentUrl,
    String? documentFilePath,
  }) async {
    if (state.isSubmitting) return false;

    final userId = _sessionService.getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      state = state.copyWith(
        errorMessage: 'User session not found. Please login again.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    String? finalDocumentUrl = documentUrl?.trim().isEmpty ?? true
        ? null
        : documentUrl?.trim();

    if (documentFilePath != null && documentFilePath.trim().isNotEmpty) {
      final uploadResult = await _uploadSellerDocumentUsecase(
        File(documentFilePath.trim()),
      );

      final uploadFailed = uploadResult.fold(
        (failure) {
          state = state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
          );
          return true;
        },
        (uploadedUrl) {
          finalDocumentUrl = uploadedUrl;
          return false;
        },
      );

      if (uploadFailed) return false;
    }

    final application = SellerApplicationEntity(
      userId: userId,
      businessName: businessName.trim(),
      categoryName: categoryName.trim(),
      businessPhone: businessPhone.trim(),
      businessAddress: businessAddress.trim(),
      description: description?.trim().isEmpty ?? true
          ? null
          : description?.trim(),
      documentUrl: finalDocumentUrl,
      status: SellerApplicationStatus.pending,
      adminRemark: null,
    );

    final result = await _createSellerApplicationUsecase(
      CreateSellerApplicationParams(application: application),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (createdApplication) {
        state = state.copyWith(
          isSubmitting: false,
          hasFetched: true,
          application: createdApplication,
          clearError: true,
        );
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void resetState() {
    _activeUserId = null;
    state = const SellerApplicationState();
  }
}
