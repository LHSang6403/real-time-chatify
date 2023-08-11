import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/pages/people_page/model/user.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/database_service.dart';

class ChatsBottomBarProvider extends ChangeNotifier {
  late String myId;
  late String myImg;
  late String myName;
  AuthenticationProvider auth;
  late DatabaseService db;

  ChatsBottomBarProvider(this.auth) {
    myId = auth.chatUser.userId;
    myImg = auth.chatUser.imageUrl;
    myName = auth.chatUser.name;
    db = GetIt.instance.get<DatabaseService>();
  }

  void getUserInfo() async {
    try {
      DocumentSnapshot userDoc = await db.getUser(myId);
      if (userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData["user_id"] = userDoc.id;
        ChatUser user = ChatUser.fromJSON(userData);
        myImg = user.imageUrl;
        myName = user.name;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
