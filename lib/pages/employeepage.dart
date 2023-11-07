import 'package:flutter/material.dart';
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/services/service.dart';
import 'package:employeemanagement/pages/editEmployee.dart';
import 'package:employeemanagement/pages/createEmployeePage.dart';
import 'package:employeemanagement/model/employees.dart';


class EmployeePage extends StatefulWidget {
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  final FetchEmployees _employees = FetchEmployees();
  List<Employees> emp = <Employees> [];
  String searchKeyword = '';

  @override
  void initState(){
    super.initState();
    fetchEmployeeData();
  }

  Future<void> _refreshEmployees() async {
    try {
      var result = await _employees.getEmployees();
      setState(() {
        emp = result;
      });
    } catch (e) {
      print(e);
    }
  }

  // void filteration(String enterKeyword){
  //   List<Employees> results = [];
  //   if(enterKeyword.isEmpty){
  //     results = emp;
  //   }else{
  //     results = emp
  //         .where((employee) => employee.empName!.toLowerCase().contains(enterKeyword.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     emp = results;
  //   });
  // }

  Future<void> fetchEmployeeData() async{
    try{
      print('hello');
      var result = await _employees.getEmployees();
      print(result);
      setState(() {
        emp = result;
        print(emp);
      });

    } catch (e) {
      print(e);
    }
  }

  void filterEmployees(String searchKeyword) {
    // Filter the employees based on the search keyword and update the list.
    List<Employees> filteredEmployees = emp
        .where((employee) =>
        employee.empName!.toLowerCase().contains(searchKeyword.toLowerCase()))
        .toList();

    setState(() {
      emp = filteredEmployees;
    });
  }


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
      body: RefreshIndicator(
        onRefresh: _refreshEmployees,
        // child: FutureBuilder<List<Employees>>(
        //   future: _employees.getEmployees(),
        //   builder: (context, snapshot){
        //     var data = snapshot.data;
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      filterEmployees(value);
                    },
                    style: TextStyle(height: 1.0,),
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
                      itemCount: emp?.length,
                      itemBuilder: (context,index) {
                        if (searchKeyword.isEmpty || emp[index].empName!.toLowerCase().contains(searchKeyword.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              child: ListTile(
                                title: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text('${emp?[index].empName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),),
                                          Text('${emp?[index].empNo}'),
                                        ],
                                      )
                                    ]
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print((emp?[index].empNo).toString());
                                        String res = (emp?[index].empNo)
                                            .toString();
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
                                              builder: (context) =>
                                                  EditEmployeePage(
                                                      text: emp?[index].empNo),
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
                      }else{
                          return SizedBox.shrink();
                        }
                      }),
                ),
              ],
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
}
