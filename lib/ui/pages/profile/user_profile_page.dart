import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/constants/app_constants.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/pages/profile/widgets/chat_button.dart';
import 'package:lang_mate/ui/widgets/profile_section_card.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lang_mate/app/app_providers.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';
import 'package:lang_mate/ui/pages/profile_edit/profile_edit_page.dart';
import 'package:lang_mate/ui/pages/profile/profile_view_model.dart';

class UserProfilePage extends ConsumerWidget {
  final AppUser user;
  final bool isCurrentUser;

  const UserProfilePage({
    super.key,
    required this.user,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 사용자의 프로필인 경우에만 뷰모델 사용
    final profileViewModel =
        isCurrentUser ? ref.watch(profileViewModelProvider) : null;

    final currentUser =
        isCurrentUser ? ref.watch(userGlobalViewModelProvider) : user;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileEditPage(user: user),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildProfileLayout(context, ref, currentUser, profileViewModel),
      bottomNavigationBar: isCurrentUser ? null : ChatButton(user: user),
    );
  }

  SingleChildScrollView _buildProfileLayout(
    BuildContext context,
    WidgetRef ref,
    AppUser displayUser,
    ProfileState? profileState,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cover and Profile Image
          _buildProfileImages(context, displayUser),
          const SizedBox(height: 60),
          // Name + Age
          Text(
            displayUser.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (displayUser.age != null)
            Text(
              '${displayUser.age}세',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          const SizedBox(height: 12),

          // Language Info
          _buildLanguageSection(context, ref, displayUser, profileState),

          const SizedBox(height: 20),

          // Location Card
          if (displayUser.district != null)
            _infoTile(
              icon: Icons.location_on_outlined,
              title: '${displayUser.district}  |  8.3 km',
            ),

          Divider(height: 40, color: Colors.grey[300]),

          // Bio Section
          if (displayUser.bio != null && displayUser.bio!.isNotEmpty)
            ProfileSectionCard('자기 소개', displayUser.bio!),

          if (displayUser.partnerPreference != null &&
              displayUser.partnerPreference!.isNotEmpty)
            ProfileSectionCard(
              '제게 완벽한 언어 교환 파트너는',
              displayUser.partnerPreference!,
            ),

          if (displayUser.languageLearningGoal != null &&
              displayUser.languageLearningGoal!.isNotEmpty)
            ProfileSectionCard('언어 학습 목표', displayUser.languageLearningGoal!),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    AppUser displayUser,
    ProfileState? profileState,
  ) {
    // 현재 상태가 언어 편집 모드이면
    if (isCurrentUser &&
        profileState != null &&
        profileState.isEditingLanguage) {
      return _buildLanguageEditSection(context, ref, displayUser, profileState);
    }

    // 기본 언어 표시 UI
    return GestureDetector(
      onTap:
          isCurrentUser
              ? () {
                ref
                    .read(profileViewModelProvider.notifier)
                    .setEditingLanguage(true);
              }
              : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayUser.nativeLanguage!,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.sync_alt, size: 20),
          const SizedBox(width: 8),
          Text(
            displayUser.targetLanguage!,
            style: const TextStyle(fontSize: 16),
          ),
          if (isCurrentUser) const SizedBox(width: 4),
          if (isCurrentUser)
            const Icon(Icons.edit, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLanguageEditSection(
    BuildContext context,
    WidgetRef ref,
    AppUser displayUser,
    ProfileState profileState,
  ) {
    // 언어 목록
    final List<String> languages = ['선택', ...AppConstants.languages];
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          // 언어 선택 드롭다운
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '모국어',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value:
                          profileState.nativeLanguage ??
                          displayUser.nativeLanguage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items:
                          languages
                              .where((lang) {
                                return lang == '선택' ||
                                    lang !=
                                        (profileState.targetLanguage ??
                                            displayUser.targetLanguage);
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
                          viewModel.setNativeLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '학습언어',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value:
                          profileState.targetLanguage ??
                          displayUser.targetLanguage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items:
                          languages
                              .where((lang) {
                                return lang == '선택' ||
                                    lang !=
                                        (profileState.nativeLanguage ??
                                            displayUser.nativeLanguage);
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
                          viewModel.setTargetLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 저장/취소 버튼
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    viewModel.resetLanguages();
                    viewModel.setEditingLanguage(false);
                  },
                  child: const Text('취소'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (profileState.nativeLanguage == '선택' ||
                        profileState.targetLanguage == '선택') {
                      SnackbarUtil.showSnackBar(context, '언어를 모두 선택해주세요');
                      return;
                    }

                    if (profileState.nativeLanguage ==
                        profileState.targetLanguage) {
                      SnackbarUtil.showSnackBar(
                        context,
                        '모국어와 학습언어는 같을 수 없습니다',
                      );
                      return;
                    }

                    viewModel.saveLanguages(context, displayUser);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      profileState.isSaving
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text('저장'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack _buildProfileImages(BuildContext context, AppUser displayUser) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/world_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: ClipOval(
            child: Container(
              width: 100,
              // 2 * radius 50
              height: 100,
              color: Colors.white,
              alignment: Alignment.center,
              child: ClipOval(
                child: AppCachedImage(
                  imageUrl:
                      displayUser.profileImage ??
                      'https://picsum.photos/200/200?random=1',
                  width: 92, // 2 * radius 46
                  height: 92,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 8),
          Flexible(child: Text(title, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
