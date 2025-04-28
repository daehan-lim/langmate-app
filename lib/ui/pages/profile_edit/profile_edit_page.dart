import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';

import '../../widgets/profile_images.dart';
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
  late TextEditingController districtController;
  late TextEditingController bioController;
  late TextEditingController partnerPreferenceController;
  late TextEditingController languageLearningGoalController;
  DateTime? birthdate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    nativeLanguageController = TextEditingController(text: widget.user.nativeLanguage ?? '');
    targetLanguageController = TextEditingController(text: widget.user.targetLanguage ?? '');
    districtController = TextEditingController(text: widget.user.district ?? '');
    bioController = TextEditingController(text: widget.user.bio ?? '');
    partnerPreferenceController = TextEditingController(text: widget.user.partnerPreference ?? '');
    languageLearningGoalController = TextEditingController(text: widget.user.languageLearningGoal ?? '');
    birthdate = widget.user.birthdate; // assuming you update AppUser to have birthdate
  }

  @override
  void dispose() {
    nameController.dispose();
    nativeLanguageController.dispose();
    targetLanguageController.dispose();
    districtController.dispose();
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

    final updatedUser = widget.user.copyWith(
      name: nameController.text,
      nativeLanguage: nativeLanguageController.text,
      targetLanguage: targetLanguageController.text,
      district: districtController.text,
      bio: bioController.text,
      partnerPreference: partnerPreferenceController.text,
      languageLearningGoal: languageLearningGoalController.text,
      birthdate: birthdate,
    );

    final vm = ref.read(editProfileViewModelProvider.notifier);
    await vm.saveProfile(updatedUser);

    if (ref.read(editProfileViewModelProvider).hasError == false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('프로필 수정'),
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

              _buildTextField(nameController, '이름', validator: (val) => val == null || val.isEmpty ? '이름을 입력하세요' : null),
              _buildTextField(nativeLanguageController, '모국어'),
              _buildTextField(targetLanguageController, '학습 언어'),
              _buildTextField(districtController, '지역'),
              _buildTextField(bioController, '자기소개', maxLines: 3),
              _buildTextField(partnerPreferenceController, '교환 파트너 선호'),
              _buildTextField(languageLearningGoalController, '언어 학습 목표'),

              ListTile(
                title: const Text('생년월일'),
                subtitle: Text(
                  birthdate != null
                      ? "${birthdate!.year}-${birthdate!.month}-${birthdate!.day}"
                      : '선택되지 않음',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickBirthdate,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveProfile,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('저장하기'),
              ),
              const SizedBox(height: 30),
            ],
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
