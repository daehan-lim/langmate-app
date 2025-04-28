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
  final int? age;
  final String? partnerPreference;
  final String? languageLearningGoal;
  // final GeoPoint? location;

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
    this.age,
    this.partnerPreference,
    this.languageLearningGoal
  }) : createdAt = createdAt ?? DateTime.now();

  AppUser copyWith({
    String? name,
    String? district,
    DateTime? createdAt,
    String? email,
    String? profileImage,
    String? nativeLanguage,
    String? targetLanguage,
    String? bio,
    int? age,
    String? partnerPreference,
    String? languageLearningGoal,
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
      age: age ?? this.age,
      partnerPreference: partnerPreference ?? this.partnerPreference,
      languageLearningGoal: languageLearningGoal ?? this.languageLearningGoal,
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
      age: map['age'],
      partnerPreference: map['partnerPreference'],
      languageLearningGoal: map['languageLearningGoal'],
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
      'age': age,
      'partnerPreference': partnerPreference,
      'languageLearningGoal': languageLearningGoal,
    };
  }
}
