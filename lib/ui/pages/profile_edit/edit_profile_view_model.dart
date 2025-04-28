import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../app/app_providers.dart';
import '../../../core/utils/geolocator_util.dart';
import '../../../data/model/app_user.dart';
import 'package:geolocator/geolocator.dart';

import '../../user_global_view_model.dart';

class EditProfileState {
  final bool isSaving;
  final String? district;
  final GeoPoint? location;

  const EditProfileState({
    this.isSaving = false,
    this.district,
    this.location,
  });

  EditProfileState copyWith({
    bool? isSaving,
    String? district,
    GeoPoint? location,
  }) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      district: district ?? this.district,
      location: location ?? this.location,
    );
  }
}

class EditProfileViewModel extends AutoDisposeFamilyNotifier<EditProfileState, AppUser> {
  late final AppUser baseUser;

  @override
  EditProfileState build(AppUser user) {
    baseUser = user;
    return EditProfileState(
      district: user.district,
      location: user.location,
    );
  }

  Future<void> saveProfile(AppUser updatedUser) async {
    state = state.copyWith(isSaving: true);
    try {
      await ref.read(userRepositoryProvider).saveUserProfile(updatedUser);
      ref.read(userGlobalViewModelProvider.notifier).setUser(updatedUser);
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<void> refreshDistrict() async {
    final (locationStatus, position) = await GeolocatorUtil.getPosition();
    if (locationStatus == LocationStatus.success && position != null) {
      final locationRepository = ref.read(locationRepositoryProvider);
      final district = await locationRepository.getDistrictByLocation(
        position.longitude,
        position.latitude,
      );
      state = state.copyWith(
        district: district,
        location: GeoPoint(position.latitude, position.longitude),
      );
    }
  }
}

final editProfileViewModelProvider =
NotifierProvider.autoDispose.family<EditProfileViewModel, EditProfileState, AppUser>(
  EditProfileViewModel.new,
);
