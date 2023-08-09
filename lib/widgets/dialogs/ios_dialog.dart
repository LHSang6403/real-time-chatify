import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSAlertDialog {
  static void show(BuildContext context, String title, String content,
      Function onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('OK', style: TextStyle(color: Colors.green)),
              onPressed: () {
                onOkPressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
