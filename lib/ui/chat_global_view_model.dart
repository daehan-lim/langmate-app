import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/new/chat_room.dart';
import '../data/repository/fake_chat_repository.dart';

class ChatGlobalState {
  List<ChatRoom> chatRooms;
  ChatRoom? currentChatRoom;
  ChatGlobalState({
    required this.chatRooms,
    required this.currentChatRoom,
  });

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
  @override
  ChatGlobalState build() {
    fetchChatRooms();
    return ChatGlobalState(
      chatRooms: [],
      currentChatRoom: null,
    );
  }

  final chatRepository = FakeChatRepository();

  Future<void> fetchChatRooms() async { // should be changed to use subscription and listen instead
    final chatRooms = await chatRepository.getChatRooms();
    if (chatRooms != null) {
      state = state.copyWith(
        chatRooms: chatRooms,
      );
    }
  }

  Future<void> fetchChatDetail(String roomId) async {
    final currentChatRoom = await chatRepository.detail(roomId);
    if (currentChatRoom != null) {
      state = state.copyWith(
        currentChatRoom: currentChatRoom,
      );
    }
  }

  // other methods like send message, create etc. need to be included


  // ChatSocket? chatSocket;
  //
  // void connectSocket() {
  //   chatSocket = chatRepository.connectSocket();
  //   final subscription = chatSocket!.messageStream.listen((chatRoom) {
  //     // 1. chatRooms 업데이트
  //     final chatRooms = state.chatRooms;
  //     final target =
  //         chatRooms.where((e) => e.id == chatRoom.id).toList();
  //     if (target.isNotEmpty) {
  //       final newList = chatRooms.map((e) {
  //         if (e.id == chatRoom.id) {
  //           return chatRoom;
  //         }
  //         return e;
  //       }).toList();
  //       state = state.copyWith(
  //         chatRooms: newList,
  //       );
  //     } else {
  //       state = state.copyWith(
  //         chatRooms: [...chatRooms, chatRoom],
  //       );
  //     }
  //     // 2. chatRoom 업데이트
  //     final room = state.currentChatRoom;
  //     if (room?.id == chatRoom.id) {
  //       //
  //       state = state.copyWith(
  //         chatRoom: ChatRoom(
  //           id: room!.id,
  //           product: room.product,
  //           sender: room.sender,
  //           messages: [...room.messages, chatRoom.messages.first],
  //           createdAt: room.createdAt,
  //         ),
  //       );
  //     }
  //   });
  //
  //   ref.onDispose(() {
  //     subscription.cancel();
  //   });
  // }

  // void send(String content) {
  //   final room = state.currentChatRoom;
  //   if (room != null) {
  //     chatSocket?.sendMessage(
  //       content: content,
  //       id: room.id,
  //     );
  //   }
  // }
}

final chatGlobalViewModel =
    NotifierProvider<ChatGlobalViewModel, ChatGlobalState>(() {
  return ChatGlobalViewModel();
});
