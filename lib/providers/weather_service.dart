import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'weather_model.dart';

class WeatherService with ChangeNotifier {
  List<Weather> cityWeather;
  List<Weather> multipleCitiesWeather;
  var weatherUnit = 'metric';
  var symbolUnit = ' °C';
  bool isMetricUnit = true;

  Future<void> fetchAndSetWeather3(String cityName) async {
    cityWeather = new List<Weather>();
    cityWeather.add(Weather(
      city: 'test',
      temperature: 22,
      cloudiness: 11,
      country: 'TE',
      date: DateTime.now(),
      description: 'feeg',
      humidity: 22,
      pressure: 22,
      icon: '09d',
      wind: 22,
    ));
  }

  Future<void> fetchAndSetWeather(String cityName) async {
    //var url = 'http://api.openweathermap.org/data/2.5/weather?q='+ cityName +'&units=metric&appid=545034d31cbaa1f5ed677248667d171d';
    var url = 'http://api.openweathermap.org/data/2.5/forecast?q=' +
        cityName +
        '&units='+weatherUnit+'&appid=545034d31cbaa1f5ed677248667d171d';
    try {
      var response = await http.get(url);
      var extractData = json.decode(response.body) as Map<String, dynamic>;
      List<Weather> loadedForecast = new List<Weather>();
      for (var i = 0; i < 7; i++) {
        loadedForecast.add(Weather(
            date: DateTime.now().add(new Duration(days: i)),
            city: extractData['city']['name'],
            country: extractData['city']['country'],
            icon: extractData['list'][i]['weather'][0]['icon'],
            description: extractData['list'][i]['weather'][0]['description'],
            temperature: extractData['list'][i]['main']['temp'],
            cloudiness: extractData['list'][i]['clouds']['all'],
            humidity: extractData['list'][i]['main']['humidity'],
            pressure: extractData['list'][i]['main']['pressure'],
            wind: extractData['list'][i]['wind']['speed']));
      }

      cityWeather = loadedForecast;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetWeatherMultipleCities(List<String> cities) async {
    List<Weather> loadedForecast = new List<Weather>();
    for (var i = 0; i < cities.length; i++) {
      var url = 'http://api.openweathermap.org/data/2.5/forecast?q=' +
          cities[i] +
          '&units='+weatherUnit+'&appid=545034d31cbaa1f5ed677248667d171d';
      try {
        var response = await http.get(url);
        var extractData = json.decode(response.body) as Map<String, dynamic>;
        loadedForecast.add(Weather(
            city: extractData['city']['name'],
            temperature: extractData['list'][0]['main']['temp'],
            icon: extractData['list'][0]['weather'][0]['icon']));
      } catch (error) {}
    }
    multipleCitiesWeather = loadedForecast;
    notifyListeners();
  }

  void changeWeatherUnit(bool isMetric) {
    if(isMetric) {
      symbolUnit = ' °C';
      weatherUnit = 'metric';
    }
    else {
      symbolUnit = ' °K';
      weatherUnit = 'standard';
    }
    isMetricUnit = isMetric;
    fetchAndSetWeather(cityWeather[0].city);
    notifyListeners();
  }
}
