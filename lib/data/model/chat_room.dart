import 'package:lang_mate/data/model/app_user.dart';

import 'chat_message.dart';


class ChatRoom {
  final String id;
  final List<AppUser> participants;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
  });

  factory ChatRoom.fromMap(
      String id,
      Map<String, dynamic> map,
      List<AppUser> participants,
      List<ChatMessage> messages
      ) {
    return ChatRoom(
      id: id,
      participants: participants,
      messages: messages,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants.map((user) => user.id).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}