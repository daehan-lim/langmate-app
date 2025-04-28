import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/pages/profile/widgets/chat_button.dart';
import 'package:lang_mate/ui/pages/profile/widgets/profile_section_card.dart';
import 'package:lang_mate/ui/widgets/profile_images.dart';

import '../../widgets/app_cached_image.dart';

class UserProfilePage extends StatelessWidget {
  final AppUser user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('사용자 프로필')),
      body: _buildProfileLayout(context),
      bottomNavigationBar: ChatButton(user: user),
    );
  }

  SingleChildScrollView _buildProfileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cover and Profile Image
          ProfileImages(
            profileImageUrl:
                user.profileImage ?? 'https://picsum.photos/200/200?random=1',
            isEditable: false,
          ),
          const SizedBox(height: 60),
          // Name + Age
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (user.age != null)
            Text(
              '${user.age}세',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          const SizedBox(height: 12),

          // Language Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.nativeLanguage!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Icon(Icons.sync_alt, size: 20),
              const SizedBox(width: 8),
              Text(user.targetLanguage!, style: const TextStyle(fontSize: 16)),
            ],
          ),

          const SizedBox(height: 20),

          // Location Card
          if (user.district != null)
            _infoTile(
              icon: Icons.location_on_outlined,
              title: '${user.district}  |  8.3 km',
            ),

          Divider(height: 40, color: Colors.grey[300]),

          // Bio Section
          if (user.bio != null && user.bio!.isNotEmpty)
            ProfileSectionCard('자기 소개', user.bio!),

          if (user.partnerPreference != null &&
              user.partnerPreference!.isNotEmpty)
            ProfileSectionCard('제게 완벽한 언어 교환 파트너는', user.partnerPreference!),

          if (user.languageLearningGoal != null &&
              user.languageLearningGoal!.isNotEmpty)
            ProfileSectionCard('제게 완벽한 언어 교환 파트너는', user.languageLearningGoal!),

          const SizedBox(height: 30),
        ],
      ),
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
