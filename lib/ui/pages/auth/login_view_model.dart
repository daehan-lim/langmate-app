import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_providers.dart';
import '../../../data/model/app_user.dart';
import '../../user_global_view_model.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;

  const LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<void> signInAndPrepareUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final firebaseUser = await _signInWithGoogle();
      if (firebaseUser == null) {   // Could not log in
        state = state.copyWith(isLoading: false);
        // Exception throw 하지 않으면 로그인했다가 로가웃 하면 로그인 버튼 누르다가 취소히면
        // 로그인이 바로 되는 오류 고치기 위해 임시적으로 다시 throw 구현
        throw Exception('로그인에 실패했습니다. 다시 시도해 주세요');
        /*// 취소는 오류가 아니므로 예외를 던지지 않음
        return;*/
      }

      final userRepository = ref.read(userRepositoryProvider);
      final userGlobalViewModel = ref.read(userGlobalViewModelProvider.notifier);
      final partialUser = _buildPartialAppUser(firebaseUser);
      userGlobalViewModel.setUser(partialUser);

      final fullUser = await userRepository.getUserById(partialUser.id);
      if (fullUser != null) {  // User exists in backend
        print("기존의 사용자 - Firestore에서 정보 가져옴");
        userGlobalViewModel.setUser(fullUser);
      } else {  // User is new sign up. Add to backend
        print("신규 사용자 - Firestore에 기본 정보 저장");
        await userRepository.createUserIfNotExists(partialUser);
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      print("로그인 과정 중 오류: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인에 실패했습니다. 다시 시도해 주세요',
      );
      rethrow;
    }
  }

  Future<User?> _signInWithGoogle() async {
    final authService = ref.read(authServiceProvider);
    final credential = await authService.signInWithGoogle();
    return credential?.user;
  }

  AppUser _buildPartialAppUser(User firebaseUser) {
    return AppUser(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      createdAt: DateTime.now(),
      profileImage: firebaseUser.photoURL,
      email: firebaseUser.email ?? '',
    );
  }
}