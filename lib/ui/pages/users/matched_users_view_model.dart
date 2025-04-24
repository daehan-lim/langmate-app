import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/app_providers.dart';

import '../../../core/exceptions/data_exceptions.dart';
import '../../../data/model/app_user.dart';

class MatchedUsersViewModel extends Notifier<AsyncValue<List<AppUser>>> {
  @override
  AsyncValue<List<AppUser>> build() {
    fetchNearbyUsers();
    return AsyncLoading();
  }

  Future<void> fetchNearbyUsers() async {
    // state = AsyncLoading();
    try {
      List<AppUser> users = await ref
          .read(userRepositoryProvider)
          .getNearbyUsers('1', '은평구');
      state = AsyncData(users);
    } on ApiException catch (e) {
      print(e);
      state = AsyncError('서버에서 오류가 발생했습니다', StackTrace.current);
    } on NetworkException catch (e) {
      print(e.message);
      state = AsyncError(
        '네트워크에 연결할 수 없습니다.\n연결 상태를 확인하고 다시 시도해 주세요.',
        StackTrace.current,
      );
    } catch (e) {
      print(e);
      state = AsyncError('문제가 발생했습니다. 다시 시도해주세요.', StackTrace.current);
    }
  }
}

final matchedUsersViewModelProvider =
    NotifierProvider<MatchedUsersViewModel, AsyncValue<List<AppUser>>>(
      MatchedUsersViewModel.new,
    );
