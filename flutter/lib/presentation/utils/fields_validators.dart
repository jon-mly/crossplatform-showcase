import 'package:easy_localization/easy_localization.dart';

class FieldsValidators {
  FieldsValidators._();

  static String? validateNameField(String? content) {
    if (content == null || content.isEmpty) {
      return 'validators.empty'.tr();
    }
    return null;
  }

  static String? validateSalaryField(String? content) {
    if (content == null || content.isEmpty) {
      return 'validators.empty'.tr();
    }
    final int? salary = int.tryParse(content);
    if (salary == null || salary < 0 || salary > 9999999) {
      return 'validators.invalidSalary'.tr();
    }
    return null;
  }

  static String? validateAgeField(String? content) {
    if (content == null || content.isEmpty) {
      return 'validators.empty'.tr();
    }
    final int? age = int.tryParse(content);
    if (age == null || age < 0 || age > 150) {
      return 'validators.invalidAge'.tr();
    }
    return null;
  }
}
