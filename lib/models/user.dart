class ChatUser {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime lastActive;

  ChatUser(
      {required this.userId,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.lastActive});

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
        userId: _json['user_id'] ?? "",
        name: _json['name'] ?? "",
        email: _json['email'] ?? "",
        imageUrl: _json['image'] ?? "",
        lastActive: _json['last_active'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'image': imageUrl,
      'last_active': lastActive
    };
  }

  String lastTimeActive() {
    return '${lastActive.month}/${lastActive.day}/${lastActive.year}';
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 1;
  }
}
