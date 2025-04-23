class User {
  final String id;
  final String name;
  final String? location;
  final String? profileImage;
  final String? nativeLanguage;
  final String? targetLanguage;

  User({
    required this.id,
    required this.name,
    this.location,
    this.profileImage,
    this.nativeLanguage,
    this.targetLanguage,
  });
}