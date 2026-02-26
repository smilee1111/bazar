import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<LatLng?> getCurrentLocation() async {
    final hasPermission = await _checkAndRequestPermission();
    if (!hasPermission) return null;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  Future<bool> _checkAndRequestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Stream<LatLng?> watchLocation({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
    int distanceFilter = 12,
  }) async* {
    final hasPermission = await _checkAndRequestPermission();
    if (!hasPermission) {
      yield null;
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      yield null;
      return;
    }

    final settings = LocationSettings(
      accuracy: desiredAccuracy,
      distanceFilter: distanceFilter,
    );
    yield* Geolocator.getPositionStream(locationSettings: settings).map(
      (position) => LatLng(position.latitude, position.longitude),
    );
  }
}
