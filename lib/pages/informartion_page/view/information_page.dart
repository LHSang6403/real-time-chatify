import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:real_time_chatify/pages/informartion_page/Model/information_model.dart';
import 'package:real_time_chatify/services/navigation_service.dart';
import 'package:real_time_chatify/widgets/rounded_button.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class InformationPage extends StatelessWidget {
  late double height;
  late double width;
  late NavigationService nav;
  late PlatformFile devImgFile;
  late PlatformFile appImgFile;

  InformationModel informationModel = InformationModel(
      "Real time Chatify",
      "0.0.1",
      "assets/images/app_logo.png",
      "Sang Le",
      "assets/images/unknown_him.png",
      "lhsang64.contact@gmail.com");
  InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    devImgFile = PlatformFile(
      name: "dev.png",
      size: 0,
      path: informationModel.devIconUrl.toString(),
    );
    appImgFile = PlatformFile(
      name: "app.png",
      size: 0,
      path: informationModel.appIconUrl.toString(),
    );
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    nav = GetIt.instance.get<NavigationService>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AssetRoundedImage(profileImage: appImgFile, imageSize: height * 0.1),
          customTextInformation(informationModel.appName, true, 28),
          customTextInformation(informationModel.appVersion, false, 24),
          AssetRoundedImage(profileImage: devImgFile, imageSize: height * 0.1),
          customTextInformation(informationModel.devName, false, 24),
          customTextInformation(informationModel.devEmail, false, 20),
          SizedBox(
            height: height * 0.04,
          ),
          RoundedButton(
              buttonName: "Ok",
              height: height * 0.05,
              width: width * 0.3,
              onPressed: () => nav.routeBack())
        ],
      ),
    );
  }

  Widget customTextInformation(String text, bool isBold, double fontSize) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white70,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
