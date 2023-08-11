import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/pages/chat_page/model/chat.dart';
import 'package:real_time_chatify/pages/people_page/model/user.dart';
import 'package:real_time_chatify/pages/chat_page/view/chat_page.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/services/database_service.dart';
import 'package:real_time_chatify/services/navigation_service.dart';

class PeoplePageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService databaseService;
  late NavigationService navigationService;

  late List<ChatUser> users;
  late List<ChatUser> selectedUsers;

  PeoplePageProvider(this.auth) {
    databaseService = GetIt.instance.get<DatabaseService>();
    navigationService = GetIt.instance.get<NavigationService>();
    users = [];
    selectedUsers = [];
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    try {
      databaseService.getUsers(name).then(
        (snap) {
          users = snap.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['user_id'] = doc.id;
              return ChatUser.fromJSON(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> idMembers =
          selectedUsers.map((user) => user.userId).toList();
      idMembers.add(auth.chatUser.userId);
      bool isGroup = idMembers.length > 1;
      DocumentReference? doc = await databaseService.createChat(
        {
          'members': idMembers,
          'is_group': isGroup,
          'is_activity': false,
        },
      );

      List<ChatUser> members = [];
      for (var id in idMembers) {
        DocumentSnapshot userSnapshot = await databaseService.getUser(id);
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        data['user_id'] = userSnapshot.id;
        members.add(ChatUser.fromJSON(data));
      }
      ConversationPage chatPage = ConversationPage(
          chat: Chat(
        id: doc!.id,
        users: members,
        currentUserId: auth.chatUser.userId,
        isGroup: isGroup,
        isActive: true,
        messages: [],
      ));
      selectedUsers = [];
      notifyListeners();
      navigationService.routeToPage(chatPage);
    } catch (e) {
      print(e);
    }
  }
}
