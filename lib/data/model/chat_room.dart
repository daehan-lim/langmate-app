class ChatRoom {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime? lastTimestamp;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastTimestamp,
  });

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoom(
      id: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'] ?? '',
      lastTimestamp:
          map['lastTimestamp'] != null
              ? DateTime.parse(map['lastTimestamp'])
              : DateTime.now(),
    );
  }
}
