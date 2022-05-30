import 'package:flutter/material.dart';

class RCMTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final bool obscureText;

  const RCMTextfield({
    Key? key,
    this.controller,
    this.hintText = "",
    this.enabled = true,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        ),
      ),
    );
  }
}
