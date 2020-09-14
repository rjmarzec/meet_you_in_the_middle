import 'package:geocoder/geocoder.dart';

import 'location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  List<Location> _locationList;
  SharedPreferences prefs;

  // Initializes the list of locations to be blank before doing anything
  LocationManager() {
    _locationList = new List<Location>();
  }

  // Creates an asynchronous to get an instance of SharedPreferences. This needs
  // to be run before any locations can be retrieved or stored, or else
  // everything will break
  Future<bool> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _loadLocations();
    return true;
  }

  // Getter for the list of locations
  List<Location> getLocations() {
    return _locationList;
  }

  // Getter for the names of locations in the list of locations
  List<String> getLocationNames() {
    List<String> locationNameList = new List<String>();
    for (var location in _locationList) {
      locationNameList.add(location.getName());
    }
    return locationNameList;
  }

  // Getter for the latitudes of locations in the list of locations
  List<Coordinates> getLocationCoordinates() {
    List<Coordinates> locationCoordinatesList = new List<Coordinates>();
    for (var location in _locationList) {
      locationCoordinatesList.add(location.getCoordinates());
    }
    return locationCoordinatesList;
  }

  // Returns the number of locations stored in the location list
  int locationCount() {
    return _locationList.length;
  }

  // Gets the name of a location at a specific index in the location list
  String getLocationNameAt(int indexIn) {
    return _locationList[indexIn].getName();
  }

  // Gets the coordinates of a location at a specific index in the location list
  Coordinates getLocationCoordinatesAt(int indexIn) {
    return _locationList[indexIn].getCoordinates();
  }

  // Gets whether the location is valid at a specific index in the location list
  bool getLocationCoordinatesReadyAt(int indexIn) {
    return _locationList[indexIn].coordinatesAreReady();
  }

  // Adds a location to the location list and saves it to SharedPreferences.
  void addLocation(String nameIn) {
    _locationList.add(new Location(nameIn));
    _saveLocations();
  }

  // Removes the location at the given index and then saves the location list
  // to SharedPreferences
  void removeLocationAt(int indexIn) {
    _locationList.removeAt(indexIn);
    _saveLocations();
  }

  void setLocationList(List<Location> locationListIn) {
    _locationList = locationListIn;
    _saveLocations();
  }

  // Pull the list of locations from SharedPreferences
  void _loadLocations() {
    String prefsResult = prefs.getString('locations');
    if (prefsResult != null) {
      Iterable l = json.decode(prefsResult);
      _locationList = (l as List).map((i) => Location.fromJson(i)).toList();
    } else {
      _locationList = [];
    }
  }

  // Saves the current location list to SharedPreferences
  void _saveLocations() {
    print(_locationList[0].toJson());
    prefs.setString('locations', json.encode(_locationList));
  }
}
