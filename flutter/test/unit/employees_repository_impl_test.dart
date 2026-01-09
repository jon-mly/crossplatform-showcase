import 'package:dio/dio.dart';
import 'package:employees_app/data/repositories/employees_api/employees_repository_impl.dart';
import 'package:employees_app/domain/exceptions/app_exceptions.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EmployeesRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = EmployeesRepositoryImpl(mockDio);
  });

  group('getAllEmployees', () {
    test(
      'returns list of employees when API returns 200 with success status',
      () async {
        when(() => mockDio.get('/employees')).thenAnswer(
          (_) async => Response(
            requestOptions: .new(path: '/employees'),
            statusCode: 200,
            data: {
              'status': 'success',
              'data': [
                {
                  'id': 1,
                  'employee_name': 'John Doe',
                  'employee_salary': '50000', // API returns strings
                  'employee_age': '30',
                  'profile_image': '',
                },
                {
                  'id': 2,
                  'employee_name': 'Jane Doe',
                  'employee_salary': '60000',
                  'employee_age': '28',
                  'profile_image': '',
                },
              ],
            },
          ),
        );

        final List<Employee> result = await repository.getAllEmployees();

        expect(result.length, 2);
        expect(result[0].employeeName, 'John Doe');
        expect(result[1].employeeName, 'Jane Doe');

        verify(() => mockDio.get('/employees')).called(1);
      },
    );

    test(
      'throws ServerException when API returns non-success status',
      () async {
        when(() => mockDio.get('/employees')).thenAnswer(
          (_) async => Response(
            requestOptions: .new(path: '/employees'),
            statusCode: 200,
            data: {'status': 'error', 'message': 'Something went wrong'},
          ),
        );

        expect(
          () => repository.getAllEmployees(),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('throws NetworkException when Dio throws DioException', () async {
      when(() => mockDio.get('/employees')).thenThrow(
        DioException(
          requestOptions: .new(path: '/employees'),
          type: .connectionTimeout,
        ),
      );

      expect(
        () => repository.getAllEmployees(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws ServerException when API returns 500 status code', () async {
      when(() => mockDio.get('/employees')).thenAnswer(
        (_) async => Response(
          requestOptions: .new(path: '/employees'),
          statusCode: 500,
          data: {'status': 'error'},
        ),
      );

      expect(
        () => repository.getAllEmployees(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('createEmployee', () {
    setUpAll(() {
      registerFallbackValue(EmployeeEdit(name: 'fallback', salary: 0, age: 0));
    });

    test('returns new employee id when creation succeeds', () async {
      final EmployeeEdit employeeEdit = .new(
        name: 'New Person',
        salary: 70000,
        age: 25,
      );

      when(() => mockDio.post('/create', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: .new(path: '/create'),
          statusCode: 200,
          data: {
            'status': 'success',
            'data': {'id': 42},
          },
        ),
      );

      final int result = await repository.createEmployee(employeeEdit);

      expect(result, 42);
    });

    test('throws NetworkException on connection failure', () async {
      final EmployeeEdit employeeEdit = .new(
        name: 'New Person',
        salary: 70000,
        age: 25,
      );

      when(() => mockDio.post('/create', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: .new(path: '/create'),
          type: .connectionError,
        ),
      );

      expect(
        () => repository.createEmployee(employeeEdit),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('deleteEmployee', () {
    test('completes successfully when delete succeeds', () async {
      // ARRANGE
      when(() => mockDio.delete('/delete/1')).thenAnswer(
        (_) async => Response(
          requestOptions: .new(path: '/delete/1'),
          statusCode: 200,
          data: {'status': 'success'},
        ),
      );

      await expectLater(repository.deleteEmployee(1), completes);
    });

    test('throws ServerException when delete fails', () async {
      when(() => mockDio.delete('/delete/1')).thenAnswer(
        (_) async => Response(
          requestOptions: .new(path: '/delete/1'),
          statusCode: 404,
          data: {'status': 'error'},
        ),
      );

      expect(
        () => repository.deleteEmployee(1),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
