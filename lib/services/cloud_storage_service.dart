import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = 'Users';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImgToStorage(String userId, PlatformFile file) async {
    try {
      Reference ref = _storage
          .ref()
          .child('images/users/$userId/profile.${file.extension}');
      UploadTask uploadTask = ref.putFile(
        File(file.path!),
      );
      return await uploadTask.then((res) => res.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<String?> saveChatImgToStorage(
      String chatId, String userId, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/$chatId/${userId}_${Timestamp.now().microsecondsSinceEpoch}/profile.${file.extension}');
      UploadTask uploadTask = ref.putFile(
        File(file.path!),
      );
      return await uploadTask.then((res) => res.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return "";
  }
}
