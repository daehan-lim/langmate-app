import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lang_mate/app/constants/app_constants.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../../app/app_providers.dart';
import '../../user_global_view_model.dart';
import '../../widgets/app_cached_image.dart';
import '../../widgets/logout_icon_button.dart';
import '../home/home_page.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends ConsumerState<WelcomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 언어 목록
  final List<String> _languages = ['선택', ...AppConstants.languages];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userGlobalViewModelProvider);
    if (user != null) {
      _usernameController.text = user.name;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final user = ref.watch(userGlobalViewModelProvider);
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);
    // 에러 메시지 처리
    if (welcomeState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarUtil.showSnackBar(context, welcomeState.errorMessage!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LangMate'),
        actions: [LogoutIconButton(authService: ref.read(authServiceProvider)),],
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
                      '환영합니다, ${user.name}님!',
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
                  GestureDetector(
                    onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? xFile = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (xFile != null) {
                        print(xFile.path);
                        welcomeViewModel.uploadImage(xFile);
                      }
                    },
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          welcomeState.imageUrl != null ||
                                  user?.profileImage != null
                              ? ClipOval(
                                child: AppCachedImage(
                                  imageUrl:
                                      welcomeState.imageUrl ??
                                      user!.profileImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person, size: 50),
                              ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 이름 입력 필드
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
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
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                '모국어',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SizedBox(
                                height: 88,
                                child: DropdownButtonFormField<String>(
                                  validator: (text) {
                                    if (text == '선택') {
                                      return '모국어를 선택해 주세요';
                                    }
                                    return null;
                                  },
                                  value: welcomeState.nativeLanguage ?? '한국어',
                                  items:
                                      _languages
                                          .where((lang) {
                                            return lang == '선택' ||
                                                lang !=
                                                    welcomeState.targetLanguage;
                                          })
                                          .map((language) {
                                            return DropdownMenuItem(
                                              value: language,
                                              child: Text(language),
                                            );
                                          })
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      ref
                                          .read(
                                            welcomeViewModelProvider.notifier,
                                          )
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
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: const Text(
                                '학습언어',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                height: 88,
                                child: DropdownButtonFormField<String>(
                                  validator: (text) {
                                    if (text == '선택') {
                                      return '배우고 싶은 언어를 선택해 주세요';
                                    }
                                    return null;
                                  },
                                  value: welcomeState.targetLanguage ?? '영어',
                                  items:
                                      _languages
                                          .where((lang) {
                                            return lang == '선택' ||
                                                lang !=
                                                    welcomeState.nativeLanguage;
                                          })
                                          .map((language) {
                                            return DropdownMenuItem(
                                              value: language,
                                              child: Text(language),
                                            );
                                          })
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      ref
                                          .read(
                                            welcomeViewModelProvider.notifier,
                                          )
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
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
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  print("시작하기 버튼 클릭됨 - 프로필 저장 시도 중");

                                  if (user == null) {
                                    print("글로벌 사용자 정보가 없습니다. 로그인 다시 시도 필요.");
                                    SnackbarUtil.showSnackBar(
                                      context,
                                      '사용자 정보를 불러올 수 없습니다.',
                                    );
                                    return;
                                  }

                                  if (welcomeState.location == null) {
                                    SnackbarUtil.showSnackBar(
                                      context,
                                      '위치 가져오기 버튼을 누르고 다시 시도해 주세요',
                                    );
                                    // return;  Uncomment later
                                  }

                                  try {
                                    await ref
                                        .read(welcomeViewModelProvider.notifier)
                                        .saveUserProfile(
                                          user,
                                          _usernameController.text,
                                          welcomeState.location,
                                        );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                    );
                                  } catch (e) {
                                    print("프로필 저장 중 오류 발생: $e");
                                  }
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
