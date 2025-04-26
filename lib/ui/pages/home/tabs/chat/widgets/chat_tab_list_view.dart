import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import '../../../../../../core/utils/date_time_util.dart';
import '../../../../../../data/model/new/chat_room.dart';
import '../../../../../chat_global_view_model.dart';
import '../../../../../widgets/app_cached_image.dart';
import '../../../../chat_detail/chat_detail_page.dart';

class ChatTabListView extends StatelessWidget {
  const ChatTabListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final chatState = ref.watch(chatGlobalViewModel);
        final chatRooms = chatState.chatRooms;
        final appUser = ref.watch(userGlobalViewModelProvider);

        if (appUser == null) {
          return SizedBox();
        }

        return Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              return chatRoomItem(chatRoom, appUser);
            },
            separatorBuilder: (context, index) {
              return Divider(height: 1);
            },
          ),
        );
      },
    );
  }

  Widget chatRoomItem(ChatRoom chatRoom, AppUser appUser) {
    final otherUser = chatRoom.participants.firstWhere(
      (AppUser participant) => participant.id != appUser.id,
    );
    final displayDateTime =
        chatRoom.messages.isEmpty
            ? ''
            : DateTimeUtil.formatString(chatRoom.messages.last.createdAt);
    final message =
        chatRoom.messages.isEmpty ? '' : chatRoom.messages.last.content;

    return Consumer(
      builder: (context, ref, child) {
        return InkWell(
          onTap: () {
            ref.read(chatGlobalViewModel.notifier).fetchChatDetail(chatRoom.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatDetailPage(otherUser);
                },
              ),
            );
          },
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                otherUser.profileImage != null
                    ? ClipOval(
                      child: AppCachedImage(
                        imageUrl: otherUser.profileImage!,
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                      ),
                    )
                    : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 50),
                    ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            otherUser.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            displayDateTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(message),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
