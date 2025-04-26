class MessageOriginal {
  final String id; // Firestore 문서 ID 저장용
  final String sender; // 보낸 사람 이름
  final String senderId; // 보낸 사람 ID
  final String text; // 메시지 내용 (요구사항의 'message'에 해당)
  final String address; // 위치 정보
  final DateTime timestamp; // 타임스탬프 (요구사항의 'createdAt'에 해당)
  final bool isRead; // 읽음 상태

  MessageOriginal({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.text,
    required this.address,
    required this.timestamp,
    this.isRead = false,
  });

  // Firestore에서 데이터를 가져올 때 사용
  factory MessageOriginal.fromMap(Map<String, dynamic> map, String docId) {
    return MessageOriginal(
      id: docId,
      sender: map['sender'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['message'] ?? '',
      address: map['address'] ?? '',
      timestamp:
          map['lastTimestamp'] != null
              ? DateTime.parse(map['lastTimestamp'])
              : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  // Firestore에 데이터를 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'senderId': senderId,
      'message': text, // 'message'로 저장 (요구사항에 맞춤)
      'address': address,
      'createdAt': timestamp.toIso8601String(), // 'createdAt'으로 저장 (요구사항에 맞춤)
      'isRead': isRead,
    };
  }
}
