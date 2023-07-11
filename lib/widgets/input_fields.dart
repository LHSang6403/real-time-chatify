import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String? hintText;
  final bool obscureText;

  CustomTextField(
      {required this.onSaved,
      required this.regEx,
      this.hintText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (value){
        return RegExp(regEx).hasMatch(value!) ? null : "Invalid Input";
      },
      decoration:  InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
      ),

    );
  }
}
