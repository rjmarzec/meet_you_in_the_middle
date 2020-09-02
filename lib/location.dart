class Location {
  final String _name;
  double _latitude, _longitude;
  bool _locationIsValid;

  // Every location has a name and related latitude and longitude
  Location(String nameIn) : _name = nameIn {
    // Since only a name is taken as input, we need to find the latitude and
    // longitude
    _findLatLong();
  }

  // Find the location's latitude and longitude. If no coordinates cannot be
  // found be cause the location is not valid, mark the location
  void _findLatLong() {
    _latitude = 0;
    _longitude = 0;
    _locationIsValid = true;
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
  double getLatitude() {
    return _latitude;
  }

  // Getter for the location longitude
  double getLongitude() {
    return _longitude;
  }

  // Convert the location to a Json string so that it can get saved using
  // SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': _name,
        'lat': _latitude,
        'long': _longitude,
      };

  // Convert the location from a Json string to recover it from how it gets
  // stored in SharedPreferences
  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _latitude = json['lat'],
        _longitude = json['long'];
}
