import 'package:flutter/material.dart';
import 'package:lang_mate/core/services/auth_service.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';

import '../../ui/pages/auth/login_page.dart';

class UIUtil {
  static Widget buildLogOutIconButton (BuildContext context, AuthService authService) {
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