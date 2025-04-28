import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/widgets/profile_images.dart';
import 'package:lang_mate/core/utils/dialogue_util.dart';
import 'edit_profile_view_model.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final AppUser user;

  const ProfileEditPage({super.key, required this.user});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late TextEditingController nameController;
  late TextEditingController nativeLanguageController;
  late TextEditingController targetLanguageController;
  late TextEditingController bioController;
  late TextEditingController partnerPreferenceController;
  late TextEditingController languageLearningGoalController;
  DateTime? birthdate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    nativeLanguageController = TextEditingController(
      text: widget.user.nativeLanguage ?? '',
    );
    targetLanguageController = TextEditingController(
      text: widget.user.targetLanguage ?? '',
    );
    bioController = TextEditingController(text: widget.user.bio ?? '');
    partnerPreferenceController = TextEditingController(
      text: widget.user.partnerPreference ?? '',
    );
    languageLearningGoalController = TextEditingController(
      text: widget.user.languageLearningGoal ?? '',
    );
    birthdate = widget.user.birthdate;
  }

  @override
  void dispose() {
    nameController.dispose();
    nativeLanguageController.dispose();
    targetLanguageController.dispose();
    bioController.dispose();
    partnerPreferenceController.dispose();
    languageLearningGoalController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthdate ?? now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await DialogueUtil.showAppCupertinoDialog(
      context: context,
      title: '저장',
      content: '변경사항을 저장하시겠습니까?',
      showCancel: true,
    );
    if (confirm != '확인') return;

    final vm = ref.read(editProfileViewModelProvider(widget.user).notifier);
    final updatedUser = widget.user.copyWith(
      name: nameController.text,
      nativeLanguage: nativeLanguageController.text,
      targetLanguage: targetLanguageController.text,
      district: ref.read(editProfileViewModelProvider(widget.user)).district,
      // updated district
      bio: bioController.text,
      partnerPreference: partnerPreferenceController.text,
      languageLearningGoal: languageLearningGoalController.text,
      birthdate: birthdate,
    );

    await vm.saveProfile(updatedUser);

    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() async {
    final confirm = await DialogueUtil.showAppCupertinoDialog(
      context: context,
      title: '나가시겠습니까?',
      content: '변경사항이 저장되지 않을 수 있습니다.',
      showCancel: true,
    );
    return confirm == '확인';
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(editProfileViewModelProvider(widget.user));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('프로필 수정'),
          actions: [
            GestureDetector(
              onTap: _saveProfile,
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 8),
                child: const Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileImages(
                  profileImageUrl: widget.user.profileImage,
                  isEditable: true,
                  onImageTap: () {}, // implement image picker separately
                ),
                const SizedBox(height: 60),

                _buildTextField(
                  nameController,
                  '이름',
                  validator:
                      (val) => val == null || val.isEmpty ? '이름을 입력하세요' : null,
                ),
                _buildTextField(nativeLanguageController, '모국어'),
                _buildTextField(targetLanguageController, '학습 언어'),

                _buildTextField(bioController, '자기소개', maxLines: 3),
                _buildTextField(partnerPreferenceController, '교환 파트너 선호'),
                _buildTextField(languageLearningGoalController, '언어 학습 목표'),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: _pickBirthdate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        birthdate != null
                            ? "${birthdate!.year}년 ${birthdate!.month}월 ${birthdate!.day}일"
                            : "생년월일 선택",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          vm.district ?? '지역을 가져오는 중...',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () =>
                            ref
                                .read(
                              editProfileViewModelProvider(
                                widget.user,
                              ).notifier,
                            )
                                .refreshDistrict(),
                        child: Text(
                          '지역 새로고침',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
