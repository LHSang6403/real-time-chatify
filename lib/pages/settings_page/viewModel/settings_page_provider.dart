import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/pages/people_page/model/user.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  late bool isDarkMode;
  late String myUserId;
  late String myUserImg;
  late String myUserName;

  AuthenticationProvider auth;
  late DatabaseService db;

  SettingsProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    myUserId = auth.chatUser.userId;
    isDarkMode = false;
    myUserImg = '';
    myUserName = 'Flutter app user';
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserInfo() async {
    try {
      DocumentSnapshot userDoc = await db.getUser(myUserId);
      if (userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData["user_id"] = userDoc.id;
        ChatUser user = ChatUser.fromJSON(userData);
        myUserImg = user.imageUrl;
        myUserName = user.name;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
