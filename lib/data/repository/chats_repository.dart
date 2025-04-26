import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_room.dart';
import '../model/message.dart';

abstract class ChatsRepository {
  Future<String> createOrGetChatRoom(String myUserId, String otherUserId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  });

  Stream<List<Message>> getMessages(String chatId);

  Stream<List<ChatRoom>> getChatRooms(String myUserId);
}

class ChatRepositoryFirebase implements ChatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> createOrGetChatRoom(String myUserId, String otherUserId) async {
    final query = await _firestore
        .collection('chats')
        .where('participants', arrayContains: myUserId)
        .get();

    for (var doc in query.docs) {
      final List participants = doc['participants'];
      if (participants.contains(otherUserId)) {
        return doc.id; // Chat already exists
      }
    }

    final docRef = await _firestore.collection('chats').add({
      'participants': [myUserId, otherUserId],
      'lastMessage': '',
      'lastTimestamp': null, // Will be updated after first message
    });

    return docRef.id;
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final timestamp = FieldValue.serverTimestamp();

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': timestamp,
    });
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.id, doc.data()))
        .toList());
  }

  @override
  Stream<List<ChatRoom>> getChatRooms(String myUserId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: myUserId)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatRoom.fromMap(doc.id, doc.data()))
        .where((chat) => chat.lastTimestamp != null && chat.lastMessage.isNotEmpty)
        .toList());
  }
}
