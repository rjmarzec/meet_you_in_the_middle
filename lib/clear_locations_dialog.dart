import 'package:flutter/material.dart';
import 'package:meet_you_in_the_middle/location_manager.dart';

class ClearLocationsDialog extends StatefulWidget {
  @override
  ClearLocationsDialogState createState() => new ClearLocationsDialogState();
}

class ClearLocationsDialogState extends State<ClearLocationsDialog> {
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
              child: Text("Clear locations?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () {
                    locationManager.clearLocations();
                    Navigator.pop(context);
                  },
                  child: Text("YES"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
