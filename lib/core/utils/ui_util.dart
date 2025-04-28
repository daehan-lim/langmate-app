import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/core/services/auth_service.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';

import '../../data/model/app_user.dart';
import '../../ui/chat_global_view_model.dart';
import '../../ui/pages/auth/login_page.dart';
import '../../ui/pages/chat_detail/chat_detail_page.dart';
import '../../ui/pages/home/home_page.dart';
import '../../ui/pages/welcome/welcome_page.dart';
import '../../ui/user_global_view_model.dart';

class UIUtil {
  static Widget buildLogOutIconButton(
    BuildContext context,
    AuthService authService,
  ) {
    return IconButton(
      icon: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(Icons.logout),
      ),
      onPressed: () async {
        try {
          await authService.signOut();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } catch (e) {
          SnackbarUtil.showSnackBar(context, '로그아웃 중 오류가 발생했습니다');
        }
      },
      tooltip: '로그아웃',
    );
  }

  static void navigateBasedOnProfile(BuildContext context, AppUser? appUser) {
    final hasLanguages =
        appUser?.nativeLanguage != null && appUser?.targetLanguage != null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => hasLanguages ? const HomePage() : const WelcomePage(),
      ),
    );
  }

  static void openConversationWithUser({
    required AppUser otherUser,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final currentUser = ref.read(userGlobalViewModelProvider);
    if (currentUser != null) {
      ref
          .read(chatGlobalViewModel.notifier)
          .openChatWithUser(currentUser, otherUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatDetailPage(otherUser)),
      );
    }
  }
}
