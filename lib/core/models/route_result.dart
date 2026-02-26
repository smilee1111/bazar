import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class RouteResult extends Equatable {
  final double distanceMeters;
  final double durationSeconds;
  final List<LatLng> points;

  const RouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.points,
  });

  String get distanceKm => (distanceMeters / 1000).toStringAsFixed(2);
  String get durationMin => (durationSeconds / 60).toStringAsFixed(0);

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final rawPoints = (geometry is Map<String, dynamic>)
        ? geometry['coordinates']
        : null;
    final points = <LatLng>[];

    if (rawPoints is List) {
      for (final item in rawPoints) {
        if (item is List && item.length >= 2) {
          final lng = (item[0] as num).toDouble();
          final lat = (item[1] as num).toDouble();
          points.add(LatLng(lat, lng));
        }
      }
    }

    return RouteResult(
      distanceMeters: (json['distance'] as num?)?.toDouble() ?? 0,
      durationSeconds: (json['duration'] as num?)?.toDouble() ?? 0,
      points: points,
    );
  }

  @override
  List<Object?> get props => [distanceMeters, durationSeconds, points];
}
