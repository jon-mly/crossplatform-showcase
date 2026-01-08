import 'package:employees_app/core/local_db/local_db.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/repositories/employees_persistence/employees_persistence_repository.dart';
import 'package:sembast/sembast.dart';

class EmployeesPersistenceRepositoryImpl
    implements EmployeesPersistenceRepository {
  static const String _keyName = 'employees';

  final _store = StoreRef<String, Map<String, dynamic>>.main();

  Future<Database> get _db => LocalDatabase.instance.database;

  @override
  Future<List<Employee>> getAllEmployees() async {
    final Map<String, dynamic>? json = await _store
        .record(_keyName)
        .get(await _db);
    // Static analysis identifies the list as List<dynamic> when using .map.
    // for-loop is forced.
    final List<Employee> employees = [];
    for (final map in json?['employees'] ?? []) {
      employees.add(Employee.fromJson(map));
    }
    return employees;
  }

  @override
  Future<void> saveEmployees(List<Employee> employees) async {
    await _store.record(_keyName).put(await _db, {
      'employees': employees.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> saveEmployeeAt(int index) {
    // TODO: implement saveEmployeeAt
    throw UnimplementedError();
  }
}
