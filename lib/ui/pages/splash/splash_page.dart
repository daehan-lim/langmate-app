import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../core/utils/ui_util.dart';
import '../../user_global_view_model.dart';
import '../auth/login_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      next.whenData((firebaseUser) async {
        if (firebaseUser == null) { // Not logged in → go to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else { // Logged in → check Firestore profile
          final appUser = await ref
              .read(userRepositoryProvider)
              .getUserById(firebaseUser.uid);
          if (appUser == null) {
            // User not in Firestore → log out
            await ref.read(authServiceProvider).signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            return;
          } else {
            // User in Firestore. Check if profile completed and navigate to WelcomePage or HomePage
            ref.read(userGlobalViewModelProvider.notifier).setUser(appUser);
            if (context.mounted) {
              UIUtil.navigateBasedOnProfile(context, appUser);
            }
          }
        }
      });
    });

    return const Scaffold(
      body: Center(child: CupertinoActivityIndicator(radius: 20)),
    );
  }
}
