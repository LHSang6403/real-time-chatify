import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';
import 'package:real_time_chatify/widgets/setting_tile.dart';
import 'package:real_time_chatify/widgets/topbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin<SettingPage> {
  late AuthenticationProvider auth;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    auth = Provider.of<AuthenticationProvider>(context);
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
              isCentered: false,
            ),
          ),
          const SizedBox(height: 20.0),
          userInfo(context, height, width),
          const SizedBox(height: 20.0),
          settingsList(height, width)
        ],
      ),
    );
  }

  Widget userInfo(BuildContext context, double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.1,
          width: width * 0.22,
          child: NetworkRoundedImageWithStatus(
            imagePath:
                "https://logowik.com/content/uploads/images/flutter5786.jpg",
            imageSize: height,
            isActive: true,
          ),
        ),
        SizedBox(height: height * 0.02),
        Text(
          "RT Chattify",
          style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.03,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget settingsList(double height, double width) {
    List<List<dynamic>> settings = [];
    settings.add(['Auto log-in', true]);
    settings.add(['Notifications', true]);
    settings.add(['Privacy', false]);
    settings.add(['Information', false]);
    settings.add(['Log out', false]);

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: settings.length,
        itemBuilder: (BuildContext context, int index) {
          return SettingTile(
              settingName: settings[index][0],
              isSwitch: settings[index][1],
              onTap: () {
                print("tap");
              },
              width: width,
              height: height);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
