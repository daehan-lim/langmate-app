import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lang_mate/data/model/chat_models.dart';

abstract class ChatRepository {
  Stream<List<Message>> getChatsByAddress(String address);
  Future<void> addChat(Message message);
}

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Message>> getChatsByAddress(String address) {
    return _firestore
        .collection('chat')
        .where('address', isEqualTo: address)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> addChat(Message message) async {
    await _firestore.collection('chat').add(message.toMap());
  }
}
