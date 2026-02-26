class GeocodingResult {
  final String displayName;
  final double latitude;
  final double longitude;

  const GeocodingResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    return GeocodingResult(
      displayName: (json['display_name'] ?? '').toString(),
      latitude: double.parse((json['lat'] ?? '0').toString()),
      longitude: double.parse((json['lon'] ?? '0').toString()),
    );
  }
}
