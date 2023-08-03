import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_time_chatify/models/message.dart';

const String USER_COLLECTION = 'Users';
const String MESSAGES_COLLECTION = 'messages';
const String CHAT_COLLECTION = 'Chats';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
      String userId, String email, String name, String imgUrl) async {
    try {
      await _db.collection(USER_COLLECTION).doc(userId).set({
        'email': email,
        'name': name,
        'imgUrl': imgUrl,
        'last_active': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    return _db.collection(USER_COLLECTION).doc(userId).get();
  }

  Stream<QuerySnapshot> getChatForUser(String userId) {
    return _db
        .collection(CHAT_COLLECTION)
        .where(
          'members',
          arrayContains: userId,
        )
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessage(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }

  Future<void> updateUserLastSeenTime(String userId) async {
    try {
      await _db.collection(USER_COLLECTION).doc(userId).update({
        'last_active': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).update(data);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> streamMsgsForChat(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: false)
        .snapshots();
  }

  Future<void> addMsgToChat(String chatId, Message msg) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .add(msg.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).delete();
    } catch (e) {
      print(e);
    }
  }
}
