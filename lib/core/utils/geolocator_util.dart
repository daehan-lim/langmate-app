import 'package:geolocator/geolocator.dart';

class GeolocatorUtil {
  static Future<Position?> getPosition() async {
    final checkPermission = await Geolocator.checkPermission();
    if (checkPermission == LocationPermission.denied ||
        checkPermission == LocationPermission.deniedForever) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied ||
          requestPermission == LocationPermission.deniedForever) {
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
    return position;
  }
}
