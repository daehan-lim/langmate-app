import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_providers.dart';
import '../../../data/model/chat_message.dart';
import '../../../data/model/chat_models.dart';
import 'chat_view_model.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String username;
  final String location;
  final String nativeLanguage;
  final String targetLanguage;

  const ChatPage({
    Key? key,
    required this.username,
    required this.location,
    required this.nativeLanguage,
    required this.targetLanguage,
  }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatViewModelProvider.notifier).loadInitialMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F9FA), //상대방 이름, 언어, 주소
        title: Column(
          children: [
            Text(
              '상대방', //매칭 된 사람으로 바꿔야 할 것.
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.location} · ${widget.nativeLanguage} → ${widget.targetLanguage}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          ), // 채팅 메시지 영역
          // TODO Firebase, Time, chat 정보 가져오기
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];
                return _buildMessageBubble(message, viewModel);
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
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        viewModel.addMessage(value.trim());
                        _messageController.clear();
                      }
                    },

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
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      viewModel.addMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
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
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ChatViewModel viewModel) {
    final isMe = message.type == MessageType.sent;

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
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text('상대방', style: TextStyle(fontSize: 12)),
                  //기본 채팅
                  //TODO 상대방 이름 ID로 가져오기
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                child: Text(message.text),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                child: Text(
                  viewModel.formatTimestamp(message.timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 16),
            ),
        ],
      ),
    );
  }
}
