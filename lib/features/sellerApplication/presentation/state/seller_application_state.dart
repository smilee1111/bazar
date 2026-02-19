import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:equatable/equatable.dart';

class SellerApplicationState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool hasFetched;
  final SellerApplicationEntity? application;
  final String? errorMessage;

  const SellerApplicationState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.hasFetched = false,
    this.application,
    this.errorMessage,
  });

  SellerApplicationState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? hasFetched,
    SellerApplicationEntity? application,
    bool clearApplication = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SellerApplicationState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasFetched: hasFetched ?? this.hasFetched,
      application: clearApplication ? null : (application ?? this.application),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get canApply {
    if (application == null) return true;
    return application!.status == SellerApplicationStatus.rejected;
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        hasFetched,
        application,
        errorMessage,
      ];
}
