import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lang_mate/app/constants/app_styles.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../data/model/app_user.dart';

class UserListItem extends StatelessWidget {
  final AppUser user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () async {
        try {
          final jsonString = '''
          {
  "users": {
    "user_1": {
      "name": "채원",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=1",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 40,
      "email": "채원1@test.com",
      "createdAt": "2025-01-30T06:24:13.385954"
    },
    "user_2": {
      "name": "현우",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=2",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 27,
      "email": "현우2@test.com",
      "createdAt": "2025-03-24T06:24:13.385982"
    },
    "user_3": {
      "name": "유진",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=3",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 29,
      "email": "유진3@test.com",
      "createdAt": "2025-04-01T06:24:13.385993"
    },
    "user_4": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=4",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 29,
      "email": "준호4@test.com",
      "createdAt": "2025-03-31T06:24:13.386003"
    },
    "user_5": {
      "name": "태현",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=5",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 30,
      "email": "태현5@test.com",
      "createdAt": "2025-03-27T06:24:13.386018"
    },
    "user_6": {
      "name": "지아",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=6",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 27,
      "email": "지아6@test.com",
      "createdAt": "2025-02-03T06:24:13.386026"
    },
    "user_7": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=7",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 39,
      "email": "예진7@test.com",
      "createdAt": "2025-02-17T06:24:13.386033"
    },
    "user_8": {
      "name": "하늘",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=8",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 39,
      "email": "하늘8@test.com",
      "createdAt": "2025-04-17T06:24:13.386048"
    },
    "user_9": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=9",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 30,
      "email": "예진9@test.com",
      "createdAt": "2025-04-13T06:24:13.386058"
    },
    "user_10": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=10",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 31,
      "email": "서연10@test.com",
      "createdAt": "2025-02-13T06:24:13.386065"
    },
    "user_11": {
      "name": "채원",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=11",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 26,
      "email": "채원11@test.com",
      "createdAt": "2025-03-18T06:24:13.386073"
    },
    "user_12": {
      "name": "민수",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=12",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 26,
      "email": "민수12@test.com",
      "createdAt": "2025-03-21T06:24:13.386079"
    },
    "user_13": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=13",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 34,
      "email": "준호13@test.com",
      "createdAt": "2025-03-09T06:24:13.386084"
    },
    "user_14": {
      "name": "채원",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=14",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 22,
      "email": "채원14@test.com",
      "createdAt": "2025-02-20T06:24:13.386090"
    },
    "user_15": {
      "name": "지훈",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=15",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 23,
      "email": "지훈15@test.com",
      "createdAt": "2025-04-25T06:24:13.386096"
    },
    "user_16": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=16",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 33,
      "email": "예진16@test.com",
      "createdAt": "2025-02-17T06:24:13.386102"
    },
    "user_17": {
      "name": "수빈",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=17",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 26,
      "email": "수빈17@test.com",
      "createdAt": "2025-02-19T06:24:13.386107"
    },
    "user_18": {
      "name": "태현",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=18",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 23,
      "email": "태현18@test.com",
      "createdAt": "2025-03-17T06:24:13.386112"
    },
    "user_19": {
      "name": "준호",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=19",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 24,
      "email": "준호19@test.com",
      "createdAt": "2025-02-03T06:24:13.386118"
    },
    "user_20": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=20",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 34,
      "email": "서연20@test.com",
      "createdAt": "2025-01-30T06:24:13.386124"
    },
    "user_21": {
      "name": "유진",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=21",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 39,
      "email": "유진21@test.com",
      "createdAt": "2025-03-30T06:24:13.386130"
    },
    "user_22": {
      "name": "현우",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=22",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 40,
      "email": "현우22@test.com",
      "createdAt": "2025-04-23T06:24:13.386135"
    },
    "user_23": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=23",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 39,
      "email": "서연23@test.com",
      "createdAt": "2025-04-13T06:24:13.386158"
    },
    "user_24": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=24",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 29,
      "email": "서연24@test.com",
      "createdAt": "2025-03-21T06:24:13.386164"
    },
    "user_25": {
      "name": "유진",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=25",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 27,
      "email": "유진25@test.com",
      "createdAt": "2025-04-25T06:24:13.386169"
    },
    "user_26": {
      "name": "지아",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=26",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 33,
      "email": "지아26@test.com",
      "createdAt": "2025-04-04T06:24:13.386175"
    },
    "user_27": {
      "name": "수빈",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=27",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 21,
      "email": "수빈27@test.com",
      "createdAt": "2025-01-24T06:24:13.386180"
    },
    "user_28": {
      "name": "지훈",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=28",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 35,
      "email": "지훈28@test.com",
      "createdAt": "2025-03-25T06:24:13.386189"
    },
    "user_29": {
      "name": "가은",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=29",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 33,
      "email": "가은29@test.com",
      "createdAt": "2025-03-21T06:24:13.386194"
    },
    "user_30": {
      "name": "채원",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=30",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 26,
      "email": "채원30@test.com",
      "createdAt": "2025-01-27T06:24:13.386200"
    },
    "user_31": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=31",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 26,
      "email": "ashley31@test.com",
      "createdAt": "2025-04-21T06:24:13.386206"
    },
    "user_32": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=32",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 27,
      "email": "ashley32@test.com",
      "createdAt": "2025-02-05T06:24:13.386211"
    },
    "user_33": {
      "name": "Emma",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=33",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 27,
      "email": "emma33@test.com",
      "createdAt": "2025-02-18T06:24:13.386217"
    },
    "user_34": {
      "name": "James",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=34",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 36,
      "email": "james34@test.com",
      "createdAt": "2025-02-16T06:24:13.386222"
    },
    "user_35": {
      "name": "James",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=35",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 23,
      "email": "james35@test.com",
      "createdAt": "2025-02-11T06:24:13.386229"
    },
    "user_36": {
      "name": "Sarah",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=36",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 39,
      "email": "sarah36@test.com",
      "createdAt": "2025-02-01T06:24:13.386238"
    },
    "user_37": {
      "name": "Michael",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=37",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 21,
      "email": "michael37@test.com",
      "createdAt": "2025-02-17T06:24:13.386246"
    },
    "user_38": {
      "name": "Emily",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=38",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 34,
      "email": "emily38@test.com",
      "createdAt": "2025-02-19T06:24:13.386253"
    },
    "user_39": {
      "name": "Daniel",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=39",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 40,
      "email": "daniel39@test.com",
      "createdAt": "2025-03-07T06:24:13.386262"
    },
    "user_40": {
      "name": "Chris",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=40",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 38,
      "email": "chris40@test.com",
      "createdAt": "2025-02-05T06:24:13.386270"
    },
    "user_41": {
      "name": "도윤",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=41",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 36,
      "email": "도윤41@test.com",
      "createdAt": "2025-03-03T06:24:13.386277"
    },
    "user_42": {
      "name": "도윤",
      "nativeLanguage": "한국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=42",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 24,
      "email": "도윤42@test.com",
      "createdAt": "2025-04-09T06:24:13.386291"
    },
    "user_43": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=43",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 21,
      "email": "서연43@test.com",
      "createdAt": "2025-02-25T06:24:13.386300"
    },
    "user_44": {
      "name": "지민",
      "nativeLanguage": "한국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=44",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 20,
      "email": "지민44@test.com",
      "createdAt": "2025-03-08T06:24:13.386310"
    },
    "user_45": {
      "name": "유진",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=45",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 38,
      "email": "유진45@test.com",
      "createdAt": "2025-03-18T06:24:13.386320"
    },
    "user_46": {
      "name": "가은",
      "nativeLanguage": "한국어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=46",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 22,
      "email": "가은46@test.com",
      "createdAt": "2025-03-03T06:24:13.386327"
    },
    "user_47": {
      "name": "지민",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=47",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 26,
      "email": "지민47@test.com",
      "createdAt": "2025-01-30T06:24:13.386337"
    },
    "user_48": {
      "name": "지훈",
      "nativeLanguage": "한국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=48",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 40,
      "email": "지훈48@test.com",
      "createdAt": "2025-03-03T06:24:13.386345"
    },
    "user_49": {
      "name": "민수",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=49",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 20,
      "email": "민수49@test.com",
      "createdAt": "2025-03-02T06:24:13.386354"
    },
    "user_50": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=50",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 38,
      "email": "예진50@test.com",
      "createdAt": "2025-02-09T06:24:13.386363"
    },
    "user_51": {
      "name": "Emily",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=51",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 30,
      "email": "emily51@test.com",
      "createdAt": "2025-03-09T06:24:13.386373"
    },
    "user_52": {
      "name": "Sarah",
      "nativeLanguage": "영어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=52",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 25,
      "email": "sarah52@test.com",
      "createdAt": "2025-02-20T06:24:13.386382"
    },
    "user_53": {
      "name": "Daniel",
      "nativeLanguage": "영어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=53",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 34,
      "email": "daniel53@test.com",
      "createdAt": "2025-03-07T06:24:13.386391"
    },
    "user_54": {
      "name": "Jessica",
      "nativeLanguage": "영어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=54",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 36,
      "email": "jessica54@test.com",
      "createdAt": "2025-03-18T06:24:13.386399"
    },
    "user_55": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=55",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 33,
      "email": "ashley55@test.com",
      "createdAt": "2025-01-18T06:24:13.386405"
    },
    "user_56": {
      "name": "James",
      "nativeLanguage": "영어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=56",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 34,
      "email": "james56@test.com",
      "createdAt": "2025-03-09T06:24:13.386410"
    },
    "user_57": {
      "name": "Daniel",
      "nativeLanguage": "영어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=57",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 33,
      "email": "daniel57@test.com",
      "createdAt": "2025-03-29T06:24:13.386416"
    },
    "user_58": {
      "name": "John",
      "nativeLanguage": "영어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=58",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 24,
      "email": "john58@test.com",
      "createdAt": "2025-03-01T06:24:13.386421"
    },
    "user_59": {
      "name": "Sarah",
      "nativeLanguage": "영어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=59",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 36,
      "email": "sarah59@test.com",
      "createdAt": "2025-04-01T06:24:13.386426"
    },
    "user_60": {
      "name": "Ashley",
      "nativeLanguage": "영어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=60",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 31,
      "email": "ashley60@test.com",
      "createdAt": "2025-02-22T06:24:13.386439"
    },
    "user_61": {
      "name": "Michael",
      "nativeLanguage": "일본어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=61",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 25,
      "email": "michael61@test.com",
      "createdAt": "2025-04-11T06:24:13.386449"
    },
    "user_62": {
      "name": "Michael",
      "nativeLanguage": "일본어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=62",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 28,
      "email": "michael62@test.com",
      "createdAt": "2025-04-07T06:24:13.386455"
    },
    "user_63": {
      "name": "Daniel",
      "nativeLanguage": "일본어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=63",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 22,
      "email": "daniel63@test.com",
      "createdAt": "2025-01-23T06:24:13.386460"
    },
    "user_64": {
      "name": "Sarah",
      "nativeLanguage": "일본어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=64",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 38,
      "email": "sarah64@test.com",
      "createdAt": "2025-02-09T06:24:13.386466"
    },
    "user_65": {
      "name": "Chris",
      "nativeLanguage": "일본어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=65",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 25,
      "email": "chris65@test.com",
      "createdAt": "2025-02-19T06:24:13.386471"
    },
    "user_66": {
      "name": "Sarah",
      "nativeLanguage": "일본어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=66",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 37,
      "email": "sarah66@test.com",
      "createdAt": "2025-04-08T06:24:13.386477"
    },
    "user_67": {
      "name": "Sarah",
      "nativeLanguage": "일본어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=67",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 40,
      "email": "sarah67@test.com",
      "createdAt": "2025-03-05T06:24:13.386482"
    },
    "user_68": {
      "name": "Emma",
      "nativeLanguage": "일본어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=68",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 39,
      "email": "emma68@test.com",
      "createdAt": "2025-04-22T06:24:13.386490"
    },
    "user_69": {
      "name": "Jessica",
      "nativeLanguage": "일본어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=69",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 23,
      "email": "jessica69@test.com",
      "createdAt": "2025-04-14T06:24:13.386499"
    },
    "user_70": {
      "name": "John",
      "nativeLanguage": "일본어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=70",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 20,
      "email": "john70@test.com",
      "createdAt": "2025-03-13T06:24:13.386507"
    },
    "user_71": {
      "name": "James",
      "nativeLanguage": "중국어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=71",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 31,
      "email": "james71@test.com",
      "createdAt": "2025-01-23T06:24:13.386514"
    },
    "user_72": {
      "name": "Emma",
      "nativeLanguage": "중국어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=72",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 24,
      "email": "emma72@test.com",
      "createdAt": "2025-04-19T06:24:13.386519"
    },
    "user_73": {
      "name": "Emma",
      "nativeLanguage": "중국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=73",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 24,
      "email": "emma73@test.com",
      "createdAt": "2025-03-18T06:24:13.386525"
    },
    "user_74": {
      "name": "Chris",
      "nativeLanguage": "중국어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=74",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 37,
      "email": "chris74@test.com",
      "createdAt": "2025-02-13T06:24:13.386531"
    },
    "user_75": {
      "name": "Jessica",
      "nativeLanguage": "중국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=75",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 35,
      "email": "jessica75@test.com",
      "createdAt": "2025-01-16T06:24:13.386536"
    },
    "user_76": {
      "name": "John",
      "nativeLanguage": "중국어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=76",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 23,
      "email": "john76@test.com",
      "createdAt": "2025-04-19T06:24:13.386541"
    },
    "user_77": {
      "name": "Chris",
      "nativeLanguage": "중국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=77",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 38,
      "email": "chris77@test.com",
      "createdAt": "2025-02-25T06:24:13.386547"
    },
    "user_78": {
      "name": "Emma",
      "nativeLanguage": "중국어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=78",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 21,
      "email": "emma78@test.com",
      "createdAt": "2025-02-18T06:24:13.386552"
    },
    "user_79": {
      "name": "Sarah",
      "nativeLanguage": "중국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=79",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 20,
      "email": "sarah79@test.com",
      "createdAt": "2025-03-20T06:24:13.386558"
    },
    "user_80": {
      "name": "Ashley",
      "nativeLanguage": "중국어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=80",
      "bio": "조용한 장소에서 이야기 나누는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 33,
      "email": "ashley80@test.com",
      "createdAt": "2025-04-17T06:24:13.386563"
    },
    "user_81": {
      "name": "Chris",
      "nativeLanguage": "스페인어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=81",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 21,
      "email": "chris81@test.com",
      "createdAt": "2025-04-01T06:24:13.386569"
    },
    "user_82": {
      "name": "Chris",
      "nativeLanguage": "스페인어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=82",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 20,
      "email": "chris82@test.com",
      "createdAt": "2025-04-11T06:24:13.386574"
    },
    "user_83": {
      "name": "Ashley",
      "nativeLanguage": "스페인어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=83",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 30,
      "email": "ashley83@test.com",
      "createdAt": "2025-03-07T06:24:13.386580"
    },
    "user_84": {
      "name": "Sarah",
      "nativeLanguage": "스페인어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=84",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 27,
      "email": "sarah84@test.com",
      "createdAt": "2025-02-18T06:24:13.386585"
    },
    "user_85": {
      "name": "James",
      "nativeLanguage": "스페인어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=85",
      "bio": "산책하면서 대화하는 걸 선호해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 22,
      "email": "james85@test.com",
      "createdAt": "2025-04-25T06:24:13.386590"
    },
    "user_86": {
      "name": "Chris",
      "nativeLanguage": "스페인어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=86",
      "bio": "여행과 새로운 언어 배우기를 좋아합니다.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 29,
      "email": "chris86@test.com",
      "createdAt": "2025-02-07T06:24:13.386595"
    },
    "user_87": {
      "name": "James",
      "nativeLanguage": "스페인어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=87",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 37,
      "email": "james87@test.com",
      "createdAt": "2025-01-28T06:24:13.386602"
    },
    "user_88": {
      "name": "Jessica",
      "nativeLanguage": "스페인어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=88",
      "bio": "일상적인 대화를 통해 배우고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 21,
      "email": "jessica88@test.com",
      "createdAt": "2025-04-07T06:24:13.386608"
    },
    "user_89": {
      "name": "Michael",
      "nativeLanguage": "스페인어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=89",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 21,
      "email": "michael89@test.com",
      "createdAt": "2025-04-13T06:24:13.386618"
    },
    "user_90": {
      "name": "John",
      "nativeLanguage": "스페인어",
      "learningLanguage": "프랑스어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=90",
      "bio": "매일 조금씩 공부 중입니다.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 21,
      "email": "john90@test.com",
      "createdAt": "2025-04-07T06:24:13.386623"
    },
    "user_91": {
      "name": "Emily",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=91",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 30,
      "email": "emily91@test.com",
      "createdAt": "2025-04-20T06:24:13.386629"
    },
    "user_92": {
      "name": "Jessica",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "한국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=92",
      "bio": "영화를 보면서 언어를 공부해요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 27,
      "email": "jessica92@test.com",
      "createdAt": "2025-03-26T06:24:13.386634"
    },
    "user_93": {
      "name": "Emma",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=93",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 26,
      "email": "emma93@test.com",
      "createdAt": "2025-02-11T06:24:13.386643"
    },
    "user_94": {
      "name": "Sarah",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "영어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=94",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 24,
      "email": "sarah94@test.com",
      "createdAt": "2025-04-15T06:24:13.386651"
    },
    "user_95": {
      "name": "Ashley",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=95",
      "bio": "언제든지 자유롭게 대화하고 싶어요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 20,
      "email": "ashley95@test.com",
      "createdAt": "2025-02-04T06:24:13.386660"
    },
    "user_96": {
      "name": "Chris",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "일본어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=96",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "친근하고 편하게 이야기 나눌 수 있는 분 환영!",
      "age": 37,
      "email": "chris96@test.com",
      "createdAt": "2025-03-07T06:24:13.386666"
    },
    "user_97": {
      "name": "Michael",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=97",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "가벼운 대화를 즐기는 분이면 좋겠어요.",
      "age": 36,
      "email": "michael97@test.com",
      "createdAt": "2025-03-26T06:24:13.386672"
    },
    "user_98": {
      "name": "James",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "중국어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=98",
      "bio": "책을 좋아해서 책 얘기를 자주 해요.",
      "partnerPreference": "정기적으로 연락할 수 있는 분을 찾고 있어요.",
      "age": 31,
      "email": "james98@test.com",
      "createdAt": "2025-04-14T06:24:13.386677"
    },
    "user_99": {
      "name": "Emma",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=99",
      "bio": "언어를 배우며 다양한 문화를 이해하고 싶어요.",
      "partnerPreference": "비슷한 관심사를 가진 분이면 좋겠어요.",
      "age": 24,
      "email": "emma99@test.com",
      "createdAt": "2025-04-14T06:24:13.386682"
    },
    "user_100": {
      "name": "Jessica",
      "nativeLanguage": "프랑스어",
      "learningLanguage": "스페인어",
      "district": "서울특별시 은평구 녹번동",
      "profileImageUrl": "https://picsum.photos/200/200?random=100",
      "bio": "커피 마시며 대화하는 걸 좋아해요.",
      "partnerPreference": "전화 통화도 가능한 분이면 좋겠어요.",
      "age": 27,
      "email": "jessica100@test.com",
      "createdAt": "2025-01-31T06:24:13.386687"
    }
  }
}
          ''';
          final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
          final usersMap = jsonMap['users'] as Map<String, dynamic>;

          final firestore = FirebaseFirestore.instance;

          for (final entry in usersMap.entries) {
            final userId = entry.key;
            final userData = entry.value as Map<String, dynamic>;

            final user = AppUser.fromMap(userId, userData);

            await firestore.collection('users').doc(user.id).set(user.toMap());
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ 테스트 유저들이 성공적으로 추가되었습니다.')),
          );
        } catch (e) {
          print('🔥 Error seeding users: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ 유저 추가 중 오류가 발생했습니다.')),
          );
        }
      },

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: AppCachedImage(
              imageUrl: user.profileImage ?? 'https://picsum.photos/200/200?random=1',
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
          ),
          // CircleAvatar(
          //   radius: 33,
          //   backgroundImage: NetworkImage(
          //     user.profileImage ?? 'https://picsum.photos/200/200?random=1',
          //   ),
          // ),
          const SizedBox(width: 12),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and distance
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Language exchange
                Row(
                  children: [
                    Text(
                      user.nativeLanguage ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.sync_alt_outlined, color: Colors.black, size: 17),
                    const SizedBox(width: 5),
                    Text(
                      user.targetLanguage ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // District
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${user.district ?? ''}  |  ',
                      style: AppStyles.usersListText,
                    ),
                    Text(
                      '8.3 km', // replace with actual distance
                      style: AppStyles.usersListText,
                    )
                  ],
                ),

                const SizedBox(height: 6),

                if (user.bio != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      user.bio!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.usersListText,
                    ),
                  ),
                Divider(indent: 0, height: 35, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
