import 'package:flutter/material.dart';
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/pages/editEmployee.dart';
import 'package:employeemanagement/pages/createEmployeePage.dart';


class EmployeePage extends StatefulWidget {
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _refreshing = false;
  final FetchEmployees _employees = FetchEmployees();

  // List<Employees> _filteredEmployed

  @override
  void initState(){
    super.initState();
    _refreshEmployees();
  }

  Future<void> _refreshEmployees() async {
    await _employees.getEmployees();
    setState(() {
      _refreshing = true;
    });

    await _employees.getEmployees();

    setState(() {
      _refreshing = false;
    });// You may need to update this to fetch the employees again.
  }

  // void updateList(String value){
  //   setState(() {
  //     display_list =
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee System',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>CreateEmployeePage())
              ).then((value){
                if(value == true){
                  _refreshEmployees();
                }
              });
              },
          )
        ],
      ),
      body:
      RefreshIndicator(
        onRefresh: _refreshEmployees,
          child: FutureBuilder<List<Employees>>(
            future: _employees.getEmployees(),
            builder: (context, snapshot){
              var data = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      style: TextStyle(height: 1.0,),
                      controller: _searchController,
                      decoration: InputDecoration(
                        fillColor: Colors.pink[50],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'search employees',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
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
                                            Text('${data?[index].empName}',
                                            style: TextStyle(fontWeight: FontWeight.bold),),
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context)=> EditEmployeePage(text : data?[index].empNo),
                                              ));
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
                            }),
                  ),
                ],
              );
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
