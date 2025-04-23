// lib/data/model/chat_models.dart

class User {
  final String id;
  final String name;
  final String? location;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    this.location,
    this.profileImage,
  });
}

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

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
}

// 채팅 페이지에서 사용하는 메시지 타입
enum MessageType { sent, received }

class ChatMessage {
  final MessageType type;
  final String text;
  final String timestamp;

  ChatMessage({
    required this.type,
    required this.text,
    required this.timestamp,
  });
}
