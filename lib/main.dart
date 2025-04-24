import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/home_page.dart';
import 'package:lang_mate/ui/pages/users/matched_users_page.dart';
import 'package:lang_mate/ui/pages/welcome/welcome_page.dart';
import 'app/constants/app_constants.dart';
import 'app/theme.dart';
import 'firebase_options.dart';
import 'ui/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {
    // Firebase가 이미 초기화된 경우 무시
  }

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env 파일이 없거나 실패해도 앱 실행에는 영향 없음
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.buildTheme(),
      home: const LoginPage(),
    );
  }
}
