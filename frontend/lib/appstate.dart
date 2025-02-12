import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    syncData();
  }

  final Map<String, Map<String, dynamic>> _seatData = {};

  DateTime lastUpdated = DateTime.now();

  void updateTimestamp(String response) {
    Map<String, dynamic> jsonData = json.decode(response);
    String timestamp = jsonData['timestamp'];
    DateTime localDateTime = DateTime.parse(timestamp).toLocal();
    lastUpdated = localDateTime;
    notifyListeners();
  }

  Future<void> syncData() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.21.66.22:3000/api/filled'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      List<dynamic> seatMapData = json.decode(response.body);

      for (final seatData in seatMapData) {
        initializeSeat(seatData["seatid"]);

        addSeat(seatData["seatid"], {
          'isOccupied': true,
          'seatNumber': seatData["seatid"],
          'seatColor': Color(int.parse("0xFF${seatData["teamcolour"]}")),
          'employeeID': seatData["employeeid"],
          'memberName': seatData["employeename"],
          'memberCompanyName': seatData["companyname"],
          'memberTeamName': seatData["teamname"],
        });
      }

    } catch (e) {
      print('Error connecting to server: $e');
      rethrow;
    } finally {
      print(_seatData);
      notifyListeners();
    }
  }

  Map<String, dynamic> defaultSeatData(String seatNumber) => {
    'isOccupied': false,
    'seatNumber': seatNumber,
    'seatColor': Colors.grey,
    'employeeID': '',
    'memberName': '',
    'memberCompanyName': '',
    'memberTeamName': '',
  };

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String? _previousSeatNumber;
  String? get previousSeatNumber => _previousSeatNumber;

  Map<String, Map<String, dynamic>> get seatData => _seatData;

  void addSeat(String seatNumber, Map<String, dynamic> newData) {
    _seatData[seatNumber]?.addAll(newData);
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setPreviousSeatIndex(String index) {
    _previousSeatNumber = index;
    notifyListeners();
  }

  void initializeSeat(String seatNumber) {
    if (!_seatData.containsKey(seatNumber)) {
      _seatData[seatNumber] = defaultSeatData(seatNumber);
    }
  }

  void updateSeat(String seatNumber, Map<String, dynamic> newData) {
    if (_seatData.containsKey(seatNumber)) {
      _seatData[seatNumber]?.addAll(newData);
      notifyListeners();
    }
  }

  Map<String, dynamic> getSeat(String seatNumber) {
    return _seatData[seatNumber] ?? defaultSeatData(seatNumber);
  }

  Future<String> addEmployee({
    required String employeeID,
    required String employeeName,
    required String companyName,
    required String teamColour,
    required String seatNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://172.21.66.22:3000/api/employees'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'employeeid': employeeID,
          'employeename': employeeName,
          'companyname': companyName,
          'teamcolour': teamColour,
          'seatid': seatNumber,
        }),
      );

      if (response.statusCode == 201) {
        updateTimestamp(response.body);
        return 'Employee added successfully';
      } else {
        print('Failed to add employee: ${response.body}');
        throw Exception('Failed to add employee: ${response.body}');
      }
    } catch (e) {
      print('Error connecting to server: $e');
      rethrow;
    }
  }

  Future<String> editEmployee({
    required String employeeID,
    required String employeeName,
    required String companyName,
    required String teamColour,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('http://172.21.66.22:3000/api/employees/$employeeID'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'employeename': employeeName,
          'companyname': companyName,
          'teamcolour': teamColour,
        }),
      );

      if (response.statusCode == 200) {
        updateTimestamp(response.body);
        return 'Employee edited successfully';
      } else {
        print('Failed to edit employee: ${response.body}');
        throw Exception('Failed to edit employee: ${response.body}');
      }
    } catch (e) {
      print('Error connecting to server: $e');
      rethrow;
    }
  }

  Future<String> deleteEmployee({
    required String employeeID
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('http://172.21.66.22:3000/api/employees/$employeeID'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        updateTimestamp(response.body);
        return 'Employee deleted successfully';
      } else {
        print('Failed to deleted employee: ${response.body}');
        throw Exception('Failed to deleted employee: ${response.body}');
      }
    } catch (e) {
      print('Error connecting to server: $e');
      rethrow;
    }
  }

}