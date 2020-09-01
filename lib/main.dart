import 'package:flutter/material.dart';
import 'location_manager.dart';

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
  final LocationManager locationManager = new LocationManager();
  int _bottomNavBarIndex = 0;
  List<Widget> _bottomNavBarPages;
  List<String> _locationNames;

  @override
  Widget build(BuildContext context) {
    _buildBottomNavBarPages();
    _loadLocations();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meet You In the Middle'),
      ),
      body: _bottomNavBarPages[_bottomNavBarIndex],
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      child: Icon(Icons.add),
      onPressed: () {
        _showLocationDialog();
      },
    );
  }

  void _buildBottomNavBarPages() {
    _bottomNavBarPages = [];
    _bottomNavBarPages.add(_buildLocationListWidgets());
    _bottomNavBarPages.add(_buildMapPage());
  }

  Widget _buildLocationListWidgets() {
    List<Widget> returnWidgetList = new List();
    for (int i = 0; i < locationManager.locationCount(); i++) {
      print(i);
      if (i != 0) {
        returnWidgetList.add(
          Divider(
            color: Colors.black,
            indent: 8,
            endIndent: 8,
          ),
        );
      }
      returnWidgetList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              Icon(
                Icons.pin_drop,
                size: 36,
              ),
              Expanded(
                child: Text(
                  locationManager.getLocationNameAt(i),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    locationManager.removeLocationAt(i);
                    _locationNames = locationManager.getLocationNames();
                  });
                },
              )
            ],
          ),
        ),
      );
    }
    return ListView(children: returnWidgetList);
  }

  Widget _buildMapPage() {
    return Container(
      child: Text('map'),
    );
  }

  Widget _buildButtonAppBarButton(IconData iconIn, String textIn, int indexIn) {
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
                Icon(iconIn, size: 30),
                Text(textIn),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildButtonAppBarButton(Icons.list, "Locations", 0),
          _buildButtonAppBarButton(Icons.map, "Maps", 1),
        ],
      ),
      shape: CircularNotchedRectangle(),
    );
  }

  void _onBottomAppBarTapped(int itemIndex) {
    setState(() {
      _bottomNavBarIndex = itemIndex;
    });
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  //locationManager.addLocation('test');
                  //_loadLocations();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _loadLocations() {
    return;
  }
}
