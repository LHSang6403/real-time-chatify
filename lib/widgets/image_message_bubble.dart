import 'package:flutter/material.dart';
import 'package:real_time_chatify/pages/chat_page/model/message.dart';

class ImageMessageBubble extends StatelessWidget {
  final bool isMe;
  final Message message;
  final double height;
  final double width;

  const ImageMessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
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

    DecorationImage image = DecorationImage(
        image: NetworkImage(message.message), fit: BoxFit.cover);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
              colors: colors,
              stops: const [0.3, 0.7],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.4,
              width: width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: image,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              message.sent_time.toDate().toString().substring(11, 16),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ));
  }
}
