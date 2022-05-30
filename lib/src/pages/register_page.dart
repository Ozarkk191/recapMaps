import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/pages/shop/shop_detail.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';
import 'package:recap_maps/src/widgets/textfield/rcm_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Position position;
  const RegisterPage({Key? key, required this.position}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController shopOwner = TextEditingController();
  TextEditingController shopPhone = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController open = TextEditingController();
  TextEditingController close = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    latitude.text = widget.position.latitude.toString();
    longitude.text = widget.position.longitude.toString();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    shopName.dispose();
    shopOwner.dispose();
    shopPhone.dispose();
    latitude.dispose();
    longitude.dispose();
    open.dispose();
    close.dispose();
    super.dispose();
  }

  void check() {
    setState(() {
      loading = true;
    });
    if (email.text == "" ||
        password.text == "" ||
        shopName.text == "" ||
        shopOwner.text == "" ||
        shopPhone.text == "" ||
        open.text == "" ||
        close.text == "") {
      // to do somthing
    } else if (password.text.length < 6) {
      // to do somthing
    } else {
      register();
    }
  }

  void register() {
    auth
        .createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    )
        .then((user) {
      ShopModel shop = ShopModel(
        email: email.text,
        close: close.text,
        open: open.text,
        shopName: shopName.text,
        shopOwner: shopOwner.text,
        shopPhone: shopPhone.text,
        latitude: widget.position.latitude,
        longitude: widget.position.longitude,
        uid: user.user!.uid,
        role: "Shop",
      );
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection("Shop")
          .doc(user.user!.uid)
          .set(shop.toJson())
          .then((value) {
        const snackBar = SnackBar(
          content: Text('สมัครเป็นร้านเป็นร้านปะยางเรียบร้อย'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetail(shop: shop, myUid: user.user!.uid),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text("LOGO"),
                    const SizedBox(height: 50),
                    RCMTextfield(
                      controller: email,
                      hintText: "Email",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: password,
                      obscureText: true,
                      hintText: "Password",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: shopName,
                      hintText: "ชื่อร้าน",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: shopOwner,
                      hintText: "ชื่อเจ้าของร้าน",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: shopPhone,
                      hintText: "เบอร์โทรร้าน",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: open,
                      hintText: "เวลาเปิด",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: close,
                      hintText: "เวลาปิด",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: latitude,
                      hintText: "ละติจูด",
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: longitude,
                      hintText: "ลองจิจูด",
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    RCMButton(
                      title: "สมัคร",
                      onTap: check,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: loading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
