import 'package:flutter/material.dart';
import 'package:real_time_chatify/widgets/setting_tile.dart';
import 'package:real_time_chatify/widgets/topbar.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return buildUI(context, height, width);
  }

  Widget buildUI(BuildContext context, double height, double width) {
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
              title: "Settings",
              action1:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
              isCentered: false,
            ),
          ),
          settingsList()
        ],
      ),
    );
  }

  Widget settingsList() {
    return ListView(
      children: [],
    );
  }
}
