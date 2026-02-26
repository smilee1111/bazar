import 'dart:async';

import 'package:bazar/core/models/geocoding_result.dart';
import 'package:bazar/core/services/location/location_service.dart';
import 'package:bazar/core/services/maps/geocoding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerMap extends StatefulWidget {
  const LocationPickerMap({
    super.key,
    required this.onChanged,
    this.initialLocation,
    this.height = 300,
  });

  final LatLng? initialLocation;
  final double height;
  final void Function(LatLng location, String? address) onChanged;

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  static const _fallbackLocation = LatLng(27.7172, 85.3240);

  final _searchCtrl = TextEditingController();
  final _mapController = MapController();
  final _geocodingService = GeocodingService();
  final _locationService = LocationService();

  Timer? _debounce;
  LatLng _selected = _fallbackLocation;
  String? _selectedAddress;
  List<GeocodingResult> _results = const [];
  bool _loadingCurrentLocation = false;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation ?? _fallbackLocation;
    if (widget.initialLocation == null) {
      Future.microtask(_loadCurrentLocation);
    } else {
      Future.microtask(() => _notifyLocationChange(_selected));
    }
  }

  Future<void> _loadCurrentLocation() async {
    setState(() => _loadingCurrentLocation = true);
    final current = await _locationService.getCurrentLocation();
    if (!mounted) return;
    setState(() => _loadingCurrentLocation = false);
    if (current == null) return;
    await _selectLocation(current, moveMap: true);
  }

  Future<void> _notifyLocationChange(LatLng point) async {
    final address = await _geocodingService.reverseGeocode(
      latitude: point.latitude,
      longitude: point.longitude,
    );
    if (!mounted) return;
    setState(() {
      _selectedAddress = address;
    });
    widget.onChanged(point, address);
  }

  Future<void> _selectLocation(LatLng point, {bool moveMap = false}) async {
    setState(() {
      _selected = point;
      _results = const [];
    });
    if (moveMap) {
      _mapController.move(point, 15);
    }
    await _notifyLocationChange(point);
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 3) {
      setState(() => _results = const []);
      return;
    }

    setState(() => _searching = true);
    final results = await _geocodingService.searchLocation(query);
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = results;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            labelText: 'Search Location',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searching
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              _search(value);
            });
          },
        ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    result.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    _searchCtrl.text = result.displayName;
                    await _selectLocation(
                      LatLng(result.latitude, result.longitude),
                      moveMap: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selected,
              initialZoom: 13,
              onTap: (_, point) => _selectLocation(point, moveMap: false),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.muskan.bazar',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 42,
                    height: 42,
                    point: _selected,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_loadingCurrentLocation)
          const Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Fetching current location...'),
            ],
          )
        else
          Text(
            _selectedAddress ?? 'Tap map or search location to set exact pin.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
      ],
    );
  }
}
