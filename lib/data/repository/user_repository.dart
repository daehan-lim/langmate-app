import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getNearbyUsers(AppUser user);

  Future<bool> userExists(String uid);

  Future<AppUser?> getUserById(String uid);

  Future<void> createUserIfNotExists(AppUser user);

  Future<void> saveUserProfile(AppUser user);
}

class UserRepositoryFirebase implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<AppUser>> getNearbyUsers(AppUser user) async {
    final snapshot =
        await _firestore
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

  @override
  Future<bool> userExists(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists;
  }

  @override
  Future<AppUser?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(uid, doc.data()!);
    }
    return null;
  }

  @override
  Future<void> createUserIfNotExists(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'profileImage': user.profileImage,
      'email': user.email,
      'createdAt': user.createdAt.toIso8601String(),
    });
  }

  @override
  Future<void> saveUserProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'nativeLanguage': user.nativeLanguage,
      'targetLanguage': user.targetLanguage,
      'district': user.district,
      'profileImage': user.profileImage,
      'bio': user.bio,
      'age': user.age,
      'partnerPreference': user.partnerPreference,
      'languageLearningGoal': user.languageLearningGoal,
    });
  }
}