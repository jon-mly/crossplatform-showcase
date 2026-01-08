import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/domain/models/employee/employee.dart';
import 'package:employees_app/domain/models/employee_edit/employee_edit.dart';
import 'package:employees_app/presentation/providers/employees_provider.dart';
import 'package:employees_app/presentation/providers/ui/scaffold_messenger_provider.dart';
import 'package:employees_app/presentation/providers/ui/snackbar_provider.dart';
import 'package:employees_app/presentation/style/fonts.dart';
import 'package:employees_app/presentation/style/radius.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:employees_app/presentation/utils/fields_validators.dart';
import 'package:employees_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailEditPopup extends ConsumerStatefulWidget {
  const EmployeeDetailEditPopup({super.key, required this.initialEmployee});

  final Employee? initialEmployee;

  @override
  ConsumerState<EmployeeDetailEditPopup> createState() =>
      _EmployeeDetailEditPopupState();
}

class _EmployeeDetailEditPopupState
    extends ConsumerState<EmployeeDetailEditPopup> {
  final GlobalKey<FormState> _formKey = .new();
  final TextEditingController _nameController = .new();
  final TextEditingController _salaryController = .new();
  final TextEditingController _ageController = .new();

  //
  // Lifecycle
  //

  @override
  void initState() {
    _nameController.text = widget.initialEmployee?.employeeName ?? '';
    _salaryController.text =
        widget.initialEmployee?.employeeSalary.toString() ?? '';
    _ageController.text = widget.initialEmployee?.employeeAge.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  //
  // Actions
  //

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final EmployeeEdit edit = EmployeeEdit(
      name: _nameController.text.trim(),
      salary: int.parse(_salaryController.text),
      age: int.parse(_ageController.text),
    );
    final int? editedEmployeeId = widget.initialEmployee?.id;

    if (editedEmployeeId == null) {
      ref.read(employeesProvider.notifier).createEmployee(edit);
    } else {
      ref
          .read(employeesProvider.notifier)
          .updateEmployee(editedEmployeeId, edit);
    }
    context.pop();
  }

  //
  // UI
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow.withAlpha(30),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingAll,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: AppRadius.cardBorderRadius,
            ),
            padding: AppSpacing.cardPaddingAll,
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            widget.initialEmployee == null
                ? context.tr('employeeDetail.editDialog.titleCreation')
                : context.tr('employeeDetail.editDialog.title'),
            style: AppFonts.h2,
          ),
          AppSpacing.verticalM,
          Semantics(
            hint: context.tr('semantics.employeeEdit.nameFieldHint'),
            child: TextFormField(
              controller: _nameController,
              decoration: .new(
                labelText: context.tr('employeeDetail.editDialog.nameLabel'),
              ),
              validator: FieldsValidators.validateNameField,
            ),
          ),
          AppSpacing.verticalS,
          Semantics(
            hint: context.tr('semantics.employeeEdit.salaryFieldHint'),
            child: TextFormField(
              controller: _salaryController,
              decoration: .new(
                labelText: context.tr('employeeDetail.editDialog.salaryLabel'),
                suffixText: '€',
              ),
              keyboardType: .number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: FieldsValidators.validateSalaryField,
            ),
          ),
          AppSpacing.verticalS,
          Semantics(
            hint: context.tr('semantics.employeeEdit.ageFieldHint'),
            child: TextFormField(
              controller: _ageController,
              decoration: .new(
                labelText: context.tr('employeeDetail.editDialog.ageLabel'),
              ),
              keyboardType: .number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: FieldsValidators.validateAgeField,
            ),
          ),
          AppSpacing.verticalM,
          AppButton(
            text: context.tr('employeeDetail.editDialog.save'),
            onPressed: _save,
            semanticHint: context.tr('semantics.employeeEdit.saveHint'),
          ),
        ],
      ),
    );
  }
}
