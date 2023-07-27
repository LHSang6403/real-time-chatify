import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, unknown }

class Message {
  final String senderId;
  MessageType type;
  final String message;
  final DateTime sentTime;

  Message(
      {required this.senderId,
      required this.type,
      required this.message,
      required this.sentTime});

  factory Message.fromJSON(Map<String, dynamic> json) {
    MessageType msgType;
    switch (json["type"]) {
      case "text":
        msgType = MessageType.text;
        break;
      case "image":
        msgType = MessageType.image;
        break;
      default:
        msgType = MessageType.unknown;
    }
    return Message(
        senderId: json["senderId"],
        type: msgType,
        message: json["message"],
        sentTime: json["sentTime"].toDate());
  }

  Map<String, dynamic> toJSON() {
    return {
      "senderId": senderId,
      "type": type.toString() == "default" ? "" : type.toString(),
      "message": message,
      "sentTime": Timestamp.fromDate(sentTime)
    };
  }
}
