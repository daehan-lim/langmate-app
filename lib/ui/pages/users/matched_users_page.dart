import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/users/widgets/user_list_item.dart';

import '../../../app/app_providers.dart';
import '../../../core/utils/ui_util.dart';
import '../../../data/model/app_user.dart';
import '../../widgets/message_layout.dart';
import 'matched_users_view_model.dart';

class MatchedUsersPage extends StatelessWidget {
  const MatchedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authService = ref.read(authServiceProvider);
        final users = ref.watch(matchedUsersViewModelProvider);
        return Column(
          children: [
            AppBar(
              title: Text('주변 파트너 찾기'),
              actions: [UIUtil.buildLogOutIconButton(context, authService)],
            ),
            users.when(
              loading:
                  () => const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
              error:
                  (error, StackTrace _) => MessageLayout(
                    message: error.toString(),
                    imageUrl: 'assets/images/connection_error.png',
                  ),
              data: (state) {
                if (state.isEmpty) {
                  return MessageLayout(
                    message: '검색 결과가 없습니다',
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
