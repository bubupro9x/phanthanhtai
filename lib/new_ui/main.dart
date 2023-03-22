import 'dart:async';

import 'package:cipher/new_ui/start.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: generateMaterialColor(Palette.main))
            .copyWith(secondary: generateMaterialColor(Palette.accent)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const MTO3();
  }
}

class MTO3 extends StatefulWidget {
  const MTO3({Key? key}) : super(key: key);

  @override
  State<MTO3> createState() => _MTO3State();
}

class _MTO3State extends State<MTO3> {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );
  Stream<Position>? positionStream;

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 100,
            ),
            Text(
              "Khoảng cách của bạn đến căn cứ Alpha là:",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont('Roboto',
                  color: Palette.extra,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),

            StreamBuilder<Position>(
                stream: positionStream,
                builder: (_, data) => Text(
                      '${Geolocator.distanceBetween(data.data?.latitude ?? 0, data.data?.longitude ?? 108.253173, 15.980580434322402, 108.26863240959302).round()}m',
                      style: GoogleFonts.getFont('Roboto',
                          color: Colors.redAccent,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ))
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);
    positionStream!.listen((event) {
      setState(() {

      });
    });
    return await Geolocator.getCurrentPosition();
  }


  @override
  void dispose() {
    super.dispose();
  }
}
