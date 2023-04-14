import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/pages/admin/admin_menu_page.dart';
import 'package:recap_maps/src/pages/shop/shop_detail.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';
import 'package:recap_maps/src/widgets/textfield/rcm_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    if (email.text == "" || password.text == "") {
      log("message");
    } else if (password.text.length < 6) {
      log("message");
    } else {
      auth
          .signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((user) async {
        log("signed in ${user.user!.email}");
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore
            .collection("Shop")
            .doc(user.user!.uid)
            .get()
            .then((value) {
          ShopModel shop =
              ShopModel.fromJson(jsonDecode(jsonEncode(value.data())));
          if (shop.role == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminMenuPage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShopDetail(shop: shop, myUid: user.user!.uid),
              ),
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เข้าสู่ระบบ"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    "assets/logo.png",
                    width: 150,
                  ),
                  const SizedBox(height: 100),
                  RCMTextfield(
                    controller: email,
                    hintText: "Username",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  RCMTextfield(
                    controller: password,
                    obscureText: true,
                    hintText: "Password",
                  ),
                  const SizedBox(height: 20),
                  RCMButton(
                    title: "เข้าสู่ระบบ",
                    onTap: login,
                  ),
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
    );
  }
}
