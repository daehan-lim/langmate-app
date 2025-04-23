import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/chat_message.dart';
import '../../../data/model/chat_models.dart';

// 채팅 페이지의 상태를 관리하는 클래스
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Riverpod Notifier 클래스로 상태 관리
class ChatViewModel extends Notifier<ChatState> {
  @override
  ChatState build() {
    // 비어 있는 초기 상태만 반환
    return ChatState();
  }

  // 초기 메시지 로딩 - 화면에서 호출해줘야 함
  void loadInitialMessages() {
    state = state.copyWith(isLoading: true);

    // 더미 데이터를 로딩 (원래는 await 비동기 호출이 있어야 할 자리)
    final initialMessages = [
      ChatMessage(
        type: MessageType.received,
        text: '안녕하세요',
        timestamp: '2024-11-15T20:57:14',
      ),
      ChatMessage(
        type: MessageType.sent,
        text: '네 안녕하세요',
        timestamp: '2024-11-15T20:57:57',
      ),
      ChatMessage(
        type: MessageType.received,
        text: '반갑습니다',
        timestamp: '2024-11-15T20:58:44',
      ),
    ];

    state = state.copyWith(messages: initialMessages, isLoading: false);
  }

  // 새 메시지 추가
  void addMessage(String text) {
    final now = DateTime.now().toIso8601String();
    final newMessage = ChatMessage(
      type: MessageType.sent,
      text: text,
      timestamp: now,
    );

    final updatedMessages = [...state.messages, newMessage];
    state = state.copyWith(messages: updatedMessages);
  }

  // 메시지 형식 변환
  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
