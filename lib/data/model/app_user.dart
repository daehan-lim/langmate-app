import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? email;
  final String? district;
  final String? profileImage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final String? bio;
  final DateTime? birthdate;
  final String? partnerPreference;
  final String? languageLearningGoal;
  final GeoPoint? location;

  AppUser({
    required this.id,
    required this.name,
    DateTime? createdAt,
    this.email,
    this.district,
    this.profileImage,
    this.nativeLanguage,
    this.targetLanguage,
    this.bio,
    this.birthdate,
    this.partnerPreference,
    this.languageLearningGoal,
    this.location,
  }) : createdAt = createdAt ?? DateTime.now();

  int? get age {
    if (birthdate == null) return null;
    final today = DateTime.now();
    int calculatedAge = today.year - birthdate!.year;
    if (today.month < birthdate!.month ||
        (today.month == birthdate!.month && today.day < birthdate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  AppUser copyWith({
    String? name,
    String? district,
    DateTime? createdAt,
    String? email,
    String? profileImage,
    String? nativeLanguage,
    String? targetLanguage,
    String? bio,
    DateTime? birthdate,
    String? partnerPreference,
    String? languageLearningGoal,
    GeoPoint? location,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      district: district ?? this.district,
      profileImage: profileImage ?? this.profileImage,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      bio: bio ?? this.bio,
      birthdate: birthdate ?? this.birthdate,
      partnerPreference: partnerPreference ?? this.partnerPreference,
      languageLearningGoal: languageLearningGoal ?? this.languageLearningGoal,
      location: location ?? this.location,
    );
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      createdAt:
          map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(),
      email: map['email'],
      district: map['district'],
      profileImage: map['profileImage'],
      nativeLanguage: map['nativeLanguage'],
      targetLanguage: map['targetLanguage'],
      bio: map['bio'],
      birthdate:
          map['birthdate'] != null ? DateTime.parse(map['birthdate']) : null,
      partnerPreference: map['partnerPreference'],
      languageLearningGoal: map['languageLearningGoal'],
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'email': email,
      'district': district,
      'profileImage': profileImage,
      'nativeLanguage': nativeLanguage,
      'targetLanguage': targetLanguage,
      'bio': bio,
      'birthdate': birthdate?.toIso8601String(),
      'partnerPreference': partnerPreference,
      'languageLearningGoal': languageLearningGoal,
      'location': location,
    };
  }
}
