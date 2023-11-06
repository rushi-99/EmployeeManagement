class Employees {
  String? status;
  String? statusDescription;
  String? empNo;
  String? empName;
  String? empAddressLine1;
  String? empAddressLine2;
  String? empAddressLine3;
  String? departmentCode;
  String? dateOfJoin;
  String? dateOfBirth;
  int? basicSalary;
  bool? isActive;

  Employees(
      { this.status,
        this.statusDescription,
        this.empNo,
        this.empName,
        this.empAddressLine1,
        this.empAddressLine2,
        this.empAddressLine3,
        this.departmentCode,
        this.dateOfJoin,
        this.dateOfBirth,
        this.basicSalary,
        this.isActive});

  Employees.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusDescription = json['statusDescription'];
    empNo = json['empNo'];
    empName = json['empName'];
    empAddressLine1 = json['empAddressLine1'];
    empAddressLine2 = json['empAddressLine2'];
    empAddressLine3 = json['empAddressLine3'];
    departmentCode = json['departmentCode'];
    dateOfJoin = json['dateOfJoin'];
    dateOfBirth = json['dateOfBirth'];
    basicSalary = json['basicSalary'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusDescription'] = this.statusDescription;
    data['empNo'] = this.empNo;
    data['empName'] = this.empName;
    data['empAddressLine1'] = this.empAddressLine1;
    data['empAddressLine2'] = this.empAddressLine2;
    data['empAddressLine3'] = this.empAddressLine3;
    data['departmentCode'] = this.departmentCode;
    data['dateOfJoin'] = this.dateOfJoin;
    data['dateOfBirth'] = this.dateOfBirth;
    data['basicSalary'] = this.basicSalary;
    data['isActive'] = this.isActive;
    return data;
  }
}
