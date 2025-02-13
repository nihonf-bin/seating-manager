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
  double seatSide = 40;

  @override
  void initState() {
    super.initState();
    seatNumber = "${widget.floor}F${widget.cardinals}${widget.alpha}${widget.numeric}";
  }

  Future<void> _showConfirmationDialog(BuildContext context, Map<String, dynamic> draggedSeatData, ApplicationState appState) async {
    try {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Seat Change'),
            content: Text('Do you want to move ${draggedSeatData["memberName"]} to seat $seatNumber?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        try {
          // Convert Color to hex string (removing alpha channel and # symbol)
          final color = draggedSeatData["seatColor"] as Color;
          final String colorHex = color.value.toRadixString(16).substring(2); // Remove alpha channel
          
          // await appState.editEmployee(
          //   employeeID: draggedSeatData["employeeID"].toString(),
          //   employeeName: draggedSeatData["memberName"] ?? '',
          //   companyName: draggedSeatData["memberCompanyName"] ?? '',
          //   teamColour: colorHex.toUpperCase(),  // Send hex color string
          //   seatNumber: seatNumber
          // );
          print('success');
        } catch (e) {
          print('error $e');
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to update seat assignment. Please try again.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } catch (e) {
      print('Error in _showConfirmationDialog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        final currentSeatData = appState.getSeat(seatNumber);
        Color currentColor = currentSeatData['seatColor'] ?? Colors.grey;
        bool isOccupied = currentSeatData["isOccupied"] == true;

        return DragTarget<Map<String, dynamic>>(
          onWillAcceptWithDetails: (data) {
            // Only accept if the target seat is vacant
            return currentSeatData["isOccupied"] == false;
          },
          onAcceptWithDetails: (details) {
            // Show confirmation dialog when dropped on a valid target
            _showConfirmationDialog(context, details.data, appState);
            widget.selectedMemberData(currentSeatData);
          },
          builder: (context, candidateData, rejectedData) {
            // Only make the seat draggable if it's occupied
            if (!isOccupied) {
              return _buildSeatWidget(currentSeatData, currentColor);
            }

            return Draggable<Map<String, dynamic>>(
              data: {
                ...currentSeatData,
                "seatNumber": seatNumber,
              },
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: widget.isWindow ? 60 : 38,
                  height: 38,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: currentColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      currentSeatData["memberName"], 
                      style: TextStyle(fontSize: 10, color: Colors.white)
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: widget.isWindow ? 60 : 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: _buildSeatWidget(currentSeatData, currentColor),
            );
          },
        );
      },
    );
  }

  Widget _buildSeatWidget(Map<String, dynamic> seatData, Color color) {
    return TextButton(
      onPressed: () {
        widget.selectedMemberData(seatData);
        setState(() {
          seatSide = 40;
        });
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
            width: widget.isWindow ? 60 : seatSide,
            height: seatSide,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                seatData["memberName"], 
                style: TextStyle(fontSize: 10, color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
