import 'package:flutter/material.dart';
import 'package:online_seating_chart/styles.dart';

class EditMember extends StatefulWidget {
  const EditMember({
    super.key, 
    this.seatData,
  });

  final Map<String, dynamic>? seatData;

  @override
  State<EditMember> createState() => _EditMemberState();
}

class _EditMemberState extends State<EditMember> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
            Text('Edit member',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name: ', style: TextStyle(fontSize: 20)),
                Text('${widget.seatData?['memberName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Company Name: ', style: TextStyle(fontSize: 20)),
                Text('${widget.seatData?['memberCompanyName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
                
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Teams: ', style: TextStyle(fontSize: 20)),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 18,
                    width: 18,
                    color: widget.seatData?['seatColor'],
                  ),
                  Text('${widget.seatData?['memberTeamName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              ],  
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Seat: ', style: TextStyle(fontSize: 20)),
                Text('${widget.seatData?['seatNumber']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                 ],   
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:() {},
                style: Styles.buttonStyle(context),
                child:Text('Edit Member')
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:() {}, 
                style: Styles.buttonStyle(context),
                child:Text('Remove Member')
              )
            )
          ],
        ),
      ),
    );
  }
}
