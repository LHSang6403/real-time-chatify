import 'package:flutter/material.dart';
import 'package:real_time_chatify/pages/chat_page/model/message.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isMe;
  final Message message;
  final double height;
  final double width;

  TextMessageBubble(
      {Key? key,
      required this.isMe,
      required this.message,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = isMe
        ? [
            const Color.fromRGBO(0, 136, 249, 1),
            const Color.fromRGBO(0, 82, 218, 1)
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1),
            const Color.fromRGBO(51, 49, 68, 1)
          ];
    return Container(
        height: height * 0.06 + message.message.length,
        width: width * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
              colors: colors,
              stops: const [0.3, 0.7],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(color: Colors.white, fontSize: height * 0.02),
            ),
            Text(
              message.sent_time.toDate().toString().substring(11, 16),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ));
  }
}
