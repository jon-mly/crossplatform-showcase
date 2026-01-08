import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
@JsonSerializable(fieldRename: .snake)
class Employee with _$Employee {
  const Employee({
    this.id,
    this.employeeName,
    this.employeeSalary,
    this.employeeAge,
    this.profileImage,
  });

  @override
  final int? id;

  @override
  final String? employeeName;

  @override
  @JsonKey(fromJson: _parseStringToInt, toJson: _parseIntToString)
  final int? employeeSalary;

  @override
  @JsonKey(fromJson: _parseStringToInt, toJson: _parseIntToString)
  final int? employeeAge;

  @override
  final String? profileImage;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  bool get isPending => id == null;
}

int? _parseStringToInt(String? value) =>
    value != null ? int.parse(value) : null;

String? _parseIntToString(int? value) => value?.toString();
