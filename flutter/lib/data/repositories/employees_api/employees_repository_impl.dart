import 'package:employees_app/domain/exceptions/app_exceptions.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/repositories/employees_api/employees_repository.dart';
import 'package:dio/dio.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  EmployeesRepositoryImpl(this._dioClient);

  final Dio _dioClient;

  @override
  Future<List<Employee>> getAllEmployees() async {
    try {
      final Response response = await _dioClient.get('/employees');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // static check failing to recognize a List<Employee> when using .map
        final List<Employee> employees = [];
        for (final item in response.data['data']) {
          employees.add(Employee.fromJson(item));
        }
        return employees;
      } else {
        throw ServerException('error.fetchEmployees');
      }
    } on DioException {
      throw NetworkException('error.fetchEmployees');
    }
  }

  @override
  Future<int> createEmployee(EmployeeEdit employeeEdit) async {
    try {
      final Response response = await _dioClient.post(
        '/create',
        data: employeeEdit.toJson(),
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']['id'];
      } else {
        throw ServerException('error.createEmployee');
      }
    } on DioException {
      throw NetworkException('error.createEmployee');
    }
  }

  @override
  Future<void> updateEmployee(int id, EmployeeEdit employeeEdit) async {
    try {
      final Response response = await _dioClient.put(
        '/update/$id',
        data: employeeEdit.toJson(),
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return;
      } else {
        throw ServerException('error.updateEmployee');
      }
    } on DioException {
      throw NetworkException('error.updateEmployee');
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    try {
      final Response response = await _dioClient.delete('/delete/$id');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return;
      } else {
        throw ServerException('error.deleteEmployee');
      }
    } on DioException {
      throw NetworkException('error.deleteEmployee');
    }
  }
}
