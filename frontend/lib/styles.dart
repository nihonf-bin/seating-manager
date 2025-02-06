import 'package:flutter/material.dart';

class Styles {
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF002E3F);

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double responsiveSize(double size, double min, double max) => size > max ? max : size < min ? min : size;
}