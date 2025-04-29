import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

class ChatDetailPage extends ConsumerStatefulWidget {
  final AppUser otherUser;

  const ChatDetailPage(this.otherUser, {super.key});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String? _lastMessageDate;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatGlobalViewModel);
    final currentUser = ref.watch(userGlobalViewModelProvider);
    final currentChat = chatState.currentChatRoom;

    if (currentUser == null || currentChat == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              child: ClipOval(
                child:
                    widget.otherUser.profileImage != null
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
            Text(widget.otherUser.name, style: const TextStyle(fontSize: 16)),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'leave') {
                _showLeaveConfirmDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'leave',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('채팅방 나가기', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 목록
          Expanded(
            child:
                currentChat.messages.isEmpty
                    ? Center(
                      child: Text(
                        '메시지가 없습니다.\n대화를 시작해보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: currentChat.messages.length,
                      itemBuilder: (context, index) {
                        final message = currentChat.messages[index];
                        final isMe = message.senderId == currentUser.id;

                        // 날짜 구분선 표시 로직
                        bool showDateSeparator = false;
                        if (index == 0) {
                          showDateSeparator = true;
                          _lastMessageDate =
                              DateTimeUtil.formatDateForMessageGroup(
                                message.createdAt,
                              );
                        } else {
                          final currentDate =
                              DateTimeUtil.formatDateForMessageGroup(
                                message.createdAt,
                              );
                          final previousDate =
                              DateTimeUtil.formatDateForMessageGroup(
                                currentChat.messages[index - 1].createdAt,
                              );

                          if (currentDate != previousDate) {
                            showDateSeparator = true;
                            _lastMessageDate = currentDate;
                          }
                        }

                        return Column(
                          children: [
                            if (showDateSeparator)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 16.0,
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _lastMessageDate!,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            _buildMessageBubble(
                              message: message,
                              isMe: isMe,
                              context: context,
                            ),
                          ],
                        );
                      },
                    ),
          ),

          // 메시지 입력 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // 이미지 첨부 버튼
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () => _sendImage(),
                    color: Colors.blue,
                  ),
                  // 메시지 입력창
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  // 전송 버튼
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required ChatMessage message,
    required bool isMe,
    required BuildContext context,
  }) {
    final timeText = DateTimeUtil.formatTimeForMessage(message.createdAt);
    final bubbleColor = isMe ? Colors.blue[100] : Colors.grey[200];
    final textColor = isMe ? Colors.black87 : Colors.black87;
    final alignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;

    Widget messageContent;

    if (message.isImage) {
      // 이미지 메시지
      messageContent = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // 이미지 전체 화면으로 보기
          },
          child: AppCachedImage(
            imageUrl: message.content,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // 텍스트 메시지
      messageContent = Text(
        message.content,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              child: ClipOval(
                child:
                    widget.otherUser.profileImage != null
                        ? AppCachedImage(
                          imageUrl: widget.otherUser.profileImage!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.person, size: 20),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isMe)
            Text(
              timeText,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          const SizedBox(width: 4),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding:
                message.isImage
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: messageContent,
          ),
          const SizedBox(width: 4),
          if (!isMe)
            Text(
              timeText,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatGlobalViewModel.notifier).sendMessage(text);
    _messageController.clear();

    // 메시지 전송 후 스크롤을 아래로 이동
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      await ref.read(chatGlobalViewModel.notifier).sendImageMessage(file);
    }
  }

  void _showLeaveConfirmDialog(BuildContext context) async {
    // static 메서드는 클래스를 통해 직접 접근
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
}
