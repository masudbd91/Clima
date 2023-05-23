import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold();

  }
}




// body: SafeArea(
// child: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// ElevatedButton(
// onPressed: () {
// //display loader
// _getCurrentLocation().then((Position position) {
// // Handle the retrieved location
// print('Latitude: ${position.latitude}');
// print('Longitude: ${position.longitude}');
// }).catchError((e) {
// // Handle any errors that occur during the location retrieval process
// print(e);
// });
//
// },
// child: Text('Get Location'),
// ),
// ],
// ),
// ),
// ),
//