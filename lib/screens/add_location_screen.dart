import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/location_service.dart';
import 'package:weather_app/screens/weather_screen.dart';

class AddLocationScreen extends StatefulWidget {
  static const routeName = '/add-location';
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final cityController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future<void> saveForm() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<MyLocations>(context, listen: false)
          .addLocation(cityController.text)
          .then((value) {});
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      cityController.text = '';
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(WeatherScreen.routeName);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<MyLocations>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 280,
                            //height: 80,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter City Name'),
                              controller: cityController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter city name.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  saveForm();
                                }
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('YOUR PLACES',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 300,
                        child: ListView.builder(
                            itemCount: Provider.of<MyLocations>(context)
                                .locations
                                .length,
                            itemBuilder: (context, index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      items.locations[index].city,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Spacer(),
                                    FlatButton.icon(
                                        onPressed: () =>
                                            Provider.of<MyLocations>(context,
                                                    listen: false)
                                                .updateDefaultLocation(items
                                                    .locations[index].city),
                                        icon: items.locations[index].isDefault
                                            ? Icon(Icons.star)
                                            : Icon(Icons.star_border),
                                        label: Text('')),
                                    FlatButton(
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () => Provider.of<MyLocations>(
                                              context,
                                              listen: false)
                                          .deleteLocation(
                                              items.locations[index].city),
                                      child: Text(
                                        'DELETE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )))
                  ],
                ),
              ),
            ),
    );
  }
}
