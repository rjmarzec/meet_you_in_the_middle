import 'package:flutter/material.dart';
import 'location_manager.dart';
import 'location_page.dart';
import 'map_page.dart';
import 'add_location_dialog.dart';

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
  // different widgets are split up between classes to make organization cleaner
  LocationManager locationManager = LocationManager();

  // keep track of which page the user is currently looking at
  int _bottomNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<bool> _sharedPrefsFuture = locationManager.loadSharedPreferences();
    locationManager.publishLocationUpdate = _updateLocationsDisplayedCallback;

    return FutureBuilder<bool>(
      future: _sharedPrefsFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // while we wait for the shared preferences to load,
        if (snapshot.hasData) {
          return _buildApp();
        } else if (snapshot.hasError) {
          return _buildSharedPrefErrorWidget();
        } else {
          return _buildSharedPrefLoadingWidget();
        }
      },
    );
  }

  Widget _buildSharedPrefLoadingWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading locations...'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSharedPrefErrorWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Something went wrong!\nPlease restart the app.'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApp() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet You In the Middle'),
      ),
      body: _buildSelectedPage(),
      floatingActionButton: _buildAddLocationButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildPageSelectionAppBar(),
    );
  }

  Widget _buildSelectedPage() {
    if (_bottomNavBarIndex == 0) {
      return _buildLocationsPage();
    }
    return _buildMapPage();
  }

  Widget _buildLocationsPage() {
    return LocationPage();
  }

  Widget _buildMapPage() {
    return MapPage();
  }

  FloatingActionButton _buildAddLocationButton() {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      child: Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AddLocationDialog();
          },
        ).then((_) => setState(() {}));
      },
    );
  }

  // builds the bottom app bar which lets the player navigate which page they
  // are currently on
  BottomAppBar _buildPageSelectionAppBar() {
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

  // builds button on the bottom app bar used to navigate between the pages.
  // button look and settings are specified by the input parameters
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

  // changes the page to the respective page of the app bar button that was
  // tapped
  void _onBottomAppBarTapped(int itemIndex) {
    setState(() {
      _bottomNavBarIndex = itemIndex;
    });
  }

  void _updateLocationsDisplayedCallback() => setState(() {});
}
