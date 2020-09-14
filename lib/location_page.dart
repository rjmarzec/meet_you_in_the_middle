import 'package:flutter/material.dart';
import 'location_manager.dart';

class LocationPage {
  LocationManager _lm;
  VoidCallback _parentSetState;

  // Store the location manager and a callback function that calls setState()
  // to use to update the UI when a location is removed
  LocationPage(LocationManager lmIn, VoidCallback parentSetStateIn)
      : _lm = lmIn,
        _parentSetState = parentSetStateIn;

  // Use a future to build the location page. We use a future because using
  // SharedPreferences to get stored information is asynchronous, so while
  // that is still running, show a loading a wheel
  Widget build() {
    return _buildLocationListWidgets();
  }

  // Build the main location page from a list of location widgets. For each
  // location, build a list item, and separate the next item using a divider
  Widget _buildLocationListWidgets() {
    List<Widget> returnWidgetList = new List();
    for (int i = 0; i < _lm.locationCount(); i++) {
      if (i != 0) {
        returnWidgetList.add(
          Divider(
            color: Colors.black,
            indent: 8,
            endIndent: 8,
          ),
        );
      }
      returnWidgetList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              Icon(
                Icons.pin_drop,
                size: 36,
              ),
              Expanded(
                child: Text(
                  _lm.getLocationNameAt(i),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  _lm.removeLocationAt(i);
                  _parentSetState();
                },
              ),
            ],
          ),
        ),
      );
    }
    return ListView(children: returnWidgetList);
  }

  // Build a loading circle to show while still waiting to get an instance of
  // SharedPreferences
  Widget _buildLoadingWidget() {
    return CircularProgressIndicator();
  }
}
