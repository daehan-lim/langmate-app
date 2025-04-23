import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/snackbar_util.dart';
import '../../../../app/app_providers.dart';
import 'package:lang_mate/ui/pages/chat/chat_page.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends ConsumerState<WelcomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider 감시
    final welcomeState = ref.watch(welcomeViewModelProvider);

    // 에러 메시지 처리
    if (welcomeState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtil.showSnackBar(context, welcomeState.errorMessage!);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 제목 텍스트
                const Text(
                  '채팅 시작',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
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
                const SizedBox(height: 50),
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
                // 위치정보 텍스트
                GestureDetector(
                  onTap: () {
                    ref.read(welcomeViewModelProvider.notifier).fetchLocation();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
