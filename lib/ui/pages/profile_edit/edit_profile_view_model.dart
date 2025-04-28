import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../data/model/app_user.dart';

class EditProfileViewModel extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> saveProfile(AppUser updatedUser) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).saveUserProfile(updatedUser);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError('저장 실패', StackTrace.current);
    }
  }
}

final editProfileViewModelProvider =
AutoDisposeNotifierProvider<EditProfileViewModel, AsyncValue<void>>(
  EditProfileViewModel.new,
);
