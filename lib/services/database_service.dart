import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String MESSAGE_COLLECTION = 'Messages';
const String CHAT_COLLECTION = 'Chats';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}
}