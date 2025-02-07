import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_seating_chart/addmember.dart';
import 'package:online_seating_chart/appbar.dart';
import 'package:online_seating_chart/editmember.dart';
import 'package:online_seating_chart/styles.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool toggle = false;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final double sw = Styles.screenWidth(context);
    final int totalSeats = 173; // Variable to store the total number of seats
    final int vacantSeats = 1; // Variable to store the number of vacant seats
    final int teams = 6; // Variable to store the number of teams

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppbar(title: 'Online Seating Chart', actions: [
          Row(
            children: [
              Text(
                '4階 - テクノプロジェクト',
                style: GoogleFonts.inter().copyWith(
                  fontSize: Styles.responsiveSize(sw * 0.014, 16, 24),
                ),
              ),
              SizedBox(width: sw * 0.015),
            ],
          )
        ]),
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              // Container with Status information
              Visibility(
                visible: toggle,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    height: 450,
                    width: 380,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total seats: ', style: TextStyle(fontSize: 14)),
                              Text('$totalSeats',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Vacant seats: ', style: TextStyle(fontSize: 14)),
                              Text('$vacantSeats',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Teams: ', style: TextStyle(fontSize: 14)),
                              Text('$teams',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('Search by seat',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Enter seat number: ', style: TextStyle(fontSize: 14)),
                          Row(
                            children: [
                              ElevatedButton(onPressed: () {}, child: Text('Search'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !toggle,
                child: AddMember())
            ],
          ),
          ElevatedButton(onPressed: () {
            setState(() {
              toggle = !toggle;
            });
          }, child: Text('Add Member')),
          Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  height: 180,
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
                ),
              ),
        ],
      ),
    );
  }
}
