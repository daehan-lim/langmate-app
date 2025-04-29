import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/tabs/chat/chat_tab.dart';
import 'package:lang_mate/ui/pages/home/tabs/users/matched_users_tab.dart';
import 'package:lang_mate/ui/pages/home/widgets/home_bottom_navigation_bar.dart';
import 'package:lang_mate/ui/pages/profile/user_profile_page.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HomeBottomNavigationBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final currentIndex = ref.watch(homeViewModelProvider);
          final currentUser = ref.read(userGlobalViewModelProvider);

          return IndexedStack(
            index: currentIndex,
            children: [
              MatchedUsersTab(),
              ChatTab(),
              UserProfilePage(
                user: currentUser!,
                isCurrentUser: true, // 내 프로필임을 표시
              ),
            ],
          );
        },
      ),
    );
  }
}
