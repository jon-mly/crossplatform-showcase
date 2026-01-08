// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  id: (json['id'] as num?)?.toInt(),
  employeeName: json['employee_name'] as String?,
  employeeSalary: _parseStringToInt(json['employee_salary'] as String?),
  employeeAge: _parseStringToInt(json['employee_age'] as String?),
  profileImage: json['profile_image'] as String?,
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'id': instance.id,
  'employee_name': instance.employeeName,
  'employee_salary': _parseIntToString(instance.employeeSalary),
  'employee_age': _parseIntToString(instance.employeeAge),
  'profile_image': instance.profileImage,
};
