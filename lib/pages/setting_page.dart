import 'package:flutter/material.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Setting",
          style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          child: Center(
        child: Text(
          "Setting Page",
          style: TextStyle(
              color: Colors.black,
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      )),
    );
  }
}
