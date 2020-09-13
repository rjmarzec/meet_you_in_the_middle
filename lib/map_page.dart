import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'location_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage {
  LocationManager _lm;

  // Store the location manager
  MapPage(LocationManager lmIn, VoidCallback parentSetStateIn) : _lm = lmIn;

  // Builds the map page
  Widget build() {
    Completer<GoogleMapController> _controller = Completer();

    Coordinates averageCoordinate = _getAverageCoordinates();

    CameraPosition _midPoint = CameraPosition(
      target: LatLng(averageCoordinate.latitude, averageCoordinate.longitude),
      zoom: 15.000,
    );

    CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
    );

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: _buildMarkers(),
        initialCameraPosition: _midPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Coordinates _getAverageCoordinates() {
    List<Coordinates> cooridinateList = _lm.getLocationCoordinates();
    double locationCount = _lm.locationCount().toDouble();
    double latitude = 0.0, longitude = 0.0;
    for (int i = 0; i < _lm.locationCount(); i++) {
      latitude = cooridinateList[i].latitude;
      longitude = cooridinateList[i].longitude;
    }
    return Coordinates(latitude / locationCount, longitude / locationCount);
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markerSet = new Set<Marker>();
    for (int i = 0; i < _lm.locationCount(); i++) {
      double locationLatitude = _lm.getLocationCoordinatesAt(i).latitude;
      double locationLongitude = _lm.getLocationCoordinatesAt(i).longitude;

      markerSet.add(new Marker(
          markerId: MarkerId(_lm.getLocationNameAt(i)),
          position: LatLng(locationLatitude, locationLongitude)));
    }
  }
}
