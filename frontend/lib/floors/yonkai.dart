import 'package:flutter/material.dart';
import 'package:online_seating_chart/addmember.dart';
import 'package:online_seating_chart/editmember.dart';
import 'package:online_seating_chart/seatmap.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Yonkai extends StatefulWidget {
  const Yonkai({super.key});

  @override
  State<Yonkai> createState() => _YonkaiState();
}

class _YonkaiState extends State<Yonkai> {
  final TextEditingController searchController = TextEditingController();
  bool vacantToggle = false;
  bool occupiedToggle = false;
  Map<String, dynamic> selectedMemberData = {};

  Map<String, dynamic> onSeatClicked(Map<String, dynamic> memberData) {
    selectedMemberData = memberData;
    setState(() {
      if (selectedMemberData['isOccupied'] == false) {
        vacantToggle = !vacantToggle;
      } else {
        occupiedToggle = !occupiedToggle;
      }
    });
    return selectedMemberData;
  }

  Future<void> fetchMemberData(String memberId) async {
    var url = Uri.parse('http://localhost:3000/api/employeedb/$memberId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        selectedMemberData = jsonDecode(response.body);
        occupiedToggle = true;
        vacantToggle = false;
      });
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Employee not found. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final int totalSeats = 173; // Variable to store the total number of seats
    final int vacantSeats = 1; // Variable to store the number of vacant seats
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
              child: AddMember(),
            ),
            Visibility(
              visible: occupiedToggle,
              child: EditMember(seatData: selectedMemberData),
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
                  padding: const EdgeInsets.all(18.0), // Add padding parameter
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
                      Text("Last updated 4:59 PM, 2/5/2025", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text('Search member',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter employee ID',
                          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String memberId = searchController.text;
                            fetchMemberData(memberId);
                          },
                          style: Styles.buttonStyle(context),
                          child: Text('Search'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  vacantToggle = !vacantToggle;
                  occupiedToggle = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    vacantToggle ? Colors.lightBlueAccent : Styles.primaryColor),
              ),
              child: Text(
                'Vacant seat click',
                style: TextStyle(color: Styles.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  occupiedToggle = !occupiedToggle;
                  vacantToggle = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    occupiedToggle ? Colors.lightBlueAccent : Styles.primaryColor),
              ),
              child: Text(
                'Occupied seat click',
                style: TextStyle(color: Styles.white),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(20.0),
          height: 180,
          width: screenWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Add padding parameter
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
        ),
      ],
    );
  }
}