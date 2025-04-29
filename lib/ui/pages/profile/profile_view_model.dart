import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/app_providers.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

// 프로필 페이지의 상태를 관리하는 클래스
class ProfileState {
  final bool isEditingLanguage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final bool isSaving;

  const ProfileState({
    this.isEditingLanguage = false,
    this.nativeLanguage,
    this.targetLanguage,
    this.isSaving = false,
  });

  ProfileState copyWith({
    bool? isEditingLanguage,
    String? nativeLanguage,
    String? targetLanguage,
    bool? isSaving,
  }) {
    return ProfileState(
      isEditingLanguage: isEditingLanguage ?? this.isEditingLanguage,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// Riverpod Notifier 클래스로 상태 관리
class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    // 초기 상태 반환
    return const ProfileState();
  }

  // 언어 편집 모드 설정
  void setEditingLanguage(bool isEditing) {
    state = state.copyWith(isEditingLanguage: isEditing);
  }

  // 모국어 설정
  void setNativeLanguage(String language) {
    state = state.copyWith(nativeLanguage: language);
  }

  // 학습 언어 설정
  void setTargetLanguage(String language) {
    state = state.copyWith(targetLanguage: language);
  }

  // 언어 설정 초기화
  void resetLanguages() {
    state = state.copyWith(nativeLanguage: null, targetLanguage: null);
  }

  // 언어 저장
  Future<void> saveLanguages(BuildContext context, AppUser user) async {
    try {
      // 로딩 상태로 변경
      state = state.copyWith(isSaving: true);

      // 사용자 데이터 업데이트
      final updatedUser = user.copyWith(
        nativeLanguage: state.nativeLanguage,
        targetLanguage: state.targetLanguage,
      );

      // 사용자 정보 저장
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserProfile(updatedUser);

      // 글로벌 사용자 상태 업데이트
      ref.read(userGlobalViewModelProvider.notifier).setUser(updatedUser);

      // 성공 메시지
      SnackbarUtil.showSnackBar(context, '언어 설정이 저장되었습니다');

      // 편집 모드 종료 및 로딩 상태 해제
      state = state.copyWith(isEditingLanguage: false, isSaving: false);
    } catch (e) {
      // 오류 처리
      SnackbarUtil.showSnackBar(context, '언어 설정 저장 중 오류가 발생했습니다');
      state = state.copyWith(isSaving: false);
    }
  }
}

// 프로필 뷰모델 프로바이더
final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);
