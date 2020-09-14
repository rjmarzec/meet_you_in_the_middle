import 'package:flutter/material.dart';
import 'location_manager.dart';
import 'location_page.dart';
import 'map_page.dart';
import 'api_keys.dart';
import 'package:google_place/google_place.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // LocationManager keeps track of all of your locations in one place
  final LocationManager _lm = new LocationManager();

  // LocationPage and MapPage are classes to hold code related to building
  // the pages they are named after
  LocationPage locationPage;
  MapPage mapPage;

  // Some variables used for keeping track of what page the user is currently on
  int _bottomNavBarIndex = 0;
  List<Widget> _bottomNavBarPages;

  // Setup the google places API access for use when adding locations
  final GooglePlace googlePlace = GooglePlace(ApiKeys.googlePlacesKey);
  List<AutocompletePrediction> predictions = [];

  @override
  Widget build(BuildContext context) {
    _buildPages();

    return FutureBuilder<bool>(
      future: _lm.loadSharedPreferences(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Meet You In the Middle'),
            ),
            body: _bottomNavBarPages[_bottomNavBarIndex],
            floatingActionButton: _buildFloatingActionButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildBottomAppBar(),
          );
        } else if (snapshot.hasError) {
          return Text('error! please reload');
          // TODO: Build an error page
          //return _buildLocationErrorWidget();
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return CircularProgressIndicator();
  }

  // Build the location and map pages
  void _buildPages() {
    locationPage = LocationPage(_lm, _setStateCallback);
    mapPage = MapPage(_lm, _setStateCallback);

    _bottomNavBarPages = [];
    _bottomNavBarPages.add(locationPage.build());
    _bottomNavBarPages.add(mapPage.build());
  }

  // Build a button that lets users add locations to the location list
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      child: Icon(Icons.add),
      onPressed: () {
        setState(() {
          _showLocationDialog();
        });
      },
    );
  }

  // Opens the dialog for users to input custom locations through google
  // autocomplete
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Search",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
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
                          setState(() {
                            autoCompleteSearch(value);
                          });
                        } else {
                          if (predictions.length > 0 && mounted) {
                            setState(() {
                              predictions = [];
                            });
                          }
                        }
                      },
                    ),
                    _buildAutocompleteResponseList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Build a list of widgets that represent the google autocomplete search
  // results taken from the predictions list
  Widget _buildAutocompleteResponseList() {
    List<Widget> returnWidgetList = new List<Widget>();
    for (int i = 0; i < predictions.length; i++) {
      String locationName = predictions[i].description;
      returnWidgetList.add(OutlineButton(
        child: Text(
          locationName,
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(
            () {
              _lm.addLocation(locationName);
              predictions = [];
              Navigator.pop(context);
            },
          );
        },
      ));
      //returnWidgetList.add(Text(predictions[i].description));
    }
    return Column(children: returnWidgetList);
  }

  // Run a google autocomplete search for the given string input and update
  // the predictions list once the result returns
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  // Builds the bottom app bar which lets the player navigate which page they
  // are currently on
  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomAppBarButton(Icons.list, "Locations", 0),
          _buildBottomAppBarButton(Icons.map, "Maps", 1),
        ],
      ),
      shape: CircularNotchedRectangle(),
    );
  }

  // Builds button on the bottom app bar used to navigate between the pages.
  // Button look and settings are specified by the input parameters
  Widget _buildBottomAppBarButton(IconData iconIn, String textIn, int indexIn) {
    Color buttonColor =
        (_bottomNavBarIndex == indexIn) ? Colors.orange[600] : Colors.grey[900];
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => _onBottomAppBarTapped(indexIn),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconIn,
                  size: 30,
                  color: buttonColor,
                ),
                Text(
                  textIn,
                  style: TextStyle(color: buttonColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Changes the page to the respective page of the app bar button that was
  // tapped
  void _onBottomAppBarTapped(int itemIndex) {
    setState(() {
      _bottomNavBarIndex = itemIndex;
    });
  }

  // Used as a callback to be able to call setState() {} in classes in other
  // files that would otherwise not be able to
  void _setStateCallback() => setState(() {});
}
