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
    return SizedBox(
      height: height * 0.12,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (action2 != null) action2!,
          SizedBox(
            width: width * 0.5,
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
