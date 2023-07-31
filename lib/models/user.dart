import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;
  final Timestamp lastActive;

  ChatUser(
      {required this.userId,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.lastActive});

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
        userId: json['user_id'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        imageUrl: json['imgUrl'] ?? "",
        lastActive: json['last_active'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'imgUrl': imageUrl,
      'last_active': lastActive
    };
  }

  String lastTimeActive() {
    return '${lastActive.toDate().month}/${lastActive.toDate().day}/${lastActive.toDate().year}';
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive.toDate()).inHours < 1;
  }
}
