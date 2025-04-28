import 'package:flutter/material.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/pages/profile/widgets/chat_button.dart';
import 'package:lang_mate/ui/widgets/profile_layout.dart';


class UserProfilePage extends StatelessWidget {
  final AppUser user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('사용자 프로필')),
      body: ProfileLayout(user: user),
      bottomNavigationBar: ChatButton(user: user),
    );
  }
}
