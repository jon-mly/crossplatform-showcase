import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/domain/exceptions/app_exceptions.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/models/sync/sync_data.dart';
import 'package:employees_app/domain/services/employee_service_provider.dart';
import 'package:employees_app/presentation/providers/ui/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Optimistic UI is handled at presentation layer (synced / unsynced state),
// local persistency in the domain layer by the service after sync with remote.

final AsyncNotifierProvider<EmployeesNotifier, SyncData<List<Employee>>>
employeesProvider = .new(EmployeesNotifier.new);

class EmployeesNotifier extends AsyncNotifier<SyncData<List<Employee>>> {
  @override
  Future<SyncData<List<Employee>>> build() async {
    final List<Employee> localEmployees = await ref
        .read(employeeServiceProvider)
        .getPersistedEmployees();
    return .new(data: localEmployees, source: .unsynced);
  }

  Future<void> fetchEmployeesRemote() async {
    final List<Employee> originalList = state.value?.data ?? [];
    try {
      final List<Employee> remoteEmployees = await ref
          .read(employeeServiceProvider)
          .fetchEmployees();
      _updateState(SyncData(data: remoteEmployees, source: .synced));
    } catch (e) {
      _updateState(SyncData(data: originalList, source: .unsynced));
      ref
          .read(snackbarProvider.notifier)
          .showErrorSnackbar(
            'error.fetchEmployees'.tr(),
            onRetry: fetchEmployeesRemote,
          );
    }
  }

  Future<void> createEmployee(EmployeeEdit employeeEdit) async {
    final List<Employee> originalList = state.value?.data ?? [];

    try {
      final Employee newEmployee = Employee(
        id: null,
        employeeName: employeeEdit.name,
        employeeSalary: employeeEdit.salary,
        employeeAge: employeeEdit.age,
        profileImage: '',
      );
      final List<Employee> newList = List<Employee>.from(originalList)
        ..add(newEmployee);
      final int newEmployeeIndex = newList.length - 1;
      _updateState(SyncData(data: newList, source: .unsynced));
      final int newEmployeeId = await ref
          .read(employeeServiceProvider)
          .createEmployee(employeeEdit);
      newList[newEmployeeIndex] = newEmployee.copyWith(id: newEmployeeId);
      _updateState(SyncData(data: newList, source: .synced));
    } catch (e) {
      _updateState(SyncData(data: originalList, source: .unsynced));
      ref
          .read(snackbarProvider.notifier)
          .showErrorSnackbar('error.createEmployee'.tr());
    }
  }

  Future<void> updateEmployee(int id, EmployeeEdit employeeEdit) async {
    final List<Employee> originalList = state.value?.data ?? [];

    try {
      final List<Employee> newList = List<Employee>.from(originalList);
      final int index = newList.indexWhere((e) => e.id == id);
      if (index == -1) {
        throw NotFoundException('Employee not found');
      }
      final Employee edited = newList[index].copyWith(
        employeeName: employeeEdit.name,
        employeeSalary: employeeEdit.salary,
        employeeAge: employeeEdit.age,
      );
      newList[index] = edited;
      _updateState(SyncData(data: newList, source: .unsynced));
      await ref.read(employeeServiceProvider).updateEmployee(id, employeeEdit);
      _updateState(SyncData(data: newList, source: .synced));
    } catch (e) {
      _updateState(SyncData(data: originalList, source: .unsynced));
      ref
          .read(snackbarProvider.notifier)
          .showErrorSnackbar('error.updateEmployee'.tr());
    }
  }

  Future<void> deleteEmployee(int id) async {
    final List<Employee> originalList = state.value?.data ?? [];

    try {
      final List<Employee> newList = originalList
          .where((e) => e.id != id)
          .toList();
      _updateState(SyncData(data: newList, source: .unsynced));
      await ref.read(employeeServiceProvider).deleteEmployee(id);
      _updateState(SyncData(data: newList, source: .synced));
    } catch (e) {
      _updateState(SyncData(data: originalList, source: .unsynced));
      ref
          .read(snackbarProvider.notifier)
          .showErrorSnackbar('error.deleteEmployee'.tr());
    }
  }

  Future<void> _updateState(SyncData<List<Employee>> syncData) async {
    state = .data(syncData);
    if (syncData.source == .synced) {
      await ref.read(employeeServiceProvider).persistEmployees(syncData.data);
    }
  }
}
