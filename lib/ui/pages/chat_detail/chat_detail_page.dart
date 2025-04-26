import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/core/utils/date_time_util.dart';
import '../../../../../data/model/app_user.dart';
import '../../../data/model/new/chat_message.dart';
import '../../chat_global_view_model.dart';
import '../../user_global_view_model.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final AppUser otherUser;

  const ChatDetailPage(this.otherUser, {super.key});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    if (text
        .trim()
        .isNotEmpty) {
      // viewModel.sendMessage(value);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser appUser = ref.read(userGlobalViewModelProvider)!;
    final chatRoom = ref
        .watch(chatGlobalViewModel)
        .currentChatRoom;
    // final chatState = ref.watch(chatViewModelProvider);
    final viewModel = ref.read(chatGlobalViewModel.notifier);

    if (chatRoom == null) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 20)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F9FA), //상대방 이름, 언어, 주소
        title: Column(
          children: [
            Text(
              widget.otherUser.name, //매칭 된 사람으로 바꿔야 할 것.
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.otherUser.district} · ${widget.otherUser
                  .nativeLanguage} → ${widget.otherUser.targetLanguage}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            ), // 채팅 메시지 영역
            // TODO Firebase, Time, chat 정보 가져오기
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: chatRoom.messages.length,
                itemBuilder: (context, index) {
                  final message = chatRoom.messages[index];
                  return _buildMessageBubble(
                      message, appUser, widget.otherUser);
                },
              ),
            ),
            // 메시지 입력 영역
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      //엔터를 누르면 onSubmitted이 호출
                      onSubmitted: sendMessage,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF1F3F4),
                        hintText: '메시지를 입력하세요',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => sendMessage(_messageController.text),
                  ),
                  //이미지 추가 버튼 추후 추가
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      print("이미지 선택 눌림");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message,
      AppUser appUser,
      AppUser otherUser,) {
    final isMe = message.senderId == appUser.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 16),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(otherUser.name, style: TextStyle(fontSize: 12)),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: isMe ? Colors.blue[100] : Colors.grey[200],
                  color: isMe ? Color(0xFFDCF8C6) : Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(message.content),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                child: Text(
                  DateTimeUtil.formatString(message.createdAt),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
