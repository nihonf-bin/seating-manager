import 'package:flutter/material.dart';
import 'package:online_seating_chart/addmember.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/editmember.dart';
import 'package:online_seating_chart/seatmap.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Yonkai extends StatefulWidget {
  const Yonkai({super.key});

  @override
  State<Yonkai> createState() => _YonkaiState();
}

class _YonkaiState extends State<Yonkai> {
  bool vacantToggle = false;
  bool occupiedToggle = false;
  Map<String, dynamic> selectedMemberData = {};
  late ApplicationState appState;
  String? previousSeatNumber;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<ApplicationState>(context, listen: false);
    previousSeatNumber = appState.previousSeatNumber;
  }

  Map<String, dynamic> onSeatClicked(Map<String, dynamic> memberData) {
    selectedMemberData = memberData;
    
    setState(() {
      // Get the current seat number
      String currentSeatNumber = memberData['seatNumber'];
      
      // If clicking a different seat
      if (previousSeatNumber != currentSeatNumber) {
        // Reset toggles when selecting a new seat
        vacantToggle = false;
        occupiedToggle = false;
        
        // Show appropriate widget based on seat status
        if (memberData['isOccupied'] == false) {
          vacantToggle = true;
        } else {
          occupiedToggle = true;
        }
      } 
      // If clicking the same seat
      else {
        // Toggle the appropriate widget
        if (memberData['isOccupied'] == false) {
          vacantToggle = !vacantToggle;
        } else {
          occupiedToggle = !occupiedToggle;
        }
      }
      
      // Update previousSeatNumber
      previousSeatNumber = currentSeatNumber;
    });
    
    return selectedMemberData;
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<ApplicationState>(context, listen: false);
    DateTime lastUpdated = appState.lastUpdated;
    double screenWidth = MediaQuery.of(context).size.width;

    final int totalSeats = 157; // Variable to store the total number of seats
    final int vacantSeats = totalSeats - appState.seatData.length; // Variable to store the number of vacant seats
    final int teams = 6; // Variable to store the number of teams

    return Column(
      children: [
        SizedBox(height: screenWidth * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Seatmap(floor: 4, selectedMemberData: onSeatClicked)),
            Visibility(
              visible: vacantToggle,
              child: AddMember(seatData: selectedMemberData)
              ),
            Visibility(
              visible: occupiedToggle,
              child: EditMember(seatData: selectedMemberData)
              ),
            Visibility(
              visible: vacantToggle == occupiedToggle,
              child: Container(
                margin: EdgeInsets.all(20.0),
                height: 450,
                width: 380,
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  color: Styles.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total seats: ', style: TextStyle(fontSize: 20)),
                          Text('$totalSeats',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Vacant seats:', style: TextStyle(fontSize: 20)),
                          Text('$vacantSeats',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Teams:', style: TextStyle(fontSize: 20)),
                          Text('$teams',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text("Last updated: ${lastUpdated.hour}:${lastUpdated.minute}, ${DateFormat('MMMM').format(lastUpdated)} ${lastUpdated.day}, ${lastUpdated.year}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text('Search member',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter employee ID',
                          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
                        ),
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            
                          }, 
                          style: Styles.buttonStyle(context),
                          child: Text('Search')),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.all(20.0),
          height: 100,
          width: screenWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teams',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 10.0, // width of the box
                      height: 10.0, // height of the box
                      color: Colors.blue, // color of the box
                    ),
                      Text('Team A',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text('0', style: TextStyle(fontSize: 14)),
                        Icon(Icons.person, size: 16, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )  
      ],
    );
  }
}