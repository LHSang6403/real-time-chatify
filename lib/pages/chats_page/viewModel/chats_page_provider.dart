import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/chat.dart';
import 'package:real_time_chatify/models/message.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/database_service.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService db;
  List<Chat> chats = [];
  late StreamSubscription chatsStream;

  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      chatsStream =
          db.getChatForUser(auth.chatUser.userId).listen((snapshot) async {
        chats = await Future.wait(snapshot.docs.map((doc) async {
          Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;

          List<ChatUser> members = [];
          for (var id in chatData["members"]) {
            DocumentSnapshot userDoc = await db.getUser(id);
            if (userDoc.data() != null) {
              Map<String, dynamic> userData =
                  userDoc.data() as Map<String, dynamic>;
              userData["user_id"] = userDoc.id;
              members.add(ChatUser.fromJSON(userData));
            }
          }

          List<Message> messages = [];
          QuerySnapshot chatMessage = await db.getLastMessage(doc.id);
          if (chatMessage.docs.isNotEmpty) {
            Map<String, dynamic> messageData =
                chatMessage.docs.first.data()! as Map<String, dynamic>;
            Message messagesTmp = Message.fromJson(messageData);
            messages.add(messagesTmp);
          }

          return Chat(
              id: doc.id,
              currentUserId: auth.chatUser.userId,
              users: members,
              messages: messages,
              isActive: chatData["is_activity"],
              isGroup: chatData["is_group"]);
        }).toList());
        notifyListeners();
      });
    } catch (e) {
      print('Error in getting chats: $e');
    }
  }
}
