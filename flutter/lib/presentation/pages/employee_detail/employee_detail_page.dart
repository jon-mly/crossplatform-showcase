import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/presentation/providers/employee_detail_provider.dart';
import 'package:employees_app/presentation/providers/employees_provider.dart';
import 'package:employees_app/presentation/style/fonts.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:employees_app/presentation/widgets/button.dart';
import 'package:employees_app/presentation/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailPage extends ConsumerWidget {
  const EmployeeDetailPage({super.key, required this.employeeId});

  final int employeeId;

  //
  // Actions
  //

  void _presentEmployeeDetailEdit(BuildContext context, Employee employee) {
    context.push("/edit", extra: employee);
  }

  Future<void> _deleteEmployee(BuildContext context, WidgetRef ref) async {
    ref.read(employeesProvider.notifier).deleteEmployee(employeeId);
    context.pop();
  }

  //
  // UI
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Employee? employee = ref.watch(employeeDetailProvider(employeeId));
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('employeeDetail.title'))),
      body: Padding(
        padding: AppSpacing.screenPaddingHorizontal,
        child: employee != null
            ? _buildEmployeeDetail(context, ref, employee)
            : _buildNotFoundError(context),
      ),
    );
  }

  Widget _buildEmployeeDetail(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
  ) {
    return Column(
      spacing: AppSpacing.sectionSpacing,
      crossAxisAlignment: .stretch,
      children: [
        _buildEmployeeDataCard(context, employee),
        Row(
          spacing: AppSpacing.m,
          children: [
            Expanded(
              child: AppButton(
                text: context.tr('employeeDetail.delete'),
                onPressed: () => _deleteEmployee(context, ref),
                destructive: true,
                semanticHint: context.tr('semantics.employeeDetail.deleteHint'),
              ),
            ),
            Expanded(
              child: AppButton(
                text: context.tr('employeeDetail.edit'),
                onPressed: () => _presentEmployeeDetailEdit(context, employee),
                semanticHint: context.tr('semantics.employeeDetail.editHint'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeDataCard(BuildContext context, Employee employee) {
    final NumberFormat numberFormat = NumberFormat.currency(
      symbol: '€',
      decimalDigits: 0,
      locale: context.locale.toString(),
    );
    return Semantics(
      label: context.tr('semantics.employeeDetail.dataCardLabel'),
      child: AppCard(
        child: Column(
          spacing: AppSpacing.s,
          children: [
            _buildDataLine(
              context.tr('employeeDetail.cell.id'),
              employee.id.toString(),
            ),
            _buildDataLine(
              context.tr('employeeDetail.cell.name'),
              employee.employeeName ?? '',
            ),
            _buildDataLine(
              context.tr('employeeDetail.cell.salary'),
              numberFormat.format(employee.employeeSalary),
            ),
            _buildDataLine(
              context.tr('employeeDetail.cell.age'),
              context.tr(
                'employeeDetail.cell.ageSuffix',
                args: [employee.employeeAge.toString()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataLine(String label, String value) {
    return Row(
      spacing: AppSpacing.s,
      children: [
        Expanded(child: Text(label, style: AppFonts.text)),
        Text(value, style: AppFonts.h3),
      ],
    );
  }

  Widget _buildNotFoundError(BuildContext context) {
    return Center(
      child: Text(
        context.tr('employeeDetail.notFound'),
        style: AppFonts.text.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
