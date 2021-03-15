import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'location_manager.dart';
import 'location.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => new MapPageState();
}

class MapPageState extends State<MapPage> {
  // a reference to our location manager, which is where we pull our list of
  // locations from
  final LocationManager locationManager = LocationManager();

  // store the controller for the map in case we need to mess with the map
  // after it has been created
  GoogleMapController mapController;

  // store the map type so that the user can change it as they want
  MapType _currentMapType = MapType.normal;

  // store the midpoint markers and coords so we can access them from anywhere
  Marker _midpointMarker;
  LatLng _midpointCoordinates;

  void _getMapController(GoogleMapController controller) {
    mapController = controller;

    _resetMap(false);
  }

  @override
  Widget build(BuildContext context) {
    locationManager.publishMapZoomUpdate = _updateMapZoomCallback;

    if (locationManager.locationCount() < 2) {
      return Stack(children: <Widget>[
        _buildGiantMapIcon(),
        _buildAddLocationNote(),
      ]);
    } else {
      return Stack(children: <Widget>[
        _buildGoogleMap(),
        _buildSwapMapTypeButton(),
        _buildResetMapZoomButton()
      ]);
    }
  }

  Widget _buildGiantMapIcon() {
    return Center(
      child: Icon(
        Icons.map,
        size: 256,
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildAddLocationNote() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          "Get started by adding a location 2 or more locations using the button below!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    // first, figure out where our center should be
    _midpointCoordinates = _getMidpointCoordinates();

    // build the set of markers from the stored locations, and then add the
    // midpoint marker as well
    Set<Marker> locationMarkers = _buildLocationMarkers();
    _midpointMarker = _buildMidpointMarker(_midpointCoordinates);
    locationMarkers.add(_midpointMarker);

    // build the map
    return GoogleMap(
      onMapCreated: _getMapController,
      markers: locationMarkers,
      mapType: _currentMapType,
      initialCameraPosition: CameraPosition(
        target: _midpointCoordinates,
        zoom: 0,
      ),
    );
  }

  LatLng _getMidpointCoordinates() {
    // get the number of locations to loop through
    int locationCount = locationManager.locationCount();

    // as a failsafe, return the LatLng [0, 0] if there are no locations stored,
    // as otherwise we would break something dividing by zero
    if (locationCount > 0) {
      // store the total lats and longs
      double totalLat = 0;
      double totalLong = 0;

      // loop through all the locations and average them out
      for (int i = 0; i < locationCount; i++) {
        // get the next location
        Location currentLocation = locationManager.getLocationAt(i);

        // add its lat and long to the totals
        totalLat += currentLocation.getCoordinates().latitude;
        totalLong += currentLocation.getCoordinates().longitude;
      }

      // return the average lat and long as a LatLng
      return LatLng(totalLat / locationCount, totalLong / locationCount);
    }
    return LatLng(0, 0);
  }

  LatLngBounds _getBoundCoordinates(double boundScale) {
    // set dummy values for the min and max that will be overwritten by any
    // other larger/smaller values as we start to calculate the mins and maxs
    double minLat = 90;
    double maxLat = -90;
    double minLong = 180;
    double maxLong = -180;

    // store the number of locations we have to loop through
    int locationCount = locationManager.locationCount();

    // loop through all the locations and record the min and max lats and longs
    for (int i = 0; i < locationCount; i++) {
      // get the next location
      Location currentLocation = locationManager.getLocationAt(i);

      // update our mins and maxs if they need to be
      minLat = min(minLat, currentLocation.getCoordinates().latitude);
      maxLat = max(maxLat, currentLocation.getCoordinates().latitude);
      minLong = min(minLong, currentLocation.getCoordinates().longitude);
      maxLong = max(maxLong, currentLocation.getCoordinates().longitude);
    }

    // rescale the bounds by the passed in scalar
    minLat -= (boundScale - 1) * (maxLat - minLat).abs();
    maxLat += (boundScale - 1) * (maxLat - minLat).abs();
    minLong -= (boundScale - 1) * (maxLong - minLong).abs();
    maxLong += (boundScale - 1) * (maxLong - minLong).abs();

    // compute the differences between the midpoint and min/max lats/longs
    double minLatDistance = (_midpointCoordinates.latitude - minLat).abs();
    double maxLatDistance = (_midpointCoordinates.latitude - maxLat).abs();
    double minLongDistance = (_midpointCoordinates.longitude - minLong).abs();
    double maxLongDistance = (_midpointCoordinates.longitude - maxLong).abs();

    // get the offset from the midpoint that all contain all the points
    double midpointLatOffset = max(minLatDistance, maxLatDistance);
    double midpointLongOffset = max(minLongDistance, maxLongDistance);

    // return the LatLngBounds built from the corners of the bounds we want
    return LatLngBounds(
      northeast: LatLng(_midpointCoordinates.latitude + midpointLatOffset,
          _midpointCoordinates.longitude + midpointLongOffset),
      southwest: LatLng(_midpointCoordinates.latitude - midpointLatOffset,
          _midpointCoordinates.longitude - midpointLongOffset),
    );
  }

  Set<Marker> _buildLocationMarkers() {
    Set<Marker> locationMarkers = {};
    int locationCount = locationManager.locationCount();

    // build a marker for each location we have saved, and keep track of lats
    // and longs so that we can found out midpoint
    for (int i = 0; i < locationCount; i++) {
      Location currentLocation = locationManager.getLocationAt(i);
      locationMarkers.add(
        Marker(
          markerId: MarkerId(currentLocation.getName()),
          infoWindow: InfoWindow(title: currentLocation.getName()),
          position: LatLng(currentLocation.getCoordinates().latitude,
              currentLocation.getCoordinates().longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(currentLocation.getHue()),
        ),
      );
    }
    return locationMarkers;
  }

  Marker _buildMidpointMarker(LatLng coordinates) {
    return Marker(
      markerId: MarkerId("Midpoint"),
      icon: BitmapDescriptor.defaultMarkerWithHue(_getAverageHue()),
      infoWindow: InfoWindow(
          title: "This is the midpoint!",
          snippet: 'Tap to open it in Google Maps'),
      position: coordinates,
      onTap: () {
        _launchGoogleMaps(coordinates.latitude, coordinates.longitude);
      },
    );
  }

  void _launchGoogleMaps(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Could not open Google Maps")));
      throw 'Could not open Google Maps';
    }
  }

  double _getAverageHue() {
    double hueSum = 0;
    for (int i = 0; i < locationManager.locationCount(); i++) {
      hueSum += locationManager.getLocationAt(i).getHue();
    }
    return hueSum / locationManager.locationCount();
  }

  Widget _buildSwapMapTypeButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () => _swapMapType(),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          child: const Icon(Icons.map, size: 32.0),
        ),
      ),
    );
  }

  Widget _buildResetMapZoomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 72, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () => _resetMap(true),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: const Icon(Icons.zoom_out_map, size: 32.0),
          ),
        ),
      ),
    );
  }

  void _resetMap(bool animated) {
    // display the midpoint's marker information
    mapController.showMarkerInfoWindow(_midpointMarker.markerId);

    // reset the bounds to center around the midpoint and show all the points
    CameraUpdate boundZoom =
        CameraUpdate.newLatLngBounds(_getBoundCoordinates(1.15), 0);

    // based on when we call this function, choose between animating the
    // camera movement or instantly jumping there
    if (animated) {
      mapController.animateCamera(boundZoom);
    } else {
      mapController.moveCamera(boundZoom);
    }
  }

  void _swapMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _updateMapZoomCallback() {
    _resetMap(true);
  }
}
