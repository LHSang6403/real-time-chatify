import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  final Function(String) onComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController textController;
  IconData? icon;

  CustomSearch(
      {required this.onComplete,
      required this.hintText,
      required this.obscureText,
      required this.textController,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onEditingComplete: () => onComplete(textController.text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
