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

  String get msg {
    return msg;
  }

  ConversationProvider(this.chatId, this.auth, this.scrollController) {
    db = GetIt.instance.get<DatabaseService>();
    cloudStorageService = GetIt.instance.get<CloudStorageService>();
    mediaService = GetIt.instance.get<MediaService>();
    navigationService = GetIt.instance.get<NavigationService>();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
