import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/app_providers.dart';
import '../../../core/utils/geolocator_util.dart';
import '../../../data/model/app_user.dart';
import '../../user_global_view_model.dart';

class EditProfileState {
  final bool isSaving;
  final String? district;
  final GeoPoint? location;
  final String? profileImageUrl;
  final bool isUploadingImage;

  const EditProfileState({
    this.isSaving = false,
    this.district,
    this.location,
    this.profileImageUrl,
    this.isUploadingImage = false,
  });

  EditProfileState copyWith({
    bool? isSaving,
    String? district,
    GeoPoint? location,
    String? profileImageUrl,
    bool? isUploadingImage,
  }) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      district: district ?? this.district,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
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
      profileImageUrl: user.profileImage,
    );
  }

  Future<void> saveProfile(AppUser updatedUser) async {
    state = state.copyWith(isSaving: true);
    try {
      // 이미지가 업데이트되었으면 이를 포함
      final finalUser = state.profileImageUrl != baseUser.profileImage
          ? updatedUser.copyWith(profileImage: state.profileImageUrl)
          : updatedUser;

      await ref.read(userRepositoryProvider).saveUserProfile(finalUser);
      ref.read(userGlobalViewModelProvider.notifier).setUser(finalUser);
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow; // 에러를 UI에서 처리할 수 있도록 다시 던짐
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

  Future<void> updateProfileImage(XFile imageFile) async {
    try {
      state = state.copyWith(isUploadingImage: true);

      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      final imageRef = storageRef.child(
        'profile_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}',
      );

      await imageRef.putFile(File(imageFile.path));
      final imageUrl = await imageRef.getDownloadURL();

      state = state.copyWith(
        profileImageUrl: imageUrl,
        isUploadingImage: false,
      );
    } catch (e) {
      state = state.copyWith(isUploadingImage: false);
      rethrow;
    }
  }
}

final editProfileViewModelProvider =
NotifierProvider.autoDispose.family<EditProfileViewModel, EditProfileState, AppUser>(
  EditProfileViewModel.new,
);