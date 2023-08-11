import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/chat_page/model/chat.dart';
import 'package:real_time_chatify/pages/chat_page/viewModel/chat_page_controller.dart';
import 'package:real_time_chatify/pages/chat_page/viewModel/chat_page_provider.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/widgets/custom_chat_tile.dart';
import 'package:real_time_chatify/widgets/custom_input_fields.dart';
import 'package:real_time_chatify/widgets/top_bar.dart';

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

  late ChatPageController chatPageController;

  @override
  void initState() {
    super.initState();
    chatPageController = ChatPageController();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(providers: [
      ChangeNotifierProvider<ConversationProvider>(
          create: (_) => ConversationProvider(
              widget.chat.id, auth, chatPageController.scrollController)),
    ], child: buildUI(context));
  }

  Widget buildUI(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      chatProvider = context.watch<ConversationProvider>();
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
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
                            Icons.call,
                            color: Colors.white60,
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
                    Divider(
                      height: height * 0.005,
                      color: Colors.white60,
                      thickness: 0.5,
                    ),
                    messagesListUI(),
                    bottomForm(),
                  ],
                ))),
      );
    });
  }

  Widget messagesListUI() {
    if (chatProvider.messages != null) {
      if (chatProvider.messages!.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            controller: chatPageController.scrollController,
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
          child: Text("No messages yet",
              style: TextStyle(color: Colors.white60, fontSize: 20)),
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
          borderRadius: BorderRadius.circular(22)),
      child: Form(
        key: chatPageController.msgFormKey,
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
            if (chatPageController.msgFormKey.currentState!.validate()) {
              chatPageController.msgFormKey.currentState!.save();
              chatProvider.sendMsg();
              chatPageController.msgFormKey.currentState!.reset();
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
