import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/repositories/employees_api/employees_repository.dart';
import 'package:dio/dio.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  EmployeesRepositoryImpl(this._dioClient);

  final Dio _dioClient;

  @override
  Future<List<Employee>> getAllEmployees() async {
    final Response response = await _dioClient.get('/employees');
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      // static check failing to recognize a List<Employee> when using .map
      final List<Employee> employees = [];
      for (final item in response.data['data']) {
        employees.add(Employee.fromJson(item));
      }
      return employees;
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  Future<int> createEmployee(EmployeeEdit employeeEdit) async {
    final Response response = await _dioClient.post(
      '/create',
      data: employeeEdit.toJson(),
    );
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      return response.data['data']['id'];
    } else {
      throw Exception('Failed to create employee');
    }
  }

  @override
  Future<void> updateEmployee(int id, EmployeeEdit employeeEdit) async {
    final Response response = await _dioClient.put(
      '/update/$id',
      data: employeeEdit.toJson(),
    );
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      return;
    } else {
      throw Exception(
        'Failed to update employee. Status code: ${response.statusCode}. Response: ${response.data.toString()}',
      );
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    final Response response = await _dioClient.delete('/delete/$id');
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      return;
    } else {
      throw Exception('Failed to delete employee');
    }
  }
}
