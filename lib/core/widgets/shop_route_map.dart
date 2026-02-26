import 'package:bazar/core/models/route_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShopRouteMap extends StatelessWidget {
  const ShopRouteMap({
    super.key,
    required this.shopLocation,
    this.userLocation,
    this.route,
    this.height = 280,
  });

  final LatLng shopLocation;
  final LatLng? userLocation;
  final RouteResult? route;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(initialCenter: shopLocation, initialZoom: 14),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.muskan.bazar',
          ),
          if (route != null && route!.points.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: route!.points,
                  strokeWidth: 4,
                  color: Colors.red,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: shopLocation,
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 34,
                  color: Colors.redAccent,
                ),
              ),
              if (userLocation != null)
                Marker(
                  width: 40,
                  height: 40,
                  point: userLocation!,
                  child: const Icon(
                    Icons.my_location_rounded,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
