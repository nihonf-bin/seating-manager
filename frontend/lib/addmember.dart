import 'package:flutter/material.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';

class AddMember extends StatefulWidget {
  const AddMember({
    super.key,
    this.seatData,
  });

  final Map<String, dynamic>? seatData;

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeIDController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _teamColorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isAdding = false;

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
            Form(
              key: _formKey,
              child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Add new member',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Seat Number: ', style: TextStyle(fontSize: 20)),
                        Text('${widget.seatData?['seatNumber']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter name',
                        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _employeeIDController,  
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter employee ID',
                        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter company name',
                        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _teamColorController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter team color',
                        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('Select Teams: ', style: TextStyle(fontSize: 20)),
                    //   ],
                         
                    // ),
                    // SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //      SizedBox(height: 10),
                    //     Container(
                    //       height: 40,
                    //       width: 40,
                    //       color: Colors.blue
                    //     )
                    //     ],
                    // ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:() async {
                          String memberName = _nameController.text;
                          String employeeID = _employeeIDController.text;
                          String companyName = _companyNameController.text;
                          String teamColor = _teamColorController.text;

                          if (_formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isAdding = true;
                              });
                              final result = await Provider.of<ApplicationState>(context, listen: false).addEmployee(
                                employeeID: employeeID,
                                employeeName: memberName,
                                companyName: companyName,
                                teamColour: teamColor,
                                seatNumber: widget.seatData?['seatNumber'],
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.toString()}')),
                              );
                            } finally {
                              setState(() {
                                isAdding = false;
                              });
                              _nameController.clear();
                              _employeeIDController.clear();
                              _companyNameController.clear();
                              _teamColorController.clear();
                            }
                          }
                        }, 
                        style: Styles.buttonStyle(context),
                        child: isAdding ? Styles.progressIndicator : Text('Add Member')
                      )
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
