import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void showSheet(BuildContext context, double height, double width,
      String title, List<Widget> children) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color.fromRGBO(40, 35, 49, 1.0),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.08,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        );
      },
    );
  }
}
