import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/model/departments.dart';

class EditEmployeePage extends StatefulWidget {
  final String? text;
  const EditEmployeePage({super.key, @required this.text});
  @override
  _UpdateEmployeePageState createState() => _UpdateEmployeePageState();
}

class _UpdateEmployeePageState extends State<EditEmployeePage> {
  final FetchEmployees _employees = FetchEmployees();
  Employees? singleEmployee = Employees();

  //department data
  List<Departments> newListDepartment = <Departments>[];
  List<String> departments = <String>[];
  String selectedDepartment = '';
  String selectedDepartmentCode = '';




  TextEditingController empNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController address3 = TextEditingController();
  TextEditingController salary = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedBday = DateTime.now();
  bool _isActive = false;
  String? empNo = '';

  @override
  void initState(){
    super.initState();
    fetchSingleEmployeeDetails();
    fetchDepartmentData();
  }

  Future<void> fetchSingleEmployeeDetails() async{
    try{
      var result = await _employees.getSingleEmployee(widget.text);
      setState(() {
        singleEmployee = result;
        empNumber.text = singleEmployee?.empNo ?? '';
        name.text = singleEmployee?.empName ?? '';
        address1.text = singleEmployee?.empAddressLine1 ?? '';
        address2.text = singleEmployee?.empAddressLine2 ?? '';
        address3.text = singleEmployee?.empAddressLine3 ?? '';
        salary.text = singleEmployee!.basicSalary.toString();
        _isActive = singleEmployee?.isActive ?? false;
        selectedBday = singleEmployee?.dateOfBirth != null ? DateTime.parse(singleEmployee!.dateOfBirth!) : DateTime.now();
        selectedDate = singleEmployee?.dateOfJoin != null ? DateTime.parse(singleEmployee!.dateOfJoin!) : DateTime.now();
      });

    } catch (e) {
      print('Error fetching employee details');
    }
  }


  Future<void> fetchDepartmentData() async{
    try{
      var result = await _employees.getDepartments();
      // if(result.isNotEmpty){
      //   for (var res in result){
      //     listDepartment.add(Departments(
      //       departmentCode: res.departmentCode,
      //       departmentName: res.departmentName,
      //       isActive: res.isActive,
      //     ));
      //     var depName = res.departmentName ?? "";
      //     departmentList.add(depName);
      //   }
      // }
      setState(() {
        if(result.isNotEmpty){
          for (var res in result){
            newListDepartment.add(Departments(
              departmentCode: res.departmentCode,
              departmentName: res.departmentName,
              isActive: res.isActive,
            ));

            var depName = res.departmentName ?? "";
            departments.add(depName);
          }
        }
        selectedDepartment = departments.first;
      });

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Employee',
          style: TextStyle(color: Colors.white),
        ), backgroundColor: Colors.pink[300],
      ),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: empNumber,
                  decoration: InputDecoration(labelText: 'Employee Id'),
                ),),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: address1,
                  decoration: InputDecoration(labelText: 'Address Line 1'),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: address2,
                  decoration: InputDecoration(labelText: 'Address Line 2'),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: address3,
                  decoration: InputDecoration(labelText: 'Address Line 3'),
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
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                child: Row(
                  children: [
                    Text(
                      'Date of Join:   ${selectedDate.year} - ${selectedDate
                          .month} - ${selectedDate.day}',
                    ),
                    SizedBox(width: 20.0,),
                    ElevatedButton(
                      child: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),);
                        if (dateTime != null) {
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
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                child: Row(
                  children: [
                    Text(
                      'Date of Birth:   ${selectedBday.year} - ${selectedBday
                          .month} - ${selectedBday.day}',
                    ),
                    SizedBox(width: 20.0,),
                    ElevatedButton(
                      child: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: selectedBday,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),);
                        if (dateTime != null) {
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
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextField(
                  controller: salary,
                  decoration: InputDecoration(labelText: 'Basic Salary'),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: SwitchListTile(
                  title: const Text('isActive: '),
                  value: _isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink[200],
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: const Text('Update Employee Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
