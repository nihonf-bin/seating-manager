import 'package:flutter/material.dart';

class EditMember extends StatelessWidget {
  const EditMember({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;

    return Align(
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
                    Text('Edit member',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name: ', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Company Name: ', style: TextStyle(fontSize: 14)),
                        ],
                        
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Teams: ', style: TextStyle(fontSize: 14)),
                         
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Team D', style: TextStyle(fontSize: 14)),
                          Container(
                            height: 40,
                            width: 40,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      ],  
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Seat: ', style: TextStyle(fontSize: 14)),
                         ],   
                    ),
                    ElevatedButton(onPressed:(){}, child:Text('Edit Member')),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed:(){}, child:Text('Remove Member'))
                  ],
                ),
              ),
            ),
          );
  }
}
