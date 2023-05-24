import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
final Geolocator geolocator = Geolocator();
  Future<Position> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, prompt the user to enable them
    return Future.error('Location services are disabled.');
  }

  // Request location permission
  permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    // Permission denied, show an error message or handle it gracefully
    return Future.error('Location permission is denied.');
  }

  if (permission == LocationPermission.deniedForever) {
    // The user has permanently denied location permission, take them to the app settings
    return Future.error(
        'Location permission is permanently denied. Please open app settings to enable location.');
  }

  // Location permission granted, retrieve the current position
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

class _LoadingScreenState extends State<LoadingScreen> {

    @override
  void initState() {

    super.initState();
    _getCurrentLocation().then((Position position) {
      // Handle the retrieved location
         print('Latitude: ${position.latitude}');
          print('Longitude: ${position.longitude}');
          }).catchError((e) {
          // Handle any errors that occur during the location retrieval process
        print(e);
   });

  }
    void getData() async {
     var url = Uri.parse('https://samples.openweathermap.org/data/2.5/forecast?id=524901&appid=b1b15e88fa797225412429c1c50c122a1');
     http.Response response = await http.get(url);
      if (response.statusCode == 200) {
      String data = response.body;
      var decodeData = jsonDecode(data);

      var tempereture = decodeData['list'][1]['main']['temp'];
      var condition = decodeData['list'][0]['weather'][0]['id'];
      var cityName = decodeData['city']['name'];
      print(tempereture);
      print(condition);
      print(cityName);

      // var longtitute = jsonDecode(data)['cod'];
      // print('Longitude: $longtitute');
      // var weatherDescription = jsonDecode(data)['list'][0]['weather'][0]['description'];
      // print(weatherDescription);
     } else {
     print('Request failed with status: ${response.statusCode}');
      }
    }

    @override
  Widget build(BuildContext context) {
      getData();
    return Scaffold();
  }
}

