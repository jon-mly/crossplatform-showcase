import 'package:employees_app/domain/exceptions/app_exceptions.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/repositories/employees_api/employees_repository.dart';

class EmployeesRepositoryMock implements EmployeesRepository {
  final List<Employee> _employees = [
    Employee(
      id: 1,
      employeeName: 'John Doe',
      employeeSalary: 100000,
      employeeAge: 30,
      profileImage: '',
    ),
    Employee(
      id: 2,
      employeeName: 'Jane Doe',
      employeeSalary: 110000,
      employeeAge: 32,
      profileImage: '',
    ),
    Employee(
      id: 3,
      employeeName: 'Jim Beam',
      employeeSalary: 120000,
      employeeAge: 34,
      profileImage: '',
    ),
  ];
  int _lastUserId = 3;

  @override
  Future<List<Employee>> getAllEmployees() async {
    await Future.delayed(const Duration(seconds: 3));
    return _employees;
  }

  @override
  Future<int> createEmployee(EmployeeEdit employeeEdit) async {
    await Future.delayed(const Duration(seconds: 3));
    _lastUserId += 1;
    final int id = _lastUserId;
    _employees.add(
      Employee(
        id: id,
        employeeName: employeeEdit.name,
        employeeSalary: employeeEdit.salary,
        employeeAge: employeeEdit.age,
        profileImage: '',
      ),
    );
    return id;
  }

  @override
  Future<void> updateEmployee(int id, EmployeeEdit employeeEdit) async {
    await Future.delayed(const Duration(seconds: 3));
    final index = _employees.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw NotFoundException('error.updateEmployee');
    }
    _employees[index] = _employees[index].copyWith(
      employeeName: employeeEdit.name,
      employeeSalary: employeeEdit.salary,
      employeeAge: employeeEdit.age,
    );
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await Future.delayed(const Duration(seconds: 3));
    final index = _employees.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw NotFoundException('error.deleteEmployee');
    }
    _employees.removeAt(index);
  }
}
