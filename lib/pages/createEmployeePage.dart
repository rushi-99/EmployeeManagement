import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/model/departments.dart';
import 'package:flutter/services.dart';

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
    super.initState();
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
          selectedDepartmentCode = listDepartment?.first.departmentCode??'';
          departments = departmentList;
          newListDepartment = listDepartment;
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
    if(empNumber.text.isNotEmpty && name.text.isNotEmpty && address1.text.isNotEmpty && selectedDepartmentCode.isNotEmpty && salary.text.isNotEmpty)
    {
      final body = {
        "empNo": empNumber.text,
        "empName": name.text,
        "empAddressLine1": address1.text,
        "empAddressLine2": address2.text,
        "empAddressLine3": address3.text,
        "departmentCode": selectedDepartmentCode,
        "dateOfJoin": selectedDate.toIso8601String(),
        "dateOfBirth": selectedBday.toIso8601String(),
        "basicSalary": salary.text,
        "isActive": _isActive,
      };
      try{
        var result = await _employees.createNewEmployee(body);

        if(result == 'Successful'){
          showSuccessMessage('Successfully created!');
          Navigator.pop(context);
        }else{
          showFailedMessage(result);
        }
      }catch(e){
        print(e);
      }
    }else{
      showFailedMessage("All Fields required");


    }
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message){
    final snackBar = SnackBar(content: Text('$message.Please try Again! '),
      backgroundColor: Colors.red[900],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
