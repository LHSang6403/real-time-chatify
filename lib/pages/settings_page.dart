import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/providers/authentication_provider.dart';
import 'package:real_time_chatify/providers/settings_page_provider.dart';
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
  late SettingsProvider settingsProvider;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    auth = Provider.of<AuthenticationProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MultiProvider(providers: [
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(auth),
      ),
    ], child: buildUI(context, height, width));
  }

  Widget buildUI(BuildContext context, double height, double width) {
    return Builder(builder: (BuildContext context) {
      settingsProvider = context.watch<SettingsProvider>();
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
    });
  }

  Widget userInfo(BuildContext context, double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.1,
          width: width * 0.22,
          child: NetworkRoundedImageWithStatus(
            imagePath: settingsProvider.myUserImg,
            imageSize: height,
            isActive: true,
          ),
        ),
        SizedBox(height: height * 0.02),
        Text(
          settingsProvider.myUserName,
          style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.03,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget settingsList(double height, double width) {
    return Expanded(
      child: ListView(
        children: [
          autoLogInTile(height, width),
          notificationsTile(height, width),
          informationTile(height, width),
          logOutTile(height, width),
        ],
      ),
    );
  }

  Widget autoLogInTile(double height, double width) {
    return SettingTile(
        settingName: 'Auto log-in',
        isSwitch: true,
        onTap: () {
          print("tap log in");
        },
        width: width,
        height: height);
  }

  Widget notificationsTile(double height, double width) {
    return SettingTile(
        settingName: 'Notifications',
        isSwitch: true,
        onTap: () {
          print("tap noti");
        },
        width: width,
        height: height);
  }

  Widget informationTile(double height, double width) {
    return SettingTile(
        settingName: 'Information',
        isSwitch: false,
        onTap: () {
          print("tap log info");
        },
        width: width,
        height: height);
  }

  Widget logOutTile(double height, double width) {
    return SettingTile(
        settingName: 'Log Out',
        isSwitch: false,
        onTap: () {
          print("tap log log out");
          //auth.logOut();
        },
        width: width,
        height: height);
  }

  @override
  bool get wantKeepAlive => true;
}
