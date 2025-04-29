import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/repository/user_repository.dart';
import '../data/repository/location_repository.dart';
import '../data/repository/chat_repository.dart';
import '../ui/pages/welcome/welcome_view_model.dart';
import '../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ui/pages/auth/login_view_model.dart';

/// 인증 서비스 프로바이더
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// 인증 상태 프로바이더
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// 로그인 뷰모델 프로바이더
final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

/// 위치 저장소 프로바이더 - 다른 프로바이더보다 먼저 정의
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryFirebase();
});

/// 환영 화면 관련 프로바이더
final welcomeViewModelProvider =
    NotifierProvider<WelcomeViewModel, WelcomeState>(WelcomeViewModel.new);

/// 채팅 저장소 프로바이더
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryFirebase(ref.read(userRepositoryProvider));
});

// // 채팅 화면 관련 프로바이더
// final chatViewModelProvider = AutoDisposeNotifierProvider<ChatViewModel, ChatState>(
//   ChatViewModel.new,
// );

// 채팅 스트림 프로바이더
// final chatStreamProvider = StreamProvider.family<List<MessageOriginal>, String>((
//   ref,
//   address,
// ) {
//   final repository = ref.watch(chatRepositoryProvider);
//   return repository.getChatsByAddress(address);
// });
