import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_providers.dart';
import '../../data/model/app_user.dart';
import '../pages/auth/login_page.dart';
import '../pages/users/matched_users_page.dart';
import '../pages/welcome/welcome_page.dart';
import '../user_global_view_model.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      next.whenData((user) async {
        if (user == null) {
          // Not logged in → go to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else {
          // Logged in → check Firestore profile
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (!doc.exists) {
            await ref.read(authServiceProvider).signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            return;
          }

          final appUser = AppUser.fromMap(user.uid, doc.data()!);
          ref.read(userGlobalViewModelProvider.notifier).setUser(appUser);

          if (appUser.nativeLanguage != null &&
              appUser.targetLanguage != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MatchedUsersPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
            );
          }
        }
      });
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
