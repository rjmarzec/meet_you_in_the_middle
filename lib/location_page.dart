import 'package:flutter/material.dart';
import 'location_manager.dart';

class LocationPage extends StatefulWidget {
  @override
  LocationPageState createState() => new LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  // a reference to our location manager, which is where we pull our list of
  // locations from
  final LocationManager locationManager = LocationManager();

  @override
  Widget build(BuildContext context) {
    return _buildLocationListWidgets();
  }

  // Build the main location page from a list of location widgets. For each
  // location, build a list item, and separate the next item using a divider
  Widget _buildLocationListWidgets() {
    List<Widget> returnWidgetList = new List();
    for (int i = 0; i < locationManager.locationCount(); i++) {
      returnWidgetList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    size: 36,
                  ),
                  Expanded(
                    child: Text(
                      locationManager.getLocationAt(i).getName(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        locationManager.removeLocationAt(i);
                        locationManager.publishLocationUpdate();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ListView(children: returnWidgetList);
  }
}
