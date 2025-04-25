import 'package:cloud_firestore/cloud_firestore.dart';
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

  // 구글 로그인 처리
  Future<void> signInAndPrepareUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final firebaseUser = await _signInWithGoogle();

      if (firebaseUser == null) {
        state = state.copyWith(isLoading: false);
        throw Exception('로그인에 실패했습니다. 다시 시도해 주세요');
      }

      // Build partial user and set to global state
      final partialUser = _buildPartialAppUser(firebaseUser);
      ref.read(userGlobalViewModelProvider.notifier).setUser(partialUser);

      final exists = await _checkUserExistsInFirestore(partialUser.id);
      if (exists) {
        await _loadFullProfileToGlobal(partialUser.id);
      } else {
        print("신규 사용자 - Firestore에 기본 정보 저장");

        await FirebaseFirestore.instance
            .collection('users')
            .doc(partialUser.id)
            .set({
              'name': partialUser.name,
              'profileImage': partialUser.profileImage,
              'email': partialUser.email,
            });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print(e.toString());
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
