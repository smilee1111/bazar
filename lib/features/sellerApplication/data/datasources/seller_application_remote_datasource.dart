import 'dart:io';

import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/sellerApplication/data/models/seller_application_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class ISellerApplicationRemoteDataSource {
  Future<SellerApplicationApiModel> createSellerApplication(
    SellerApplicationApiModel model,
  );
  Future<SellerApplicationApiModel?> getMySellerApplication();
  Future<String> uploadSellerDocument(File document);
}

final sellerApplicationRemoteProvider =
    Provider<ISellerApplicationRemoteDataSource>((ref) {
      return SellerApplicationRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class SellerApplicationRemoteDatasource
    implements ISellerApplicationRemoteDataSource {
  final ApiClient _apiClient;

  SellerApplicationRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<SellerApplicationApiModel> createSellerApplication(
    SellerApplicationApiModel model,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.sellerApplications,
      data: model.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return SellerApplicationApiModel.fromJson(data);
  }

  @override
  Future<SellerApplicationApiModel?> getMySellerApplication() async {
    final response = await _apiClient.get(ApiEndpoints.mySellerApplication);
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return SellerApplicationApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<String> uploadSellerDocument(File document) async {
    final fileName = document.path.split('/').last;
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(
        document.path,
        filename: fileName,
      ),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.sellerApplicationUploadDocument,
      formData: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        final url = data['documentUrl'] ?? data['url'] ?? data['fileUrl'];
        if (url is String && url.isNotEmpty) return url;
      }

      final directUrl =
          payload['documentUrl'] ?? payload['url'] ?? payload['fileUrl'];
      if (directUrl is String && directUrl.isNotEmpty) return directUrl;
    }

    throw Exception('Document upload succeeded but URL was not returned.');
  }
}
