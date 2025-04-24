import 'package:geolocator/geolocator.dart';

enum LocationStatus {
  success,
  deniedTemporarily,
  deniedForever,
  error,
}


class GeolocatorUtil {
  static Future<(LocationStatus, Position?)> getPosition() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final requested = await Geolocator.requestPermission();

        if (requested == LocationPermission.denied) {
          return (LocationStatus.deniedTemporarily, null);
        }

        if (requested == LocationPermission.deniedForever) {
          return (LocationStatus.deniedForever, null);
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      return (LocationStatus.success, position);
    } catch (e) {
      print('위치 정보 가져오기 오류: $e');
      return (LocationStatus.error, null);
    }
  }
}

