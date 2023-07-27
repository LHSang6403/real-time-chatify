import 'package:flutter/material.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class MessageCard extends StatelessWidget {
  final double height;
  final double width;
  final ChatUser chatUser;
  MessageCard(
      {Key? key,
      required this.height,
      required this.width,
      required this.chatUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: width * 0.01),
        height: height * 0.075,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.015),
            color: const Color.fromRGBO(0, 82, 218, 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: NetworkRoundedImage(
                  imagePath: chatUser.imageUrl, imageSize: height * 0.055),
            ),
            Text(chatUser.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
                "${chatUser.lastActive.hour}:${chatUser.lastActive.minute}:${chatUser.lastActive.second}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.normal)),
            SizedBox(width: width * 0.06)
          ],
        ));
  }
}
