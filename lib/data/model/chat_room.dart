import 'package:lang_mate/data/model/app_user.dart';

class ChatRoom {
  final String id;
  final String name;
  final List<AppUser> participants;
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