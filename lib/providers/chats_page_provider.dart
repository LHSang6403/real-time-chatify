import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/chat.dart';
import 'package:real_time_chatify/models/message.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
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
          db.getChatForUser(auth.chatUser.userId).listen((snap) async {
        chats = await Future.wait(snap.docs.map((doc) async {
          Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;

          List<ChatUser> members = [];
          for (var id in chatData["members"]) {
            DocumentSnapshot userDoc = await db.getUser(id);
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;
            members.add(ChatUser.fromJSON(userData));
          }

          List<Message> messages = [];
          QuerySnapshot chatMessages = await db.getLastMessages(doc.id).first;
          if (chatMessages.docs.isNotEmpty) {
            Map<String, dynamic> messageData =
                chatMessages.docs.first.data()! as Map<String, dynamic>;
            Message messagesTmp = Message.fromJSON(messageData);
            messages.add(messagesTmp);
          }

          return Chat(
              id: doc.id,
              currentUserId: auth.chatUser.userId,
              users: members,
              messages: messages,
              isActive: chatData["is_active"],
              isGroup: chatData["is_group"]);
        }).toList());
        notifyListeners();
      });
    } catch (e) {
      print('Error in getting chats: $e');
    }
  }
}
