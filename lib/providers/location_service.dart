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

  List<Location> locations = [];

  Future<void> fetchAndSetLocations() async {
    locations = [];
    var data = await DBHelper.getData('locations');
    data.forEach((lokacija) {
      locations.add(Location(city: lokacija['city'], isDefault: lokacija['isFavorite'] == 0 ? false : true));
    });
    notifyListeners();
  }

  Future<void> addLocation(String city) async {
    return Future.delayed(Duration(seconds: 2), () async {
      //locations.add(Location(city: city));
      //database
      var count = await DBHelper.getData('locations');
      DBHelper.insert('locations', {
        'city': city,
        'isFavorite': count.length == 0 ? 1 : 0
      });
      var data = DBHelper.getData('locations');
      data.then((value) => print(value));
      fetchAndSetLocations();
    });
  }

  Future<void> deleteLocation(String cityToRemove) async {
    locations.removeWhere((location) => location.city == cityToRemove);
    await DBHelper.delete('locations', 'city', cityToRemove);
    if(locations.length > 0) {
      var loc = locations.firstWhere((element) => element.city != cityToRemove);
      print(loc.city);
      updateDefaultLocation(loc.city);
    }
    else {
      fetchAndSetLocations();
    }
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
    fetchAndSetLocations();
    //notifyListeners();
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
