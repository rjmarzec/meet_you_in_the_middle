import 'package:geocoder/geocoder.dart';

class Location {
  final String _name;
  Coordinates _coordinates;
  bool _locationIsValid;

  // Every location has a name and related latitude and longitude
  Location(String nameIn) : _name = nameIn {
    // Since only a name is taken as input, we need to find the latitude and
    // longitude
    _findCoordinates();
  }

  // Find the location's latitude and longitude. If no coordinates cannot be
  // found be cause the location is not valid, mark the location
  void _findCoordinates() async {
    _locationIsValid = true;
    var _geocoderResult = await Geocoder.local.findAddressesFromQuery(_name);
    if (_geocoderResult.isNotEmpty) {
      _coordinates = _geocoderResult.first.coordinates;
      _locationIsValid = true;
    } else {
      _coordinates = new Coordinates(-180.0, -180.0);
      _locationIsValid = false;
    }
  }

  // Return whether or not the location is valid and can be used
  bool isValid() {
    return _locationIsValid;
  }

  // Getter for the location name
  String getName() {
    return _name;
  }

  // Getter for the location latitude
  Coordinates getCoordinates() {
    return _coordinates;
  }

  // Convert the location to a Json string so that it can get saved using
  // SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': _name,
        'cooridnates': _coordinates,
      };

  // Convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _coordinates = json['coordinates'];
}
