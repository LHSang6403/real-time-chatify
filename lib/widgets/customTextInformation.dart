import 'package:flutter/material.dart';

class CustomTextInformation extends StatelessWidget {
  final String text;
  final bool isBold;
  final double width;

  const CustomTextInformation({
    Key? key,
    required this.text,
    required this.isBold,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.005),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: width * 0.05,
                color: Colors.white70,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
