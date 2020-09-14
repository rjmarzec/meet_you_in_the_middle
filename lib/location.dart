import 'package:geocoder/geocoder.dart';

class Location {
  final String _name;
  Coordinates _coordinates;
  bool _coordinatesAreReady;

  // Every location has a name and related latitude and longitude
  Location(String nameIn)
      : _name = nameIn,
        _coordinatesAreReady = false,
        _coordinates = new Coordinates(0, 0);

  // Getter for the location name
  String getName() {
    return _name;
  }

  // Getter for the location latitude
  Coordinates getCoordinates() {
    return _coordinates;
  }

  void setCoordinates(Coordinates coordinatesIn) {
    _coordinates = coordinatesIn;
    _coordinatesAreReady = true;
  }

  bool coordinatesAreReady() {
    return _coordinatesAreReady;
  }

  // Convert the location to a Json string so that it can get saved using
  // SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': _name,
        //'coordinates': _coordinates,
        'coordinatesAreReady': _coordinatesAreReady
      };

  // Convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        //_coordinates = json['coordinates'],
        _coordinatesAreReady = json['coordinatesAreReady'];
}
