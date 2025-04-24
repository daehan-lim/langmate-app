import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/tabs/chat/chat_tab.dart';
import 'package:lang_mate/ui/pages/home/widgets/home_bottom_navigation_bar.dart';

import '../users/matched_users_page.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HomeBottomNavigationBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final currentIndex = ref.watch(homeViewModelProvider);
          return IndexedStack(
            index: currentIndex,
            children: [
              MatchedUsersPage(),
              ChatTab(),
              MatchedUsersPage(),
            ],
          );
        },
      ),
    );
  }
}
