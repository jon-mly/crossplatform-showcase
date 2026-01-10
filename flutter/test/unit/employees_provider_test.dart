import 'package:collection/collection.dart';
import 'package:employees_app/domain/exceptions/app_exceptions.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/domain/models/sync/sync_data.dart';
import 'package:employees_app/domain/repositories/employees_api/employees_repository.dart';
import 'package:employees_app/domain/repositories/employees_persistence/employees_persistence_repository.dart';
import 'package:employees_app/domain/services/employee_service.dart';
import 'package:employees_app/domain/services/employee_service_provider.dart';
import 'package:employees_app/presentation/providers/employees_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeRepository extends Mock implements EmployeesRepository {}

class MockEmployeePersistenceRepository extends Mock
    implements EmployeesPersistenceRepository {}

void main() {
  late ProviderContainer container;
  late MockEmployeeRepository mockEmployeeRepository;
  late MockEmployeePersistenceRepository mockEmployeePersistenceRepository;
  late EmployeeService employeeService;

  final EmployeeEdit mockEdit = .new(name: 'John Doe', age: 30, salary: 50000);

  final List<Employee> mockLocalList = [
    Employee(
      id: 1,
      employeeName: 'First (local)',
      employeeSalary: 5000,
      employeeAge: 25,
    ),
  ];
  final List<Employee> mockRemoteList = [
    Employee(
      id: 1,
      employeeName: 'First',
      employeeSalary: 10000,
      employeeAge: 30,
    ),
  ];

  //
  // Stubs
  //

  void stubFetchSuccess() {
    when(
      () => mockEmployeeRepository.getAllEmployees(),
    ).thenAnswer((_) async => List.from(mockRemoteList));
    when(
      () => mockEmployeePersistenceRepository.saveEmployees(any()),
    ).thenAnswer((_) async {});
  }

  //
  // Helpers
  //

  SyncData<List<Employee>>? getProviderValue() {
    return container.read(employeesProvider).value;
  }

  //
  // Setup
  //

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(<Employee>[]);
  });

  setUp(() {
    mockEmployeeRepository = .new();
    mockEmployeePersistenceRepository = .new();
    employeeService = .new(
      mockEmployeeRepository,
      mockEmployeePersistenceRepository,
    );
    container = .test(
      overrides: [employeeServiceProvider.overrideWithValue(employeeService)],
    );
  });

  //
  // Tests groups
  //

  group('EmployeesProvider + Notifier', () {
    group('fetchEmployeesRemote', () {
      setUp(() {
        when(
          () => mockEmployeePersistenceRepository.getAllEmployees(),
        ).thenAnswer((_) async => List.from(mockLocalList));
        when(
          () => mockEmployeePersistenceRepository.saveEmployees(any()),
        ).thenAnswer((_) async {});
      });

      test('initial state is loading, unsynced then synced', () async {
        when(
          () => mockEmployeeRepository.getAllEmployees(),
        ).thenAnswer((_) async => List.from(mockRemoteList));

        final AsyncValue initialValue = container.read(employeesProvider);
        expect(initialValue.isLoading, equals(true));

        await container.read(employeesProvider.future);
        final DataSource? localSource = getProviderValue()?.source;
        expect(localSource, equals(DataSource.unsynced));

        await container.read(employeesProvider.notifier).fetchEmployeesRemote();
        final DataSource? remoteSource = getProviderValue()?.source;
        expect(remoteSource, equals(DataSource.synced));
      });

      test('replaces local data with remote data on success', () async {
        when(
          () => mockEmployeeRepository.getAllEmployees(),
        ).thenAnswer((_) async => List.from(mockRemoteList));

        await container.read(employeesProvider.future);

        final List<Employee>? localList = getProviderValue()?.data;
        expect(localList?.length, equals(mockLocalList.length));
        expect(
          localList?.first.employeeName,
          equals(mockLocalList.first.employeeName),
        );

        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        final List<Employee>? remoteList = getProviderValue()?.data;
        expect(remoteList?.length, equals(mockRemoteList.length));
        expect(
          remoteList?.first.employeeName,
          equals(mockRemoteList.first.employeeName),
        );
        verify(() => mockEmployeeRepository.getAllEmployees()).called(1);
        verify(
          () => mockEmployeePersistenceRepository.saveEmployees(any()),
        ).called(1);
      });

      test('keeps local data when fetch fails', () async {
        when(
          () => mockEmployeeRepository.getAllEmployees(),
        ).thenThrow(const ServerException());

        await container.read(employeesProvider.future);

        final List<Employee>? localList = getProviderValue()?.data;
        expect(localList?.length, equals(mockLocalList.length));
        expect(
          localList?.first.employeeName,
          equals(mockLocalList.first.employeeName),
        );

        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        final List<Employee>? remoteList = getProviderValue()?.data;
        expect(remoteList?.length, equals(mockLocalList.length));
        expect(
          remoteList?.first.employeeName,
          equals(mockLocalList.first.employeeName),
        );
        verify(() => mockEmployeeRepository.getAllEmployees()).called(1);
        verifyNever(
          () => mockEmployeePersistenceRepository.saveEmployees(any()),
        );
      });

      test('marks state as unsynced when fetch fails', () async {
        when(
          () => mockEmployeeRepository.getAllEmployees(),
        ).thenThrow(const ServerException());

        await container.read(employeesProvider.future);

        final DataSource? localSource = getProviderValue()?.source;
        expect(localSource, equals(DataSource.unsynced));

        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        final DataSource? remoteSource = getProviderValue()?.source;
        expect(remoteSource, equals(DataSource.unsynced));
      });
    });

    group('createEmployee', () {
      setUp(stubFetchSuccess);

      test(
        'adds employee optimistically then updates with server ID on success',
        () async {
          await container
              .read(employeesProvider.notifier)
              .fetchEmployeesRemote();

          when(
            () => mockEmployeeRepository.createEmployee(mockEdit),
          ).thenAnswer((_) async => 42);

          await container
              .read(employeesProvider.notifier)
              .createEmployee(mockEdit);

          final int? updatedListLength = getProviderValue()?.data.length;
          expect(updatedListLength, equals(mockRemoteList.length + 1));

          final Employee? newEmployee = getProviderValue()?.data
              .firstWhereOrNull((c) => c.id == 42);
          expect(newEmployee, isNotNull);
          expect(newEmployee?.employeeName, equals(mockEdit.name));
          verify(
            () => mockEmployeeRepository.createEmployee(mockEdit),
          ).called(1);
        },
      );

      test('rolls back to original list when service throws', () async {
        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        when(
          () => mockEmployeeRepository.createEmployee(mockEdit),
        ).thenThrow(const ServerException());

        await container
            .read(employeesProvider.notifier)
            .createEmployee(mockEdit);

        final int? afterCreateLength = getProviderValue()?.data.length;
        final Employee? newEmployee = getProviderValue()?.data.firstWhereOrNull(
          (c) => c.employeeName == mockEdit.name,
        );
        expect(afterCreateLength, equals(mockRemoteList.length));
        expect(newEmployee, isNull);
        verify(() => mockEmployeeRepository.createEmployee(mockEdit)).called(1);
      });
    });

    group('deleteEmployee', () {
      setUp(stubFetchSuccess);

      test('removes employee optimistically and confirms on success', () async {
        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        when(
          () => mockEmployeeRepository.deleteEmployee(1),
        ).thenAnswer((_) async {});

        await container.read(employeesProvider.notifier).deleteEmployee(1);

        final int? afterDeleteLength = getProviderValue()?.data.length;
        final Employee? removedEmployee = getProviderValue()?.data
            .firstWhereOrNull((c) => c.id == 1);
        expect(afterDeleteLength, equals(mockRemoteList.length - 1));
        expect(removedEmployee, isNull);
        verify(() => mockEmployeeRepository.deleteEmployee(1)).called(1);
      });

      test('rolls back when delete fails', () async {
        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        when(
          () => mockEmployeeRepository.deleteEmployee(1),
        ).thenThrow(const ServerException());

        await container.read(employeesProvider.notifier).deleteEmployee(1);

        final int? afterDeleteLength = getProviderValue()?.data.length;
        final Employee? removedEmployee = getProviderValue()?.data
            .firstWhereOrNull((c) => c.id == 1);
        expect(afterDeleteLength, equals(mockRemoteList.length));
        expect(removedEmployee, isNotNull);
        verify(() => mockEmployeeRepository.deleteEmployee(1)).called(1);
      });
    });

    group('updateEmployee', () {
      setUp(stubFetchSuccess);

      test(
        'updates employee data optimistically and confirms on success',
        () async {
          await container
              .read(employeesProvider.notifier)
              .fetchEmployeesRemote();

          when(
            () => mockEmployeeRepository.updateEmployee(1, mockEdit),
          ).thenAnswer((_) async {});

          await container
              .read(employeesProvider.notifier)
              .updateEmployee(1, mockEdit);

          final int? afterEditLength = getProviderValue()?.data.length;
          final Employee? editedEmployee = getProviderValue()?.data
              .firstWhereOrNull((c) => c.id == 1);
          expect(afterEditLength, equals(mockRemoteList.length));
          expect(editedEmployee?.employeeName, equals(mockEdit.name));
          verify(
            () => mockEmployeeRepository.updateEmployee(1, mockEdit),
          ).called(1);
        },
      );

      test('rolls back when update fails', () async {
        await container.read(employeesProvider.notifier).fetchEmployeesRemote();

        when(
          () => mockEmployeeRepository.updateEmployee(1, mockEdit),
        ).thenThrow(const ServerException());

        await container
            .read(employeesProvider.notifier)
            .updateEmployee(1, mockEdit);

        final int? afterEditLength = getProviderValue()?.data.length;
        final Employee? employee = getProviderValue()?.data.firstWhereOrNull(
          (c) => c.id == 1,
        );
        expect(afterEditLength, equals(mockRemoteList.length));
        expect(
          employee?.employeeName,
          equals(mockRemoteList.first.employeeName),
        );
        verify(
          () => mockEmployeeRepository.updateEmployee(1, mockEdit),
        ).called(1);
      });
    });
  });

  tearDown(() {
    container.dispose();
  });
}
