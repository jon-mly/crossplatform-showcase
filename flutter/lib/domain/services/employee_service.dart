import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/repositories/employees_api/employees_repository.dart';
import 'package:employees_app/domain/repositories/employees_persistence/employees_persistence_repository.dart';

// Orchestration between API interactions and local persistence is done in the
// presentation layer's related provider, as its purpose is already to
// maintain state while a service in doman layer should not.

class EmployeeService {
  final EmployeesRepository _repository;
  final EmployeesPersistenceRepository _persistenceRepository;

  EmployeeService(this._repository, this._persistenceRepository);

  Future<List<Employee>> fetchEmployees() async {
    return await _repository.getAllEmployees();
  }

  Future<int> createEmployee(EmployeeEdit employeeEdit) async {
    final int newIndex = await _repository.createEmployee(employeeEdit);
    return newIndex;
  }

  Future<void> updateEmployee(int id, EmployeeEdit employeeEdit) async {
    await _repository.updateEmployee(id, employeeEdit);
  }

  Future<void> deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
  }

  Future<List<Employee>> getPersistedEmployees() async {
    return _persistenceRepository.getAllEmployees();
  }

  Future<void> persistEmployees(List<Employee> employees) async {
    await _persistenceRepository.saveEmployees(employees);
  }
}
