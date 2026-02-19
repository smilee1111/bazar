import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/sellerApplication/data/models/seller_application_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class ISellerApplicationRemoteDataSource {
  Future<SellerApplicationApiModel> createSellerApplication(SellerApplicationApiModel model);
  Future<SellerApplicationApiModel?> getMySellerApplication();
}

final sellerApplicationRemoteProvider =
    Provider<ISellerApplicationRemoteDataSource>((ref) {
  return SellerApplicationRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class SellerApplicationRemoteDatasource implements ISellerApplicationRemoteDataSource {
  final ApiClient _apiClient;

  SellerApplicationRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<SellerApplicationApiModel> createSellerApplication(SellerApplicationApiModel model) async {
    final response = await _apiClient.post(ApiEndpoints.sellerApplications, data: model.toJson());
    final data = response.data['data'] as Map<String, dynamic>;
    return SellerApplicationApiModel.fromJson(data);
  }

  @override
  Future<SellerApplicationApiModel?> getMySellerApplication() async {
    final response = await _apiClient.get(ApiEndpoints.sellerApplications + '/my');
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return SellerApplicationApiModel.fromJson(data);
    }
    return null;
  }
}
