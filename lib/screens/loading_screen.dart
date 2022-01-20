import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

const apiKey = 'e0ee8e8da7561910f16cc6b2bc43d0cc';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double? lat;
  double? lon;
  NetworkHelper? networkHelper;
  @override
  void initState() {
    super.initState();
    getLocationData();
    print('This line is triggered');
  }

  void getLocationData() async {
    if (await Permission.location.isGranted) {
      Location location = Location();
      await location.getCurrentLocation();
      lat = location.lati;
      lon = location.longi;
      networkHelper = NetworkHelper(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');

      var weatherData = await networkHelper!.getData();

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(
          locationWeather: weatherData,
        );
      }));
    } else {
// You can request multiple permissions at once.
      /*Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      */
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.cyanAccent,
          size: 100,
        ),
      ),
    );
  }
}
