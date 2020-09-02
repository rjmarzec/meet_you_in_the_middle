import 'location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  List<Location> _locationList;
  SharedPreferences prefs;

  LocationManager() {
    _locationList = new List<Location>();
  }

  Future<bool> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _loadLocations();
    return true;
  }

  List<Location> getLocations() {
    return _locationList;
  }

  List<String> getLocationNames() {
    List<String> locationNameList = new List<String>();
    for (var location in _locationList) {
      locationNameList.add(location.getName());
    }
    return locationNameList;
  }

  List<double> getLocationLats() {
    List<double> locationLatList = new List<double>();
    for (var location in _locationList) {
      locationLatList.add(location.getLatitude());
    }
    return locationLatList;
  }

  List<double> getLocationLongs() {
    List<double> getLocationLongs = new List<double>();
    for (var location in _locationList) {
      getLocationLongs.add(location.getLongitude());
    }
    return getLocationLongs;
  }

  String getLocationNameAt(int indexIn) {
    return _locationList[indexIn].getName();
  }

  bool addLocation(String nameIn) {
    Location locationToAdd = new Location(nameIn);
    if (locationToAdd.isValid()) {
      _locationList.add(locationToAdd);
      _saveLocations();
      _loadLocations();
      return true;
    } else {
      return false;
    }
  }

  void removeLocationAt(int indexIn) {
    _locationList.removeAt(indexIn);
    _saveLocations();
  }

  int locationCount() {
    return _locationList.length;
  }

  void _loadLocations() {
    Iterable l = json.decode(prefs.getString('locations'));
    _locationList = (l as List).map((i) => Location.fromJson(i)).toList();
  }

  void _saveLocations() {
    prefs.setString('locations', json.encode(_locationList));
  }
}
