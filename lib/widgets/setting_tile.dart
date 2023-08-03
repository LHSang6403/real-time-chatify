import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String settingName;
  final bool buttonstate;
  final Icon icon;
  final Function onTap;
  final width;
  final height;

  const SettingTile({
    Key? key,
    required this.settingName,
    required this.buttonstate,
    required this.icon,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
