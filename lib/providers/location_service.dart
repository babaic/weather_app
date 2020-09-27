import 'dart:async';

import 'package:flutter/material.dart';

class Location {
  final String city;
  bool isDefault;
  Location({this.city, this.isDefault = false});
}

class MyLocations with ChangeNotifier {
  //List<String> locations = ["London", "Paris", "New York"];

  List<Location> locations = [
    Location(city: 'London', isDefault: true),
    Location(city: 'Paris'),
    Location(city: 'Berlin'),
    Location(city: 'New Orleans'),
  ];

  Future<void> addLocation(String city) async {
    return Future.delayed(Duration(seconds: 2), () {
      locations.add(Location(city: city));
      notifyListeners();
    });
    //return Future.delayed(Duration(seconds: 2), () => throw Exception('Logout failed: user ID is invalid'));
  }

  void deleteLocation(String cityToRemove) {
    locations.removeWhere((location) => location.city == cityToRemove);
    notifyListeners();
  }

  void updateDefaultLocation(String city) {
    //remove old default
    var defaultLocations = locations.where((location) => location.isDefault == true).toList();
    defaultLocations.forEach((location) {
      location.isDefault = false;
    });

    var location = locations.firstWhere((location) => location.city == city);
    location.isDefault = true;
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
