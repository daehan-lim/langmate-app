import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/utils/date_time_util.dart';
import '../../../../../../data/model/chat_room.dart';
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

        if (chatRooms.isEmpty) {
          return _buildNoChatsLayout();
        }

        return Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              return _buildChatRoomItem(context, ref, chatRoom, appUser);
            },
            separatorBuilder: (context, index) {
              return Divider(indent: 5, height: 20, color: Colors.grey[300]);
            },
          ),
        );
      },
    );
  }

  Widget _buildChatRoomItem(
    BuildContext context,
    WidgetRef ref,
    ChatRoom chatRoom,
    AppUser appUser,
  ) {
    // Find the other participant in the chat
    final otherUser = chatRoom.participants.firstWhere(
      (participant) => participant.id != appUser.id,
      orElse: () => throw Exception("Other user not found in chat room"),
    );

    // Get the last message info for preview
    final hasMessages = chatRoom.messages.isNotEmpty;
    final displayDateTime =
        hasMessages
            ? DateTimeUtil.formatForChatList(chatRoom.messages.last.createdAt)
            : '';
    final message = hasMessages ? chatRoom.messages.last.content : '';

    return InkWell(
      onTap: () {
        // Load chat detail and navigate
        ref.read(chatGlobalViewModel.notifier).fetchChatDetail(chatRoom.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailPage(otherUser)),
        );
      },
      child: Container(
        // height: 80,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserAvatar(otherUser),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        otherUser.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        displayDateTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AppUser user) {
    if (user.profileImage != null) {
      return ClipOval(
        child: AppCachedImage(
          imageUrl: user.profileImage!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 30, color: Colors.grey),
      );
    }
  }

  Widget _buildNoChatsLayout() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/no_chats.json',
              width: 240,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              '대화 내역이 없습니다',
              style: TextStyle(
                fontSize: 21,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '언어 파트너를 찾아 대화를 시작해보세요',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
