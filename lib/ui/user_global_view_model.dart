import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/app_user.dart';

class UserGlobalViewModel extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  void setUser(AppUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final userGlobalViewModelProvider =
    NotifierProvider<UserGlobalViewModel, AppUser?>(UserGlobalViewModel.new);
