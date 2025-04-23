// lib/ui/pages/home/home_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod Notifier 클래스로 상태 관리
class HomeViewModel extends Notifier<AsyncValue<int>> {
  @override
  AsyncValue<int> build() {
    // 초기 상태를 설정합니다 (데이터 0으로 초기화)
    return const AsyncValue.data(0);
  }

  // 카운터 증가 메서드 (예시)
  void increment() {
    // 현재 상태가 로딩 중이거나 에러 상태면 무시
    if (state is AsyncLoading || state is AsyncError) return;

    // 현재 데이터 값을 가져옵니다
    final currentValue = state.value ?? 0;

    // 새 값으로 상태를 업데이트합니다
    state = AsyncValue.data(currentValue + 1);
  }
}

// 프로바이더는 app_providers.dart 파일에서 정의
