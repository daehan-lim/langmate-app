//       {
//         "id": 59243509,
//         "senderId": "user_other_user",
//         "content": "안녕하세요?",
//         "createdAt": "2024-11-13T16:48:35.131Z"
//       }

class ChatMessage {
  String id;
  String senderId;
  String content;
  DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  ChatMessage.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          senderId: map['senderId'],
          content: map['content'],
          createdAt: DateTime.parse(map['createdAt']),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
