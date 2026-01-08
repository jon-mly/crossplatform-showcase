import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData clearTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  static final ThemeData darkTheme = ThemeData.dark(useMaterial3: true);
}
