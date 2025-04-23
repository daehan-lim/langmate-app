class User {
  final String id;
  final String name;
  final String? district;
  final String? profileImage;
  final String? nativeLanguage;
  final String? targetLanguage;
  final String? bio;
  final int? age;
  final String? idealPartnerDescription;
  // final GeoPoint? location;

  User({
    required this.id,
    required this.name,
    this.district,
    this.profileImage,
    this.nativeLanguage,
    this.targetLanguage,
    this.bio,
    this.age,
    this.idealPartnerDescription
  });
}