import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/constants/app_colors.dart';
import 'package:lang_mate/core/utils/date_time_util.dart';
import '../../../../../data/model/app_user.dart';
import '../../../data/model/chat_message.dart';
import '../../chat_global_view_model.dart';
import '../../user_global_view_model.dart';
import '../../widgets/app_cached_image.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final AppUser otherUser;

  const ChatDetailPage(this.otherUser, {super.key});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      ref.read(chatGlobalViewModel.notifier).sendMessage(text);
      _messageController.clear();

      // Schedule scroll to bottom after the message is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(userGlobalViewModelProvider)!;
    final chatState = ref.watch(chatGlobalViewModel);
    final chatRoom = chatState.currentChatRoom;
    print(chatRoom?.id);

    if (chatRoom == null) {
      print('chat room null');
      return _buildConvoLoadingLayout();
    }

    // Listen for changes to scroll to bottom on new messages
    ref.listen(chatGlobalViewModel, (previous, current) {
      print('enter listen page');
      if (previous?.currentChatRoom?.messages.length !=
          current.currentChatRoom?.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });



    // Group messages by date for better visualization
    final groupedMessages = _groupMessagesByDate(chatRoom.messages);

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Messages area
            Expanded(
              child:
                  chatRoom.messages.isEmpty
                      ? _buildEmptyChatView()
                      : _buildMessagesList(groupedMessages, appUser),
            ),
            // Message input area
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Scaffold _buildConvoLoadingLayout() {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 1,
          color: AppColors.appBarGrey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: CupertinoActivityIndicator(radius: 12)),
            ),
          ),
        ),
      ),
      body: Center(child: CupertinoActivityIndicator(radius: 20)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appBarGrey,
      title: Column(
        children: [
          Text(
            widget.otherUser.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.otherUser.district ?? ''} · ${widget.otherUser.nativeLanguage ?? ''} → ${widget.otherUser.targetLanguage ?? ''}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline, color: Colors.black),
          onPressed: () {
            // Show user profile or chat info
          },
        ),
      ],
    );
  }

  Widget _buildEmptyChatView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child:
                widget.otherUser.profileImage != null
                    ? AppCachedImage(
                      imageUrl: widget.otherUser.profileImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
          ),
          SizedBox(height: 16),
          Text(
            widget.otherUser.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '${widget.otherUser.nativeLanguage ?? ''} → ${widget.otherUser.targetLanguage ?? ''}',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 24),
          Text(
            '대화를 시작해보세요!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    Map<String, List<ChatMessage>> groupedMessages,
    AppUser currentUser,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final date = groupedMessages.keys.elementAt(index);
        final messages = groupedMessages[date]!;

        return Column(
          children: [
            // Date separator
            _buildDateSeparator(date),

            // Messages for this date
            ...messages.asMap().entries.map((entry) {
              final i = entry.key;
              final message = entry.value;

              // Determine if this is the first message from this sender in a sequence
              final isFirstInSequence =
                  i == 0 || messages[i - 1].senderId != message.senderId;

              return _buildMessageBubble(
                message: message,
                isCurrentUser: message.senderId == currentUser.id,
                isFirstInSequence: isFirstInSequence,
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required ChatMessage message,
    required bool isCurrentUser,
    required bool isFirstInSequence,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInSequence ? 16.0 : 4.0,
        bottom: 4.0,
      ),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar for other user's first message in a sequence
          if (!isCurrentUser && isFirstInSequence)
            ClipOval(
              child:
                  widget.otherUser.profileImage != null
                      ? AppCachedImage(
                        imageUrl: widget.otherUser.profileImage!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 32,
                        height: 32,
                        color: Colors.grey[200],
                        child: Icon(Icons.person, size: 20, color: Colors.grey),
                      ),
            )
          else if (!isCurrentUser)
            SizedBox(width: 32), // Placeholder for alignment

          SizedBox(width: 8),

          // Message content and timestamp
          Column(
            crossAxisAlignment:
                isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              // Name label for first message in sequence
              if (!isCurrentUser && isFirstInSequence)
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(
                    widget.otherUser.name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),

              // Message bubble
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Color(0xFFDCF8C6) : Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(message.content, style: TextStyle(fontSize: 15)),
              ),

              // Message timestamp
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
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

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image, color: Colors.grey[700]),
            onPressed: () {
              // Image selection functionality
              print("이미지 선택 눌림");
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: _sendMessage,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F3F4),
                hintText: '메시지를 입력하세요',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }

  // Helper method to group messages by date
  Map<String, List<ChatMessage>> _groupMessagesByDate(
    List<ChatMessage> messages,
  ) {
    final Map<String, List<ChatMessage>> grouped = {};

    for (final message in messages) {
      final date = _formatDateForGroup(message.createdAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(message);
    }

    return grouped;
  }

  // Helper to format the date for grouping
  String _formatDateForGroup(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '오늘';
    } else if (messageDate == yesterday) {
      return '어제';
    } else {
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    }
  }
}
