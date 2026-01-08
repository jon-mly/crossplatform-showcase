import 'package:collection/collection.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/sync/sync_data.dart';
import 'package:employees_app/presentation/providers/employees_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeDetailProvider = Provider.family.autoDispose<Employee?, int>((
  ref,
  employeeId,
) {
  return ref.watch(
    employeesProvider.select(
      (AsyncValue<SyncData<List<Employee>>> asyncValue) => asyncValue
          .value
          ?.data
          .firstWhereOrNull((employee) => employee.id == employeeId),
    ),
  );
});
