import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/core/utils/ui_util.dart';
import 'package:lang_mate/ui/pages/profile_edit/profile_edit_page.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lang_mate/ui/widgets/profile_layout.dart';

import '../../../../../app/app_providers.dart';

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final user = ref.watch(userGlobalViewModelProvider)!;
        return ListView(
          children: [
            AppBar(
              title: Text('나의 프로필'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: '수정',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileEditPage(user: user);
                        },
                      ),
                    );
                  },
                ),
                UIUtil.buildLogOutIconButton(
                  context,
                  ref.read(authServiceProvider),
                ),
              ],
            ),
            ProfileLayout(user: user),
          ],
        );
      },
    );
  }
}
