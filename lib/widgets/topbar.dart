import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String title;
  Widget? action1;
  Widget? action2;
  double? fontSize;

  late double deviceHeight;
  late double deviceWidth;

  TopBar({
    Key? key,
    required this.title,
    this.action1,
    this.action2,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI(context, deviceHeight, deviceWidth);
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Container(
      padding: EdgeInsets.only(
          left: width * 0.06, right: width * 0.06, top: width * 0.09),
      height: height * 0.12,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (action2 != null) action2!,
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? width * 0.08,
                  fontWeight: FontWeight.bold)),
          if (action1 != null) action1!,
        ],
      ),
    );
  }
}
