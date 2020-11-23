import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/location_service.dart';
import 'package:weather_app/providers/weather_service.dart';
import 'package:weather_app/widgets/app_drawer.dart';

import 'add_location_screen.dart';

class WeatherScreen extends StatefulWidget {
  static const routeName = '/weather_screen';
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  String defaultCity;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<MyLocations>(context, listen: false)
          .fetchAndSetLocations()
          .then((value) {
        if ((Provider.of<MyLocations>(context, listen: false)
                    .locations
                    .length ==
                null ||
            Provider.of<MyLocations>(context, listen: false).locations.length ==
                0)) {
        } else {
          Provider.of<WeatherService>(context, listen: false)
              .fetchAndSetWeather(
                  Provider.of<MyLocations>(context, listen: false)
                      .getDefaultCity())
              .then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getDefaultCity() {
    defaultCity =
        Provider.of<MyLocations>(context, listen: false).getDefaultCity();
  }

  void navigateToPage(int index) {
    switch (index) {
      case 2:
        Navigator.of(context).pushNamed(AddLocationScreen.routeName);
        break;
      default:
        break;
    }
  }

  Widget _widgetWeatherInfoColumn(String imageUrl, String value, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(imageUrl),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _widgetForecast(
      String date, String icon, String description, String temperature) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
      ),
      height: 60,
      child: Card(
        margin: const EdgeInsets.only(right: 25, left: 25),
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 50, child: Text(date)),
              Spacer(),
              Image.network(
                'http://openweathermap.org/img/wn/' + icon + '@2x.png',
                width: 24,
                height: 24,
              ),
              Text(description),
              Spacer(),
              Text(temperature)
            ],
          ),
        ),
      ),
    );
  }

  Widget noCity() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                'https://img.icons8.com/cute-clipart/64/000000/address.png'),
            Text(
              'Please add city',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var symbolUnit =
        Provider.of<WeatherService>(context, listen: false).symbolUnit;
    final forecast = Provider.of<WeatherService>(context).cityWeather;
    return (Provider.of<MyLocations>(context, listen: false).locations.length ==
                null ||
            Provider.of<MyLocations>(context, listen: false).locations.length ==
                0)
        ? noCity()
        : Scaffold(
            appBar: AppBar(
              title: _isLoading
                  ? Text('...')
                  : Text(forecast[0].city + ', ' + forecast[0].country),
              elevation: 0.0,
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .400,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.deepPurple,
                                  Colors.purple
                                ])),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          //padding: EdgeInsets.only(top: 0),
                                          child: Image.network(
                                              'http://openweathermap.org/img/wn/' +
                                                  forecast[0].icon +
                                                  '@2x.png')),
                                      Text(
                                        forecast[0].temperature < 10
                                            ? forecast[0]
                                                .temperature
                                                .toString()
                                                .substring(0, 1)
                                            : forecast[0]
                                                .temperature
                                                .toString()
                                                .substring(0, 2),
                                        style: TextStyle(
                                            fontSize: 60,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        symbolUnit,
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    forecast[0].description,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        DateFormat('dd.MM.yyyy hh:mm')
                                            .format(forecast[0].date)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: new EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .330,
                                right: 20.0,
                                left: 20.0),
                            child: new Container(
                              height: 100.0,
                              width: MediaQuery.of(context).size.width,
                              child: new Card(
                                color: Colors.white,
                                elevation: 4.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _widgetWeatherInfoColumn(
                                        'https://img.icons8.com/fluent/48/000000/wet.png',
                                        forecast[0].humidity.toString(),
                                        'Humidity'),
                                    _widgetWeatherInfoColumn(
                                        'https://img.icons8.com/fluent/48/000000/wind.png',
                                        forecast[0].wind.toString() + ' m/s',
                                        'Wind'),
                                    _widgetWeatherInfoColumn(
                                        'https://img.icons8.com/fluent/48/000000/atmospheric-pressure.png',
                                        forecast[0].pressure.toString() +
                                            ' hpa',
                                        'Pressure'),
                                    _widgetWeatherInfoColumn(
                                        'https://img.icons8.com/fluent/48/000000/clouds.png',
                                        forecast[0].cloudiness.toString() + '%',
                                        'Cloudiness'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height * .320,
                        child: ListView.builder(
                            itemCount: forecast.length - 1,
                            itemBuilder: (_, i) => _widgetForecast(
                                DateFormat()
                                        .add_EEEE()
                                        .format(forecast[i + 1].date)
                                        .substring(0, 3) +
                                    ' ' +
                                    DateFormat()
                                        .add_d()
                                        .format(forecast[i + 1].date),
                                forecast[i + 1].icon,
                                forecast[i + 1].description,
                                forecast[i + 1].temperature < 10
                                    ? forecast[i + 1]
                                            .temperature
                                            .toString()
                                            .substring(0, 1) +
                                        symbolUnit
                                    : forecast[i + 1]
                                            .temperature
                                            .toString()
                                            .substring(0, 2) +
                                        symbolUnit)),
                      )
                    ],
                  ),
            drawer: AppDrawer(),
          );
  }
}
