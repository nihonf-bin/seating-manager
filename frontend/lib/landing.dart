import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_seating_chart/appbar.dart';
import 'package:online_seating_chart/styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double sw = Styles.screenWidth(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppbar(title: 'Online Seating Chart', actions: [
          Row(
            children: [
              Text('4階 - テクノプロジェクト', style: GoogleFonts.inter().copyWith(
                fontSize: Styles.responsiveSize(sw*0.014, 16, 24),
              )),
              SizedBox(width: sw*0.015)
            ],
          )
        ]),
      ),
      body: Center(
        child: Text('Landing Page'),
      ),
    );
  }
}