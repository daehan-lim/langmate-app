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