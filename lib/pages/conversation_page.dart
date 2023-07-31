import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/models/chat.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/providers/conversation_provider.dart';
import 'package:real_time_chatify/widgets/topbar.dart';

class ConversationPage extends StatefulWidget {
  final Chat chat;
  const ConversationPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late double height;
  late double width;

  late AuthenticationProvider auth;
  late ConversationProvider conversationProvider;

  late GlobalKey<FormState> msgFormKey;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    msgFormKey = GlobalKey<FormState>();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<ConversationProvider>(
          create: (_) =>
              ConversationProvider(widget.chat.id, auth, scrollController)),
    ], child: buildUI(context));
  }

  Widget buildUI(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      conversationProvider = context.watch<ConversationProvider>();
      return Scaffold(
          body: Container(
              height: height,
              width: width * 0.97,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    title: widget.chat.getChatName(),
                    action1: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                    action2: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    fontSize: width * 0.07,
                  ),
                ],
              )));
    });
  }
}
