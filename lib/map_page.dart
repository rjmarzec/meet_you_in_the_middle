import 'package:flutter/material.dart';
import 'location_manager.dart';

class MapPage {
  LocationManager _lm;
  VoidCallback _parentSetState;

  // Store the location manager and a callback function that calls setState()
  MapPage(LocationManager lmIn, VoidCallback parentSetStateIn)
      : _lm = lmIn,
        _parentSetState = parentSetStateIn;

  // Builds the map page
  Widget build() {
    return Container(
      child: Text('map to be implemented at a later date'),
    );
  }
}
