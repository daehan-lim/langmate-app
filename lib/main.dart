import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/pages/home/home_page.dart';
import 'package:lang_mate/ui/pages/users/matched_users_page.dart';
import 'package:lang_mate/ui/pages/welcome/welcome_page.dart';
import 'app/constants/app_constants.dart';
import 'app/theme.dart';
import 'ui/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  try {
    await dotenv.load(fileName: '.env');
    // ignore: empty_catches
  } catch (e) {}

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
