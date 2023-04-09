import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recap_maps/src/pages/home_page.dart';
import 'package:recap_maps/src/pages/maps_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: 250,
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    final position = GeolocatorPlatform.instance.getCurrentPosition();
    final data = await position;
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(position: data),
        ),
      );
    });
  }

  void checkPermission() async {
    await Permission.locationWhenInUse.serviceStatus;

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      Navigator.pop(context);
    } else if (status == PermissionStatus.permanentlyDenied) {
      Navigator.pop(context);
    }
    log(status.toString());
  }
}
