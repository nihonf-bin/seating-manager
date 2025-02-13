import 'package:flutter/material.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';

class Seatmap extends StatefulWidget {
  const Seatmap({
    super.key, 
    required this.floor,
    required this.selectedMemberData,
  });
  final int floor;
  final Map<String, dynamic> Function(Map<String, dynamic> memberData) selectedMemberData;

  @override
  State<Seatmap> createState() => _SeatmapState();
}

class _SeatmapState extends State<Seatmap> {
  //Color seatColor
  
  @override
  Widget build(BuildContext context) {

    Widget northSeatColumn(String alpha) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(alpha=='G'||alpha=='H' ? 2 : 5, (index) {
          return Column(
            children: [
              Seat(floor: widget.floor, cardinals: 'N', alpha: alpha, numeric: index+1, isWindow: false, selectedMemberData: widget.selectedMemberData),
              SizedBox(height: 3.0),
            ],
          );
        })
      );
    }

    Widget southSeatColumn(String alpha) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(alpha=='J'||alpha=='K' ? 4 : 5, (index) {
          return Column(
            children: [
              Seat(floor: widget.floor, cardinals: 'S', alpha: alpha, numeric: 5-index, isWindow: false, selectedMemberData: widget.selectedMemberData),
              SizedBox(height: 3.0),
            ],
          );
        })
      );
    }

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Row(
                children: [
                  Seat(floor: widget.floor, cardinals: 'N', alpha: 'X', numeric: index+1, isWindow: true, selectedMemberData: widget.selectedMemberData),
                  SizedBox(width: 50.0),
                ],
              );
            })
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(15, (i) { 
              return Row(
                children: [
                  northSeatColumn(String.fromCharCode('A'.codeUnitAt(0) + i)),
                  if (i % 2 == 1 && i < 14) 
                    const SizedBox(width: 20),
                ],
              );
            }),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(16, (i) { 
              return Row(
                children: [
                  southSeatColumn(String.fromCharCode('A'.codeUnitAt(0) + i)),
                  // Space after first column (A)
                  if (i == 0)
                    const SizedBox(width: 20),
                  // Space after every pair starting from C (index 2)
                  if (i > 1 && i < 15 && i % 2 == 0)
                    const SizedBox(width: 20),
                  
                ],
              );
            }),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Seat(floor: widget.floor, cardinals: 'S', alpha: 'Q', numeric: 1, isWindow: false, selectedMemberData: widget.selectedMemberData),
              Seat(floor: widget.floor, cardinals: 'S', alpha: 'R', numeric: 1, isWindow: false, selectedMemberData: widget.selectedMemberData),
              SizedBox(width: 80.0),
              Seat(floor: widget.floor, cardinals: 'S', alpha: 'X', numeric: 1, isWindow: true, selectedMemberData: widget.selectedMemberData),
              SizedBox(width: 50.0),
              Seat(floor: widget.floor, cardinals: 'S', alpha: 'X', numeric: 2, isWindow: true, selectedMemberData: widget.selectedMemberData),
              SizedBox(width: 50.0),
              Seat(floor: widget.floor, cardinals: 'S', alpha: 'X', numeric: 3, isWindow: true, selectedMemberData: widget.selectedMemberData),
            ],
          )
        ],
      ),
    );
  }
}

class Seat extends StatefulWidget {
  const Seat({
    super.key, 
    required this.floor, 
    required this.cardinals, 
    required this.alpha, 
    required this.numeric,
    required this.isWindow,
    required this.selectedMemberData,
  });
  final int floor;
  final String cardinals;
  final String alpha;
  final int numeric;
  final bool isWindow;
  final Map<String, dynamic> Function(Map<String, dynamic> memberData) selectedMemberData;
  

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  late String seatNumber;

  @override
  void initState() {
    super.initState();
    seatNumber = "${widget.floor}F${widget.cardinals}${widget.alpha}${widget.numeric}";
  }

  @override
  Widget build(BuildContext context) {
   return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        final currentSeatData = appState.getSeat(seatNumber);
        final currentColor = currentSeatData['seatColor'] ?? Colors.grey;

        return TextButton(
          onPressed: () {
            String? previousSeatNumber = appState.previousSeatNumber;
      
            if (previousSeatNumber != null && previousSeatNumber != seatNumber && currentSeatData["isOccupied"] == false) {
              appState.updateSeat(previousSeatNumber, {
                'seatColor': Colors.grey
              });
            }
      
            if (currentSeatData["isOccupied"] == false) {
              appState.updateSeat(seatNumber, {
                'seatColor': currentColor == Colors.grey ? Styles.primaryLightColor : currentColor == Styles.primaryLightColor ? Colors.grey : currentColor,
              });
            }
      
            appState.setPreviousSeatIndex(seatNumber);
      
            widget.selectedMemberData(currentSeatData);
          }, 
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(2.0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), 
            backgroundColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory, 
          ),
          child: Column(
            children: [
              Container(
                width: widget.isWindow ? 60 : 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: currentColor,
                  borderRadius: BorderRadius.circular(6), 
                ),
                child: Text(currentSeatData["memberName"], style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
              // Text(currentSeatData["memberName"], style: TextStyle(fontSize: 10)),
            ],
          )
        );
      }
     
   );
  }
}

