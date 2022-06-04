import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recap_maps/src/pages/login_page.dart';
import 'package:recap_maps/src/pages/maps_page.dart';
import 'package:recap_maps/src/pages/register_page.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';

class HomePage extends StatefulWidget {
  final Position position;
  const HomePage({Key? key, required this.position}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เมนูหลัก"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                child: Center(
                  child: Image.asset(
                    "assets/logo.png",
                    width: 150,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              RCMButton(
                title: "หาร้านปะยาง",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPage(position: widget.position),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              RCMButton(
                title: "สมัครเป็นร้านปะยาง",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage(position: widget.position),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              RCMButton(
                title: "LOGIN",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
