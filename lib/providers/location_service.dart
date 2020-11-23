import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/DBHelper.dart';

class Location {
  final String city;
  bool isDefault;
  Location({this.city, this.isDefault = false});
}

class MyLocations with ChangeNotifier {
  //List<String> locations = ["London", "Paris", "New York"];

  List<Location> locations = [
    // Location(city: 'London', isDefault: true),
    // Location(city: 'Paris'),
    // Location(city: 'Berlin'),
    // Location(city: 'New Orleans'),
  ];

  Future<void> fetchAndSetLocations() async {
    locations = [];
    var data = await DBHelper.getData('locations');
    data.forEach((lokacija) {
      locations.add(Location(city: lokacija['city'], isDefault: lokacija['isFavorite'] == 0 ? false : true));
    });
    print(data);
    notifyListeners();
  }

  Future<void> addLocation(String city) async {
    return Future.delayed(Duration(seconds: 2), () {
      //locations.add(Location(city: city));
      //database
      DBHelper.insert('locations', {
        'city': city,
        'isFavorite': 0
      });
      var data = DBHelper.getData('locations');
      data.then((value) => print(value));
      fetchAndSetLocations();
    });
    //return Future.delayed(Duration(seconds: 2), () => throw Exception('Logout failed: user ID is invalid'));
  }

  Future<void> deleteLocation(String cityToRemove) async {
    //locations.removeWhere((location) => location.city == cityToRemove);
    await DBHelper.delete('locations', 'city', cityToRemove);
    fetchAndSetLocations();
  }


  void updateDefaultLocation(String city) {
    //remove old default
    var defaultLocations = locations.where((location) => location.isDefault == true).toList();
    defaultLocations.forEach((location) {
      location.isDefault = false;
      DBHelper.update('locations', {'city': location.city, 'isFavorite': 0}, 'city', location.city);
    });
    
    var location = locations.firstWhere((location) => location.city == city);
    location.isDefault = true;
    DBHelper.update('locations', {'city': location.city, 'isFavorite': 1}, 'city', location.city);
    notifyListeners();
  }

  String getDefaultCity() {
    var result = locations.firstWhere((element) => element.isDefault == true);
    notifyListeners();
    return result.city;
  }

  List<String> get myLocations {
    List<String> cities = new List<String>();
    locations.forEach((location) {
      cities.add(location.city);
    });
    return cities;
  }

}
