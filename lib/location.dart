class Location {
  String _name;
  double _latitude, _longitude;
  bool _locationIsValid;

  Location(String nameIn) {
    _name = nameIn;
    _findLatLong();
  }

  void _findLatLong() {
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
}
