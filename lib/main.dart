import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_service.dart';
import 'package:weather_app/providers/location_service.dart';
import 'package:weather_app/screens/add_location_screen.dart';

import 'screens/app.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: WeatherService()),
        ChangeNotifierProvider.value(value: MyLocations()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          //accentColor: Colors.purpleAccent,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: App(),
        routes: {
          App.routeName: (context) => App(),
          WeatherScreen.routeName: (context) => WeatherScreen(),
          AddLocationScreen.routeName: (context) => AddLocationScreen(),
        },
      ),
    );
  }
}
