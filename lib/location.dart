class Location {
  final String _name;
  double _latitude, _longitude;
  bool _locationIsValid;

  Location(String nameIn) : _name = nameIn {
    _findLatLong();
  }

  void _findLatLong() {
    _latitude = 0;
    _longitude = 0;
    _locationIsValid = true;
  }

  bool isValid() {
    return _locationIsValid;
  }

  String getName() {
    return _name;
  }

  double getLatitude() {
    return _latitude;
  }

  double getLongitude() {
    return _longitude;
  }

  Map<String, dynamic> toJson() => {
        'name': _name,
        'lat': _latitude,
        'long': _longitude,
      };

  Location.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _latitude = json['lat'],
        _longitude = json['long'];
}
