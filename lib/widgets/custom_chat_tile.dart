import 'package:flutter/material.dart';
import 'package:real_time_chatify/models/message.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/widgets/image_message_bubble.dart';
import 'package:real_time_chatify/widgets/text_message_bubble.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class CustomChatTile extends StatelessWidget {
  final double height;
  final double width;
  final Message message;

  final ChatUser sender;
  final bool isMe;

  CustomChatTile(
      {Key? key,
      required this.height,
      required this.width,
      required this.message,
      required this.sender,
      required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: width,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !isMe
                  ? NetworkRoundedImage(
                      imagePath: sender.imageUrl, imageSize: width * 0.06)
                  : const SizedBox(
                      height: 10,
                      width: 10,
                    ),
              SizedBox(
                width: width * 0.04,
              ),
              message.type == MessageType.text
                  ? TextMessageBubble(
                      isMe: isMe,
                      message: message,
                      height: height,
                      width: width)
                  : ImageMessageBubble(
                      isMe: isMe,
                      message: message,
                      height: height,
                      width: width),
            ]));
  }
}
