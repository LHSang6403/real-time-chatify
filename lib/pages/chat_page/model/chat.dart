import 'package:real_time_chatify/pages/chat_page/model/message.dart';
import 'package:real_time_chatify/pages/people_page/model/user.dart';

class Chat {
  final String id;
  final String currentUserId;
  final bool isActive;
  final bool isGroup;
  final List<ChatUser> users;
  List<Message> messages;
  late final List<ChatUser> receivers;

  Chat({
    required this.id,
    required this.currentUserId,
    required this.isActive,
    required this.messages,
    required this.isGroup,
    required this.users,
  }) {
    receivers = users.where((user) => user.userId != currentUserId).toList();
  }

  List<ChatUser> getReceivers() => receivers;

  String getChatName() {
    if (isGroup) {
      return receivers.map((user) => user.name).join(", ");
    } else {
      return receivers.first.name;
    }
  }

  String getSubTitle() {
    String result = "";
    if (messages.isNotEmpty) {
      result = messages.first.type != MessageType.text
          ? "Attachment"
          : messages.first.message;
    } else {
      result = "No messages";
    }
    return result;
  }

  String getImageUrl() {
    if (isGroup) {
      return "https://cdn-icons-png.flaticon.com/512/6387/6387947.png";
    } else {
      return receivers.first.imageUrl;
    }
  }

  bool getActiveStatus() {
    return receivers.any((person) => person.wasRecentlyActive());
  }
}
