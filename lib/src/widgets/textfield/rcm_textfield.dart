import 'package:flutter/material.dart';

class RCMTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;

  const RCMTextfield({
    Key? key,
    this.controller,
    this.hintText = "",
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
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
        maxLength: maxLength,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          counterText: "",
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        ),
      ),
    );
  }
}
