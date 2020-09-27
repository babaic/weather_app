import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/location_service.dart';
import 'package:weather_app/providers/weather_service.dart';

import 'app.dart';
import 'weather_screen.dart';

class MyLocationsScreen extends StatefulWidget {
  static const routeName = '/my-locations';

  @override
  _MyLocationsScreenState createState() => _MyLocationsScreenState();
}

class _MyLocationsScreenState extends State<MyLocationsScreen> {

  bool _isLoading = false;
  bool _isInit = true;

  @override
  void initState() { 
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<WeatherService>(context).fetchAndSetWeatherMultipleCities(Provider.of<MyLocations>(context, listen: false).myLocations).then((value) {
        setState((){
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget _widgetCardCity(String city, double temperature, String icon, String displayUnit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Provider.of<MyLocations>(context, listen: false).updateDefaultLocation(city);
            Navigator.of(context).pushReplacementNamed(App.routeName);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  child: Text(
                    city,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20,), softWrap: true,
                  ),
                ),
                //Spacer(),
                Image.network(
                  'http://openweathermap.org/img/wn/'+ icon +'@2x.png',
                  width: 100,
                  height: 100,
                ),
                //Spacer(),
                Text(
                  (temperature < 10 ? temperature.toString().substring(0,1) : temperature.toString().substring(0,2)) + displayUnit,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var mylocations = Provider.of<MyLocations>(context).locations;
    var weatherData = Provider.of<WeatherService>(context).multipleCitiesWeather;
    var symbolUnit = Provider.of<WeatherService>(context, listen: false).symbolUnit;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Locations'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        child: SingleChildScrollView(
          child: Column(
              children: weatherData.map((location) => _widgetCardCity(location.city, location.temperature, location.icon, symbolUnit)).toList(),
          ),
        ),
      ),
    );
  }
}
