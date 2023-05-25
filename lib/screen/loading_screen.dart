import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const apiKey = '7baec9c3b474693710b481f18a1a0f98';


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
    late double latitude = 0.0;
    late double longitude = 0.0;

    @override
  void initState() {
    super.initState();
    getLocation();
  }
  void getLocation() async {
    await _getCurrentLocation().then((Position position) {
      // Handle the retrieved location
      //    print('Latitude: ${position.latitude}');
      //     print('Longitude: ${position.longitude}');
      latitude = position.latitude;
      longitude = position.longitude;
    }).catchError((e) {
      // Handle any errors that occur during the location retrieval process
      print(e);
    });

  }

    void getData() async {
     var url = Uri.parse('http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&appid=$apiKey');
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

     } else {
     print('Request failed with status: ${response.statusCode}');
      }
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

