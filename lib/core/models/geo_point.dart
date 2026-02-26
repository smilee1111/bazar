import 'package:equatable/equatable.dart';

class GeoPoint extends Equatable {
  final double latitude;
  final double longitude;

  const GeoPoint({required this.latitude, required this.longitude});

  factory GeoPoint.fromGeoJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];
    if (coordinates is! List || coordinates.length < 2) {
      throw const FormatException('Invalid GeoJSON coordinates.');
    }

    return GeoPoint(
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
    );
  }

  Map<String, dynamic> toGeoJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
