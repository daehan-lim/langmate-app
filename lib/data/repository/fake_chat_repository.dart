import 'dart:async';

import 'package:lang_mate/data/model/app_user.dart';

import '../model/chat_message.dart';
import '../model/chat_room.dart';

class FakeChatRepository {
  Future<List<ChatRoom>?> getChatRooms() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      ChatRoom(
        id: '1',
        participants: [
          AppUser(
            id: 'Kz2UPg1OB5fPhZKpZ2hFhhc8NHV2', // me
            name: '민수',
            district: '서울특별시 은평구 불광동',
            profileImage: 'https://picsum.photos/200/200?random=1',
            nativeLanguage: '한국어',
            targetLanguage: '영어',
            bio: '여행과 새로운 언어 배우기를 좋아합니다.',
            age: 25,
            partnerPreference: '가벼운 대화를 즐기는 분이면 좋겠어요.',
          ),
          AppUser(
            id: 'user_1',
            name: '준호',
            district: '서울특별시 은평구 녹번동',
            profileImage: 'https://picsum.photos/seed/1/200/200',
            nativeLanguage: '한국어',
            targetLanguage: '영어',
            bio: '산책하면서 대화하는 걸 선호해요.',
            age: 22,
            partnerPreference: '친근하고 편하게 이야기 나눌 수 있는 분 환영!',
          ),
        ],
        messages: [
          ChatMessage(
            id: '1',
            senderId: "Kz2UPg1OB5fPhZKpZ2hFhhc8NHV2",
            content: "안녕하세요, 물건 아직 있나요?",
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ChatMessage(
            id: '2',
            senderId: "user_1",
            content: "네, 아직 있습니다.",
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<ChatRoom?> detail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final rooms = await getChatRooms();
    return rooms?.firstWhere((room) => room.id == id);
  }

  Future<ChatRoom?> create(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
