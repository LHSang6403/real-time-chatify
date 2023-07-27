import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:real_time_chatify/models/user.dart';
import "package:real_time_chatify/providers/authentication_provider.dart";
import "package:real_time_chatify/providers/chats_page_provider.dart";
import "package:real_time_chatify/widgets/custom_list_view.dart";
import "package:real_time_chatify/widgets/message_card.dart";
import "package:real_time_chatify/widgets/topbar.dart";

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late AuthenticationProvider auth;
  late ChatsPageProvider chatsPageProvider;

  ChatUser chatUser = ChatUser(
      userId: "1",
      name: "John Doe",
      email: "",
      imageUrl:
          "https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=360",
      lastActive: DateTime.now());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(auth))
    ], child: buildUI(context, height, width));
    //return buildUI(context, height, width);
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Builder(builder: (BuildContext context) {
      chatsPageProvider = context.watch<ChatsPageProvider>();
      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              title: "Chats",
              action1: IconButton(
                  onPressed: () {
                    auth.logOut();
                  },
                  icon: const Icon(Icons.logout)),
            ),
            chatsList(height, width),
          ],
        ),
      );
    });
  }

  Widget chatsList(double height, double width) {
    return Expanded(child: chatTile(height, width));
  }

  Widget chatTile(double height, double width) {
    return CustomListTile(
        height: height * 0.05,
        width: width,
        title: "Sang Le",
        subtitle: "ajsdbhgfjkhdsnfkjsndf",
        imgUrl: "https://i.pravatar.cc/300",
        isActive: true,
        isActivity: false,
        onTap: () {});
  }
}
