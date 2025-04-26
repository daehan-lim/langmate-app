import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/data/model/app_user.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

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
              return Divider(height: 1);
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
            ? DateTimeUtil.formatString(chatRoom.messages.last.createdAt)
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
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
            Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '대화 내역이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              '주변 사용자를 찾아 대화를 시작해보세요',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
