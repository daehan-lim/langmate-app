// lib/app/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/location_repository.dart';
import '../ui/pages/chat/chat_view_model.dart';
import '../ui/pages/home/welcome/welcome_view_model.dart';
import '../ui/pages/home/home_view_model.dart';

/// 앱에서 사용되는 공통 프로바이더들을 모아둡니다.
/// 이 파일을 통해 앱 전체에서 사용되는 프로바이더를 쉽게 관리할 수 있습니다.

// 위치 저장소 프로바이더 - 다른 프로바이더보다 먼저 정의
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

// 홈 화면 관련 프로바이더
final homeViewModelProvider = NotifierProvider<HomeViewModel, AsyncValue<int>>(
  HomeViewModel.new,
);

// 환영 화면 관련 프로바이더
final welcomeViewModelProvider =
    NotifierProvider<WelcomeViewModel, WelcomeState>(WelcomeViewModel.new);

// 채팅 화면 관련 프로바이더
final chatViewModelProvider = NotifierProvider<ChatViewModel, ChatState>(
  ChatViewModel.new,
);
