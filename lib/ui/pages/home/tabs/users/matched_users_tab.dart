import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/tabs/users/widgets/user_list_item.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import '../../../../../app/app_providers.dart';
import '../../../../../core/utils/ui_util.dart';
import '../../../../../data/model/app_user.dart';
import '../../../../widgets/feedback_layout.dart';
import '../../../../widgets/logout_icon_button.dart';
import 'matched_users_view_model.dart';

class MatchedUsersTab extends StatelessWidget {
  const MatchedUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final users = ref.watch(matchedUsersViewModelProvider);
        final appUser = ref.watch(userGlobalViewModelProvider);
        print(appUser?.name);
        return Column(
          children: [
            AppBar(
              title: Text('주변 파트너 찾기'),
              actions: [LogoutIconButton(authService: ref.read(authServiceProvider)),],
            ),
            users.when(
              loading:
                  () => const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
              error:
                  (error, StackTrace _) => FeedbackLayout(
                    message: error.toString(),
                    imageUrl: 'assets/images/connection_error.png',
                  ),
              data: (state) {
                if (state.isEmpty) {
                  return FeedbackLayout(
                    message: '이 지역에는 아직 연결할 수 있는 사용자가 없습니다',
                    imageUrl: 'assets/images/no_results.png',
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 5,
                      bottom: 100,
                    ),
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final AppUser user = state[index];
                      return UserListItem(user);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
