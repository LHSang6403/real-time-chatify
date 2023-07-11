import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final double height;
  final double width;
  final Function onPressed;

  const RoundedButton(
      {required this.buttonName,
      required this.height,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.25),
          color: const Color.fromRGBO(0, 82, 218, 1.0)),
      child: TextButton(
        onPressed: onPressed(),
        child: Text(
          buttonName,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
