import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';

import '../app/app_providers.dart';
import '../data/model/app_user.dart';
import '../data/model/chat_message.dart';
import '../data/model/chat_room.dart';

class ChatGlobalState {
  final List<ChatRoom> chatRooms;
  final ChatRoom? currentChatRoom;

  ChatGlobalState({required this.chatRooms, this.currentChatRoom});

  ChatGlobalState copyWith({
    List<ChatRoom>? chatRooms,
    ChatRoom? currentChatRoom,
  }) {
    return ChatGlobalState(
      chatRooms: chatRooms ?? this.chatRooms,
      currentChatRoom: currentChatRoom ?? this.currentChatRoom,
    );
  }
}

class ChatGlobalViewModel extends Notifier<ChatGlobalState> {
  StreamSubscription<List<ChatRoom>>? _chatRoomsSubscription;
  StreamSubscription<List<ChatMessage>>? _chatMessagesSubscription;

  @override
  ChatGlobalState build() {
    return ChatGlobalState(chatRooms: []);
  }

  void initialize(String userId) {
    // Cancel previous subscriptions if they exist
    _chatRoomsSubscription?.cancel();

    // Get the chat repository
    final chatRepository = ref.read(chatRepositoryProvider);

    // Subscribe to chat rooms
    _chatRoomsSubscription = chatRepository.getUserChatRooms(userId).listen((
      chatRooms,
    ) {
      state = state.copyWith(chatRooms: chatRooms);
    });

    // Set up disposal
    ref.onDispose(() {
      _chatRoomsSubscription?.cancel();
      _chatMessagesSubscription?.cancel();
    });
  }

  void clearCurrentChat() {
    state = state.copyWith(currentChatRoom: null);
  }

  Future<void> openChatWithUser(AppUser currentUser, AppUser otherUser) async {
    final chatRepository = ref.read(chatRepositoryProvider);

    final chatRoomId = await chatRepository.createOrGetChatRoom(
      currentUser,
      otherUser,
    );

    // Fetch existing messages or create empty chat room
    await fetchChatDetail(chatRoomId);

    // If chat room is new, initialize with empty messages
    if (state.currentChatRoom == null) {
      final newChatRoom = ChatRoom(
        id: chatRoomId,
        participants: [currentUser, otherUser],
        messages: [],
        createdAt: DateTime.now(),
      );

      state = state.copyWith(currentChatRoom: newChatRoom);
    }
  }

  Future<void> fetchChatDetail(String chatRoomId) async {
    // Cancel previous messages subscription if exists
    _chatMessagesSubscription?.cancel();

    // Find the chat room in existing list
    final chatRoom = state.chatRooms.firstWhere(
          (room) => room.id == chatRoomId,
      orElse: () => ChatRoom(
        id: chatRoomId,
        participants: [],
        messages: [],
        createdAt: DateTime.now(),
      ),
    );

    state = state.copyWith(currentChatRoom: chatRoom);

    final chatRepository = ref.read(chatRepositoryProvider);

    // Listen to messages for this chat room
    _chatMessagesSubscription = chatRepository
        .getChatMessages(chatRoomId)
        .listen((messages) {
      final updatedChatRoom = ChatRoom(
        id: chatRoom.id,
        participants: chatRoom.participants,
        messages: messages,
        createdAt: chatRoom.createdAt,
      );

      state = state.copyWith(currentChatRoom: updatedChatRoom);
    });
  }

  Future<void> sendMessage(String content) async {
    if (state.currentChatRoom == null) return;

    final userViewModel = ref.read(userGlobalViewModelProvider);
    if (userViewModel == null) return;

    try {
      final chatRepository = ref.read(chatRepositoryProvider);

      await chatRepository.sendMessage(
        chatRoomId: state.currentChatRoom!.id,
        senderId: userViewModel.id,
        content: content,
      );
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}

final chatGlobalViewModel =
    NotifierProvider<ChatGlobalViewModel, ChatGlobalState>(
      () => ChatGlobalViewModel(),
    );
