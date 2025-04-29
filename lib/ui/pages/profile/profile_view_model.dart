import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/app/app_providers.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

class ProfileState {
  final bool isEditingLanguage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final bool isSaving;

  ProfileState({
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

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState();
  }

  void setEditingLanguage(bool isEditing) {
    state = state.copyWith(isEditingLanguage: isEditing);
  }

  void setNativeLanguage(String language) {
    state = state.copyWith(nativeLanguage: language);
  }

  void setTargetLanguage(String language) {
    state = state.copyWith(targetLanguage: language);
  }

  void resetLanguages() {
    state = state.copyWith(nativeLanguage: null, targetLanguage: null);
  }

  Future<void> saveLanguages(BuildContext context, AppUser user) async {
    if (state.nativeLanguage == null || state.targetLanguage == null) {
      return;
    }

    state = state.copyWith(isSaving: true);

    try {
      final updatedUser = user.copyWith(
        nativeLanguage: state.nativeLanguage,
        targetLanguage: state.targetLanguage,
      );

      // Save to repository
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserProfile(updatedUser);

      // Update global user state
      ref.read(userGlobalViewModelProvider.notifier).setUser(updatedUser);

      // Reset state
      state = state.copyWith(isEditingLanguage: false, isSaving: false);

      SnackbarUtil.showSnackBar(context, '언어 설정이 저장되었습니다.');
    } catch (e) {
      state = state.copyWith(isSaving: false);
      SnackbarUtil.showSnackBar(context, '저장 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);
