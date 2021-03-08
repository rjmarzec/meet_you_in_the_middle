import 'package:flutter/material.dart';
import 'package:meet_you_in_the_middle/location_manager.dart';

class ResetLocationsDialog extends StatefulWidget {
  @override
  ResetLocationsDialogState createState() => new ResetLocationsDialogState();
}

class ResetLocationsDialogState extends State<ResetLocationsDialog> {
  // store a reference to our location manager for access later
  final LocationManager locationManager = LocationManager();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text("Clear the location list?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    locationManager.clearLocations();
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
