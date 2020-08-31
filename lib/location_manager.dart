import 'location.dart';

class LocationManager {
  List<Location> locationList;
  List<String> locationNameList;

  bool addLocation(String nameIn) {
    Location tempLocation = new Location(nameIn);
    if (tempLocation.isValid()) {
      locationList.add(tempLocation);
      return true;
    } else {
      return false;
    }
  }

  List<String> getLocationNameList() {
    return locationNameList;
  }
}
