import 'package:flutter/material.dart';

class Styles {
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF002E3F);
  static const Color primaryLightColor = Color.fromARGB(255, 0, 99, 135);
  static const Color backgroundColor = Color(0xFFEDEDED);

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double responsiveSize(double size, double min, double max) => size > max ? max : size < min ? min : size;

  static ButtonStyle buttonStyle(BuildContext context) => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(primaryColor),
    foregroundColor: WidgetStateProperty.all(white),
    textStyle: WidgetStateProperty.all(TextStyle(fontSize: responsiveSize(screenWidth(context) * 0.002, 24, 32))),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: screenWidth(context) * 0.012)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  );

  static Widget progressIndicator = Center(
    child: SizedBox(
      height: 28,
      width: 28,
      child: CircularProgressIndicator(
        color: white,
        strokeWidth: 2.5,
      )
    )
  );
}