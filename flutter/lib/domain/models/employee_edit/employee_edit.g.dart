// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_edit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeEdit _$EmployeeEditFromJson(Map<String, dynamic> json) => EmployeeEdit(
  name: json['name'] as String,
  salary: (json['salary'] as num).toInt(),
  age: (json['age'] as num).toInt(),
);

Map<String, dynamic> _$EmployeeEditToJson(EmployeeEdit instance) =>
    <String, dynamic>{
      'name': instance.name,
      'salary': instance.salary,
      'age': instance.age,
    };
