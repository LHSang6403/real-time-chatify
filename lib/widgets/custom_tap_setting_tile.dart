import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TapSettingTile extends StatefulWidget {
  final String settingName;
  final bool isSwitch;
  final Function? onTap;
  final Function? onChanged;
  bool? buttonState;
  final double width;
  final double height;

  TapSettingTile({
    Key? key,
    required this.settingName,
    required this.isSwitch,
    this.onTap,
    this.onChanged,
    this.buttonState,
    required this.width,
    required this.height,
  });

  @override
  State<TapSettingTile> createState() => _TapSettingTileState();
}

class _TapSettingTileState extends State<TapSettingTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.width * 0.05),
        height: widget.height * 0.06,
        width: widget.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.settingName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.height * 0.02,
                    fontWeight: FontWeight.w400)),
            widget.isSwitch
                ? CupertinoSwitch(
                    value: widget.buttonState ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.buttonState = value;
                      });
                      widget.onChanged!();
                    },
                  )
                : Container(
                    padding: EdgeInsets.only(right: widget.width * 0.03),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: widget.height * 0.03),
                  )
          ],
        ),
      ),
    );
  }
}
