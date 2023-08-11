import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/models/user.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/pages/people_page/viewModel/people_page_provider.dart';
import 'package:real_time_chatify/widgets/custom_person_tile.dart';
import 'package:real_time_chatify/widgets/custom_search.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';
import 'package:real_time_chatify/widgets/topbar.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage>
    with AutomaticKeepAliveClientMixin<PeoplePage> {
  late double height;
  late double width;

  late AuthenticationProvider auth;
  late PeoplePageProvider peoplePageProvider;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<PeoplePageProvider>(
        create: (_) => PeoplePageProvider(auth),
      ),
    ], child: buildUI(context, height, width));
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Builder(builder: (BuildContext context) {
      peoplePageProvider = context.watch<PeoplePageProvider>();
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
          searchController.clear();
          peoplePageProvider.getUsers();
        },
        child: Scaffold(
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
                  title: "People",
                  isCentered: false,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: width * 0.9,
                height: height * 0.06,
                child: CustomSearch(
                    onComplete: (value) {
                      peoplePageProvider.getUsers(name: value);
                      //FocusScope.of(context).unfocus();
                    },
                    hintText: "Search...",
                    obscureText: false,
                    textController: searchController),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              userList(context, height, width),
              startChatButton(height, width),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget userList(BuildContext context, double height, double width) {
    List<ChatUser> users = peoplePageProvider.users;

    return Expanded(
      child: () {
        if (users != null) {
          if (users.isNotEmpty) {
            return RefreshIndicator(
              key: UniqueKey(),
              color: const Color.fromRGBO(36, 35, 49, 1.0),
              backgroundColor: Colors.white,
              strokeWidth: 4.0,
              onRefresh: () async {
                peoplePageProvider.getUsers();
              },
              child: ListView.builder(
                itemCount: users.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return CustomPersonTile(
                    height: height,
                    width: width,
                    name: users[index].name,
                    imgUrl: users[index].imageUrl,
                    isActive: users[index].wasRecentlyActive(),
                    isSelected:
                        peoplePageProvider.selectedUsers.contains(users[index]),
                    onTap: () {
                      peoplePageProvider.updateSelectedUsers(users[index]);
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text("No users found"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }(),
    );
  }

  Widget startChatButton(double height, double width) {
    return Visibility(
      visible: peoplePageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        buttonName: peoplePageProvider.selectedUsers.length == 1
            ? "Chat with ${peoplePageProvider.selectedUsers.first.name}"
            : "Group chat ${peoplePageProvider.selectedUsers.length + 1} people",
        height: height * 0.06,
        width: width * 0.7,
        onPressed: () {
          peoplePageProvider.createChat();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
