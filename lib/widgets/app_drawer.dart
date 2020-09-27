import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_service.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var isMetric = Provider.of<WeatherService>(context).isMetricUnit;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Weather App'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          SwitchListTile(
            title: Text('Change temperature unit'),
            subtitle: isMetric ? Text('Metric') : Text('Standard'),
            value: isMetric,
            onChanged: (value) => Provider.of<WeatherService>(context, listen: false).changeWeatherUnit(value),
          )
        ],
      ),
    );
  }
}
