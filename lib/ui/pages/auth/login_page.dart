import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_providers.dart';
import '../../../core/utils/snackbar_util.dart';
import '../welcome/welcome_page.dart';
import 'login_view_model.dart';

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

    // 로그인 상태 확인 (authStateProvider 사용)
    ref.listen(authStateProvider, (previous, next) {
      print("authStateProvider 변경 감지됨: $previous -> $next");
      next.whenData((user) {
        print("authStateProvider 데이터: ${user?.displayName ?? '로그인 안됨'}");
        if (user != null) {
          print("로그인 성공: ${user.displayName}, uid: ${user.uid}");
          print("Welcome 페이지로 이동 시도 (authStateProvider 경로)");
          // 로그인 성공 시 WelcomePage로 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 로고나 이미지
              Icon(
                Icons.chat_sharp,
                size: 100,
                color: Colors.blue[400],
              ),
              const SizedBox(height: 30),

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
                                final user =
                                    await ref
                                        .read(loginViewModelProvider.notifier)
                                        .signInWithGoogle();

                                print("로그인 결과: ${user != null ? '성공' : '실패'}");

                                if (user != null) {
                                  print(
                                    "사용자 정보: ${user.displayName}, ${user.email}",
                                  );
                                  print("Welcome 페이지로 이동 시도 (버튼 클릭 경로)");

                                  // 두 가지 방법으로 시도
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    print("WidgetsBinding 콜백 실행됨");
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const WelcomePage(),
                                      ),
                                      (route) => false,
                                    );
                                  });
                                }
                              } catch (e) {
                                print("로그인 중 예외 발생: $e");
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
                        Image.asset(
                          'assets/icons/google.png',
                          height: 18,
                        ),
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
