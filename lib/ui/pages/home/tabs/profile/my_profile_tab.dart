import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/app_providers.dart';
import 'package:lang_mate/core/utils/ui_util.dart';
import 'package:lang_mate/ui/pages/profile/user_profile_page.dart';
import 'package:lang_mate/ui/pages/profile_edit/profile_edit_page.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

class MyProfileTab extends ConsumerWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final currentUser = ref.watch(userGlobalViewModelProvider);

    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(user: currentUser),
                ),
              );
            },
          ),
          UIUtil.buildLogOutIconButton(context, authService),
        ],
      ),
      body: UserProfilePage(user: currentUser, isCurrentUser: true),
    );
  }
}
