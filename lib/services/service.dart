import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:employeemanagement/model/employees.dart';
import 'package:employeemanagement/model/departments.dart';

class FetchEmployees{
  var data = [];
  String baseUrl = "http://examination.24x7retail.com";
  String apiToken = "?D(G+KbPeSgVkYp3s6v9y\$B&E)H@McQf";

  Future<List<Employees>> getEmployees({String? query}) async{
    List<Employees> results = [];
    var url = Uri.parse('$baseUrl/api/v1.0/Employees$apiToken');
    try{
      final response = await http.get(url,headers: {
        'apiToken': apiToken,
      },);
      print(response);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        results = data.map((e) => Employees.fromJson(e)).toList();
        // if(query!= null){
        //   results = results.where((element) => element.empName!.toLowerCase().contains((query.toLowerCase()))).toList();
        // }
      }else{
        print('fetch error');
      }
    } catch (e){
      print('error: $e');
    }
    return results;
  }

  Future<List<Departments>> getDepartments({String? query}) async{
    List<Departments> results = [];
    var url = Uri.parse('$baseUrl/api/v1.0/Departments$apiToken');
    try{
      final response = await http.get(url,headers: {
        'apiToken': apiToken,
      },);
      print(response);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        results = data.map((e) => Departments.fromJson(e)).toList();
        // if(query!= null){
        //   results = results.where((element) => element.empName!.toLowerCase().contains((query.toLowerCase()))).toList();
        // }
      }else{
        print('fetch error');
      }
    } catch (e){
      print('error: $e');
    }
    return results;
  }

  Future<String> deleteEmployeeById(String empNo) async{
    var url = Uri.parse('$baseUrl/api/v1.0/Employee/$empNo$apiToken');
    try{
      final response = await http.delete(url,headers: {
        'apiToken': apiToken,
      },);
      print(response);
      if(response.statusCode == 200){
        return 'Success';
      }else{
        print('fetch error');
        return 'Failed';
      }
      return 'hello';
    } catch (e){
      print('error: $e');
      return 'Something Went wrong';
    }
  }

  Future<Employees?> getSingleEmployee(String? empNo) async{
    Employees? results;
    var url = Uri.parse('$baseUrl/api/v1.0/Employee/$empNo$apiToken');
    try{
      final response = await http.get(url,headers: {
        'apiToken': apiToken,
      },);
      print(response);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        results = Employees.fromJson(data);
        // if(query!= null){
        //   results = results.where((element) => element.empName!.toLowerCase().contains((query.toLowerCase()))).toList();
        // }
      }else{
        print('fetch error');
      }
    } catch (e){
      print('error: $e');
    }
    return results;
  }


  // Future<List<Employees>> CreateEmployees({String? query}) async{
  //   List<Employees> results = [];
  //   var url = Uri.parse('$baseUrl/api/v1.0/Employee$apiToken');
  //   try{
  //     final response = await http.post(url, body: body,headers: {
  //       'apiToken': apiToken,
  //     },);
  //     print(response);
  //     if(response.statusCode == 200){
  //       data = json.decode(response.body);
  //       results = data.map((e) => Departments.fromJson(e)).toList();
  //       // if(query!= null){
  //       //   results = results.where((element) => element.empName!.toLowerCase().contains((query.toLowerCase()))).toList();
  //       // }
  //     }else{
  //       print('fetch error');
  //     }
  //   } catch (e){
  //     print('error: $e');
  //   }
  //   return results;
  // }
}
