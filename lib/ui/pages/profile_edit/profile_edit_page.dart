import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lang_mate/app/constants/app_constants.dart';
import 'package:lang_mate/core/utils/dialogue_util.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lang_mate/app/app_providers.dart';
import 'edit_profile_view_model.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final AppUser user;

  const ProfileEditPage({super.key, required this.user});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController partnerPreferenceController;
  late TextEditingController languageLearningGoalController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _profileImageUrl;
  String? _nativeLanguage;
  String? _targetLanguage;
  DateTime? _birthdate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    bioController = TextEditingController(text: widget.user.bio ?? '');
    partnerPreferenceController = TextEditingController(
      text: widget.user.partnerPreference ?? '',
    );
    languageLearningGoalController = TextEditingController(
      text: widget.user.languageLearningGoal ?? '',
    );
    _nativeLanguage = widget.user.nativeLanguage;
    _targetLanguage = widget.user.targetLanguage;
    _profileImageUrl = widget.user.profileImage;
    _birthdate = widget.user.birthdate;
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    partnerPreferenceController.dispose();
    languageLearningGoalController.dispose();
    super.dispose();
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

    setState(() {
      _isLoading = true;
    });

    try {
      final editProfileState = ref.read(
        editProfileViewModelProvider(widget.user),
      );

      final updatedUser = widget.user.copyWith(
        name: nameController.text,
        nativeLanguage: _nativeLanguage,
        targetLanguage: _targetLanguage,
        bio: bioController.text,
        partnerPreference: partnerPreferenceController.text,
        languageLearningGoal: languageLearningGoalController.text,
        profileImage: _profileImageUrl,
        birthdate: _birthdate,
        district: editProfileState.district,
        location: editProfileState.location,
      );

      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserProfile(updatedUser);
      ref.read(userGlobalViewModelProvider.notifier).setUser(updatedUser);

      SnackbarUtil.showSnackBar(context, '프로필이 성공적으로 저장되었습니다.');
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      SnackbarUtil.showSnackBar(context, '저장 중 오류가 발생했습니다: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref();
        final imageRef = storageRef.child(
          'profile_images/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}',
        );
        await imageRef.putFile(File(pickedFile.path));
        final imageUrl = await storageRef.getDownloadURL();

        setState(() {
          _profileImageUrl = imageUrl;
        });
      } catch (e) {
        SnackbarUtil.showSnackBar(
          context,
          '이미지 업로드 중 오류가 발생했습니다: ${e.toString()}',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    final editProfileState = ref.watch(
      editProfileViewModelProvider(widget.user),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('프로필 수정'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('저장', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child:
                              _profileImageUrl != null
                                  ? ClipOval(
                                    child: AppCachedImage(
                                      imageUrl: _profileImageUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Icon(Icons.person, size: 50),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabeledField('이름', nameController, hintText: '이름을 입력하세요'),
                _buildBirthdatePicker(),
                _buildDistrictSection(editProfileState),
                _buildLanguageSelection(),
                _buildLabeledField(
                  '자기 소개',
                  bioController,
                  hintText: '자신을 소개해주세요',
                  maxLines: 3,
                ),
                _buildLabeledField(
                  '완벽한 언어 교환 파트너는 어떤 사람인가요?',
                  partnerPreferenceController,
                  hintText: '원하는 파트너의 특성을 설명해주세요',
                  maxLines: 3,
                ),
                _buildLabeledField(
                  '언어 학습 목표는 무엇인가요?',
                  languageLearningGoalController,
                  hintText: '학습 목표를 설명해주세요',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
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
    String? hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: maxLines,
            validator: (value) {
              if ((value == null || value.isEmpty) && label == '이름') {
                return '이름을 입력해주세요';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _birthdate ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              _birthdate = picked;
            });
          }
        },
        decoration: InputDecoration(
          labelText: '생년월일',
          hintText: '생년월일을 선택하세요',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        controller: TextEditingController(
          text:
              _birthdate != null
                  ? '${_birthdate!.year}-${_birthdate!.month.toString().padLeft(2, '0')}-${_birthdate!.day.toString().padLeft(2, '0')}'
                  : '',
        ),
      ),
    );
  }

  Widget _buildDistrictSection(EditProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.district ?? '지역 정보를 가져올 수 없습니다',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                ref
                    .read(editProfileViewModelProvider(widget.user).notifier)
                    .refreshDistrict();
              },
              child: const Text(
                '새로고침',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelection() {
    final languages = ['선택', ...AppConstants.languages];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _nativeLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '모국어',
              ),
              items:
                  languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang == '선택' ? null : lang,
                      child: Text(lang),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _nativeLanguage = value),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _targetLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '학습 언어',
              ),
              items:
                  languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang == '선택' ? null : lang,
                      child: Text(lang),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _targetLanguage = value),
            ),
          ),
        ],
      ),
    );
  }
}
