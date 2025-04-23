import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../../app/app_providers.dart';
import '../../pages/auth/login_page.dart';
import '../chat/chat_page.dart'; // ChatPage 경로 수정

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends ConsumerState<WelcomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 언어 목록
  final List<String> _languages = ['한국어', '영어', '일본어', '중국어', '스페인어', '프랑스어'];

  @override
  void initState() {
    super.initState();
    // 기본 언어 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(welcomeViewModelProvider.notifier).setNativeLanguage('한국어');
      ref.read(welcomeViewModelProvider.notifier).setTargetLanguage('영어');
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;

    // 에러 메시지 처리
    if (welcomeState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtil.showSnackBar(context, welcomeState.errorMessage!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LangMate'),
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
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
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // 환영 메시지와 사용자 정보 표시
                  if (user != null) ...[
                    Text(
                      '환영합니다, ${user.displayName ?? '사용자'}님!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('이메일: ${user.email ?? ''}'),
                    const SizedBox(height: 20),
                  ],
                  // 제목 텍스트
                  const Text(
                    '채팅 시작',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  // 사용자 아이콘
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 이름 입력 필드
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: '사용할 이름을 입력해 주세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해 주세요';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      ref
                          .read(welcomeViewModelProvider.notifier)
                          .setUsername(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // 언어 선택 영역
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '나의 언어',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: welcomeState.nativeLanguage ?? '한국어',
                              items:
                                  _languages.map((language) {
                                    return DropdownMenuItem(
                                      value: language,
                                      child: Text(language),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(welcomeViewModelProvider.notifier)
                                      .setNativeLanguage(value);
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '배우고 싶은 언어',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: welcomeState.targetLanguage ?? '영어',
                              items:
                                  _languages.map((language) {
                                    return DropdownMenuItem(
                                      value: language,
                                      child: Text(language),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(welcomeViewModelProvider.notifier)
                                      .setTargetLanguage(value);
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 위치정보 텍스트
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(welcomeViewModelProvider.notifier)
                          .fetchLocation();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (welcomeState.isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          welcomeState.location != null
                              ? '위치: ${welcomeState.location}'
                              : '위치정보 가져오기',
                          style: TextStyle(color: Colors.blue[400]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 시작하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          welcomeState.isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChatPage(
                                            username: _usernameController.text,
                                            location:
                                                welcomeState.location ??
                                                '서울시 강남구',
                                            nativeLanguage:
                                                welcomeState.nativeLanguage ??
                                                '한국어',
                                            targetLanguage:
                                                welcomeState.targetLanguage ??
                                                '영어',
                                          ),
                                    ),
                                  );
                                }
                              },
                      child: const Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
