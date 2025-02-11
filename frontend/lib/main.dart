import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/landing.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      name: 'landing',
      path: '/',
      builder: (context, state) => const LandingPage(),
      routes: [

      ],
    ),
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: GoogleFonts.interTextTheme(),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      title: 'Online Seating Chart',
      routerConfig: _router,
    );
  }
}