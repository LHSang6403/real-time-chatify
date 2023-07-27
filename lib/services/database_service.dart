import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String MESSAGES_COLLECTION = 'messages';
const String CHAT_COLLECTION = 'Chats';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
      String _userId, String _email, String _name, String _imgURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_userId).set({
        'email': _email,
        'name': _name,
        'imgURL': _imgURL,
        'last_active': DateTime.now().toUtc(),
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
        .collection(USER_COLLECTION)
        .where(
          'members',
          arrayContains: userId,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessages(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> updateUserLastTime(String userId) async {
    try {
      await _db.collection(USER_COLLECTION).doc(userId).update({
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }
}
