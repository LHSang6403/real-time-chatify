import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chatify/pages/informartion_page/view/information_page.dart';
import 'package:real_time_chatify/pages/login_page/viewModel/authentication_provider.dart';
import 'package:real_time_chatify/pages/settings_page/viewModel/settings_page_provider.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/services/platform_service.dart';
import 'package:real_time_chatify/services/shared_preference_service.dart';
import 'package:real_time_chatify/widgets/dialogs/android_dialog.dart';
import 'package:real_time_chatify/widgets/dialogs/ios_dialog.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';
import 'package:real_time_chatify/widgets/custom_tap_setting_tile.dart';
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
  late SharedPreference sharedPreference;
  late NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    sharedPreference = SharedPreference();
    auth = Provider.of<AuthenticationProvider>(context);
    navigationService = GetIt.instance.get<NavigationService>();

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
          child: settingsProvider.myUserImg != ""
              ? NetworkRoundedImageWithStatus(
                  imagePath: settingsProvider.myUserImg,
                  imageSize: height,
                  isActive: true,
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
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
    return TapSettingTile(
        settingName: 'Auto log-in',
        isSwitch: true,
        buttonState: auth.autoLogIn,
        onChanged: () {
          auth.autoLogIn = !auth.autoLogIn;
          sharedPreference.writeBoolToLocal('autoLogIn', auth.autoLogIn);
        },
        onTap: () {},
        width: width,
        height: height);
  }

  Widget notificationsTile(double height, double width) {
    return TapSettingTile(
        settingName: 'Notifications',
        isSwitch: true,
        buttonState: false,
        onChanged: () {
          sharedPreference.writeBoolToLocal('notifications', false);
          PlatformManager.isIOS()
              ? IOSAlertDialog.show(
                  context, "Alert", "This function is not supported", () {})
              : AndroidAlertDialog.show(
                  context, "Alert", "This function is not supported", () {});
        },
        onTap: () {},
        width: width,
        height: height);
  }

  Widget informationTile(double height, double width) {
    return TapSettingTile(
        settingName: 'Information',
        isSwitch: false,
        onTap: () {
          InformationPage informationPage = InformationPage();
          navigationService.routeToPage(informationPage);
        },
        width: width,
        height: height);
  }

  Widget logOutTile(double height, double width) {
    return TapSettingTile(
        settingName: 'Log Out',
        isSwitch: false,
        onTap: () {
          PlatformManager.isIOS()
              ? IOSAlertDialog.show(context, "Log out",
                  "Do you want to log out?", () => auth.logOut())
              : AndroidAlertDialog.show(context, "Log out",
                  "Do you want to log out?", () => auth.logOut());
        },
        width: width,
        height: height);
  }

  @override
  bool get wantKeepAlive => true;
}
