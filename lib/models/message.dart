import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, unknown }

class Message {
  final String sender_id;
  MessageType type;
  final String message;
  final Timestamp sent_time;

  Message(
      {required this.sender_id,
      required this.type,
      required this.message,
      required this.sent_time});

  factory Message.fromJson(Map<String, dynamic> json) {
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
        sender_id: json["sender_id"],
        type: msgType,
        message: json["content"],
        sent_time: json["sent_time"]);
  }

  Map<String, dynamic> toJson() {
    String msgType;
    switch (type) {
      case MessageType.text:
        msgType = "text";
        break;
      case MessageType.image:
        msgType = "image";
        break;
      default:
        msgType = "default";
    }
    return {
      "sender_id": sender_id,
      "type": msgType,
      "content": message,
      "sent_time": sent_time,
    };
  }
}
