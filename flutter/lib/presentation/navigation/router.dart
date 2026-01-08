import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/presentation/pages/edit_popup/employee_detail_edit_popup.dart';
import 'package:employees_app/presentation/pages/employee_detail/employee_detail_page.dart';
import 'package:employees_app/presentation/pages/employees_list/employees_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> fadePopupPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    opaque: false,
    barrierDismissible: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: child,
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/employees',
  routes: [
    GoRoute(
      path: '/employees',
      builder: (context, state) => const EmployeesListPage(),
      routes: [
        GoRoute(
          path: 'create',
          pageBuilder: (context, state) {
            return fadePopupPage(
              key: state.pageKey,
              child: EmployeeDetailEditPopup(initialEmployee: null),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/employee/:id',
      builder: (context, state) => EmployeeDetailPage(
        employeeId: int.parse(state.pathParameters['id']!),
      ),
      routes: [
        GoRoute(
          path: 'edit',
          pageBuilder: (context, state) {
            final Employee employee = state.extra as Employee;
            return fadePopupPage(
              key: state.pageKey,
              child: EmployeeDetailEditPopup(initialEmployee: employee),
            );
          },
        ),
      ],
    ),
  ],
);
