import 'package:flutter/material.dart';
import 'package:online_seating_chart/appbar.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/floors/gokai.dart';
import 'package:online_seating_chart/floors/rokkai.dart';
import 'package:online_seating_chart/floors/yonkai.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Widget> floors = [
    Yonkai(),
    Gokai(),
    Rokkai()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppbar(title: 'Online Seating Chart'),
      ),
      backgroundColor: Styles.backgroundColor,
      body: SingleChildScrollView(
        child: Consumer<ApplicationState>(
          builder: (context, appState, child) {
            return floors[appState.currentIndex];
          },
        ),
      ),
    );
  }
}
