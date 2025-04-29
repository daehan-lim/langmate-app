import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import '../../chat_global_view_model.dart';

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

final homeViewModelProvider = NotifierProvider.autoDispose<HomeViewModel, int>(
  HomeViewModel.new,
);
