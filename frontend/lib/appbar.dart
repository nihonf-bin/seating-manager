import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_seating_chart/styles.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key, required this.title, required this.actions});
  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final double sw = Styles.screenWidth(context);

    return AppBar(
      title: Text(title, style: GoogleFonts.inter().copyWith(
        fontSize: Styles.responsiveSize(sw*0.014, 20, 24),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2
      )),
      backgroundColor: Styles.primaryColor,
      foregroundColor: Styles.white,
      actions: actions
    );
  }
}