import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/core/utils/ui_util.dart';

class ChatButton extends ConsumerWidget {
  final AppUser user;

  const ChatButton({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 33),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ElevatedButton.icon(
              onPressed: () {
                UIUtil.openConversationWithUser(
                  otherUser: user,
                  ref: ref,
                  context: context,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              icon: Icon(
                CupertinoIcons.chat_bubble_2_fill,
                size: 22,
                color: Colors.white,
              ),
              label: Text(
                '채팅하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
