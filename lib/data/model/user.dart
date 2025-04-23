class User {
  final String id;
  final String name;
  final String? location;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    this.location,
    this.profileImage,
  });
}