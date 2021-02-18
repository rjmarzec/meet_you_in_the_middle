import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'location_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location.dart';

class MapPage {
  MapPage() {}
}

/*
class MapPage {
  LocationManager _lm;
  VoidCallback _parentSetState;

  // Store the location manager
  MapPage(LocationManager lmIn, VoidCallback parentSetStateIn)
      : _lm = lmIn,
        _parentSetState = parentSetStateIn;

  // Builds the map page
  Widget build() {
    return FutureBuilder<bool>(
      future: _loadLocationCoordinates(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return _buildGoogleMap();
        } else if (snapshot.hasError) {
          print(snapshot);
          return Text('error! please reload');
          // TODO: Build an error page
          //return _buildLocationErrorWidget();
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Future<bool> _loadLocationCoordinates() async {
    List<Location> locationList = _lm.getLocations();
    for (int i = 0; i < _lm.locationCount(); i++) {
      print(locationList[i].getName());
      print(locationList[i].getCoordinates().toString());
      if (!locationList[i].coordinatesAreReady()) {
        var addresses = await Geocoder.local
            .findAddressesFromQuery(locationList[i].getName());
        var firstAddress = addresses.first;
        locationList[i].setCoordinates(firstAddress.coordinates);
      }
      print('2');
    }
    _lm.setLocationList(locationList);
    print('3');
    return true;
  }

  Widget _buildGoogleMap() {
    Completer<GoogleMapController> _controller = Completer();
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _getMidpointCameraPosition(),
        markers: _buildMarkers(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  CameraPosition _getMidpointCameraPosition() {
    Coordinates averageCoordinates = _getAverageCoordinates();
    return CameraPosition(
      target: LatLng(averageCoordinates.latitude, averageCoordinates.longitude),
      zoom: 15,
    );
  }

  Coordinates _getAverageCoordinates() {
    List<Coordinates> coordinateList = _lm.getLocationCoordinates();
    List<Location> locationList = _lm.getLocations();
    double latitude = 0.0, longitude = 0.0;
    double validLocationCount = 0.0;
    for (int i = 0; i < _lm.locationCount(); i++) {
      if (locationList[i].coordinatesAreReady()) {
        latitude += coordinateList[i].latitude;
        longitude += coordinateList[i].longitude;
        validLocationCount += 1;
      }
    }
    return Coordinates(
        latitude / validLocationCount, longitude / validLocationCount);
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markerSet = new Set<Marker>();
    List<Location> locationList = _lm.getLocations();
    for (int i = 0; i < _lm.locationCount(); i++) {
      if (locationList[i].coordinatesAreReady()) {
        double locationLatitude = _lm.getLocationCoordinatesAt(i).latitude;
        double locationLongitude = _lm.getLocationCoordinatesAt(i).longitude;

        markerSet.add(new Marker(
            markerId: MarkerId(_lm.getLocationNameAt(i)),
            position: LatLng(locationLatitude, locationLongitude)));
      }
    }
    return markerSet;
  }

  Widget _buildLoadingWidget() {
    return CircularProgressIndicator();
  }
}
*/
