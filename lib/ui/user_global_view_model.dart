import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/model/app_user.dart';

class UserGlobalViewModel extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  void setUser(AppUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  /// Calculates the distance in kilometers between the user's location and [otherLocation].
  /// Returns a formatted string like "3.2 km".
  String? calculateDistanceFrom(GeoPoint? otherLocation) {
    final userLocation = state?.location;

    if (userLocation == null || otherLocation == null) return null;

    final distanceInMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      otherLocation.latitude,
      otherLocation.longitude,
    );

    final distanceInKm = distanceInMeters / 1000;
    return '${distanceInKm.toStringAsFixed(1)} km';
  }
}

final userGlobalViewModelProvider =
    NotifierProvider<UserGlobalViewModel, AppUser?>(UserGlobalViewModel.new);
