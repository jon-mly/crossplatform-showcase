import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/presentation/style/fonts.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:employees_app/presentation/widgets/card.dart';
import 'package:flutter/material.dart';

class EmployeeLoadingCell extends StatelessWidget {
  const EmployeeLoadingCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.tr('semantics.employeeLoadingCell.label'),
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
                  Container(
                    height: AppFonts.h2.fontSize,
                    width: 100,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  Container(
                    height: AppFonts.text.fontSize,
                    width: 50,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
