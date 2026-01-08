import 'package:employees_app/domain/models/employee/employee.dart';

abstract class EmployeesPersistenceRepository {
  Future<List<Employee>> getAllEmployees();
  Future<void> saveEmployees(List<Employee> employees);
  Future<void> saveEmployeeAt(int index);
}
