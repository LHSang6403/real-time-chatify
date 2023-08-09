import 'package:flutter/material.dart';

class AndroidAlertDialog {
  static Future<void> show(BuildContext context, String title, String content,
      Function onOkPressed) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.green)),
              onPressed: () {
                onOkPressed();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
