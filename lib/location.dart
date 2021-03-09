import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';

class Location {
  final String _name;
  final Coordinates _coordinates;
  final Color _color;
  final bool _canFavorite;
  bool _isFavorite;

  // every location has a name, a related latitude & longitude, and may be a
  // user's favorite
  Location(String nameIn, Coordinates coordinatesIn, Color colorIn,
      bool canFavoriteIn, bool isFavoriteIn)
      : _name = nameIn,
        _coordinates = coordinatesIn,
        _color = colorIn,
        _canFavorite = canFavoriteIn,
        _isFavorite = isFavoriteIn;

  String getName() {
    return _name;
  }

  Coordinates getCoordinates() {
    return _coordinates;
  }

  Color getColor() {
    return _color;
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
        'colorRed': _color.red,
        'colorGreen': _color.green,
        'colorBlue': _color.blue,
        'canFavorite': _canFavorite,
        'isFavorite': _isFavorite
      };

  // convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _coordinates = Coordinates(json['latitude'], json['longitude']),
        _color = Color.fromRGBO(
            json['colorRed'], json['colorGreen'], json['colorBlue'], 1.0),
        _canFavorite = json['canFavorite'],
        _isFavorite = json['isFavorite'];
}
