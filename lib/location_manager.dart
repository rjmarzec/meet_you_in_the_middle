import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:convert';
import 'location.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  List<Location> _locationList;
  Set<String> _favoritesSet;
  SharedPreferences _prefs;

  // store a void callback that we can call to tell main to update the page it
  // is displaying as our location list gets updated, and to tell our map to
  // reset the zoom every time we get a new location
  VoidCallback publishLocationUpdate;
  VoidCallback publishMapZoomUpdate;

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
    _loadFavorites();
    print("\tFAVORITES SHARED PREFS LOADED");
    _loadLocations();
    print("\tLOCATIONS SHARED PREFS LOADED");
    return true;
  }

  // pull the list of locations from SharedPreferences
  void _loadLocations() {
    String prefsResult = _prefs.getString("locations");
    if (prefsResult != null) {
      Iterable l = json.decode(prefsResult);
      _locationList = (l as List).map((i) => Location.fromJson(i)).toList();
    } else {
      _locationList = [];
    }
  }

  void _loadFavorites() {
    List<String> _prefsResult = _prefs.getStringList("favorites");

    if (_prefsResult != null) {
      _favoritesSet = _prefsResult.toSet();
    } else {
      _favoritesSet = {};
    }
  }

  Future addLocation(String locationName) async {
    // use a geocoder to get coordinates for the addresses users enter
    var addresses = await Geocoder.local.findAddressesFromQuery(locationName);
    Coordinates addressCoordinates = addresses.first.coordinates;
    Location newLocation = Location(
        locationName,
        addressCoordinates,
        _hueFromCoordinates(addressCoordinates),
        true,
        _favoritesSet.contains(locationName));

    // once the location is constructed, add it to the location list and then
    // update the stored shared preferences
    _locationList.add(newLocation);
    _saveLocations();
    publishLocationUpdate();
  }

  Future addCurrentLocation() async {
    // use a geocoder to get coordinates for the addresses users enter
    var currentPosition = await Geolocator.getCurrentPosition();
    Coordinates addressCoordinates =
        Coordinates(currentPosition.latitude, currentPosition.longitude);
    Location newLocation = Location(
      "Current Location",
      addressCoordinates,
      _hueFromCoordinates(addressCoordinates),
      false,
      false,
    );

    // once the location is constructed, add it to the location list and then
    // update the stored shared preferences
    _locationList.add(newLocation);
    _saveLocations();
    publishLocationUpdate();
    publishMapZoomUpdate();
  }

  double _hueFromCoordinates(Coordinates coordinates) {
    // to make the app more fun, each location has a unique color assigned.
    // for consistency, we will build colors from hues, so we need to generate
    // a unique number between 0 and 360 here
    double latLongDifference = (coordinates.latitude - coordinates.longitude);
    return lerpDouble(0, 360, ((latLongDifference * 10000000) % 100) / 100);
  }

  void _saveLocations() {
    _prefs.setString('locations', json.encode(_locationList));
  }

  void _saveFavorites() {
    _prefs.setStringList('favorites', _favoritesSet.toList());
  }

  int locationCount() {
    return _locationList.length;
  }

  int favoritesCount() {
    return _favoritesSet.length;
  }

  Location getLocationAt(int index) {
    return _locationList[index];
  }

  String getFavoriteAt(int index) {
    return _favoritesSet.elementAt(index);
  }

  void flipFavoriteAt(int index) {
    if (_locationList[index].getIsFavorite() == true) {
      _favoritesSet.remove(_locationList[index].getName());
    } else {
      _favoritesSet.add(_locationList[index].getName());
    }
    _refreshFavorites();
    _saveFavorites();
  }

  void _refreshFavorites() {
    for (int i = 0; i < _locationList.length; i++) {
      _locationList[i]
          .setFavorite(_favoritesSet.contains(_locationList[i].getName()));
    }
  }

  void removeLocationAt(int index) {
    _locationList.removeAt(index);
    _saveLocations();
  }

  void clearLocations() {
    _locationList = [];
    _saveLocations();
  }
}
