import 'package:flutter/material.dart';

class AppInfoDialog extends StatefulWidget {
  @override
  AppInfoDialogState createState() => new AppInfoDialogState();
}

class AppInfoDialogState extends State<AppInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("[APP INFO HERE]"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Done"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
