import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void _getMapController(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _buildGoogleMap(),
      _buildSwapMapTypeButton(),
    ]);
  }

  Widget _buildGoogleMap() {
    // first, figure out where our center should be
    LatLng _midpointCoordinates = _getMidpointCoordinates();

    // build the set of markers from the stored locations, and then add the
    // midpoint marker as well
    Set<Marker> locationMarkers = _buildLocationMarkers();
    locationMarkers.add(_buildCenterMarker(_midpointCoordinates));

    // build the map
    return GoogleMap(
      onMapCreated: _getMapController,
      markers: locationMarkers,
      mapType: _currentMapType,
      initialCameraPosition: CameraPosition(
        target: _midpointCoordinates,
        zoom: 11.0,
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

  Marker _buildCenterMarker(LatLng coordinates) {
    return Marker(
      markerId: MarkerId("Midpoint"),
      infoWindow: InfoWindow(title: "Midpoint", snippet: '*'),
      position: coordinates,
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
          infoWindow:
              InfoWindow(title: currentLocation.getName(), snippet: '*'),
          position: LatLng(currentLocation.getCoordinates().latitude,
              currentLocation.getCoordinates().longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              HSVColor.fromColor(currentLocation.getColor()).hue),
        ),
      );
    }

    return locationMarkers;
  }

  Widget _buildSwapMapTypeButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () => _swapMapType(),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Colors.green,
          child: const Icon(Icons.map, size: 36.0),
        ),
      ),
    );
  }

  void _swapMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
