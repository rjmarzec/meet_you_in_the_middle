import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'location.dart';

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
  int _bottomNavBarIndex = 0;
  List<Widget> _bottomNavBarPages;
  List<String> _locations;

  @override
  Widget build(BuildContext context) {
    _buildBottomNavBarPages();

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
      onPressed: () {},
    );
  }

  void _buildBottomNavBarPages() {
    _bottomNavBarPages = [];
    _bottomNavBarPages.add(_buildLocationListPage());
    _bottomNavBarPages.add(_buildMapPage());
  }

  Widget _buildLocationListPage() {
    return ListView(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          //color: Colors.teal,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.pin_drop,
                size: 36,
              ),
              Expanded(
                child: Text(
                  'Entry A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
              )
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          indent: 8,
          endIndent: 8,
        ),
        Container(
          height: 50,
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
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

  Widget _buildLocationDialog() {
    return Dialog();
  }
}
