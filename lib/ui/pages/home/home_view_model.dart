// 1. 상태클래스 만들기
// 2. 뷰모델 만들기
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chat_global_view_model.dart';
import '../../user_global_view_model.dart';

class HomeViewModel extends AutoDisposeNotifier<int> {
  @override
  int build() {
    final currentUser = ref.read(userGlobalViewModelProvider);
    if (currentUser != null) {
      ref.read(chatGlobalViewModel.notifier).initialize(currentUser.id);
    }
    return 0;
  }

  void onIndexChanged(int newIndex) {
    state = newIndex;
  }
}

final homeViewModelProvider = AutoDisposeNotifierProvider<HomeViewModel, int>(() {
  return HomeViewModel();
});
