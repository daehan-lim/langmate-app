import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/tabs/chat/chat_tab.dart';
import 'package:lang_mate/ui/pages/home/tabs/users/matched_users_tab.dart';
import 'package:lang_mate/ui/pages/home/widgets/home_bottom_navigation_bar.dart';
import 'package:lang_mate/ui/widgets/profile_layout.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import '../profile_edit/profile_edit_page.dart';
import 'home_veiw_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeViewModelProvider);
    final currentUser = ref.read(userGlobalViewModelProvider);
    PreferredSizeWidget? appBar;
    if (currentIndex == 2) {
      appBar = AppBar(
        title: const Text('내 프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(user: currentUser!),
                ),
              );
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: const HomeBottomNavigationBar(),
      body: IndexedStack(
        index: currentIndex,
        children: [
          const MatchedUsersTab(),
          const ChatTab(),
          ProfileLayout(user: currentUser!),
        ],
      ),
    );
  }
}
