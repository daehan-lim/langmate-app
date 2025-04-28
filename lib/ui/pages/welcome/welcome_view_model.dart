import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lang_mate/app/constants/app_constants.dart';
import '../../../../../core/utils/geolocator_util.dart';
import '../../../../../app/app_providers.dart';
import '../../../data/model/app_user.dart';
import '../../user_global_view_model.dart';

// 환영 페이지의 상태를 관리하는 클래스
class WelcomeState {
  final String? username;
  final String? location;
  final bool isLoading;
  final String? errorMessage;
  final String? nativeLanguage; // 나의언어
  final String? targetLanguage; // 배울언어
  final String? imageUrl;

  const WelcomeState({
    this.username,
    this.location,
    this.isLoading = false,
    this.errorMessage,
    this.nativeLanguage,
    this.targetLanguage,
    this.imageUrl,
  });

  WelcomeState copyWith({
    String? username,
    String? location,
    bool? isLoading,
    String? errorMessage,
    String? nativeLanguage,
    String? targetLanguage,
    String? imageUrl,
  }) {
    return WelcomeState(
      username: username ?? this.username,
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // 에러 메시지는 null로 재설정할 수 있도록 ?? 연산자 사용하지 않음
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

// Riverpod Notifier 클래스로 상태 관리
class WelcomeViewModel extends Notifier<WelcomeState> {
  @override
  WelcomeState build() {
    // 초기 상태 반환
    return const WelcomeState(nativeLanguage: '선택', targetLanguage: '선택');
  }

  // 사용자 이름 설정
  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  // 위치 정보 가져오기
  Future<void> fetchLocation() async {
    try {
      // 로딩 상태로 변경, 이전 에러 메시지 제거
      state = state.copyWith(isLoading: true, errorMessage: null);

      final (status, position) = await GeolocatorUtil.getPosition();

      switch (status) {
        case LocationStatus.success:
          // LocationRepository 가져오기
          final locationRepo = ref.read(locationRepositoryProvider);
          final district = await locationRepo.getDistrictByLocation(
            position!.longitude,
            position.latitude,
          );

          // 결과 상태 업데이트
          state = state.copyWith(
            location: district ?? '알 수 없는 위치',
            isLoading: false,
          );
          break;

        case LocationStatus.deniedTemporarily:
          state = state.copyWith(
            isLoading: false,
            errorMessage: '위치 권한이 거부되었습니다. 권한을 허용해주세요.',
          );
          break;

        case LocationStatus.deniedForever:
          state = state.copyWith(
            isLoading: false,
            errorMessage: AppConstants.locPermissionDeniedForever,
          );
          break;

        case LocationStatus.error:
          state = state.copyWith(
            isLoading: false,
            errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도해 주세요',
          );
          break;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '위치 정보 처리 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  // 모국어 설정
  void setNativeLanguage(String language) {
    state = state.copyWith(nativeLanguage: language);
  }

  // 배우고자 하는 언어 설정
  void setTargetLanguage(String language) {
    state = state.copyWith(targetLanguage: language);
  }

  void uploadImage(XFile xfile) async {
    try {
      final storage = FirebaseStorage.instance;
      Reference ref = storage.ref();
      Reference fileRef = ref.child(
        '${DateTime.now().microsecondsSinceEpoch}_${xfile.name}',
      );
      print('123');
      await fileRef.putFile(File(xfile.path));
      print('456');
      // 5. 파일에 접근 할 수있는 URL 받기
      String imageUrl = await fileRef.getDownloadURL();
      state = state.copyWith(imageUrl: imageUrl);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUserProfile(AppUser user, String username, String? location) async {
    try {
      // Set loading state
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Create updated user object
      final updatedUser = user.copyWith(
        name: username,
        nativeLanguage: state.nativeLanguage,
        targetLanguage: state.targetLanguage,
        district: location ?? '서울특별시 강남구 청담동',
        profileImage: state.imageUrl,
      );

      // Get user repository and save profile
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserProfile(updatedUser);

      // Update global user state
      ref.read(userGlobalViewModelProvider.notifier).setUser(updatedUser);

      // Reset loading state
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '정보 저장 중 오류가 발생했습니다: ${e.toString()}',
      );
      rethrow;
    }
  }
}
