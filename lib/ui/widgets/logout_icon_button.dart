import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/utils/snackbar_util.dart';
import '../pages/auth/login_page.dart';

class LogoutIconButton extends StatelessWidget {
  final AuthService authService;

  const LogoutIconButton({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
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
}
