import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:convert';
import 'location.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  List<Location> _locationList;
  SharedPreferences _prefs;

  // store a void callback that we can call to tell main to update the page it
  // is displaying as our location list gets updated
  VoidCallback publishLocationUpdate;

  // we use a singleton pattern for our location manager here so that all of
  // our location-related needs can refer back to the same place without
  // causing any issues with race conditions
  factory LocationManager() {
    return _instance;
  }

  // a constructor using the singleton pattern
  LocationManager._internal() {
    print("*** SINGLETON LOCATION MANAGER CREATED ***");
    _locationList = [];
  }

  // load up the user's stored locations by first waiting for sharedPreferences
  // to come back with those locations
  Future<bool> loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    print("\tSHARED PREFS LOADED");
    _loadLocations();
    print("\tLOCATIONS LOADED FROM SHARED PREFS");
    return true;
  }

  // pull the list of locations from SharedPreferences
  void _loadLocations() {
    String prefsResult = _prefs.getString('locations');
    if (prefsResult != null) {
      Iterable l = json.decode(prefsResult);
      _locationList = (l as List).map((i) => Location.fromJson(i)).toList();
    } else {
      _locationList = [];
    }
  }

  Future addLocation(String locationName) async {
    // use a geocoder to get coordinates for the addresses users enter
    var addresses = await Geocoder.local.findAddressesFromQuery(locationName);
    Coordinates addressCoordinates = addresses.first.coordinates;
    Location newLocation = Location(locationName, addressCoordinates);

    // once the location is constructed, add it to the location list and then
    // update the stored shared preferences
    _locationList.add(newLocation);
    _saveLocations();
  }

  void _saveLocations() {
    _prefs.setString('locations', json.encode(_locationList));
  }

  int locationCount() {
    return _locationList.length;
  }

  Location getLocationAt(int index) {
    return _locationList[index];
  }

  void removeLocationAt(int index) {
    _locationList.removeAt(index);
    _saveLocations();
  }
}
