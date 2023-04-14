import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/pages/shop/shop_detail.dart';

import '../model/distance_model.dart';

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
  List<DistanceModel> distanceList = [];
  ExpansionStatus expansionStatus = ExpansionStatus.contracted;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  bool isExpand = false;

// ฟังช์ชันปักหมุดบนแผนที่
  void addMarker() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("Shop")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        ShopModel shop = ShopModel.fromJson(jsonDecode(jsonEncode(doc.data())));
        if (shop.role == "Shop") {
          if (shop.approve!) {
            final distace = calculateDistance(
              widget.position.latitude,
              widget.position.longitude,
              shop.latitude!,
              shop.longitude!,
            );
            DistanceModel data = DistanceModel(
              shopName: shop.shopName ?? "ไม่มี",
              distance: distace,
              phone: shop.shopPhone ?? "ไม่มี",
            );

            distanceList.add(data);
            markers.add(
              Marker(
                markerId: MarkerId(shop.uid!),
                position: LatLng(shop.latitude!, shop.longitude!),
                infoWindow: InfoWindow(
                  title: shop.shopName ?? "ไม่มี",
                  snippet: shop.shopPhone ?? "ไม่มี",
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
      distanceList.sort((a, b) => a.distance!.compareTo(b.distance!));
      setState(() {});
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
        child: ExpandableBottomSheet(
          key: key,
          onIsContractedCallback: () => setState(() => isExpand = false),
          onIsExtendedCallback: () => setState(() => isExpand = true),
          background: GoogleMap(
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
          persistentHeader: InkWell(
            onTap: () {
              if (isExpand) {
                key.currentState!.contract();
                isExpand = false;
              } else {
                key.currentState!.expand();
                isExpand = true;
              }
              setState(() {});
            },
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ทั้งหมด ${distanceList.length} ร้าน'),
                        Row(
                          children: [
                            const Text('ระยะทาง (กิโลเมตร)'),
                            Icon(
                              !isExpand
                                  ? Icons.arrow_drop_up_sharp
                                  : Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.01),
                ),
              ],
            ),
          ),
          expandableContent: Container(
            width: MediaQuery.of(context).size.width,
            height: 500,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
              itemCount: distanceList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "ชื่อร้าน ${distanceList[index].shopName}"),
                                Text("เบอร์โทร ${distanceList[index].phone}"),
                              ],
                            ),
                            Text(
                                " ${distanceList[index].distance!.toStringAsFixed(2)} km."),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
