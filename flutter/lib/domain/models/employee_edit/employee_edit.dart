import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_edit.freezed.dart';
part 'employee_edit.g.dart';

@freezed
@JsonSerializable()
class EmployeeEdit with _$EmployeeEdit {
  const EmployeeEdit({
    required this.name,
    required this.salary,
    required this.age,
  });

  @override
  final String name;
  @override
  final int salary;
  @override
  final int age;

  Map<String, dynamic> toJson() => _$EmployeeEditToJson(this);
}
