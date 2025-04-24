import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/app_providers.dart';
import '../../../../../data/model/chat_message.dart';
import '../../../../../data/model/chat_models.dart';

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
  String? _currentUserId;
  String? _currentUsername;
  String? _currentLocation;

  @override
  ChatState build() {
    // 비어 있는 초기 상태만 반환
    return ChatState();
  }

  // 초기 메시지 로딩 - 화면에서 호출해줘야 함
  void initialize(String userId, String username, String location) {
    _currentUserId = userId;
    _currentUsername = username;
    _currentLocation = location;

    // 초기 로딩 상태
    state = state.copyWith(isLoading: true);

    // 기존 메시지 로딩 (예제 데이터는 유지)
    loadInitialMessages();

    // Firestore 메시지 구독
    if (_currentLocation != null) {
      _subscribeToMessages(_currentLocation!);
    }
  }

  // 기존 메시지 로딩 메서드 (변경 전 메서드 유지)
  void loadInitialMessages() {
    state = state.copyWith(isLoading: true);

    // 더미 데이터를 로딩
    final initialMessages = [
      ChatMessage(
        type: MessageType.received,
        text: '안녕하세요',
        timestamp: '2025-04-24T20:57:14',
      ),
      ChatMessage(
        type: MessageType.sent,
        text: '네 안녕하세요',
        timestamp: '2025-04-24T20:57:57',
      ),
    ];

    state = state.copyWith(messages: initialMessages, isLoading: false);
  }

  // 메시지 구독 설정
  void _subscribeToMessages(String address) {
    ref.listen(chatStreamProvider(address), (previous, next) {
      next.when(
        data: (messages) {
          // Firestore에서 가져온 메시지를 UI에 표시할 형태로 변환
          final chatMessages =
              messages
                  .map(
                    (msg) => ChatMessage(
                      type:
                          msg.senderId == _currentUserId
                              ? MessageType.sent
                              : MessageType.received,
                      text: msg.text,
                      timestamp: msg.timestamp.toIso8601String(),
                    ),
                  )
                  .toList();

          state = state.copyWith(messages: chatMessages, isLoading: false);
        },
        loading: () {
          state = state.copyWith(isLoading: true);
        },
        error: (error, stack) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: '메시지를 불러오는 중 오류가 발생했습니다: $error',
          );
        },
      );
    });
  }

  // 새 메시지 추가
  Future<void> addMessage(String text) async {
    if (_currentUserId == null ||
        _currentUsername == null ||
        _currentLocation == null) {
      state = state.copyWith(errorMessage: '사용자 정보가 없습니다.');
      return;
    }

    try {
      final now = DateTime.now();
      final message = Message(
        id: '', // Firestore에서 자동 생성될 ID
        sender: _currentUsername!,
        senderId: _currentUserId!,
        text: text,
        address: _currentLocation!,
        timestamp: now,
      );

      final chatRepository = ref.read(chatRepositoryProvider);
      await chatRepository.addChat(message);

      // UI 업데이트를 위한 로컬 메시지 추가 (실제로는 구독을 통해 업데이트됨)
      final newMessage = ChatMessage(
        type: MessageType.sent,
        text: text,
        timestamp: now.toIso8601String(),
      );

      final updatedMessages = [...state.messages, newMessage];
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(errorMessage: '메시지 전송 중 오류가 발생했습니다: $e');
    }
  }

  // 메시지 형식 변환 (기존 코드 유지)
  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
