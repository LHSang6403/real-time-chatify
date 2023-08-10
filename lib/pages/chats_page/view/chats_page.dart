import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:provider/provider.dart";
import "package:real_time_chatify/models/chat.dart";
import "package:real_time_chatify/pages/chat_page/view/chat_page.dart";
import "package:real_time_chatify/pages/chats_page/viewModel/chats_bottombar_provider.dart";
import 'package:real_time_chatify/pages/chats_page/viewModel/chats_page_provider.dart';
import "package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart";
import "package:real_time_chatify/services/navigation_service.dart";
import "package:real_time_chatify/widgets/bottom_sheet.dart";
import 'package:real_time_chatify/widgets/custom_list_tile.dart';
import "package:real_time_chatify/widgets/rounded_image.dart";
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
  late ChatsBottomBarProvider chatsBottomBarProvider;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    auth = Provider.of<AuthenticationProvider>(context);
    navigationService = GetIt.instance.get<NavigationService>();

    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(auth)),
      ChangeNotifierProvider<ChatsBottomBarProvider>(
          create: (_) => ChatsBottomBarProvider(auth)),
    ], child: buildUI(context, height, width));
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Builder(builder: (BuildContext context) {
      chatsPageProvider = context.watch<ChatsPageProvider>();
      chatsBottomBarProvider = context.watch<ChatsBottomBarProvider>();
      chatsBottomBarProvider.getUserInfo();

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
                    // show bottom sheet
                    CustomBottomSheet.showAdd(
                        context, height, width, "Your account", [
                      NetworkRoundedImageWithStatus(
                        imagePath: chatsBottomBarProvider.myImg,
                        imageSize: width * 0.1,
                        isActive: true,
                      )
                    ]);
                  },
                  icon: chatsBottomBarProvider.myImg != ""
                      ? NetworkRoundedImageWithStatus(
                          imagePath: chatsBottomBarProvider.myImg,
                          imageSize: width * 0.1,
                          isActive: true,
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
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
        return RefreshIndicator(
            key: UniqueKey(),
            color: Colors.blue,
            backgroundColor: Colors.white,
            strokeWidth: 4.0,
            onRefresh: () async {
              chatsPageProvider.getChats();
              return Future.delayed(const Duration(seconds: 5));
            },
            child: chats != null
                ? chats.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return chatTile(chats[index], height, width, index);
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                : const Center(
                    child: Text("No chat"),
                  ));
      }(),
    );
  }

  Widget chatTile(Chat chat, double height, double width, int index) {
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
        },
        onRightSwipe: () {
          chatsPageProvider.deleteThisChat(index);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
