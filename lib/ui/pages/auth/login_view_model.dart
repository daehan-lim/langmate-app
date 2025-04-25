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
      if (firebaseUser == null) {
        state = state.copyWith(isLoading: false);
        // 취소는 오류가 아니므로 예외를 던지지 않음
        return;
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
  Future<bool> _checkUserExistsInFirestore(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists;
  }

  Future<void> _loadFullProfileToGlobal(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final fullUser = AppUser.fromMap(uid, doc.data()!);
      ref.read(userGlobalViewModelProvider.notifier).setUser(fullUser);
    }
  }
}