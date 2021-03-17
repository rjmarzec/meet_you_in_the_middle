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
            Text(
              "Finally, a fair meetup coordination tool!\n\nHit the + button to get started by adding a location from a search, a saved favorite, or wherever you're currently standing.\n\nOnce you're done, switch to the map screen and tap the midpoint to open it up in Google Maps.\n\nYou've got your fair midpoint, and from there it's up to you to decide what spot looks best.\n\n---------------------------------------------\n\nDeveloped by Robert Marzec using Flutter. Find out more at rjmarzec.com",
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("DONE"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
