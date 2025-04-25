import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/core/utils/ui_util.dart';
import '../../../app/app_providers.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../user_global_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);

    // 에러 메시지 처리
    if (loginState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtil.showSnackBar(context, loginState.errorMessage!);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 로고나 이미지
              Image.asset(
                'assets/icons/app_logo_rounded_border.png',
                height: 120,
              ),
              const SizedBox(height: 20),

              // 앱 이름 또는 환영 텍스트
              const Text(
                'LangMate',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Text(
                '가까운 언어 교환 파트너를 찾아보세요 👋',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.grey[800]),
              ),
              const SizedBox(height: 50),

              // 구글 로그인 버튼
              Center(
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed:
                        loginState.isLoading
                            ? null
                            : () async {
                                print("로그인 버튼 클릭됨");
                                try {
                                  await ref
                                      .read(loginViewModelProvider.notifier)
                                      .signInAndPrepareUser();
                                  
                                  final appUser = ref.read(
                                    userGlobalViewModelProvider,
                                  );
                                  
                                  // 사용자 정보가 설정된 경우에만 네비게이션
                                  if (appUser != null && appUser.id.isNotEmpty && context.mounted) {
                                    UIUtil.navigateBasedOnProfile(
                                      context,
                                      appUser,
                                    );
                                  }
                                } catch (e) {
                                  print("로그인 과정 중 오류 발생: $e");
                                  // 오류는 이미 LoginViewModel에서 처리됨
                                }
                              },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      minimumSize: const Size(double.infinity, 53),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 구글 로고 (이미지 사용 권장)
                        Image.asset('assets/icons/google.png', height: 18),
                        const SizedBox(width: 16),
                        Text(
                          loginState.isLoading ? '로그인 중...' : '구글 계정으로 시작하기',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}