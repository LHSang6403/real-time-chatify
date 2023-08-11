import 'package:flutter/material.dart';

class RegisterPageModel {
  String email = "";
  String password = "";
  String name = "";
  final registerFormKey = GlobalKey<FormState>();

  RegisterPageModel();
}
