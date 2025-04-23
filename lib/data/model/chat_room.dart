import 'package:lang_mate/data/model/user.dart';

class ChatRoom {
  final String id;
  final String name;
  final List<User> participants;
  final DateTime lastMessageTime;
  final String? lastMessageText;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.lastMessageTime,
    this.lastMessageText,
  });
}