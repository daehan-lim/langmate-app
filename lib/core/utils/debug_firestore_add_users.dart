import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/model/app_user.dart';

void assignLanguageLearningGoals(BuildContext context) async {
  final firestore = FirebaseFirestore.instance;

  try {
    for (int i = 1; i <= 35; i++) {
      final docId = 'user_$i';
      final docRef = firestore.collection('users').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'languageLearningGoal': learningGoals[i % learningGoals.length],
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Language learning goals successfully assigned!')),
    );
  } catch (e) {
    print('🔥 Error assigning language learning goals: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Failed to assign goals: ${e.toString()}')),
    );
  }
}

void updateTestDistricts(BuildContext context) async {
  try {
    final firestore = FirebaseFirestore.instance;

    final querySnapshot = await firestore
        .collection('users')
        .where('district', isEqualTo: '서울특별시 강남구 청담동')
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({
        'district': '서울특별시 강남구 청담동',
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ All test districts updated successfully.')),
    );
  } catch (e) {
    print('🔥 Error updating test districts: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Failed to update districts: ${e.toString()}')),
    );
  }
}


void removeDebugUsers(BuildContext context) async {
  try {
    final firestore = FirebaseFirestore.instance;

    for (int i = 1; i <= 28; i++) {
      final docId = 'user_$i';
      final docRef = firestore.collection('users').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.delete();
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🗑 테스트 유저들이 성공적으로 삭제되었습니다.')));
  } catch (e) {
    print('🔥 Error deleting test users: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('❌ 삭제 중 오류가 발생했습니다.')));
  }
}

void addDebugUsersFromJson(BuildContext context) async {
  try {
    final jsonMap = jsonDecode(Json4UsersUnknownLocation) as Map<String, dynamic>;
    final usersMap = jsonMap['users'] as Map<String, dynamic>;

    final firestore = FirebaseFirestore.instance;

    for (final entry in usersMap.entries) {
      final userId = entry.key;
      final userData = entry.value as Map<String, dynamic>;

      final user = AppUser.fromMap(userId, userData);

      await firestore.collection('users').doc(user.id).set(user.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Success: 테스트 유저들이 성공적으로 추가되었습니다.')),
    );
  } catch (e) {
    print('🔥 Error seeding users: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fail: 유저 추가 중 오류가 발생했습니다. ${e.toString()}')),
    );
  }
}

const List<String> learningGoals = [
  '자연스럽게 일상 대화를 하고 싶어요.',
  '비즈니스 회화를 배우고 싶어요.',
  '여행할 때 자유롭게 말하고 싶어요.',
  '문화에 대해 깊이 이해하고 싶어요.',
  '새로운 친구를 사귀고 싶어요.',
  '드라마를 자막 없이 보고 싶어요.',
  '책을 원어로 읽고 싶어요.',
  '자신감을 가지고 말하고 싶어요.',
  '시험 준비를 하고 있어요.',
  '뉴스를 이해하고 싶어요.',
  '노래 가사를 이해하고 싶어요.',
  '글쓰기 실력을 향상시키고 싶어요.',
  '발음을 자연스럽게 하고 싶어요.',
  '프레젠테이션을 잘하고 싶어요.',
  '면접 준비를 하고 있어요.',
  '학업을 위해 필요해요.',
  '자녀와 소통하고 싶어요.',
  'SNS에서 자유롭게 소통하고 싶어요.',
  '취미로 배우고 있어요.',
  '이중언어를 목표로 하고 있어요.',
  '다른 나라에서 살고 싶어요.',
  '언어를 통해 사고를 확장하고 싶어요.',
  '원어민과 쉽게 대화하고 싶어요.',
  '언어 교환 친구를 만들고 싶어요.',
  '전화 대화를 자연스럽게 하고 싶어요.',
  '이메일을 자연스럽게 쓰고 싶어요.',
  '포멀한 상황에서 잘 말하고 싶어요.',
  '캐주얼한 대화를 즐기고 싶어요.',
  '스토리텔링 능력을 키우고 싶어요.',
  '토론을 잘하고 싶어요.',
  '감정을 자연스럽게 표현하고 싶어요.',
  '새로운 언어를 경험하고 싶어요.',
  '언어 장벽을 넘고 싶어요.',
  '여러 언어를 동시에 배우고 싶어요.',
  '현지 생활을 더 풍성하게 하고 싶어요.',
  '자기 소개를 자연스럽게 하고 싶어요.'
];

const Json4UsersUnknownLocation = '''
{
  "users": {
    "user_11": {
      "name": "Michael M",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 강남구 청담동",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 24,
      "email": "michael11@test.com",
      "createdAt": "2025-04-22T06:45:27.663852",
      "profileImage": "https://picsum.photos/seed/11/200/200"
    },
    "user_12": {
      "name": "Jessica J",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 강남구 청담동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 24,
      "email": "jessica12@test.com",
      "createdAt": "2025-01-30T06:45:27.663861",
      "profileImage": "https://picsum.photos/seed/12/200/200"
    },
    "user_13": {
      "name": "Emma E",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 강남구 청담동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 38,
      "email": "emma13@test.com",
      "createdAt": "2025-02-03T06:45:27.663867",
      "profileImage": "https://picsum.photos/seed/13/200/200"
    },
    "user_14": {
      "name": "Ashley A",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 강남구 청담동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 37,
      "email": "ashley14@test.com",
      "createdAt": "2025-04-16T06:45:27.663872",
      "profileImage": "https://picsum.photos/seed/14/200/200"
    }
  }  
}
''';

const jsonString28 = '''
{
  "users": {
    "user_1": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 22,
      "email": "1@test.com",
      "createdAt": "2025-01-18T06:45:27.663715",
      "profileImage": "https://picsum.photos/seed/1/200/200"
    },
    "user_2": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 20,
      "email": "2@test.com",
      "createdAt": "2025-03-01T06:45:27.663735",
      "profileImage": "https://picsum.photos/seed/2/200/200"
    },
    "user_3": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 33,
      "email": "3@test.com",
      "createdAt": "2025-02-17T06:45:27.663743",
      "profileImage": "https://picsum.photos/seed/3/200/200"
    },
    "user_4": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 25,
      "email": "4@test.com",
      "createdAt": "2025-02-26T06:45:27.663749",
      "profileImage": "https://picsum.photos/seed/4/200/200"
    },
    "user_5": {
      "name": "수빈",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 34,
      "email": "5@test.com",
      "createdAt": "2025-03-24T06:45:27.663756",
      "profileImage": "https://picsum.photos/seed/5/200/200"
    },
    "user_6": {
      "name": "하늘",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 24,
      "email": "6@test.com",
      "createdAt": "2025-01-19T06:45:27.663761",
      "profileImage": "https://picsum.photos/seed/6/200/200"
    },
    "user_7": {
      "name": "지민",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 27,
      "email": "7@test.com",
      "createdAt": "2025-01-21T06:45:27.663768",
      "profileImage": "https://picsum.photos/seed/7/200/200"
    },
    "user_8": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 40,
      "email": "8@test.com",
      "createdAt": "2025-02-07T06:45:27.663777",
      "profileImage": "https://picsum.photos/seed/8/200/200"
    },
    "user_9": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 29,
      "email": "9@test.com",
      "createdAt": "2025-02-01T06:45:27.663785",
      "profileImage": "https://picsum.photos/seed/9/200/200"
    },
    "user_10": {
      "name": "도윤",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 23,
      "email": "10@test.com",
      "createdAt": "2025-03-24T06:45:27.663791",
      "profileImage": "https://picsum.photos/seed/10/200/200"
    },
    "user_11": {
      "name": "Michael",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 24,
      "email": "michael11@test.com",
      "createdAt": "2025-04-22T06:45:27.663852",
      "profileImage": "https://picsum.photos/seed/11/200/200"
    },
    "user_12": {
      "name": "Jessica",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 24,
      "email": "jessica12@test.com",
      "createdAt": "2025-01-30T06:45:27.663861",
      "profileImage": "https://picsum.photos/seed/12/200/200"
    },
    "user_13": {
      "name": "Emma",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 38,
      "email": "emma13@test.com",
      "createdAt": "2025-02-03T06:45:27.663867",
      "profileImage": "https://picsum.photos/seed/13/200/200"
    },
    "user_14": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 37,
      "email": "ashley14@test.com",
      "createdAt": "2025-04-16T06:45:27.663872",
      "profileImage": "https://picsum.photos/seed/14/200/200"
    },
    "user_15": {
      "name": "Jessica",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 21,
      "email": "jessica15@test.com",
      "createdAt": "2025-02-11T06:45:27.663878",
      "profileImage": "https://picsum.photos/seed/15/200/200"
    },
    "user_16": {
      "name": "Chris",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 36,
      "email": "chris16@test.com",
      "createdAt": "2025-01-18T06:45:27.663884",
      "profileImage": "https://picsum.photos/seed/16/200/200"
    },
    "user_17": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 27,
      "email": "ashley17@test.com",
      "createdAt": "2025-04-11T06:45:27.663891",
      "profileImage": "https://picsum.photos/seed/17/200/200"
    },
    "user_18": {
      "name": "James",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 33,
      "email": "james18@test.com",
      "createdAt": "2025-02-06T06:45:27.663897",
      "profileImage": "https://picsum.photos/seed/18/200/200"
    },
    "user_19": {
      "name": "Sarah",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 35,
      "email": "sarah19@test.com",
      "createdAt": "2025-04-16T06:45:27.663903",
      "profileImage": "https://picsum.photos/seed/19/200/200"
    },
    "user_20": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 34,
      "email": "ashley20@test.com",
      "createdAt": "2025-03-11T06:45:27.663909",
      "profileImage": "https://picsum.photos/seed/20/200/200"
    },
    "user_21": {
      "name": "도윤",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 23,
      "email": "21@test.com",
      "createdAt": "2025-01-29T06:45:27.663995",
      "profileImage": "https://picsum.photos/seed/21/200/200"
    },
    "user_22": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 36,
      "email": "22@test.com",
      "createdAt": "2025-03-20T06:45:27.664004",
      "profileImage": "https://picsum.photos/seed/22/200/200"
    },
    "user_23": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "targetLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 36,
      "email": "23@test.com",
      "createdAt": "2025-04-01T06:45:27.664011",
      "profileImage": "https://picsum.photos/seed/23/200/200"
    },
    "user_24": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "targetLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 24,
      "email": "24@test.com",
      "createdAt": "2025-03-27T06:45:27.664017",
      "profileImage": "https://picsum.photos/seed/24/200/200"
    },
    "user_25": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 40,
      "email": "25@test.com",
      "createdAt": "2025-04-02T06:45:27.664024",
      "profileImage": "https://picsum.photos/seed/25/200/200"
    },
    "user_26": {
      "name": "수빈",
      "nativeLanguage": "한국어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 20,
      "email": "26@test.com",
      "createdAt": "2025-03-09T06:45:27.664030",
      "profileImage": "https://picsum.photos/seed/26/200/200"
    },
    "user_27": {
      "name": "민수",
      "nativeLanguage": "한국어",
      "targetLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 20,
      "email": "27@test.com",
      "createdAt": "2025-01-21T06:45:27.664037",
      "profileImage": "https://picsum.photos/seed/27/200/200"
    },
    "user_28": {
      "name": "지훈",
      "nativeLanguage": "한국어",
      "targetLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 34,
      "email": "28@test.com",
      "createdAt": "2025-03-01T06:45:27.664043",
      "profileImage": "https://picsum.photos/seed/28/200/200"
    }
  }
}
''';