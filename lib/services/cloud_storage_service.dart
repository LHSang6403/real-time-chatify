import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = 'Users';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService() {}

  Future<String?> saveUserImgToStorage(
      String _userId, PlatformFile _file) async {
    try {
      Reference _ref = _storage
          .ref()
          .child('images/users/$_userId/profile.{$_file.extension}}');
      UploadTask _uploadTask = _ref.putFile(
        File(_file.path!),
      );
      return await _uploadTask.then((res) => res.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImgToStorage(
      String _chatId, String _userId, PlatformFile _file) async {
    try {
      Reference _ref = _storage.ref().child(
          'images/chats/$_chatId/${_userId}_${Timestamp.now().microsecondsSinceEpoch}/profile.{${_file.extension}}');
      UploadTask _uploadTask = _ref.putFile(
        File(_file.path!),
      );
      return await _uploadTask.then((res) => res.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }
}
