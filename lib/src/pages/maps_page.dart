import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/pages/shop/shop_detail.dart';

class MapsPage extends StatefulWidget {
  final Position position;
  const MapsPage({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Completer<GoogleMapController> controller = Completer();
  Set<Marker> markers = {};

  void addMarker() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("Shop")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        log(doc.data().toString());
        ShopModel shop = ShopModel.fromJson(jsonDecode(jsonEncode(doc.data())));
        if (shop.role == "Shop") {
          if (shop.approve!) {
            markers.add(
              Marker(
                markerId: MarkerId(shop.uid!),
                position: LatLng(shop.latitude!, shop.longitude!),
                infoWindow: InfoWindow(
                  title: shop.shopName!,
                  snippet: shop.shopPhone!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetail(
                          shop: shop,
                        ),
                      ),
                    );
                  },
                ),
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    addMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ค้นหาร้านปะยาง"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.position.latitude,
              widget.position.longitude,
            ),
            zoom: 12,
          ),
          markers: markers,
        ),
      ),
    );
  }
}
