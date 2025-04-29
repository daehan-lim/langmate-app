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
    bool isImage,
  });

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId);

  Stream<List<ChatRoom>> getUserChatRooms(String userId);

  /// 채팅방 삭제
  ///
  /// [chatRoomId] 삭제할 채팅방 ID
  /// [userId] 삭제를 요청한 사용자 ID
  Future<void> leaveChatRoom(String chatRoomId, String userId);
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
    bool isImage = false,
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
      isImage: isImage,
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

  @override
  Future<void> leaveChatRoom(String chatRoomId, String userId) async {
    try {
      // Firebase에서는 채팅방을 물리적으로 삭제하지 않고
      // 참가자 목록에서 사용자를 제거하거나, 참가자가 모두 나가면 채팅방을 삭제하는 방식을 사용할 수 있음

      // 채팅방 문서 가져오기
      final chatRoomDoc =
          await _firestore.collection('chatRooms').doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        print('채팅방이 존재하지 않습니다: $chatRoomId');
        return;
      }

      // 참가자 목록 가져오기
      List<String> participants = List<String>.from(
        chatRoomDoc.data()?['participants'] ?? [],
      );

      // 참가자가 두 명 이하면 채팅방 자체를 삭제 (우리 앱에서는 1:1 채팅만 지원하므로)
      if (participants.length <= 2) {
        // 메시지 서브컬렉션 모두 삭제 (Firebase에서 한번에 컬렉션을 삭제할 수 없으므로
        // 일정 수 이상의 메시지가 있는 경우 Cloud Functions으로 처리하는 것이 좋음)
        final messagesSnapshot =
            await _firestore
                .collection('chatRooms')
                .doc(chatRoomId)
                .collection('messages')
                .limit(100) // 제한된 개수만 가져옴 (실제 앱에서는 모든 메시지를 삭제해야 함)
                .get();

        final batch = _firestore.batch();

        for (var doc in messagesSnapshot.docs) {
          batch.delete(doc.reference);
        }

        // 채팅방 자체도 삭제
        batch.delete(_firestore.collection('chatRooms').doc(chatRoomId));

        await batch.commit();
        print('채팅방 삭제 완료: $chatRoomId');
      }
      // 참가자가 더 많은 경우 (그룹 채팅 기능을 구현한다면)
      else {
        // 해당 사용자만 참가자 목록에서 제거
        participants.remove(userId);

        await _firestore.collection('chatRooms').doc(chatRoomId).update({
          'participants': participants,
        });

        print('채팅방에서 사용자 제거 완료: $userId');
      }
    } catch (e) {
      print('채팅방 나가기 오류: $e');
      throw e;
    }
  }
}
