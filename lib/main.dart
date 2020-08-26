import 'package:flutter/material.dart';

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
    return Container(
      child: Text('map'),
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
