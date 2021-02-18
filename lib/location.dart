import 'package:geocoder/geocoder.dart';

class Location {
  final String _name;
  final Coordinates _coordinates;
  bool _isFavorite;

  // every location has a name, a related latitude & longitude, and may be a
  // user's favorite
  Location(String nameIn, Coordinates coordinatesIn)
      : _name = nameIn,
        _coordinates = coordinatesIn,
        _isFavorite = false;

  // Getter for the location name
  String getName() {
    return _name;
  }

  // Getter for the location latitude
  Coordinates getCoordinates() {
    return _coordinates;
  }

  bool getIsFavorite() {
    return _isFavorite;
  }

  // convert the location to a Json string so that it can get saved using
  // SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': _name,
        'latitude': _coordinates.latitude,
        'longitude': _coordinates.longitude,
        'isFavorite': _isFavorite
      };

  // convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _coordinates = Coordinates(json['latitude'], json['longitude']),
        _isFavorite = json['isFavorite'];
}
