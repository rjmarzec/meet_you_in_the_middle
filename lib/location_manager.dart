import 'location.dart';

class LocationManager {
  List<Location> locationList = new List();
  List<String> locationNameList = new List();

  LocationManager() {
    // Not necessary, should be removed when testing is done
    addLocation('Test1');
    addLocation('Test2');
  }

  bool addLocation(String nameIn) {
    Location tempLocation = new Location(nameIn);
    if (tempLocation.isValid()) {
      locationList.add(tempLocation);
      locationNameList.add(tempLocation.getName());
      return true;
    } else {
      return false;
    }
  }

  String getLocationNameAt(int indexIn) {
    return locationNameList[indexIn];
  }

  void removeLocation(int indexIn) {
    locationList.removeAt(indexIn);
    locationNameList.removeAt(indexIn);
  }

  int locationCount() {
    return locationList.length;
  }
}
