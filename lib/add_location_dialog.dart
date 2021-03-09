import 'package:flutter/material.dart';
import 'package:meet_you_in_the_middle/location_manager.dart';
import 'api_keys.dart';
import 'package:google_place/google_place.dart';

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
                  onPressed: () => _textFieldController.clear(),
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
                    predictions = [];
                  });
                }
              },
            ),
            _buildAutocompleteResponseList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
              child: Text(
                locationName,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                setState(() {
                  locationManager.addLocation(locationName).then((value) => () {
                        _textFieldController.clear();
                        predictions = [];
                      });
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
            return ButtonTheme(
              minWidth: 300,
              child: OutlinedButton(
                child: Text(
                  "Current Location",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(() {
                    locationManager.addCurrentLocation();
                    predictions = [];
                  });
                },
              ),
            );
          } else {
            String locationName = locationManager.getFavoriteAt(index - 1);
            return ButtonTheme(
              minWidth: 300,
              child: OutlinedButton(
                child: Text(
                  locationName,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(() {
                    locationManager.addLocation(locationName);
                    _textFieldController.clear();
                    predictions = [];
                  });
                },
              ),
            );
          }
        },
      );
    }
  }
}
