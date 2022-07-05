import 'package:flutter/material.dart';

class RCMButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final double width;
  final double height;
  const RCMButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.width = 0,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width == 0 ? MediaQuery.of(context).size.width * 0.7 : width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
