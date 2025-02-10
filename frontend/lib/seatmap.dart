import 'package:flutter/material.dart';

class Seatmap extends StatefulWidget {
  const Seatmap({super.key});

  @override
  State<Seatmap> createState() => _SeatmapState();
}

class _SeatmapState extends State<Seatmap> {
  
  @override
  Widget build(BuildContext context) {
    final Widget seat = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
    );

    //final Widget group

    return Center(
      child: Text('Seatmap'),
    );
  }
}

