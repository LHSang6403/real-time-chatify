import 'package:flutter/material.dart';
import 'package:real_time_chatify/pages/chats_page/view/chats_page.dart';
import 'package:real_time_chatify/pages/people_page/view/people_page.dart';
import 'package:real_time_chatify/pages/settings_page/view/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double height;
  late double width;

  int pageIndex = 0;
  List<Widget> pages = [];
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    pages.add(ChatsPage());
    pages.add(PeoplePage());
    pages.add(SettingPage());

    return buildPagesUI(context);
  }

  Widget buildPagesUI(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          pageController.animateToPage(value,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          setState(() {
            pageIndex = value;
          });
        },
        selectedItemColor: Colors.deepPurple[50],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "People"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: pages),
    );
  }
}
