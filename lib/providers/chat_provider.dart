import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/models/message.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/services/cloud_storage_service.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/media_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

class ConversationProvider extends ChangeNotifier {
  late DatabaseService db;
  late CloudStorageService cloudStorageService;
  late MediaService mediaService;
  late NavigationService navigationService;

  AuthenticationProvider auth;
  ScrollController scrollController;

  String chatId;
  List<Message>? messages;
  String? message;

  late StreamSubscription messagesStream;

  String getMsg() => message!;
  void setMsg(String value) => message = value;

  ConversationProvider(this.chatId, this.auth, this.scrollController) {
    db = GetIt.instance.get<DatabaseService>();
    cloudStorageService = GetIt.instance.get<CloudStorageService>();
    mediaService = GetIt.instance.get<MediaService>();
    navigationService = GetIt.instance.get<NavigationService>();
    listenMsgForChat();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenMsgForChat() {
    try {
      messagesStream = db.streamMsgsForChat(chatId).listen((snapshot) {
        List<Message> msgs = snapshot.docs.map((msg) {
          Map<String, dynamic> data = msg.data() as Map<String, dynamic>;
          return Message.fromJson(data);
        }).toList();
        messages = msgs;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void sendMsg() {
    if (message != null) {
      Message toSend = Message(
          message: message!,
          type: MessageType.text,
          sender_id: auth.chatUser.userId,
          sent_time: Timestamp.now());

      db.addMsgToChat(chatId, toSend);
    }
  }

  void sendImageMsg() async {
    try {
      PlatformFile? file = await mediaService.getImgFromLibrary();
      if (file != null) {
        String? url = await cloudStorageService.saveChatImgToStorage(
            chatId, auth.chatUser.userId, file);
        Message toSend = Message(
            message: url!,
            type: MessageType.image,
            sender_id: auth.chatUser.userId,
            sent_time: Timestamp.now());
        db.addMsgToChat(chatId, toSend);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteChat() {
    navigationService.routeBack();
    db.deleteChat(chatId);
  }
}
