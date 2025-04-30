import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/constants/app_colors.dart';
import 'package:lang_mate/core/utils/date_time_util.dart';
import 'package:lang_mate/core/utils/dialogue_util.dart';
import 'package:lang_mate/core/utils/snackbar_util.dart';
import '../../../../../data/model/app_user.dart';
import '../../../data/model/chat_message.dart';
import '../../chat_global_view_model.dart';
import '../../user_global_view_model.dart';
import '../../widgets/app_cached_image.dart';
import '../home/home_page.dart';
import '../profile/user_profile_page.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final AppUser otherUser;

  const ChatDetailPage(this.otherUser, {super.key});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToBottom();
    // });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 50),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      ref.read(chatGlobalViewModel.notifier).sendMessage(text);
      _messageController.clear();

      // Schedule scroll to bottom after the message is added
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _scrollToBottom();
      // });
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await ref.read(chatGlobalViewModel.notifier).sendImageMessage(file);
    }
  }

  void _showLeaveConfirmDialog(BuildContext context) async {
    final result = await DialogueUtil.showAppCupertinoDialog(
      context: context,
      title: '채팅방 나가기',
      content: '정말로 이 채팅방을 나가시겠습니까?\n채팅 내용이 모두 삭제되며, 이 작업은 되돌릴 수 없습니다.',
      showCancel: true,
    );

    if (result == '확인') {
      final success =
      await ref.read(chatGlobalViewModel.notifier).leaveChatRoom();

      if (success) {
        SnackbarUtil.showSnackBar(context, '채팅방에서 나갔습니다.');
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false,
          );
        }
      } else {
        SnackbarUtil.showSnackBar(context, '채팅방 나가기에 실패했습니다.');
      }
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
    // ref.listen(chatGlobalViewModel, (previous, current) {
    //   print('enter listen page');
    //   if (previous?.currentChatRoom?.messages.length !=
    //       current.currentChatRoom?.messages.length) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _scrollToBottom();
    //     });
    //   }
    // });

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
      centerTitle: false,
      titleSpacing: 0,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UserProfilePage(user: widget.otherUser);
              },
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              child: ClipOval(
                child: widget.otherUser.profileImage != null
                    ? AppCachedImage(
                  imageUrl: widget.otherUser.profileImage!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.person, size: 18),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  '${widget.otherUser.district ?? ''}'/* · ${widget.otherUser.nativeLanguage ?? ''} → ${widget.otherUser.targetLanguage ?? ''}*/,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) async {
              if (value == 'leave') {
                _showLeaveConfirmDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  height: 40,
                  value: 'leave',
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app, color: Colors.redAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '채팅방 나가기',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ];
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
      margin: EdgeInsets.only(top: 5, bottom: 10),
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
    final timeText = DateTimeUtil.formatTimeForMessage(message.createdAt);
    final bubbleColor = isCurrentUser ? Color(0xFFDCF8C6) : Color(0xFFEFEFEF);

    return Padding(
      padding: EdgeInsets.only(top: isFirstInSequence ? 0 : 4, bottom: 4.0),
      child: Row(
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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

          if (!isCurrentUser) SizedBox(width: 8),

          if (isCurrentUser)
            Text(
              timeText,
              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
            ),

          SizedBox(width: 6),

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
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    padding: message.isImage
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                    message.isImage
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          // Implement full-screen image view if needed
                        },
                        child: AppCachedImage(
                          imageUrl: message.content,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Text(message.content, style: TextStyle(fontSize: 15)),
                  ),

                  SizedBox(width: 6),
                  if (!isCurrentUser)
                    Text(
                      timeText,
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    ),
                ],
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
            onPressed: _pickImage,
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
      final date = DateTimeUtil.formatDateForMessageGroup(message.createdAt);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(message);
    }

    return grouped;
  }
}