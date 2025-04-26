import 'package:lang_mate/data/model/app_user.dart';

import 'chat_message.dart';


class ChatRoom {
  String id;
  final List<AppUser> participants;
  List<ChatMessage> messages;
  DateTime createdAt;
  ChatRoom({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
  });
}
