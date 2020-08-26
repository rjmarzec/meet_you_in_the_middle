import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.dark(),
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

  @override
  Widget build(BuildContext context) {
    _buildBottomNavBarPages();

    return Scaffold(
        appBar: AppBar(
          title: Text('Meet You In the Middle'),
        ),
        body: _bottomNavBarPages[_bottomNavBarIndex],
        bottomNavigationBar: _buildBottomNavBar());
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
              Icon(Icons.pin_drop),
              Expanded(
                child: Text('Entry A'),
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

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_add_check),
          title: Text('Locations'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Map'),
        ),
      ],
      currentIndex: _bottomNavBarIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onBottomNavBarTapped,
    );
  }

  void _onBottomNavBarTapped(int itemIndex) {
    setState(() {
      _bottomNavBarIndex = itemIndex;
    });
  }
}
