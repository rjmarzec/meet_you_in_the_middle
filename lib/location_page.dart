import 'package:flutter/material.dart';
import 'location_manager.dart';
import 'location.dart';

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
    if (locationManager.locationCount() < 1) {
      return Stack(children: <Widget>[
        _buildGiantPinIcon(),
        _buildAddLocationNote(),
      ]);
    } else {
      return Stack(children: <Widget>[
        _buildGiantPinIcon(),
        _buildLocationListWidgets(),
      ]);
    }
  }

  Widget _buildGiantPinIcon() {
    return Center(
      child: Icon(
        Icons.location_pin,
        size: 256,
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildAddLocationNote() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          "Get started by adding a location using the button below!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  // build the main location page from a list of location widgets. For each
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
                  _buildColoredPinIcon(i),
                  _buildLocationNameText(i),
                  _buildFavoriteLocationIconButton(i),
                  _buildRemoveLocationIconButton(i),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ListView(children: returnWidgetList);
  }

  Widget _buildColoredPinIcon(int locationIndex) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Icon(
        Icons.pin_drop,
        size: 32,
        color: locationManager.getLocationAt(locationIndex).getColor(),
      ),
    );
  }

  Widget _buildLocationNameText(int locationIndex) {
    return Expanded(
      child: Text(
        locationManager.getLocationAt(locationIndex).getName(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildFavoriteLocationIconButton(int locationIndex) {
    Location currentLocation = locationManager.getLocationAt(locationIndex);

    Icon favoriteIcon = (currentLocation.getIsFavorite())
        ? Icon(Icons.star)
        : Icon(Icons.star_outline);

    return IconButton(
      icon: favoriteIcon,
      onPressed: () {
        setState(() {
          locationManager.flipFavoriteAt(locationIndex);
        });
      },
    );
  }

  Widget _buildRemoveLocationIconButton(int locationIndex) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        setState(() {
          locationManager.removeLocationAt(locationIndex);
          locationManager.publishLocationUpdate();
        });
      },
    );
  }
}
