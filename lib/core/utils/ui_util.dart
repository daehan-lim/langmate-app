import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/app_user.dart';
import '../../ui/chat_global_view_model.dart';
import '../../ui/pages/chat_detail/chat_detail_page.dart';
import '../../ui/pages/home/home_page.dart';
import '../../ui/pages/welcome/welcome_page.dart';
import '../../ui/user_global_view_model.dart';

abstract class UIUtil {
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
      final viewModel = ref.read(chatGlobalViewModel.notifier);
      viewModel.clearCurrentChat();
      viewModel.openChatWithUser(currentUser, otherUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatDetailPage(otherUser)),
      );
    }
  }
}