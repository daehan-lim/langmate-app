import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lang_mate/data/model/chat_models.dart';

abstract class ChatRepository {
  Stream<List<MessageOriginal>> getChatsByAddress(String address);
  Future<void> addChat(MessageOriginal message);
}

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MessageOriginal>> getChatsByAddress(String address) {
    return _firestore
        .collection('chat')
        .where('address', isEqualTo: address)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageOriginal.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> addChat(MessageOriginal message) async {
    await _firestore.collection('chat').add(message.toMap());
  }
}
