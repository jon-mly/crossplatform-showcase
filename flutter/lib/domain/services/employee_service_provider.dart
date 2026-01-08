import 'package:employees_app/core/config/app_config_provider.dart';
import 'package:employees_app/core/network/dio_client_provider.dart';
import 'package:employees_app/data/repositories/employees_api/employees_repository_impl.dart';
import 'package:employees_app/data/repositories/employees_api/employees_repository_mock.dart';
import 'package:employees_app/data/repositories/employees_persistence/employees_persistence_repository_impl.dart';
import 'package:employees_app/domain/services/employee_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<EmployeeService> employeeServiceProvider = .new((ref) {
  return EmployeeService(
    ref.watch(appConfigProvider).useMockApi
        ? EmployeesRepositoryMock()
        : EmployeesRepositoryImpl(ref.watch(employeesApiDioProvider)),
    EmployeesPersistenceRepositoryImpl(),
  );
});
