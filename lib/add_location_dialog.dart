import 'package:flutter/material.dart';
import 'package:meet_you_in_the_middle/location_manager.dart';
import 'api_keys.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';

class AddLocationDialog extends StatefulWidget {
  @override
  AddLocationDialogState createState() => new AddLocationDialogState();
}

class AddLocationDialogState extends State<AddLocationDialog> {
  // setup the google places API access for use when adding locations
  final LocationManager locationManager = LocationManager();
  final GooglePlace googlePlace = GooglePlace(ApiKeys.googlePlacesKey);
  List<AutocompletePrediction> predictions = [];

  // storing the controller for the location entry so that we can clear it on
  // command as necessary
  TextEditingController _textFieldController = TextEditingController();

  // keep track of whether or not we are currently displaying autocomplete
  // suggestions
  bool displayingPredictions = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _textFieldController.clear();
                      displayingPredictions = false;
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  displayingPredictions = true;
                  autoCompleteSearch(value);
                } else {
                  setState(() {
                    displayingPredictions = false;
                  });
                }
              },
            ),
            Divider(),
            _buildAutocompleteResponseList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                    locationManager.publishMapZoomUpdate();
                  },
                  child: Text('Done'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // run a google autocomplete search for the given string input and update
  // the predictions list once the result returns
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (displayingPredictions) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  // build a list of widgets that represent the google autocomplete search
  // results taken from the predictions list
  Widget _buildAutocompleteResponseList() {
    if (displayingPredictions) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          String locationName = predictions[index].description;
          return ButtonTheme(
            minWidth: 300,
            child: OutlinedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        locationName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  setState(() {
                    displayingPredictions = false;
                    _textFieldController.clear();
                    predictions = [];
                  });
                  locationManager
                      .addLocation(locationName)
                      .then((_) => setState);
                });
              },
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: locationManager.favoritesCount() + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return FutureBuilder<LocationPermission>(
              future: Geolocator.checkPermission(),
              builder: (BuildContext context,
                  AsyncSnapshot<LocationPermission> snapshot) {
                // while we wait for the shared preferences to load,
                if (snapshot.data == LocationPermission.deniedForever) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return ButtonTheme(
                    minWidth: 300,
                    child: OutlinedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "My Current Location",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          ),
                        ],
                      ),
                      onPressed: () {
                        predictions = [];
                        setState(() {
                          locationManager.addCurrentLocation();
                        });
                      },
                    ),
                  );
                }
              },
            );
          } else {
            String locationName = locationManager.getFavoriteAt(index - 1);
            return ButtonTheme(
              minWidth: 300,
              child: OutlinedButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          locationName,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _textFieldController.clear();
                    predictions = [];
                  });
                  locationManager
                      .addLocation(locationName)
                      .then((_) => setState);
                },
              ),
            );
          }
        },
      );
    }
  }
}
