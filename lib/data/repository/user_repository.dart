import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getNearbyUsers(AppUser user);
}

class UserRepositoryFirebase implements UserRepository {
  @override
  Future<List<AppUser>> getNearbyUsers(AppUser user) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('district', isEqualTo: user.district)
            .where('nativeLanguage', isEqualTo: user.targetLanguage)
            .where('targetLanguage', isEqualTo: user.nativeLanguage)
            .get();
    return List<AppUser>.from(
      snapshot.docs
          .where((queryDocumentSnapshot) => queryDocumentSnapshot.id != user.id)
          .map((queryDocumentSnapshot) {
            return AppUser.fromMap(
              queryDocumentSnapshot.id,
              queryDocumentSnapshot.data(),
            );
          }),
    );
  }
}

class UserRepositoryMock implements UserRepository {
  @override
  Future<List<AppUser>> getNearbyUsers(AppUser user) async {
    await Future.delayed(Duration(seconds: 1));
    return [];
    // return [
    //   AppUser(
    //     id: '1',
    //     name: '민수',
    //     district: '서울특별시 은평구 불광동',
    //     profileImage: 'https://picsum.photos/200/200?random=1',
    //     nativeLanguage: '한국어',
    //     targetLanguage: '영어',
    //     bio: '여행과 새로운 언어 배우기를 좋아합니다.',
    //     age: 25,
    //     partnerPreference: '가벼운 대화를 즐기는 분이면 좋겠어요.',
    //   ),
    //   AppUser(
    //     id: '2',
    //     name: '소영',
    //     district: '서울특별시 강남구 역삼동',
    //     profileImage: 'https://picsum.photos/200/200?random=2',
    //     nativeLanguage: '한국어',
    //     targetLanguage: '일본어',
    //     bio: '맛집 탐방을 좋아하며 일본어 실력을 키우고 싶어요.',
    //     age: 30,
    //     partnerPreference: '친절하고 인내심 있는 언어 파트너를 원합니다.',
    //   ),
    //   AppUser(
    //     id: '3',
    //     name: '다니엘',
    //     district: '부산광역시 해운대구 우동',
    //     profileImage: 'https://picsum.photos/200/200?random=3',
    //     nativeLanguage: '영어',
    //     targetLanguage: '한국어',
    //     bio: '애니메이션을 좋아하는 언어 학습자입니다.',
    //     age: 22,
    //     partnerPreference: '비슷한 관심사를 가진 분을 찾고 있어요.',
    //   ),
    //   AppUser(
    //     id: '4',
    //     name: '지민',
    //     district: '대구광역시 수성구 범어동',
    //     profileImage: 'https://picsum.photos/200/200?random=4',
    //     nativeLanguage: '한국어',
    //     targetLanguage: '중국어',
    //     bio: '중국어를 연습하고 싶은 학생입니다.',
    //     age: 28,
    //     partnerPreference: '깊이 있는 대화를 즐기는 분이면 좋겠어요.',
    //   ),
    //   AppUser(
    //     id: '5',
    //     name: '유키',
    //     district: '인천광역시 연수구 송도동',
    //     profileImage: 'https://picsum.photos/200/200?random=5',
    //     nativeLanguage: '일본어',
    //     targetLanguage: '한국어',
    //     bio: '기술에 관심이 많고 새로운 문화를 탐험하고 싶어요.',
    //     age: 35,
    //     partnerPreference: '기술에 열정적인 분을 만나고 싶습니다.',
    //   ),
    //   AppUser(
    //     id: '6',
    //     name: '리우',
    //     district: '경기도 성남시 분당구 정자동',
    //     profileImage: 'https://picsum.photos/200/200?random=6',
    //     nativeLanguage: '중국어',
    //     targetLanguage: '한국어',
    //     bio: '유학 준비 중인 학생입니다.',
    //     age: 20,
    //     partnerPreference: '학문적인 한국어를 도와줄 수 있는 분을 찾고 있어요.',
    //   ),
    // ];
  }
}
