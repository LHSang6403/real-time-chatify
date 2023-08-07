import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  String title;
  Widget? action1;
  Widget? action2;
  double? fontSize;
  bool isCentered;

  late double deviceHeight;
  late double deviceWidth;

  TopBar(
      {Key? key,
      required this.title,
      this.action1,
      this.action2,
      this.fontSize,
      required this.isCentered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI(context, deviceHeight, deviceWidth);
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return SizedBox(
      height: height * 0.08,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (action2 != null) action2!,
          isCentered
              ? Center(
                  heightFactor: 1.8,
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize ?? width * 0.08,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                )
              : Container(
                  padding: EdgeInsets.only(bottom: height * 0.006),
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize ?? width * 0.08,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
          if (action1 != null) action1!,
        ],
      ),
    );
  }
}
