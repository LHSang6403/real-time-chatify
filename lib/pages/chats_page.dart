import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:provider/provider.dart";
import "package:real_time_chatify/models/chat.dart";
import 'package:real_time_chatify/pages/chat_page.dart';
import "package:real_time_chatify/providers/authentication_provider.dart";
import "package:real_time_chatify/providers/chats_page_provider.dart";
import "package:real_time_chatify/services/navigation_service.dart";
import 'package:real_time_chatify/widgets/custom_list_tile.dart';
import "package:real_time_chatify/widgets/topbar.dart";

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin<ChatsPage> {
  late AuthenticationProvider auth;
  late ChatsPageProvider chatsPageProvider;
  late NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    auth = Provider.of<AuthenticationProvider>(context);
    navigationService = GetIt.instance.get<NavigationService>();

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
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  top: height * 0.02,
                  bottom: 0.0),
              child: TopBar(
                title: "Chats",
                action1: IconButton(
                    onPressed: () {
                      auth.logOut();
                    },
                    icon: const Icon(Icons.logout)),
                isCentered: false,
              ),
            ),
            chatsList(height, width),
          ],
        ),
      );
    });
  }

  Widget chatsList(double height, double width) {
    List<Chat> chats = chatsPageProvider.chats;

    return Expanded(
      child: () {
        return chats != null
            ? chats.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return chatTile(chats[index], height, width);
                    },
                  )
                : const Center(
                    child: Text("No chat"),
                  )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
      }(),
    );
  }

  Widget chatTile(Chat chat, double height, double width) {
    return CustomListTile(
        height: height * 0.05,
        width: width * 0.9,
        title: chat.getChatName(),
        subtitle: chat.getSubTitle(),
        imgUrl: chat.getImageUrl(),
        isActive: chat.getActiveStatus(),
        isActivity: chat.isActive,
        onTap: () {
          navigationService.routeToPage(ConversationPage(chat: chat));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
