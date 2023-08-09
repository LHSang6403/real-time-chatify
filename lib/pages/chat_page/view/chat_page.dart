import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/models/chat.dart';
import 'package:real_time_chatify/pages/chats_page/ViewModel/chat_provider.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/widgets/custom_chat_tile.dart';
import 'package:real_time_chatify/widgets/input_fields.dart';
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
  late ConversationProvider chatProvider;

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
      chatProvider = context.watch<ConversationProvider>();
      return Scaffold(
          body: Container(
              height: height,
              width: width * 0.97,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    title: widget.chat.getChatName(),
                    action1: IconButton(
                        onPressed: () {
                          chatProvider.deleteChat();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                    action2: IconButton(
                        onPressed: () {
                          chatProvider.navigationService.routeBack();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    fontSize: width * 0.05,
                    isCentered: true,
                  ),
                  messagesListUI(),
                  bottomForm(),
                ],
              )));
    });
  }

  Widget messagesListUI() {
    if (chatProvider.messages != null) {
      if (chatProvider.messages!.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: chatProvider.messages!.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              bool isMe = chatProvider.messages![index].sender_id ==
                  auth.chatUser.userId;
              return CustomChatTile(
                height: height,
                width: width,
                message: chatProvider.messages![index],
                sender: widget.chat.users
                    .where((user) =>
                        user.userId == chatProvider.messages![index].sender_id)
                    .first,
                isMe: isMe,
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text("No messages yet"),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
  }

  Widget bottomForm() {
    return Container(
      height: height * 0.06,
      width: width * 0.9,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 31, 29, 42),
          borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: msgFormKey,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [sendImgButton(), customTextField(), sendMsgButton()]),
      ),
    );
  }

  Widget customTextField() {
    return SizedBox(
      height: height * 0.06,
      width: width * 0.6,
      child: CustomTextField(
        onSaved: (value) {
          chatProvider.setMsg(value);
        },
        regEx: r'.*',
        hintText: "Type...",
        obscureText: false,
      ),
    );
  }

  Widget sendMsgButton() {
    double size = height * 0.06;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
          onPressed: () {
            if (msgFormKey.currentState!.validate()) {
              msgFormKey.currentState!.save();
              chatProvider.sendMsg();
              msgFormKey.currentState!.reset();
            }
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }

  Widget sendImgButton() {
    double size = height * 0.06;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
          onPressed: () {
            chatProvider.sendImageMsg();
          },
          icon: const Icon(
            Icons.image,
            color: Colors.white,
          )),
    );
  }
}
