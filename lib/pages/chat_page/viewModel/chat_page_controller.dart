import 'package:flutter/material.dart';

class ChatPageController {
  late GlobalKey<FormState> msgFormKey;
  late ScrollController scrollController;

  ChatPageController() {
    msgFormKey = GlobalKey<FormState>();
    scrollController = ScrollController();
  }
}
