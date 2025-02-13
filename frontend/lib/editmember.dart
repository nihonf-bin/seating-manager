import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _teamColorController = TextEditingController();
  String selectedColor = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.seatData?['memberName'];
    _companyNameController.text = widget.seatData?['memberCompanyName'];
  }

  bool isEditPage = false;
  bool isEditing = false;
  bool isRemoving = false;

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    DateTime lastUpdated = DateTime.parse(widget.seatData?['timestamp']).toLocal();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Text('Edit member',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Seat Number: ', style: TextStyle(fontSize: 20)),
                        Text('${widget.seatData?['seatNumber']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                    ),
                    Visibility(
                      visible: !isEditPage,
                      child: Column(
                        children: [
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
                              Text('Company: ', style: TextStyle(fontSize: 20)),
                              Text('${widget.seatData?['memberCompanyName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                              
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Team: ', style: TextStyle(fontSize: 20)),
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
                              Text('Last Updated: ', style: TextStyle(fontSize: 20)),
                              Text(DateFormat('yyyy-MM-dd  HH:mm').format(lastUpdated),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isEditPage,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
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
                      ],
                    ),
                  )
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isEditPage) {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isEditing = true;
                            });
                            final result = await Provider.of<ApplicationState>(context, listen: false).editEmployee(
                              employeeID: widget.seatData!['employeeID'].toString(),
                              employeeName: _nameController.text,
                              companyName: _companyNameController.text,
                              teamColour: selectedColor, 
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
                              isEditing = false;
                            });
                            _nameController.clear();
                            _companyNameController.clear();
                            selectedColor = '';
                          }
                        }
                      } else {
                        setState(() {
                          isEditPage = true;
                        });
                      }
                    },
                    style: Styles.buttonStyle(context),
                    child: isEditing ? Styles.progressIndicator : Text(isEditPage ? 'Update' : 'Edit Member')
                  )
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: isEditPage,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            isRemoving = true;
                          });
                          final result = await Provider.of<ApplicationState>(context, listen: false).deleteEmployee(
                            employeeID: widget.seatData!['employeeID'].toString(),
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
                            isRemoving = false;
                          });
                          _nameController.clear();
                          _companyNameController.clear();
                          _teamColorController.clear();
                        }
                      }, 
                      style: Styles.buttonStyle(context).copyWith(backgroundColor: WidgetStateProperty.all(Colors.redAccent)),
                      child: isRemoving ? Styles.progressIndicator : Text('Remove Member')
                    )
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
