import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/model/departments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEmployeePage extends StatefulWidget {
  @override
  _CreateEmployeePageState createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  final FetchEmployees _employees = FetchEmployees();
  //drop down department data
  List<String> departmentList = <String>[];
  String selectedDepartment = '';
  String selectedDepartmentCode = '';
  String code ='';
  List<Departments> listDepartment = <Departments>[];
  List<Departments> newListDepartment = <Departments>[];

  List<String> departments = <String>[];
  // Map<String,String> dep = <String,String>[];

  // String? dropdownValue = ' ';

  //------
  TextEditingController empNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController address3 = TextEditingController();
  TextEditingController salary = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedBday = DateTime.now();
  bool _isActive = false;
  @override
  void initState(){
    super.initState(); // Call the superclass's initState method
    fetchDepartmentData();
  }


  Future<void> fetchDepartmentData() async{
    try{
      var result = await _employees.getDepartments();
        if(result.length > 0){
          for (var res in result){
            listDepartment.add(Departments(
              departmentCode: res.departmentCode,
              departmentName: res.departmentName,
              isActive: res.isActive,
            ));
            var resu = res.departmentName ?? "";
            departmentList.add(resu);
          }
        }
        setState(() {
          selectedDepartment = departmentList.first;
          departments = departmentList;
          newListDepartment = listDepartment;
          // dropdown = result;
        });

    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Employee',
          style: TextStyle(color: Colors.white),
        ), backgroundColor: Colors.pink[300],
      ),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: empNumber,
                    decoration: InputDecoration(labelText: 'Employee Id' ),
                  ),),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(labelText: 'Name' ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: address1,
                    decoration: InputDecoration(labelText: 'Address Line 1' ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: address2,
                    decoration: InputDecoration(labelText: 'Address Line 2' ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: address3,
                    decoration: InputDecoration(labelText: 'Address Line 3' ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,10.0),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<String>(
                    value: selectedDepartment,
                    // initialSelection: list.first,
                    onChanged: (String? value){
                      setState(() {
                        selectedDepartment = value!;
                        for(var res in newListDepartment){
                          if(selectedDepartment == res.departmentName){

                            var a = res.departmentCode ?? "";
                            selectedDepartmentCode =a;
                          }
                        }
                      });
                    },
                    items: departments.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem(value: value, child: Text(value),);
                    }).toList(),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,10.0),
                  child: Row(
                    children: [
                      Text(
                        'Date of Join:   ${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}',
                      ),
                      SizedBox(width: 20.0,),
                      ElevatedButton(
                          child: const Icon(Icons.calendar_month),
                          onPressed: () async {
                            final DateTime? dateTime = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1990), lastDate: DateTime.now(),);
                            if(dateTime != null){
                              setState(() {
                                selectedDate = dateTime;
                              });
                            }
                          },
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,10.0),
                  child: Row(
                    children: [
                      Text(
                        'Date of Birth:   ${selectedBday.year} - ${selectedBday.month} - ${selectedBday.day}',
                      ),
                      SizedBox(width: 20.0,),
                      ElevatedButton(
                        child: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(context: context, initialDate: selectedBday, firstDate: DateTime(1950), lastDate: DateTime.now(),);
                          if(dateTime != null){
                            setState(() {
                              selectedBday = dateTime;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextField(
                    controller: salary,
                    decoration: InputDecoration(labelText: 'Basic Salary' ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: SwitchListTile(
                    title: const Text('isActive: '),
                    value: _isActive,
                    onChanged: (bool value){
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0,5.0,20.0,20.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink[200],
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: createEmployee,
                    child: const Text('Create New Employee'),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Future<void> createEmployee() async{
    final id = empNumber.text;
    final eName = name.text;
    final add1 = address1.text;
    final add2 = address2.text;
    final add3 = address3.text;
    final joiningDate = selectedDate;
    final bday = selectedBday;
    final activeStatus = _isActive;
    final income = salary.text;
    final departmentCode = selectedDepartmentCode;
    final body = {
      "empNo": id,
      "empName": eName,
      "empAddressLine1": add1,
      "empAddressLine2": add2,
      "empAddressLine3": add3,
      "departmentCode": departmentCode,
      "dateOfJoin": joiningDate.toIso8601String(),
      "dateOfBirth": bday.toIso8601String(),
      "basicSalary": income,
      "isActive": activeStatus,
    };
    final baseUrl = 'http://examination.24x7retail.com';
    String apiToken = "?D(G+KbPeSgVkYp3s6v9y\$B&E)H@McQf";
    var url = Uri.parse('$baseUrl/api/v1.0/Employee$apiToken');
    final response = await http.post(url,body: jsonEncode(body),headers: {
      'apiToken': apiToken,
      'Content-Type':'application/json'
    },);
    if(response.statusCode == 200){
      print('Success');
      showSuccessMessage('Successfully created');
      Navigator.pop(context);
    }else{
      print(response.body);
      showFailedMessage('Please try again!');
    }
  }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
