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
  final _formKey = GlobalKey<FormState>();
  String selectedColor = '';

  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    final List<String> colorLabels = [
      '0000FF',
      '00FF00',
      '666600',
      'FF6600',
      '800080',
      'FF0000',
    ];

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
                    Row( // Or use a Row/Column if you don't need wrapping
                      spacing: 8.0, // Space between buttons
                      children: List.generate(colorLabels.length, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedColor = colorLabels[index];
                            });
                          }, 
                          style: IconButton.styleFrom(
                            backgroundColor: selectedColor == colorLabels[index] ? const Color.fromARGB(255, 199, 237, 255) : null,
                          ),
                          icon: Container(
                            width: 30.0, // width of the box
                            height: 30.0, // height of the box
                            color: Color(int.parse("0xFF${colorLabels[index]}")),// color of the box
                          ),
                        );
                      }),
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
                          String teamColor = selectedColor;

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
                              selectedColor = '';
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
