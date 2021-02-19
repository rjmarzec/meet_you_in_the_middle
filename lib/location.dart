import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';

class Location {
  final String _name;
  final Coordinates _coordinates;
  final Color _color;
  bool _isFavorite;

  // every location has a name, a related latitude & longitude, and may be a
  // user's favorite
  Location(String nameIn, Coordinates coordinatesIn, Color colorIn)
      : _name = nameIn,
        _coordinates = coordinatesIn,
        _color = colorIn,
        _isFavorite = false;

  String getName() {
    return _name;
  }

  Coordinates getCoordinates() {
    return _coordinates;
  }

  Color getColor() {
    return _color;
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
        'colorRed': _color.red,
        'colorGreen': _color.green,
        'colorBlue': _color.blue,
        'isFavorite': _isFavorite
      };

  // convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _coordinates = Coordinates(json['latitude'], json['longitude']),
        _color = Color.fromRGBO(
            json['colorRed'], json['colorGreen'], json['colorBlue'], 1.0),
        _isFavorite = json['isFavorite'];
}
