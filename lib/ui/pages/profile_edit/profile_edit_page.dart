import 'package:flutter/cupertino.dart';
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
  late TextEditingController birthdateController;

  final _formKey = GlobalKey<FormState>();
  DateTime? birthdate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    nativeLanguageController = TextEditingController(text: widget.user.nativeLanguage ?? '');
    targetLanguageController = TextEditingController(text: widget.user.targetLanguage ?? '');
    bioController = TextEditingController(text: widget.user.bio ?? '');
    partnerPreferenceController = TextEditingController(text: widget.user.partnerPreference ?? '');
    languageLearningGoalController = TextEditingController(text: widget.user.languageLearningGoal ?? '');
    birthdate = widget.user.birthdate;
    birthdateController = TextEditingController(
      text: birthdate != null
          ? "${birthdate!.year}년 ${birthdate!.month}월 ${birthdate!.day}일"
          : '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nativeLanguageController.dispose();
    targetLanguageController.dispose();
    bioController.dispose();
    partnerPreferenceController.dispose();
    languageLearningGoalController.dispose();
    birthdateController.dispose();
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
      birthdate = picked;
      birthdateController.text = "${picked.year}년 ${picked.month}월 ${picked.day}일";
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
      location: ref.read(editProfileViewModelProvider(widget.user)).location,
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
                margin: const EdgeInsets.only(right: 8),
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

                _buildLabeledField('이름', nameController),
                _buildLabeledField('모국어', nativeLanguageController),
                _buildLabeledField('학습 언어', targetLanguageController),
                _buildLabeledField('자기소개', bioController, maxLines: 3),
                _buildLabeledField('완벽한 언어 교환 파트너는 어떤 사람인가요?', partnerPreferenceController),
                _buildLabeledField('언어 학습 목표는 무엇인가요?', languageLearningGoalController),
                _buildDateField('생년월일', birthdateController),

                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 20, top: 14, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '지역',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                vm.district ?? '지역을 가져오는 중...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => ref
                                  .read(editProfileViewModelProvider(widget.user).notifier)
                                  .refreshDistrict(),
                              child: const Text(
                                '새로고침',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: _pickBirthdate,
            decoration: InputDecoration(
              suffixIcon: const Icon(CupertinoIcons.calendar),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
