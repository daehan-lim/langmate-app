import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_user.dart';
import '../model/chat_message.dart';
import '../model/chat_room.dart';
import 'user_repository.dart';

abstract class ChatRepository {
  Future<String> createOrGetChatRoom(AppUser currentUser, AppUser otherUser);

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
  });

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId);

  Stream<List<ChatRoom>> getUserChatRooms(String userId);
}

class ChatRepositoryFirebase implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepository;

  ChatRepositoryFirebase(this._userRepository);

  @override
  Future<String> createOrGetChatRoom(
    AppUser currentUser,
    AppUser otherUser,
  ) async {
    // Sort user IDs to create a consistent chat room ID
    final List<String> sortedUserIds = [currentUser.id, otherUser.id]..sort();
    final String chatRoomId = sortedUserIds.join('_');
    print(chatRoomId);

    // Check if chat room already exists
    final chatRoomDoc =
        await _firestore.collection('chatRooms').doc(chatRoomId).get();

    if (!chatRoomDoc.exists) {
      print('Chatroom not exists');
      // Create new chat room if it doesn't exist
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'participants': sortedUserIds,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
    print('Chatroom  exists');

    return chatRoomId;
  }

  @override
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
  }) async {
    final messageId =
        _firestore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .doc()
            .id;

    final message = ChatMessage(
      id: messageId,
      senderId: senderId,
      content: content,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // Update last message reference in the chat room
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': message.toMap(),
      'lastMessageAt': message.createdAt.toIso8601String(),
    });
  }

  @override
  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatMessage.fromMap(doc.data());
          }).toList();
        });
  }

  @override
  Stream<List<ChatRoom>> getUserChatRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ChatRoom> chatRooms = [];

          for (var doc in snapshot.docs) {
            List<String> participantIds = List<String>.from(
              doc.data()['participants'],
            );
            List<AppUser> participants = [];

            // Get user details for each participant
            for (String participantId in participantIds) {
              AppUser? user = await _userRepository.getUserById(participantId);
              if (user != null) {
                participants.add(user);
              }
            }

            // Get the last message for preview
            final lastMessageData = doc.data()['lastMessage'];
            List<ChatMessage> messages = [];

            if (lastMessageData != null) {
              messages.add(ChatMessage.fromMap(lastMessageData));
            }

            // Only add chats that have at least one message
            if (messages.isNotEmpty) {
              chatRooms.add(
                ChatRoom.fromMap(doc.id, doc.data(), participants, messages),
              );
            }
          }

          return chatRooms;
        });
  }
}
