import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../app/constants/app_constants.dart';


class HomeViewModel extends Notifier<AsyncValue<int>> {
  @override
  AsyncValue<int> build() {
    throw UnimplementedError();
  }
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, AsyncValue<int>>(HomeViewModel.new);
