import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/geolocator_util.dart';
import '../../../../../data/repository/location_repository.dart';
import '../../../../../app/app_providers.dart';

// 환영 페이지의 상태를 관리하는 클래스
class WelcomeState {
  final String? username;
  final String? location;
  final bool isLoading;
  final String? errorMessage;
  final String? nativeLanguage; //나의언어
  final String? targetLanguage; //배울언어

  const WelcomeState({
    this.username,
    this.location,
    this.isLoading = false,
    this.errorMessage,
    this.nativeLanguage,
    this.targetLanguage,
  });

  WelcomeState copyWith({
    String? username,
    String? location,
    bool? isLoading,
    String? errorMessage,
    String? nativeLanguage,
    String? targetLanguage,
  }) {
    return WelcomeState(
      username: username ?? this.username,
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // 에러 메시지는 null로 재설정할 수 있도록 ?? 연산자 사용하지 않음
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }
}

// Riverpod Notifier 클래스로 상태 관리
class WelcomeViewModel extends Notifier<WelcomeState> {
  @override
  WelcomeState build() {
    // 간단한 초기 상태 반환 - 빈 값으로 시작
    return const WelcomeState();
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

      final position = await GeolocatorUtil.getPosition();
      if (position == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.',
        );
        return;
      }

      // LocationRepository 가져오기
      final locationRepo = ref.read(locationRepositoryProvider);
      final district = await locationRepo.getDistrictByLocation(
        position.longitude,
        position.latitude,
      );

      // 결과 상태 업데이트
      state = state.copyWith(
        location: district ?? '알 수 없는 위치',
        isLoading: false,
      );
    } catch (e) {
      // 오류 상태 업데이트
      state = state.copyWith(
        isLoading: false,
        errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  void setNativeLanguage(String language) {
    state = state.copyWith(nativeLanguage: language);
  }

  void setTargetLanguage(String language) {
    state = state.copyWith(targetLanguage: language);
  }
}

// 프로바이더는 app_providers.dart 파일에서 정의
