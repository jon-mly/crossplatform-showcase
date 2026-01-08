import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/presentation/style/fonts.dart';
import 'package:employees_app/presentation/style/radius.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:employees_app/presentation/widgets/card.dart';
import 'package:flutter/material.dart';

class EmployeeCell extends StatelessWidget {
  const EmployeeCell({super.key, required this.employee, required this.onTap});

  final Employee employee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String ageText = context.tr(
      'employees.cell.age',
      args: [employee.employeeAge.toString()],
    );
    return Semantics(
      button: !employee.isPending,
      enabled: !employee.isPending,
      label: context.tr(
        'semantics.employeeCell.label',
        args: [employee.employeeName ?? '', ageText],
      ),
      hint: employee.isPending
          ? context.tr('semantics.employeeCell.pendingHint')
          : context.tr('semantics.employeeCell.hint'),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: employee.isPending ? null : onTap,
          borderRadius: AppRadius.cardBorderRadius,
          excludeFromSemantics: true,
          child: AppCard(
            child: Row(
              spacing: AppSpacing.s,
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: Column(
                    spacing: AppSpacing.s,
                    crossAxisAlignment: .start,
                    children: [
                      Text(employee.employeeName ?? '', style: AppFonts.h2),
                      Text(ageText, style: AppFonts.text),
                    ],
                  ),
                ),
                if (!employee.isPending)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
