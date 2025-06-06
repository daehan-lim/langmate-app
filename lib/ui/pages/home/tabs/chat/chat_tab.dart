import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/tabs/chat/widgets/chat_tab_list_view.dart';
import 'package:lang_mate/ui/widgets/logout_icon_button.dart';

import '../../../../../app/app_providers.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            AppBar(
              title: Text('채팅'),
              actions: [
                LogoutIconButton(authService: ref.read(authServiceProvider)),
              ],
            ),
            ChatTabListView(),
          ],
        );
      },
    );
  }
}
