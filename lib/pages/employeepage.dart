import 'package:flutter/material.dart';
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/model/departments.dart';
import 'package:employeemanagement/pages/editEmployee.dart';
import 'package:employeemanagement/pages/createEmployeePage.dart';


class EmployeePage extends StatefulWidget {
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  FetchEmployees _employees = FetchEmployees();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Employee System',style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.pink[300],
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateEmployeePage()));
                },
              )
            ],
          ),
          body: Container(
            child: FutureBuilder<List<Employees>>(
              future: _employees.getEmployees(),
              builder: (context, snapshot){
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context,index)
                    {
                      if(!snapshot.hasData){
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${data?[index].empName}'),
                                    Text('${data?[index].empNo}'),
                                  ],
                                )
                              ]
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      print((data?[index].empNo).toString());
                                      String res = (data?[index].empNo).toString();
                                      deleteEmp(res);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red[400],
                                    tooltip: 'Delete Employee',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=> EditEmployeePage(
                                          )));
                                    },
                                    icon: const Icon(Icons.edit),
                                    color: Colors.blue[400],
                                    tooltip: 'Edit Employee',
                                  ),
                                ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
        ),
    );
  }

  deleteEmp(String res) async{
    try{
      var result = await _employees.deleteEmployeeById(res);
      if(result == 'Success'){
        showSuccessMessage('Employee Deleted Successfully!');
      }else if(result == 'Failed'){
        ShowFailedMessage("Please Try again!");

      }
    }catch(e){
      print(e);
    }
  }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void ShowFailedMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Widget getCard(){
  //
  // }
}
