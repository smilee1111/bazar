import 'package:bazar/core/models/geocoding_result.dart';
import 'package:dio/dio.dart';

class GeocodingService {
  GeocodingService({Dio? dio}) : _dio = dio ?? Dio();

  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _headers = {'User-Agent': 'BazarApp/1.0'};

  final Dio _dio;

  Future<List<GeocodingResult>> searchLocation(String query) async {
    if (query.trim().length < 3) return const [];

    try {
      final response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'q': query.trim(),
          'format': 'json',
          'limit': '5',
          'addressdetails': '1',
        },
        options: Options(headers: _headers),
      );

      final data = response.data;
      if (data is! List) return const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(GeocodingResult.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/reverse',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
        options: Options(headers: _headers),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      if (data['error'] != null) return null;
      final display = data['display_name'];
      return display is String && display.isNotEmpty ? display : null;
    } catch (_) {
      return null;
    }
  }
}
