import 'package:flutter/material.dart';
import 'package:weather_app/providers/location_service.dart';
import 'package:weather_app/screens/add_location_screen.dart';
import 'package:weather_app/screens/my_locations_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';

class App extends StatefulWidget {
  static const routeName = '/app';
  
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Map<String, Object>> _pages;
  var _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'Screen': WeatherScreen(), 'Title': 'Weather screen'},
      {'Screen': MyLocationsScreen(), 'Title': 'My locations'},
      {'Screen': AddLocationScreen(), 'Title': 'Add Location'},
      {'Screen': WeatherScreen(), 'Title': 'Settings'}
    ];
    super.initState();
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['Screen'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        onTap: (index) => selectPage(index),
        items: [
          BottomNavigationBarItem(
            title: Text('Dashboard'),
            icon: Icon(Icons.dashboard,color: Theme.of(context).primaryColor,)
          ),
          BottomNavigationBarItem(
            title: Text('My Locations'),
            icon: Icon(Icons.my_location,color: Theme.of(context).primaryColor,)
          ),
          BottomNavigationBarItem(
            title: Text('Add Location'),
            icon: Icon(Icons.add_location,color: Theme.of(context).primaryColor,)
          ),
        ],
      )
    );
  }
}
