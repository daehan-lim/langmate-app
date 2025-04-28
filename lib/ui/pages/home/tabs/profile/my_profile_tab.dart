import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/profile_edit/profile_edit_page.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lang_mate/ui/widgets/profile_layout.dart';

class MyProfileTab extends StatelessWidget {

  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final user = ref.watch(userGlobalViewModelProvider)!;
        return Column(
          children: [
            AppBar(
              title: Text('나의 프로필'),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileEditPage(user: user);
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    child: const Text(
                      '수정',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
