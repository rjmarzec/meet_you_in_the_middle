import 'package:geocoder/geocoder.dart';

class Location {
  final String _name;
  final Coordinates _coordinates;
  final double _hue;
  final bool _canFavorite;
  bool _isFavorite;

  // every location has a name, a related latitude & longitude, and may be a
  // user's favorite
  Location(String nameIn, Coordinates coordinatesIn, double hueIn,
      bool canFavoriteIn, bool isFavoriteIn)
      : _name = nameIn,
        _coordinates = coordinatesIn,
        _hue = hueIn,
        _canFavorite = canFavoriteIn,
        _isFavorite = isFavoriteIn;

  String getName() {
    return _name;
  }

  Coordinates getCoordinates() {
    return _coordinates;
  }

  double getHue() {
    return _hue;
  }

  bool getCanFavorite() {
    return _canFavorite;
  }

  bool getIsFavorite() {
    return _isFavorite;
  }

  void setFavorite(bool favoriteState) {
    _isFavorite = favoriteState;
  }

  // convert the location to a Json string so that it can get saved using
  // SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': _name,
        'latitude': _coordinates.latitude,
        'longitude': _coordinates.longitude,
        'hue': _hue,
        'canFavorite': _canFavorite,
        'isFavorite': _isFavorite
      };

  // convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _coordinates = Coordinates(json['latitude'], json['longitude']),
        _hue = json['hue'],
        _canFavorite = json['canFavorite'],
        _isFavorite = json['isFavorite'];
}
