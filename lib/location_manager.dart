import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:convert';
import 'location.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  List<Location> _locationList;
  Set<String> _favoritesSet;
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
        _colorFromCoordinates(addressCoordinates),
        _favoritesSet.contains(locationName));

    // once the location is constructed, add it to the location list and then
    // update the stored shared preferences
    _locationList.add(newLocation);
    _refreshFavorites();
    _saveLocations();
  }

  Color _colorFromCoordinates(Coordinates coordinates) {
    // to make the app more fun, each location has a unique color assigned.
    // one way to approach this is to make an RBG codes using a sort of hash
    // from the latitudes and longitudes of each color, computed as shown
    double latSquared = coordinates.latitude * coordinates.latitude;
    double longSquared = coordinates.longitude * coordinates.longitude;
    int red = ((100 * latSquared * latSquared + 100)).round() % 160 + 16;
    int green = ((100 * longSquared * longSquared + 100)).round() % 160 + 16;
    int blue = ((100 * latSquared * longSquared + 100)).round() % 160 + 16;
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  void _saveLocations() {
    _prefs.setString('locations', json.encode(_locationList));
    _prefs.setStringList('favorites', _favoritesSet.toList());
  }

  int locationCount() {
    return _locationList.length;
  }

  Location getLocationAt(int index) {
    return _locationList[index];
  }

  void flipFavoriteAt(int index) {
    if (_locationList[index].getIsFavorite() == true) {
      _favoritesSet.remove(_locationList[index].getName());
    } else {
      _favoritesSet.add(_locationList[index].getName());
    }
    _refreshFavorites();
    _saveLocations();
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
