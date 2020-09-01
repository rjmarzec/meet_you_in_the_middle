import 'location.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
}

class LocationManager {
  final storage = GetStorage();
  List<Location> _locationList = new List<Location>();

  LocationManager() {
    main();

    _readStoredLocations();

    // Not necessary, should be removed when testing is done
    addLocation('Test1');
    addLocation('Test2');
    addLocation('Test3');
    addLocation('Test4');
  }

  List<Location> getLocations() {
    return _locationList;
  }

  List<String> getLocationNames() {
    List<String> locationNameList = new List<String>();
    for (var location in _locationList) {
      locationNameList.add(location.getName());
    }
    return locationNameList;
  }

  String getLocationNameAt(int indexIn) {
    return _locationList[indexIn].getName();
  }

  bool addLocation(String nameIn) {
    Location tempLocation = new Location(nameIn);
    if (tempLocation.isValid()) {
      _locationList.add(tempLocation);
      _updateStoredLocations();
      return true;
    } else {
      return false;
    }
  }

  void removeLocationAt(int indexIn) {
    _locationList.removeAt(indexIn);
    _updateStoredLocations();
  }

  int locationCount() {
    return _locationList.length;
  }

  void _updateStoredLocations() {
    storage.write('locations', _locationList);
  }

  void _readStoredLocations() {
    if (!storage.hasData('locations')) {
      _updateStoredLocations();
    }
    _locationList = storage.read('locations');
  }
}
