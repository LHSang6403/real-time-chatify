import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void showSheet(BuildContext context, double height, double width,
      String title, List<Widget> children) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          width: width,
          color: Colors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
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
